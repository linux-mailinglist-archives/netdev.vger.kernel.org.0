Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B5E44DCD4
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 22:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhKKVCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 16:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhKKVCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 16:02:46 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1C3C061767
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 12:59:56 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b11so6650923pld.12
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 12:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xH9gjV2+nQ3ZXVAA9ckgRKISikhIh7VE5b1rKD4RA9g=;
        b=VZief8gcJTmN0bmEvM6HlCarwCctVeWuXDa/Q1OxX+EVMMuR2THVmXorf1kkYqerkT
         FTXoYsmHBoACjvraBff4jM53N13P7vEHzkixEz7AKhRF6hHE6jSHzAl81rv5UoS623LO
         DUwErdudOfmXzSGt9FADOYVPBotlvFn8pDJLfd2DMOi+K6Had75UaZJGcinWoePnqbJ9
         NtDU3O0EASpsnGU81cC4Eoxv8Db2jd+CECuhaG6nnYu5dH87DPLkMqm8ct8gSHXrRyjs
         ebS0kJOrMoQ4f2mzCfe0IbgiMTErg2qKya6UrwiQk0n6ip3ILVAx9AyhDEO8XE0gM2Ol
         BjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xH9gjV2+nQ3ZXVAA9ckgRKISikhIh7VE5b1rKD4RA9g=;
        b=aixr2ll8vEILD62fSEN66Gu23YgGVsThZzmAXJP8GtmPaNhGfTrzVBpJr8jkiLY0yF
         86y1bqdnvOdcvNeH8Q2r2xjnyWWLkj3KepMwZ2PaqbAhC6xuGd4+gBiNLFyqDkpb50kC
         YUVeu4+GoJ1ijg+JkO1jR5Xo/0eEWFIYDFPxRDcAXNqh+53mjSE0Fx4tkyyjICAU7tIZ
         sjTddZhhTv7gbbT1WGPPWjxVhj7oBmghiR70ggybTnYxQvBIoKSBsg/mKF2ES9efYEGa
         L7riO+zIjXBDn8xXYUeKyJ2fHTa/iXvw+YG7NfPo3JbY2ckrXwfLlgCbEvL4wk/8vW5Y
         3Ibg==
X-Gm-Message-State: AOAM532cgL7bMN15xXXa56DYGPLO5nb/9TJjO85d04GOSi+KBaH1bj3P
        DPq7cOXVdW5rp4hYW7q/+edhng==
X-Google-Smtp-Source: ABdhPJxJgGDJhD/qRjDkTQlUfFiPDPb7oHTykdnit2GbfWLFhdP0O62YHtRsH2DMJcMjM5zFRpgKJQ==
X-Received: by 2002:a17:902:b907:b0:13f:ccaf:9ed8 with SMTP id bf7-20020a170902b90700b0013fccaf9ed8mr2289398plb.46.1636664396407;
        Thu, 11 Nov 2021 12:59:56 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id g5sm9134575pjt.15.2021.11.11.12.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 12:59:56 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     jmaloy@redhat.com
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] tipc: use consistent GFP flags
Date:   Thu, 11 Nov 2021 12:59:16 -0800
Message-Id: <20211111205916.37899-2-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111205916.37899-1-tadeusz.struk@linaro.org>
References: <20211111205916.37899-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions, like tipc_crypto_start use inconsisten GFP flags
when allocating memory. The mentioned function use GFP_ATOMIC to
to alloc a crypto instance, and then calls alloc_ordered_workqueue()
which allocates memory with GFP_KERNEL. tipc_aead_init() function
even uses GFP_KERNEL and GFP_ATOMIC interchangeably.
No doc comment specifies what context a function is designed to
work in, but the flags should at least be consistent within a function.

Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 net/tipc/crypto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 988a343f9fd5..a59c4eece5db 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -524,7 +524,7 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 		return -EEXIST;
 
 	/* Allocate a new AEAD */
-	tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
 	if (unlikely(!tmp))
 		return -ENOMEM;
 
@@ -1475,7 +1475,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 		return -EEXIST;
 
 	/* Allocate crypto */
-	c = kzalloc(sizeof(*c), GFP_ATOMIC);
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c)
 		return -ENOMEM;
 
@@ -1489,7 +1489,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	}
 
 	/* Allocate statistic structure */
-	c->stats = alloc_percpu_gfp(struct tipc_crypto_stats, GFP_ATOMIC);
+	c->stats = alloc_percpu(struct tipc_crypto_stats);
 	if (!c->stats) {
 		if (c->wq)
 			destroy_workqueue(c->wq);
@@ -2462,7 +2462,7 @@ static void tipc_crypto_work_tx(struct work_struct *work)
 	}
 
 	/* Lets duplicate it first */
-	skey = kmemdup(aead->key, tipc_aead_key_size(aead->key), GFP_ATOMIC);
+	skey = kmemdup(aead->key, tipc_aead_key_size(aead->key), GFP_KERNEL);
 	rcu_read_unlock();
 
 	/* Now, generate new key, initiate & distribute it */
-- 
2.33.1

