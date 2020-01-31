Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD2714F363
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgAaUw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:52:57 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:56036 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgAaUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:52:55 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so3368331pjz.5;
        Fri, 31 Jan 2020 12:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oAzrzsjfwfb2NIzzZbZDHsuVL/on7pj6/MP3jhQnaRY=;
        b=Ifr+XYVLgJV7/+DBXpVG23JNLzbRw3PFkfqiSksCI3muXUMZBlo5pJyTHVKMZlYrG2
         fVJeraB+wCKQpvnWmDgJa/1ZVC1tJNesfk8pWYBulOTVFslg/KK6qDac/HmK0rZhswmA
         fc7xAUoJG+P0Cc8Wz4g9LtRrhQ1qVkCwke6Bxd1fNmAHZP/BNpuaS1zVnmgYV1pC87Rd
         eCl5pRutrXtnI9AtdTjdMEuaf2JiqT9loHI/gZKJEN7vGg0ERf68cNA9DCikl6ASDLa1
         RLgzsKx/PkOG0GtRM63xQUdXfHZimsSBwiH9Z8lDJPuqCNA7bUGAtKJmP7UzGPv1oG7A
         HJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oAzrzsjfwfb2NIzzZbZDHsuVL/on7pj6/MP3jhQnaRY=;
        b=AFO9/Te2qcRm1VxgupLCHPdOfR1QHG0MlDshM9j8lP71pZ6Z8Ej7LncPa6aNW0FXSP
         I9HeSOonOoTXR2k+O5a+J8eCw0BZX5tmxWgYZNfV7HcDZm2+t2qfoddSmVQE4uodhdw8
         8I8lyf7vgOHjiMUcPsk8HP08nY5Q+wDqfOn1+nsj0E+qGL9z1LK+R85eMXrG3AVgZbxA
         6tg9cYMBkGghgw3bmBI/XDDQgPegelpPpT76nSnS0P8yHzaHLz9MISFtaF2bIsGp/mPw
         oMk9ELK6gqPgHa4xN/+tNBUbM7Th1njoh5A+ImwTpu2pepf9Cda3Fp/7tXU1KOUs0eEI
         L6tQ==
X-Gm-Message-State: APjAAAVPNEXTMxtxTcSK5Gb4GNcrW361NFjFA5Mu9KwWBpMLycp/cbrH
        MsZmH1fsU0IPn9ZgvpqtUdWZKmwv888=
X-Google-Smtp-Source: APXvYqw2w5weWDxQil8rnx96IEgzQK9YOcuE+JjskYVY6LG8n7fURa1Q1fMK1+LnhXx95tVD7Cy6tQ==
X-Received: by 2002:a17:90a:26ab:: with SMTP id m40mr14844193pje.42.1580503974452;
        Fri, 31 Jan 2020 12:52:54 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id m128sm11599169pfm.183.2020.01.31.12.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 12:52:54 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [Patch nf 1/3] xt_hashlimit: avoid OOM for user-controlled vmalloc
Date:   Fri, 31 Jan 2020 12:52:14 -0800
Message-Id: <20200131205216.22213-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hashtable size could be controlled by user, so use flags
GFP_USER | __GFP_NOWARN to avoid OOM warning triggered by user-space.

Also add __GFP_NORETRY to avoid retrying, as this is just a
best effort and the failure is already handled gracefully.

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index bccd47cd7190..885a266d8e57 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -293,8 +293,9 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		if (size < 16)
 			size = 16;
 	}
-	/* FIXME: don't use vmalloc() here or anywhere else -HW */
-	hinfo = vmalloc(struct_size(hinfo, hash, size));
+	/* FIXME: don't use __vmalloc() here or anywhere else -HW */
+	hinfo = __vmalloc(struct_size(hinfo, hash, size),
+			  GFP_USER | __GFP_NOWARN | __GFP_NORETRY, PAGE_KERNEL);
 	if (hinfo == NULL)
 		return -ENOMEM;
 	*out_hinfo = hinfo;
-- 
2.21.1

