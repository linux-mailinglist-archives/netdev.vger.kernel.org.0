Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2BC3F57BC
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 07:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhHXFx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 01:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhHXFxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 01:53:45 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73E0C061575;
        Mon, 23 Aug 2021 22:53:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u15so11535028plg.13;
        Mon, 23 Aug 2021 22:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lrFQm7flTkEFFwdFjWBoVvPjc3n+60qzJ4VZO7fQv8w=;
        b=QtHbrhx+OiFXKxbRJkfrAnvATXqGIwuBUfDWLS4K1YRlorq3cvz7LGthbDYr/oXXVk
         s7cdECmXymt8NJ57+vFAUdnp68J1mH0/y2Tw0y4vh+yNWAE/Crd3fUE+VrbvsaKJ16Id
         HF5JzDzZbgD5534vSeV8IdU2O/rwDIMn12/k2hjXE9sUSIynYswyuDD6kpXxMAmeRkoJ
         tPCwt7QBEsUa+DWKdGvyvYC5oyhS2AFF+sDIXqiujdm3CMU/inbiVTakOhMonUeETN8h
         mj7PapFPePifK07+7iaFsg9ZFWTeb1+BcydRX7gr4m7vi8/ROq3D8ETloDq8wg4/KCCu
         Kt+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lrFQm7flTkEFFwdFjWBoVvPjc3n+60qzJ4VZO7fQv8w=;
        b=iTbxig1NGA/u0jaJftNNSD3ovLc5W7v+Tdfy7rk1Timf9jYduuTPOpknE0fXQBfHu9
         uTPOeLpssiy2tc0NEUGbz6NMtFp9S18XJ7FHSsZT65xsIyGIbkY1Y7MIkCAh9xkPpBLo
         BxI3ISRbYvj5CDl7MyUvoOCoyx4niQBAEFfsjHPulophVZFpjYv8nkXeTQYr+kjngu2y
         IQjKsdzbv4+17DGObeq/RXojTDQ08LOhwguwdH4z6VujM/xp95FdxBBdTNkzTCQcqP8+
         MVe7GEMJswyr125fIhYJxLnFuertc76VfJvIcmKx11YcXZkmLSyUSBnesa1TsCS0KMrf
         si5w==
X-Gm-Message-State: AOAM5329b+aNMi9XCl/l+E6/iso2RgKC7a8l6seVwWC7tqgEqnHDFzNE
        XbfwzfZpKWP08hhJV/Pus+n9SrM96Vy2r1S/
X-Google-Smtp-Source: ABdhPJzz5xrfLOEviDCGsTH9xdIXyACp3PC0jd7A6XrFLpI3PQQm8uMigntzQtlu6oOPAeuketZ3bA==
X-Received: by 2002:a17:90a:e641:: with SMTP id ep1mr2530027pjb.209.1629784380935;
        Mon, 23 Aug 2021 22:53:00 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id c23sm20665523pgb.74.2021.08.23.22.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 22:53:00 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:MEDIATEK SWITCH DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5.4.y] net: dsa: mt7530: disable learning on standalone ports
Date:   Tue, 24 Aug 2021 13:52:50 +0800
Message-Id: <20210824055250.1315862-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a partial backport of commit 5a30833b9a16f8d1aa15de06636f9317ca51f9df
("net: dsa: mt7530: support MDB and bridge flag operations") upstream.

Make sure that the standalone ports start up with learning disabled.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e1a3c33fdad9..b21444b38377 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -764,6 +764,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			   PCR_MATRIX_MASK, PCR_MATRIX(port_bitmap));
 	priv->ports[port].pm |= PCR_MATRIX(port_bitmap);
 
+	mt7530_clear(priv, MT7530_PSC_P(port), SA_DIS);
+
 	mutex_unlock(&priv->reg_mutex);
 
 	return 0;
@@ -864,6 +866,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 			   PCR_MATRIX(BIT(MT7530_CPU_PORT)));
 	priv->ports[port].pm = PCR_MATRIX(BIT(MT7530_CPU_PORT));
 
+	mt7530_set(priv, MT7530_PSC_P(port), SA_DIS);
+
 	mutex_unlock(&priv->reg_mutex);
 }
 
@@ -1246,11 +1250,15 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
 			   PCR_MATRIX_CLR);
 
-		if (dsa_is_cpu_port(ds, i))
+		if (dsa_is_cpu_port(ds, i)) {
 			mt7530_cpu_port_enable(priv, i);
-		else
+		} else {
 			mt7530_port_disable(ds, i);
 
+			/* Disable learning by default on all user ports */
+			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+		}
+
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
-- 
2.25.1

