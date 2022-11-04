Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778E361909E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 07:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiKDGDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 02:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiKDGDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 02:03:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88E8117A
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 23:03:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so7303371pjk.2
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 23:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88tOeLPsWCVekBUY0oEIMvHJFlQGAI2IcuZIBKwXMgk=;
        b=JZm2OwRdsLk7NuLxEFjRNHgVGuHJKJ/Ma2gRnf485bdNgjYvuPl+6lYe6ir+ic/suq
         yHnON4kTRzIp6u/lqobjdMikgGWMOUyTjGeOFeS5+BaJi8eCRdEBG7SevWOZxVP0Px8c
         T7koa1lcTJtjxwPzmt+9kS/AtrJ/ZU0llUvBpkXV7S6a1RkDyjpCC8F8KmHGP7jYdbK6
         Y6OPf7hTdTyVxsD8zfXhUaeZMY7IFE0OL/kEn5hzX/qzhNBkGPogx74bYTYbrJVbN52H
         qM7Fdh5PFltU5uyeAuFq+fsEAEEdpRk+I8G+lQt5FWE3I5PxIpS8rjqSglzAA9uKRGGT
         /f4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88tOeLPsWCVekBUY0oEIMvHJFlQGAI2IcuZIBKwXMgk=;
        b=qZ7A9ETTRzVEQsLTAB8IoZN2GtmuXUhvVe2I5kREmaubb2+qp0QlewYJAXGxPd7t/n
         UHHi+z5aFXPNTmNuCvQEBGHHKzlq9V+8suuWHURyqsqPCCpuE3Kq3h+0c1jvI39y5M29
         nrULHUV6MpzQcwSbBvNSYcR6XQZuWkdtxyZYU2neXwmctgblamDENDk/908lra+cmUmb
         EXJfUYvrIWDPhX/Lma6+Rt407T/dSyQ+K5dI688XeVoNAGlRFiNeJ4sY3l2hjaUEehXP
         FSbKYv7Kn7ySV4xIOH53mqrXFKs6iI/1Z7k5pgf1lK1tEhRzJ5+8rdTepmzuTOoXr/cw
         EnVA==
X-Gm-Message-State: ACrzQf1GvwRz0wwuvbQ0TsLlAYmTwJUfL2oNnA540TBxCENU4PXcWaPc
        8KPAAcUScVEe8Np+oNfWJXpenQ==
X-Google-Smtp-Source: AMsMyM4TrjXfnxiyLliAl0efUuwAj1Mi9IhYw8ZyLlDr/ThGa+pQP/P/MF619Khb2uuySfRZCm9ffQ==
X-Received: by 2002:a17:902:e5c8:b0:187:3593:a841 with SMTP id u8-20020a170902e5c800b001873593a841mr18941654plf.150.1667541794350;
        Thu, 03 Nov 2022 23:03:14 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902684f00b00186bc66d2cbsm1727180pln.73.2022.11.03.23.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:03:13 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v3 net-next 1/3] net: axienet: Unexport and remove unused mdio functions
Date:   Fri,  4 Nov 2022 14:03:03 +0800
Message-Id: <20221104060305.1025215-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221104060305.1025215-1-andy.chiu@sifive.com>
References: <20221104060305.1025215-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both axienet_mdio_enable functions are no longer used in
xilinx_axienet_main.c due to 253761a0e61b7. And axienet_mdio_disable is
not even used in the mdio.c. So unexport and remove them.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 --
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 13 +------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 6370c447ac5c..575ff9de8985 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -611,8 +611,6 @@ static inline void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 #endif /* CONFIG_64BIT */
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
-int axienet_mdio_enable(struct axienet_local *lp);
-void axienet_mdio_disable(struct axienet_local *lp);
 int axienet_mdio_setup(struct axienet_local *lp);
 void axienet_mdio_teardown(struct axienet_local *lp);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 0b3b6935c558..e1f51a071888 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -153,7 +153,7 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware.
  **/
-int axienet_mdio_enable(struct axienet_local *lp)
+static int axienet_mdio_enable(struct axienet_local *lp)
 {
 	u32 host_clock;
 
@@ -226,17 +226,6 @@ int axienet_mdio_enable(struct axienet_local *lp)
 	return axienet_mdio_wait_until_ready(lp);
 }
 
-/**
- * axienet_mdio_disable - MDIO hardware disable function
- * @lp:		Pointer to axienet local data structure.
- *
- * Disable the MDIO interface in hardware.
- **/
-void axienet_mdio_disable(struct axienet_local *lp)
-{
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, 0);
-}
-
 /**
  * axienet_mdio_setup - MDIO setup function
  * @lp:		Pointer to axienet local data structure.
-- 
2.36.0

