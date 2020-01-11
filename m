Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2A9137BCF
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgAKGN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:13:27 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41494 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAKGN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:13:27 -0500
Received: by mail-il1-f194.google.com with SMTP id f10so3584538ils.8;
        Fri, 10 Jan 2020 22:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lhB0LKsb7l79Kz/6/x4gGYFNCjC4VcBwutdH+J/eLFs=;
        b=kUwY/oq+hcBwiMRSO8NWJaYwEYHjr+D8MTxGos/pa2BdTjU40qRu6NLAdAdPTrdDOa
         jGQCXBGm3OpFZN46Ojx2eYvIwZsj5Vm5xRPKgMH1k9ixJmJbun+uA84QIe78oy8wXQIT
         HMpyXYE0TdUKC3Qc+L6a4jInx3L7ODeUVTawHHrJ4AzQqmxuH6IF74X/LEZxd6pc2azp
         5Igit2i1VY9SCEbBlGWHcaXPnYiOawdh95OlUDamAPb94bLPxx4dQjTPwU7RJfCsPClR
         wt3iHHCl+C/0a3Y9RjdP/AJxb3DlKyUed7etOoJbcGaauivJAkEmu+b63mPUUO2BeQUz
         rJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lhB0LKsb7l79Kz/6/x4gGYFNCjC4VcBwutdH+J/eLFs=;
        b=UaTjxDpyCs4uZO0BFkZ+zmJ1I8yhfeW1VVYxXAOh9NV6RoiZL83QiOft+R+JX3qCTz
         LR/zgVQDz/HCY6UHBTZKPFwpUp/1bcbKdKrxtsPhUL+TTUDLKzUbwA0pdBysMBNdTyzL
         r1yBxtziPOnr1iwe1E6vPZHqM8c77DGZoHA7mkdVpAcvlNV54rQchMLOgFszkPoJtXJ8
         Uh1gWp03JDdN+akqTRKsJSHBjltF+fJahCmpRc3wBQzXlQfA+a4HilAIp8DyreQ6eJ4F
         fvVrZr1XC01vetEkq46LxUmQ8mNTVzuD+rebQOVOfUUaIa1QYIB73HSlnbP5dHr5nDRL
         y3Lg==
X-Gm-Message-State: APjAAAV35bmxYs8Zux0nIGOy97S+w37stoZiSQ2SdsD/2y2p0jZRp2dP
        QoQ1fFFwbBvUarmFrPKlP8/WOWBD
X-Google-Smtp-Source: APXvYqw604jH7SmBLKeov5rjpfFiYbl8oSc7NvFdS/eDGqUntZvEsQif19tMwrMcC8sOEtU8uEWRTA==
X-Received: by 2002:a92:489a:: with SMTP id j26mr6403868ilg.226.1578723206876;
        Fri, 10 Jan 2020 22:13:26 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:13:26 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 7/8] bpf: sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining
Date:   Sat, 11 Jan 2020 06:12:05 +0000
Message-Id: <20200111061206.8028-8-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its possible through a set of push, pop, apply helper calls to construct
a skmsg, which is just a ring of scatterlist elements, with the start
value larger than the end value. For example,

      end       start
  |_0_|_1_| ... |_n_|_n+1_|

Where end points at 1 and start points and n so that valid elements is
the set {n, n+1, 0, 1}.

Currently, because we don't build the correct chain only {n, n+1} will
be sent. This adds a check and sg_chain call to correctly submit the
above to the crypto and tls send path.

Cc: stable@vger.kernel.org
Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_sw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 31f6bbbc8992..21c7725d17ca 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -729,6 +729,12 @@ static int tls_push_record(struct sock *sk, int flags,
 		sg_mark_end(sk_msg_elem(msg_pl, i));
 	}
 
+	if (msg_pl->sg.end < msg_pl->sg.start) {
+		sg_chain(&msg_pl->sg.data[msg_pl->sg.start],
+			 MAX_SKB_FRAGS - msg_pl->sg.start + 1,
+			 msg_pl->sg.data);
+	}
+
 	i = msg_pl->sg.start;
 	sg_chain(rec->sg_aead_in, 2, &msg_pl->sg.data[i]);
 
-- 
2.17.1

