Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05972213331
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 07:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgGCFBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 01:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCFBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 01:01:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D5BC08C5C1;
        Thu,  2 Jul 2020 22:01:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q15so30502720wmj.2;
        Thu, 02 Jul 2020 22:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6CSz1t21P1s1QIl9drzthPclFfgp444pHgQTTwZGkmQ=;
        b=WUfuaAYEalJm2sFaTpMXXet+97GEzCAVWd/iNCgAzj6QWaNBYjDdZ+2u1oDS7DYjbW
         RPcRf9DIXb1L8u4hRSz1jmV0FulcqktY4eaug/Of328YC8xbKogvAV+uG5erAVbGNx1D
         faXVIVT1IaGda5Kx/F+uzCDX+rtz8ZJbbJ8OVZ94iMaE7DhXfyYSlAXW72sjlz04ZtU0
         KJA/g+nM8S2QqUBU+acGxZmznjeimE+Vl3P9IuE6Suk9SmKBEiTr97Yb3MGiSdftUVJZ
         TFYSFIenl8pgzQ7/8wFQfCFoMnBUeXc+efOWJc0aCSH3TuAo4XOvszaXMjB8PSOI6JSO
         GFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6CSz1t21P1s1QIl9drzthPclFfgp444pHgQTTwZGkmQ=;
        b=onI51TfUvsiGVMsjj+R8xyNzVRXV1wPNJ8In4sdSwUVWj0vdsM6dpOE4Oky+kXoMvs
         p6hTwSEjKlsZC5dbL+cS0loRAu3IbRLLrDZLRW4ZFFFBQz9eWXGO1LI0ltd0iMaDnyks
         +okC3juRbudwtXaGOhzrX3bQ3dag5YJUD15iCDlYo6UW4k0nV42dcg6o6zXrEfs3MLDB
         SGOq4cCsDErOMl8D2ir6yO+q+kRg1RiCnXTLQ4su/vJNGkmGVIlAdQIZNfAi+AeJ23JH
         pphz5WFHxZ7LJnahNJi/v8IEpVkO/f7xEMzcHkj0W9IJIuduPSu/Lae7wmI5KQbvxE+H
         bvhA==
X-Gm-Message-State: AOAM533R3sq/iPUJeFklNllF9v1ir70aQkyUkq7TSe0j6DeeXHAFU64B
        WyeE2oPVoCL/IvcPH9R7a6V7GyVF
X-Google-Smtp-Source: ABdhPJynSKlEqRb/diSRVpUGdPQ5MaWQTUnWAFqpAeaVknbLbirBgTTn9hhSBOI8Xy5+dT9iJGPBvA==
X-Received: by 2002:a1c:7313:: with SMTP id d19mr21986941wmb.147.1593752510024;
        Thu, 02 Jul 2020 22:01:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g14sm12397967wrm.93.2020.07.02.22.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 22:01:49 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: bcmgenet: Allow changing carrier from user-space
Date:   Thu,  2 Jul 2020 21:57:00 -0700
Message-Id: <20200703045701.18996-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GENET driver interfaces with internal MoCA interface as well as
external MoCA chips like the BCM6802/6803 through a fixed link
interface. It is desirable for the mocad user-space daemon to be able to
control the carrier state based upon out of band messages that it
receives from the MoCA chip.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index af924a8b885f..ee84a26bd8f3 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3647,6 +3647,22 @@ static struct net_device_stats *bcmgenet_get_stats(struct net_device *dev)
 	return &dev->stats;
 }
 
+static int bcmgenet_change_carrier(struct net_device *dev, bool new_carrier)
+{
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+
+	if (!dev->phydev || !phy_is_pseudo_fixed_link(dev->phydev) ||
+	    priv->phy_interface != PHY_INTERFACE_MODE_MOCA)
+		return -EOPNOTSUPP;
+
+	if (new_carrier)
+		netif_carrier_on(dev);
+	else
+		netif_carrier_off(dev);
+
+	return 0;
+}
+
 static const struct net_device_ops bcmgenet_netdev_ops = {
 	.ndo_open		= bcmgenet_open,
 	.ndo_stop		= bcmgenet_close,
@@ -3660,6 +3676,7 @@ static const struct net_device_ops bcmgenet_netdev_ops = {
 	.ndo_poll_controller	= bcmgenet_poll_controller,
 #endif
 	.ndo_get_stats		= bcmgenet_get_stats,
+	.ndo_change_carrier	= bcmgenet_change_carrier,
 };
 
 /* Array of GENET hardware parameters/characteristics */
-- 
2.17.1

