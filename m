Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078C96BE1CE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjCQHQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQHQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:16:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B0D10CD;
        Fri, 17 Mar 2023 00:16:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so4253933pjg.4;
        Fri, 17 Mar 2023 00:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679037403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=twdLlgB3/E3HSbMTtDor1opxwUKFLrWwvnMciQmwMZw=;
        b=PSnreZneZ+daXFmxmBfyRM8oFppTxIPoLSkAQVJXO425Ams0XucJ29tF4NZ2pCr/DZ
         W4t6jB+urog/fxeD+uVczo/pSQiCUKz6n1Cturd5fMhf3oduhppStGOfySmai9oqRGrR
         xHf+UQWdqH+aY+eh7Zk1O+kCfW2dN7usRAWCwzDOVYt6ahI04FWI/bf+dJdfsx5Kz5KP
         0BKi8vkdVscgdYPYxPUE+BoL/J1vFwTH6ixaHRwrNcWZ27CAOUersTjxffeZoqWac6ms
         Lw3Ua6KYPfDs32wxC0pEEOEKxh6udbW2viYzE5uCVmmzp3cj2iepEkyrlX35ERHtd1GZ
         ALEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679037403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=twdLlgB3/E3HSbMTtDor1opxwUKFLrWwvnMciQmwMZw=;
        b=qvbdDKr74dcNie3W0DlrQTzSyRH1s24cEAgh/QHTRSPYVdlXkTbKvFuza7iFJeeQu4
         938Gi/riImMeViZBr8PuKoap8juKZpHyLs7xg/5SpYpRdUsyePn1GZlKH+didtywd1hL
         R9mnmlGk7C51muGh0xPgTRRRgj3rvGYGN7wRVh3J6YzpHPxlgu5WOwieFdiK/8KCKQHE
         39SOEvob9xRWLK/IUDbaA7VmmYT1QeOnRiEvcvlMbLZJmlsO6rPssFKrnx/JoVHB0FiS
         NhQYG6z7nyPnbONT0MXZxl1bft6ehjeu9pT02ALYiUMNgDwrMpZETTlhKLFutLts2nPI
         R7sg==
X-Gm-Message-State: AO0yUKXgsoYxyztGkE+Rr1tqg95AebrgHXJjyoKW2zCDm4DG/mlAPnXt
        qjLRID30qsA/SfLZXqznSYE=
X-Google-Smtp-Source: AK7set/zUnAVf6iz7d2V6pdox3/jQlIdrwRizEbq0p1299dimTSDl4ZFN+7EKJbuB4kNVGBHh3qtXg==
X-Received: by 2002:a17:902:dac9:b0:19e:82d5:634c with SMTP id q9-20020a170902dac900b0019e82d5634cmr8183720plx.53.1679037402633;
        Fri, 17 Mar 2023 00:16:42 -0700 (PDT)
Received: from passwd123-ThinkStation-P920.. ([222.20.94.23])
        by smtp.gmail.com with ESMTPSA id w4-20020a1709029a8400b0019a773419a6sm832498plp.170.2023.03.17.00.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 00:16:42 -0700 (PDT)
From:   Kang Chen <void0red@gmail.com>
To:     borisp@nvidia.com
Cc:     john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        dirk.vandermerwe@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kang Chen <void0red@gmail.com>
Subject: [PATCH] net/tls: refine the branch condition in tls_dev_event
Date:   Fri, 17 Mar 2023 15:16:36 +0800
Message-Id: <20230317071636.1028488-1-void0red@gmail.com>
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

dev->tlsdev_ops may be null and cause null pointer dereference later.

Fixes: eeb2efaf36c7 ("net/tls: generalize the resync callback")
Signed-off-by: Kang Chen <void0red@gmail.com>
---
 net/tls/tls_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a7cc4f9faac2..f30a8fe373c2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1449,7 +1449,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 		if (netif_is_bond_master(dev))
 			return NOTIFY_DONE;
 		if ((dev->features & NETIF_F_HW_TLS_RX) &&
-		    !dev->tlsdev_ops->tls_dev_resync)
+		   (!dev->tlsdev_ops || (dev->tlsdev_ops &&
+		    !dev->tlsdev_ops->tls_dev_resync)))
 			return NOTIFY_BAD;
 
 		if  (dev->tlsdev_ops &&
-- 
2.34.1

