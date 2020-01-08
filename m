Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E054134EB2
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgAHVQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:16:05 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35796 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:16:05 -0500
Received: by mail-io1-f67.google.com with SMTP id h8so4837473iob.2;
        Wed, 08 Jan 2020 13:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=HW7dGFRN4q8bVZHBetakZ6zy0wQpBxJQHxmfLpTAask=;
        b=JbP+xeCvCBV0fUzxT0Z0He+ZVY2XR3uiUCiTYzgKhIr2tgVzx12O9F8wPnt3vplWQS
         WU1KbPFYf4+fclhsaJeaDzYMRDSr3N+ESmAEIUCFSzC9iXIxPB2F8xLhP4MBoA/hRSWV
         7Dingq1msS4AqeiKtDU1pege/lu9/K8nRCMAxiHJf/dW3XBIJ/xvSpnWvVcR7Wo5yKGH
         e4gcushclqiEwkqW2ubs++igPTfVdgASmXYXdF2V65sGvc3pg0QAJx9D7X72v5ruMBA1
         8MB8AbHIZw7TJrByJSGDW1WaWRFM6SL6sF2t7TrRDpelvcfkMh7sAwNzK2hVyg2bbEYg
         CuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HW7dGFRN4q8bVZHBetakZ6zy0wQpBxJQHxmfLpTAask=;
        b=Xnz0J3FrWmi+m0M00exeQzsLC1fvsRRSEQhN5g0G/PD1O7Ik3+Ua26Mq7WtQCGzvL3
         D0ijpl7iZFEZnXGrUQFTo/sVziHkRjNydy8475v9L5A7bJ43cLxwAq/IDhcbbxGek2Lc
         Hql67IhAWhdy/YrNTivxXBWQsGh3f5ZzCMBM1+1NlKtUpGtJ0vSpYxWJtpWyIJ/6s8q+
         mVCMzojT5HrM7zlttOMg7JxNSdPLA0VlnXyEGOqfj4QmT+IOdqBrRVqmPXOyanCrsfSl
         uVqbneQ7/na24wggtbGlIZAcL+kwgt8PO/wl5dQwsAWhi0zpCpOWM7IWseULjekcg7Jr
         16ew==
X-Gm-Message-State: APjAAAWLWHTWXRwMfo6CjRc+5i7JVp71B8SCswl0oV5JDjLQQ5bGmuNF
        hu2bb0SL//wI1uG3ArfSAr19/fxi
X-Google-Smtp-Source: APXvYqxrAz+2+NHfFm0dIV73z87vKm/FbqDyeTNBvHbNH65M+DoitYwuv2iFN8i4AXMe1LkxVjL8Dw==
X-Received: by 2002:a5d:8353:: with SMTP id q19mr4904287ior.163.1578518164602;
        Wed, 08 Jan 2020 13:16:04 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v10sm886889iol.85.2020.01.08.13.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:16:04 -0800 (PST)
Subject: [bpf PATCH 7/9] bpf: sockmap/tls,
 skmsg can have wrapped skmsg that needs extra chaining
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:15:52 +0000
Message-ID: <157851815284.1732.9999561233745329569.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_sw.c |    6 ++++++
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
 

