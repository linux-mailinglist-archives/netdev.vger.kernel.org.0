Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BF134EB31
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhC3OzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbhC3Oyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:54:35 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCD8C061764
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:35 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id dm8so18570206edb.2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BdsP1ZW4mSaGfjx1+f6l0OI23FJr15hztFckhKv01eA=;
        b=W4dBDgWTdB1HIMPVlao1P6yedSJ3NMZ/CI4THsemLchAoPa3OYI0+988OBooId5/ik
         bHadgHPvFB7jS60ItaEMRLQht+nlTFER6HewLApGf8I+OCK/svcD71VI58BzUNABsfc8
         a8kpzL7oST00EjyI8iPM07ezAzOAXQXjApVZdyT4YDYcn/K4h0A8shl9pkkOeWoyAb5K
         kE2/NaeDDkvSrPIowWWNeII2XKbg9keuPAKTzs3MdcpHrE/uCtKWqI+PWXD2vtWXdJgn
         bM2pNLmlY06x8X8lRLhsAgRFHLPr97t1Rg2gyf6VxERBOJoOH0kP92KAwoQCI2EQzOPf
         4m4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BdsP1ZW4mSaGfjx1+f6l0OI23FJr15hztFckhKv01eA=;
        b=rJLsf7p4SzJYJckaVtagX12050gGDa7O2RulbhGCZN8aY7c8ok/KT+AZtEd7g56Nen
         cM31g6xXNFlGwJG/rWCdD/MeWFIT79/KmUGVMLUXdR+n6c0pgn5+5eLtRdAjisCFrAyi
         uyPBJmmVMi8jv6Y2y8SeDm9JZwqSPbtbYn4/z5vnS6CtM4cz9W5inVlkC6AJ5aWgDLzy
         JWSYBqII6j9X5F1PT+6MVMhy6X4g84xicjdBPeR2jW+OVKoYgSdt39eMoNh93yYWtSLY
         ile44osT7b1FGaSUDirm0k0Z8tyCazSqaY/WpnncAiak2UN1N80agqqzzCLPBQxgz6rU
         H67A==
X-Gm-Message-State: AOAM532e4jqa7VKy/cnQmLrgclhbRDdc0/mlB7M4V/SLssYyjgtsY4rG
        EYCo/MnrE1OSh1QCVBovBFQ=
X-Google-Smtp-Source: ABdhPJwr1x/m/fBqAWZ303OKAHU+AVichc7x2dacdsx3sm56hqqBt1q78yplvD73k0IERHV6h2BJVg==
X-Received: by 2002:a05:6402:3592:: with SMTP id y18mr28745064edc.360.1617116073813;
        Tue, 30 Mar 2021 07:54:33 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id la15sm10284625ejb.46.2021.03.30.07.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 07:54:33 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/5] dpaa2-switch: setup learning state on STP state change
Date:   Tue, 30 Mar 2021 17:54:19 +0300
Message-Id: <20210330145419.381355-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210330145419.381355-1-ciorneiioana@gmail.com>
References: <20210330145419.381355-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Depending on what STP state a port is in, the learning on that port
should be enabled or disabled.

When the STP state is DISABLED, BLOCKING or LISTENING no learning should
be happening irrespective of what the bridge previously requested. The
learning state is changed to be the one setup by the bridge when the STP
state is LEARNING or FORWARDING.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 34 ++++++++++++++-----
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 72b7ba003538..80efc8116963 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1250,14 +1250,6 @@ static void dpaa2_switch_teardown_irqs(struct fsl_mc_device *sw_dev)
 	fsl_mc_free_irqs(sw_dev);
 }
 
-static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
-						u8 state)
-{
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
-
-	return dpaa2_switch_port_set_stp_state(port_priv, state);
-}
-
 static int dpaa2_switch_port_set_learning(struct ethsw_port_priv *port_priv, bool enable)
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
@@ -1280,6 +1272,32 @@ static int dpaa2_switch_port_set_learning(struct ethsw_port_priv *port_priv, boo
 	return err;
 }
 
+static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
+						u8 state)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	int err;
+
+	err = dpaa2_switch_port_set_stp_state(port_priv, state);
+	if (err)
+		return err;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		err = dpaa2_switch_port_set_learning(port_priv, false);
+		break;
+	case BR_STATE_LEARNING:
+	case BR_STATE_FORWARDING:
+		err = dpaa2_switch_port_set_learning(port_priv,
+						     port_priv->learn_ena);
+		break;
+	}
+
+	return err;
+}
+
 static int dpaa2_switch_port_flood(struct ethsw_port_priv *port_priv,
 				   struct switchdev_brport_flags flags)
 {
-- 
2.30.0

