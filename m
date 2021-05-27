Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A52439374A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbhE0UrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhE0UrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC9FC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:45 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id z12so2240942ejw.0
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zZrJAKistV6Q/B1No+cwqeXn71UQaxifsVS30S0BqGc=;
        b=ITvqgLUehzvzHiGeOl+5fnFIzos2/qmnGjfPbnG8+p/wky2ysQaYXYNy64+FB/YZU5
         /O5EEaNmz20SheYA1aRRy38s+cICgFYAn1Ye3aUAIxzLsYCaY1HzKrZ3ozuqgxrGtsia
         JC5ZZfBPZvqhF1UqtKKuliyWIVeZk4UjlNb6IAm4gcfYJ9BNQq141qpA2LEmLOTab4kn
         gEwAG8Jdj0FaYVTjvv2d/d4Qmm8ySFklofTBR8DXMe23eY5eXYpiR4pGqhZZUs4lVeYD
         DM5Yza984EVEt5u4PUzn4GU7ZhHTsG/oWFqX7SUPj28MUMYV/NnH+SPuJpgEWtp62iL5
         mi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zZrJAKistV6Q/B1No+cwqeXn71UQaxifsVS30S0BqGc=;
        b=RcMmbJ/lk6mxR/5zW3w+1GIgpA99TuPqsj0nH1jGuVwah47n7J2rpTtWme0q0CDU39
         kuH2pVV/ZNR5kXfOx1UMXnP3ULRx78EG7xkZHYlQOVlOn8oyAo3OnJw3B56scYSbeDNv
         +7TH0dQkzMGbJ4Q3DCe9+xke4C6cR8Q1ZBwKofxwzQKYKEfG6ulpkPTQbscVPycpmQ/I
         ZYbNE69K3VHdqtVg7A8mrW03Tc5n8ius4GZ5qUb2aMuMYYgmLSQxklm4OWz89+LXe3FH
         82ROarTsnCJfxStw1wWme/FEBq/v7eWjTfj8nFbTSBQnsgP++/op2AyniwlSyKFxnjUu
         4dgw==
X-Gm-Message-State: AOAM531P8/W/jhEOZlwGCDdINZRIS1RKoPuqHzM/AkOetXpA9L/qVAT8
        fu9wbqSP5GXQIQjM1h6KAmA=
X-Google-Smtp-Source: ABdhPJxG1VMm5zuLTYuodIHjZWmyjo9fpn5BVeMzcpRjiy0YewA3eEewNwmswLOyX3pPNvaQWdvtLQ==
X-Received: by 2002:a17:906:5448:: with SMTP id d8mr5889849ejp.248.1622148343944;
        Thu, 27 May 2021 13:45:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 5/8] net: pcs: xpcs: export xpcs_probe
Date:   Thu, 27 May 2021 23:45:25 +0300
Message-Id: <20210527204528.3490126-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Similar to the other recently functions, it is not necessary for
xpcs_probe to be a function pointer, so export it so that it can be
called directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h        | 2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 drivers/net/pcs/pcs-xpcs.c                        | 4 ++--
 include/linux/pcs/pcs-xpcs.h                      | 2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 2d2843edaf21..5014b260844b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -619,8 +619,6 @@ struct stmmac_mmc_ops {
 	stmmac_do_callback(__priv, xpcs, get_state, __args)
 #define stmmac_xpcs_link_up(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, link_up, __args)
-#define stmmac_xpcs_probe(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, probe, __args)
 
 struct stmmac_regs_off {
 	u32 ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index d12dfa60b8ea..2af83d902ea1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -522,7 +522,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 		for (addr = 0; addr < max_addr; addr++) {
 			xpcs->addr = addr;
 
-			ret = stmmac_xpcs_probe(priv, xpcs);
+			ret = xpcs_probe(xpcs);
 			if (!ret) {
 				found = 1;
 				break;
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index a7851a8a219b..4063dcc0f767 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -934,7 +934,7 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 	return 0xffffffff;
 }
 
-static int xpcs_probe(struct mdio_xpcs_args *xpcs)
+int xpcs_probe(struct mdio_xpcs_args *xpcs)
 {
 	u32 xpcs_id = xpcs_get_id(xpcs);
 	int i;
@@ -956,12 +956,12 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs)
 
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(xpcs_probe);
 
 static struct mdio_xpcs_ops xpcs_ops = {
 	.config = xpcs_config,
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
-	.probe = xpcs_probe,
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 203aafae9166..11585fa093cd 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -31,7 +31,6 @@ struct mdio_xpcs_ops {
 			 struct phylink_link_state *state);
 	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
 		       phy_interface_t interface);
-	int (*probe)(struct mdio_xpcs_args *xpcs);
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
@@ -39,5 +38,6 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 		    int enable);
+int xpcs_probe(struct mdio_xpcs_args *xpcs);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

