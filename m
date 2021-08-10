Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD33E5A7A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbhHJMzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbhHJMzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:55:49 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED71C0613D3;
        Tue, 10 Aug 2021 05:55:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id g13so41263944lfj.12;
        Tue, 10 Aug 2021 05:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4rViaCUp03F0sOMlLIrr/48hOom8gf9ywmMtY7hOCEw=;
        b=QhDrGZLyjbA+pSrCNOia22rq2ksofFcAAHQdCK9zOvnrwjwdvm8gX4oUvEzmyfEb+e
         wiTutgnsFTzVv1Bi6DqP1lenvA2AEqpS83J1C+i4EaBai8teuEnfETejvbRfk+/RGWjf
         JXe4+npxD9GWeetIrXD5uN2AKxaa3uvSCJzZ+ZU+UtEODLVifkAVYPSLgKeTAgXyjrKb
         eAkTYnSjrkuMej/bG4d7vIHR4QVu0dfgUYs+/ZiR3Mxak1wSu4CnJCMI/9cZPWzrJtsL
         Y7o+1TYR+rYMc4eaJD1TioIawKlGr+l5l8iGo5qV4ytqaGrkVuD3vPostkfucpRHHIsm
         NGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4rViaCUp03F0sOMlLIrr/48hOom8gf9ywmMtY7hOCEw=;
        b=uCQQwnvYG+BQLMMRIAwv7oZ90U2gWBc9HvHh37VwlsYKQxxOr1uexu9SKugfLwrIYN
         xvFX6v3iuLDyZ3yVzAS2v46QoATs90nKabkGRvRy6BQOu9Dskew3qkO65f4P/kSSkiZO
         cbZYz0+wzLM00xGSmPxhnaH/WIBwlXb/Nh5biKHnt6TsVme31wqS3B9WMm5dv8FCkyry
         TGUqWb+UyNitMkoUEt6A9pY8F7dPD8uy2+jNil9t8AHVX0W+0p+Rvj8FTTu+HTcfAHkl
         aTueXhdO8ZumzMY4VuqrLOEbcq3LNU2En2MUwQYhcqqYPdgtTA9TPQ1TDmEFN4YBeBWv
         1WIg==
X-Gm-Message-State: AOAM5337At97m+ZVWVeLAqJvOi/VGk7QMGD7h0PXQf6liQi+8t75AjXd
        vthTljka3Wul5d9JZUOnNuI=
X-Google-Smtp-Source: ABdhPJxVRsKFgx2m5ReTxzKsAj+BWBLyWiKUWBNi+p/47kWiw91JrwzOve3y9nUUzr9UpTQYPMXCPg==
X-Received: by 2002:a05:6512:470:: with SMTP id x16mr22072229lfd.497.1628600125867;
        Tue, 10 Aug 2021 05:55:25 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id k17sm1873341ljm.7.2021.08.10.05.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:55:25 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Subject: [PATCH] netfiler: protect nft_ct_pcpu_template_refcnt with mutex
Date:   Tue, 10 Aug 2021 15:55:23 +0300
Message-Id: <20210810125523.15312-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot hit use-after-free in nf_tables_dump_sets. The problem was in
missing lock protection for nft_ct_pcpu_template_refcnt.

Before commit f102d66b335a ("netfilter: nf_tables: use dedicated
mutex to guard transactions") all transactions were serialized by global
mutex, but then global mutex was changed to local per netnamespace
commit_mutex.

This change causes use-after-free bug, when 2 netnamespaces concurently
changing nft_ct_pcpu_template_refcnt without proper locking. Fix it by
adding nft_ct_pcpu_mutex and protect all nft_ct_pcpu_template_refcnt
changes with it.

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-and-tested-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/netfilter/nft_ct.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 337e22d8b40b..99b1de14ff7e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -41,6 +41,7 @@ struct nft_ct_helper_obj  {
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 static DEFINE_PER_CPU(struct nf_conn *, nft_ct_pcpu_template);
 static unsigned int nft_ct_pcpu_template_refcnt __read_mostly;
+static DEFINE_MUTEX(nft_ct_pcpu_mutex);
 #endif
 
 static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
@@ -525,8 +526,10 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
+		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		break;
 #endif
 	default:
@@ -564,9 +567,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
-		if (!nft_ct_tmpl_alloc_pcpu())
+		mutex_lock(&nft_ct_pcpu_mutex);
+		if (!nft_ct_tmpl_alloc_pcpu()) {
+			mutex_unlock(&nft_ct_pcpu_mutex);
 			return -ENOMEM;
+		}
 		nft_ct_pcpu_template_refcnt++;
+		mutex_unlock(&nft_ct_pcpu_mutex);
 		len = sizeof(u16);
 		break;
 #endif
-- 
2.32.0

