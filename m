Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7030E6A0470
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjBWJFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjBWJFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:05:39 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524014A1EF;
        Thu, 23 Feb 2023 01:05:29 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so3598538pja.5;
        Thu, 23 Feb 2023 01:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677143129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ABFyAb/K2zI5FCoqs7l1h895rViJiGUkMa/G+N7XXR0=;
        b=eRYg5gH5jZG9aubphPCvLc7x5upjysQQzZyXoF2V6WJV3eOrk4Pz2H1BYlFUqeK38j
         P3skW/zOEMjWTeVniLFSlSZErJUhu5c9CaJFai7KroP67RquxbqDI/lgfUpZk962ZJJb
         1xFHcbShqatmg9lVYCtdPk5gH/uUvyeToDoXHHkz5YQUf0CChpd4XhfHWWhoNfe7/Us5
         rC+xV72hcFA7e/HJ2K8LXSAIzJmhsATUTifQ0uTYbw9TsjmF7j3GrkLpvGQ6h/NfInLF
         4PUIFbBbHIOQA8/jCd4z33An0lj5BcEmxnBqcDK4xdhozuVUZD4FkG4eAveWM99V42gY
         Q52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677143129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABFyAb/K2zI5FCoqs7l1h895rViJiGUkMa/G+N7XXR0=;
        b=HX1japHiXhrV415gTxwDe2aeyCN5+wGFmNi4SVnjew6p+V2B+PFts5MRzBQzyjezje
         CtA8RKJaqWr2M3GwwYU7arlt/2VCTjuv/oDfviwM+e1br1m/PBzeq1AZA+LTnYaO+WCM
         8Yo5UVbz64zoX+/dVno2kljyk+oqP3G/lBCK87ZR9SYW9QQgUgIaFVfpzi59alSRj+fr
         Nr/6LCLgbvoSiTD/6+mnho6FMae2NQYKXE0gfB2QYR4qnUpfOui+jTuwV5qLaE8eJW0Y
         dYeOOXcM5IrOG9usgMfpco4qkZf8ENU9Hu+Xy+aF6ngUwAZD5OLxDxh5eA6dH0CyfJ+8
         LA5w==
X-Gm-Message-State: AO0yUKU+y7vk+7WEaQlr60TSxJOp0l3txiuRGd0mSExPNjCh5ZvLBdM1
        mKCxVU8TlOeQQa5lmmKYWyKUa3lUD0TK5A==
X-Google-Smtp-Source: AK7set/cLiqDH9td3Ix/MImyJJRskXHJc8NAsXDMSGpR6L0vJoZH1SZeMvotWBoOIkThtpTsx4lPNw==
X-Received: by 2002:a05:6a20:548a:b0:c6:d235:ac8c with SMTP id i10-20020a056a20548a00b000c6d235ac8cmr13335584pzk.4.1677143128961;
        Thu, 23 Feb 2023 01:05:28 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id u16-20020aa78390000000b005cdf83e4513sm4733214pfm.145.2023.02.23.01.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 01:05:28 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: tls: fix possible info leak in tls_set_device_offload()
Date:   Thu, 23 Feb 2023 17:05:08 +0800
Message-Id: <20230223090508.443157-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it fails
before kmalloc cctx->iv. This may cause info leak when we call
do_tls_getsockopt_conf().

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/tls/tls_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..a63f6f727f58 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1241,8 +1241,10 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	kfree(start_marker_record);
 free_rec_seq:
 	kfree(ctx->tx.rec_seq);
+	ctx->tx.rec_seq = NULL;
 free_iv:
 	kfree(ctx->tx.iv);
+	ctx->tx.iv = NULL;
 release_netdev:
 	dev_put(netdev);
 	return rc;
-- 
2.34.1

