Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5E56A1AC2
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 11:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBXK7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 05:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBXK6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 05:58:31 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7352112;
        Fri, 24 Feb 2023 02:58:29 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id c23so11196381pjo.4;
        Fri, 24 Feb 2023 02:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677236309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jk45hO2dJBO+eSPwpnI7b1q3xk4uLOBl8nIPeR2AALE=;
        b=EbtLiTrZVXwyUhMqFPZW6GnvOXqwvqMj60fwvVKR3JRnlMN6MYs6r0wPhtUsfKb3mW
         aFsyPU1h3BzzMehRfYea6BrZXZ+hcQQvwFFty4JRMAsof8n9q+Ijey8n7Dy+lKsVsbmj
         rQZY/4rm1yqoEhoimQZoQV5/oXyuP/0THwsEzeqs1Hr2AUIHEOAgvoy5E7vD0EGJo3B0
         cKgDrSyjuJ1iXXesRWoyVLiEbszymY1esoY8fv+XF7b7LgnhXy0YpXMqZnJBs8qiZyzx
         4ltEJ3MErnS8PgsNZUbkMqBLRDBI6hzhH2wKYZaVU2rw4OmsweiOkQvU71A8dHJZVEXI
         F0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677236309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jk45hO2dJBO+eSPwpnI7b1q3xk4uLOBl8nIPeR2AALE=;
        b=ZDY6SA50Pknt59NKHRSUthJlvUaHG1NjVwsU0mrYgu1PkGaR3ZZaH6vGb7PlBR0kwV
         m6FOI+EQFGmU7zus6PHGUQhalzOyEy6GXewpOTF6d0L3CnN7d9/ful0hPH0c47nnNlmt
         4zTof5Wa4u6lo414W1WK0Th3YDSwJo05ozplo05ZTqaSdndCDVqeT7eN5eN/HmDTdYEV
         WT8uxziZykQe/McX25VBjVfbGM3D5RuotxATC8mIaOOHyP5YS5koBN8JuPheacsOip50
         XhDR9mMIvZ7o3T4sF2GA2xLpI09nDiidhl61JpcUttoFcAok5G23bZK4UsKZ2aQNK9oY
         P+Iw==
X-Gm-Message-State: AO0yUKW6ozD0SlhCAkK/LS47GzjG9gpmlEsF1X7yfBevIstAh/KHAdUT
        k/wxeWBfIS8utO46TCsB6ws=
X-Google-Smtp-Source: AK7set/LJCulTVccNUMhf4Iemv6zz4cFMBcyG7/259+FoRSgrFMuYCx00YkNHyC1fo2H2OA4BV7LBg==
X-Received: by 2002:a17:902:ab57:b0:19a:839d:b67a with SMTP id ij23-20020a170902ab5700b0019a839db67amr15847909plb.5.1677236308870;
        Fri, 24 Feb 2023 02:58:28 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id g24-20020a170902fe1800b0019c2b1c4ad4sm10044933plj.6.2023.02.24.02.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 02:58:28 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        davejwatson@fb.com, aviadye@mellanox.com, ilyal@mellanox.com,
        sd@queasysnail.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Date:   Fri, 24 Feb 2023 18:58:11 +0800
Message-Id: <20230224105811.27467-1-hbh25y@gmail.com>
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

ctx->crypto_send.info is not protected by lock_sock in
do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
and do_tls_setsockopt_conf() can cause a NULL point dereference or
use-after-free read when memcpy.

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/tls/tls_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 3735cb00905d..4956f5149b8e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -374,6 +374,7 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 	}
 
 	/* get user crypto info */
+	lock_sock(sk);
 	if (tx) {
 		crypto_info = &ctx->crypto_send.info;
 		cctx = &ctx->tx;
@@ -381,6 +382,7 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 		crypto_info = &ctx->crypto_recv.info;
 		cctx = &ctx->rx;
 	}
+	release_sock(sk);
 
 	if (!TLS_CRYPTO_INFO_READY(crypto_info)) {
 		rc = -EBUSY;
-- 
2.34.1

