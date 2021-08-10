Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EED3E5A95
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241049AbhHJM77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239188AbhHJM77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:59:59 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3175CC0613D3;
        Tue, 10 Aug 2021 05:59:37 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id m9so28921624ljp.7;
        Tue, 10 Aug 2021 05:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C8ukQa3sXo+DBl8G/r0rlRb+zkXrtXj0fbs8AcpdmLM=;
        b=BeR0m3pZrkVng8z/cHE1HhRzPFWun7v6JeIPJr7i2Y0ic0pnr5hNFoZdBlYDJL0Xg+
         RoM7hPyLnx0zqG27UL1O7qbP3yuUFooPWRR77qltiO/ij40qu7ZMsF8Mpa0Lw+/jdrQ/
         fji0Tzfl/hUi1cU9j/u0iptIowVN2aNGLtqe7WzwL58Tu4aI83G5mGeJBzxrO7GkyjdE
         wR4IB0POHiMTq6k2wTVyjghI9zGVJPRxWwmb7PbulzaU3YcwvLAUZvZSDEApQVWyvvp8
         sawq7BSsw+rr64tuzNRMlSJQdgFQB68FAg3Kkq7vHCcApuV0zocldjj0uPpVts2MAh7j
         1h9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C8ukQa3sXo+DBl8G/r0rlRb+zkXrtXj0fbs8AcpdmLM=;
        b=fjeSbIHsOI9jEWIwwTHn4CtpOLUJ3Jxy8jbsV6wNlq3pjxCStOOgtTp+uF3gMsrjGr
         Q7Xu6koICRGM/8NaYvzFOzBvsUgIjsiIBWHBJ3O8NrjJ7PpHy41WjPXthRdsopyOaodO
         K5YkMJQN+IflPtuL/4KNoqwWH1uZuYGibIhzYYAJ8F5a+EmRpCw0MMHfnluH+IwQarE6
         rZNz8egvY2x+SWxTt8d7+9DI/zpV+dXP93ye6Di3OJsTx3ZPMoW79XAQ/4xYTFLmGB0b
         0uxJclebv+f5tbaAPS09Iw7oVV/mGYuQEFhiI9SmdsmXUE2su5zZyG1DECpntROGqvHm
         Lb3w==
X-Gm-Message-State: AOAM531IjXpLRn0Oh/jMO56gYoBo4gK/4C34oCgZlmrI4x1z4YkAdPWp
        7qaZ2Wqmw24A78CqV5tuGqc=
X-Google-Smtp-Source: ABdhPJyXKs6dOhzi+KmIRhTXSLCqmlcLAcEQglehQFPDp/eginYv8FRijzR7lGhqlXzh/oYaSjmoog==
X-Received: by 2002:a2e:8250:: with SMTP id j16mr19645493ljh.164.1628600375545;
        Tue, 10 Aug 2021 05:59:35 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id m12sm2039397lfh.182.2021.08.10.05.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:59:35 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Subject: [PATCH v2] netfilter: protect nft_ct_pcpu_template_refcnt with mutex
Date:   Tue, 10 Aug 2021 15:59:20 +0300
Message-Id: <20210810125920.23187-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810125523.15312-1-paskripkin@gmail.com>
References: <20210810125523.15312-1-paskripkin@gmail.com>
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

Changes in v2:
	Fixed typo in title: netfiler -> netfilter

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

