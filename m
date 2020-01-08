Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFA0133AAE
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 06:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgAHFGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 00:06:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35570 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgAHFGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 00:06:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so1115278wmb.0
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 21:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uY5O2Mtcr58bPOvnp4H3f3Q/9UtXf33LhCUTwQ4KjDk=;
        b=bSubTokB9kx06esUlxQkk7iERtP2NwvdjcVScuR+jJlcP5+SGfQPFAkWzb0s+Qq4sV
         24wE2MS2bSdEF9kqc035N6tNsjLPgEXQNdBEXUYn/iORFslLw02VUlFe2pkl4LV5lCag
         f0v9bzYcAcPnWVAHnbJ8PglaOIwADcGatmsAvJq/jcL558cAkCBdWHGf6NFWwWSQVKj+
         Xnk7oaL+Bbo2mQ+tD/IsW9f1Yt3kGXcC9Ps88pMC27yZNi4CXPCFsTE6Xa4dZ/fznQot
         uSMxEHQV2YaIZXrTqQsQaiCRct6ma+umMV7aR3TuPw7lSlZOYi0bgEhX2lC16lu+3bWO
         P3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uY5O2Mtcr58bPOvnp4H3f3Q/9UtXf33LhCUTwQ4KjDk=;
        b=EprlL2LlCv/FvN0O0XQXYepKLsiqh7M+j8e8fzEFp9nYM6P3Gzqj7l0A9h/CWUjxbI
         1yGQHSbvzkvbTsXyIXya7czeXruZH3JqyqmWm74YjiK2GaBcK3/tVBrLp/a2r3jU9LLo
         +zDmI9lQAYvAHUuOyeNeeYRtpUbAW94jnyccO1SavmljlYDxtKqRsQxGUEwx8kowtcus
         oIvhFRTycstyWaDeDu6ft61HsafLOzZb/oGEKfy2n3L4TFQNGFc1U8s5MaFohC7LCFPW
         3dJgd6tLRZSlsEQ2+2cjonokHoiGL8TEHAQTI0OOAJCnDF5aN9TFQtf4/gkWqbmrZjQv
         eNVQ==
X-Gm-Message-State: APjAAAWXWusseOGXEaoFHH/LxWHf2GOnY26VV4lrDe7SGisiBrmDAJgO
        UIA8rPOpj3hqfDCYHm2nmEWMwBBl
X-Google-Smtp-Source: APXvYqzC4YT7sjvZcI8ZyGp941gGMBSKczQYVk18tUxQsjX1deKEwTnrIvPaj/OXQu59VVduIpk2/g==
X-Received: by 2002:a05:600c:108a:: with SMTP id e10mr1459506wmd.38.1578459975513;
        Tue, 07 Jan 2020 21:06:15 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p5sm2730048wrt.79.2020.01.07.21.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 21:06:15 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/2] net: dsa: b53: Enable Broadcom tags for 531x5/539x families
Date:   Tue,  7 Jan 2020 21:06:06 -0800
Message-Id: <20200108050606.22090-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200108050606.22090-1-f.fainelli@gmail.com>
References: <20200108050606.22090-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BCM531x5 and BCM539x families require that the IMP port be enabled
within the management page and that management mode (SM_SW_FWD_MODE) be
turned on. Once this is done, everything works as expected, including
multicast with standalone DSA devices or bridge devices.

Because such switches are frequencly cascaded with other internal
Broadcom switches on which we want to enable Broadcom tags, update
b53_can_enable_brcm_tags() to check the kind of DSA master tagging
protocol being used, if it is one of the two supported Broadcom tagging
protocols, force DSA_TAG_PROTO_NONE.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 46 +++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 2b530a31ef0f..060497512159 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -371,8 +371,6 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable,
 		b53_read8(dev, B53_VLAN_PAGE, B53_VLAN_CTRL5, &vc5);
 	}
 
-	mgmt &= ~SM_SW_FWD_MODE;
-
 	if (enable) {
 		vc0 |= VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID;
 		vc1 |= VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN;
@@ -594,6 +592,22 @@ void b53_brcm_hdr_setup(struct dsa_switch *ds, int port)
 		break;
 	}
 
+	/* Enable management mode if tagging is requested */
+	b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, &hdr_ctl);
+	if (tag_en)
+		hdr_ctl |= SM_SW_FWD_MODE;
+	else
+		hdr_ctl &= ~SM_SW_FWD_MODE;
+	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, hdr_ctl);
+
+	/* Configure the appropriate IMP port */
+	b53_read8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, &hdr_ctl);
+	if (port == 8)
+		hdr_ctl |= GC_FRM_MGMT_PORT_MII;
+	else if (port == 5)
+		hdr_ctl |= GC_FRM_MGMT_PORT_M;
+	b53_write8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, hdr_ctl);
+
 	/* Enable Broadcom tags for IMP port */
 	b53_read8(dev, B53_MGMT_PAGE, B53_BRCM_HDR, &hdr_ctl);
 	if (tag_en)
@@ -1865,13 +1879,29 @@ static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 	return false;
 }
 
-static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port)
+static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port,
+				     enum dsa_tag_protocol tag_protocol)
 {
 	bool ret = b53_possible_cpu_port(ds, port);
 
-	if (!ret)
+	if (!ret) {
 		dev_warn(ds->dev, "Port %d is not Broadcom tag capable\n",
 			 port);
+		return ret;
+	}
+
+	switch (tag_protocol) {
+	case DSA_TAG_PROTO_BRCM:
+	case DSA_TAG_PROTO_BRCM_PREPEND:
+		dev_warn(ds->dev,
+			 "Port %d is stacked to Broadcom tag switch\n", port);
+		ret = false;
+		break;
+	default:
+		ret = true;
+		break;
+	}
+
 	return ret;
 }
 
@@ -1881,12 +1911,10 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 	struct b53_device *dev = ds->priv;
 
 	/* Older models (5325, 5365) support a different tag format that we do
-	 * not support in net/dsa/tag_brcm.c yet. 539x and 531x5 require managed
-	 * mode to be turned on which means we need to specifically manage ARL
-	 * misses on multicast addresses (TBD).
+	 * not support in net/dsa/tag_brcm.c yet.
 	 */
-	if (is5325(dev) || is5365(dev) || is539x(dev) || is531x5(dev) ||
-	    !b53_can_enable_brcm_tags(ds, port)) {
+	if (is5325(dev) || is5365(dev) ||
+	    !b53_can_enable_brcm_tags(ds, port, mprot)) {
 		dev->tag_protocol = DSA_TAG_PROTO_NONE;
 		goto out;
 	}
-- 
2.17.1

