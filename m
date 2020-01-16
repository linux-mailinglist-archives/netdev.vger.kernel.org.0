Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B317D13EDDD
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407108AbgAPSFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:05:37 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40016 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390828AbgAPRjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:39:54 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so4688013wmi.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 09:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5is99BpkG2bxKMbDNNsbXDKVl3CfNLut+2t3w5aK8G8=;
        b=ps9l1zC/Wer3Qt/zgMtVMieT7O2NLj0eNKQZVQ2CeYgj0gpg0KsmsIMG8G/cTttAc4
         HyOYe/2cCIJiqkZrF03GtB8LM1YlyL28oQoGTctONq4NqiBUTOqXpb2txvEtp9gDFqmU
         NcKs3QDGhD2RB1xaA+rAcMhYV9quN8jkWs4+DkCbqEzPjn7VBUK5+x19nsAv4k9jAWlu
         +o3zvxL+Gnk5i0mAyHdNRXbX7opvdibYs84IYJ8sZw2FiWX8jkIpAWMEtZ95Py3TEJWj
         1Qy97C+bKrwO6I2nAzWEdow7eZBAEjPezp6exV4mtl8z/5AXWaR1lRXMTXCf6Xmen+WJ
         Jp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5is99BpkG2bxKMbDNNsbXDKVl3CfNLut+2t3w5aK8G8=;
        b=HPa9lnigrWsv+SY/ZW9L1EGxF6pDrxUf3zG8wXdTodkHr/JTVNlM1x00/x7ajER0//
         CvT1QmxccIT5IY5xquWMwEIn2wlhpJeNukQTaLexZqfzMo89z27untfY3+f+Hk9ssU2O
         u4H4dW6vMjwhagRIhQbI0/2JUiiVINYeF8GCxQRHQaldPtz7r55OZT2iasHvgJl/OuOF
         ZTF1HXbQVKMzNXkaHWgXh+Pt9vciIbBvcBPb8zSbwuABpzCzwuR6e4MwxtbzSc/cqaIy
         HXMe0MWNMAOVj39FERisBd0bGYgqBKxLAmj/WDgIpM2G6Fjdq2oUKSDZEuNc9H90mNSa
         RZ8g==
X-Gm-Message-State: APjAAAWoR/IUFy5CJoLSbJfXwWAW2nJ1Aa02wDYW25aRJGE6b9Yj+5oq
        CHrT3V5SLBkpOZ8ElCnl49c=
X-Google-Smtp-Source: APXvYqyu/+hPKS4RaFS5b1PKCqZtkK3iaqHG51KuIR1N4tlr91JMC1rLkkC0wpPt3ErBDMPfYvoa5g==
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr136104wme.125.1579196392752;
        Thu, 16 Jan 2020 09:39:52 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l3sm27420316wrt.29.2020.01.16.09.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 09:39:52 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: phylink: allow in-band AN for USXGMII
Date:   Thu, 16 Jan 2020 19:39:30 +0200
Message-Id: <20200116173930.14775-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

USXGMII supports passing link information in-band between PHY and MAC PCS,
add it to the list of protocols that support in-band AN mode.

Being a MAC-PHY protocol that can auto-negotiate link speeds up to 10
Gbps, we populate the initial supported mask with the entire spectrum of
link modes up to 10G that PHYLINK supports, and we let the driver reduce
that mask in its .phylink_validate method.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index efabbfa4a6d3..f40d92ec32f8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -299,6 +299,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			break;
 
 		case PHY_INTERFACE_MODE_10GKR:
+		case PHY_INTERFACE_MODE_USXGMII:
 		case PHY_INTERFACE_MODE_10GBASER:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
-- 
2.17.1

