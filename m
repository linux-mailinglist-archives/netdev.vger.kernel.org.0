Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA383E4FA9
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhHIW7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhHIW7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 18:59:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F66C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 15:59:31 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id go31so31824686ejc.6
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 15:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y3AKjkQhrbsJp6r3NozM8uONsoZG+T4yti+l7i+HdTw=;
        b=W8Ygkzgdv/oXhiKEDZfPiorS0cbmaV33IU6eHAFr7DG5TgHW8Q8pA/mTsmQfuf/spX
         Jo1sfSLa+xD/ZIujZsIntUxhv4yE/1rlKiwPXNl2EEt2usDIRLRzoeVYRnfTNYr7RX12
         8xPgLhXkK/XF2b/H5KGnJWGSGAnNXvycXIeGyilhgelpjCH2mNvi470ln1+b076KcGF0
         atqxVvFShxGvUWgyTlE6IFvkQ8N3fL1CbATGoU3ai48VS4S2CmPbsZ+ogBj+JTUtdeNm
         vT4AtaO791QocCs3KnQtNCdlOj/3qjspf/0pV+5ksDOq8pCdRjVyvHm7P9ArFCl6/K10
         uxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y3AKjkQhrbsJp6r3NozM8uONsoZG+T4yti+l7i+HdTw=;
        b=HYyN+hNNOzLOzD1g1+/2F/TvcVhx8UOYltiIqeo5/v7ZAMoMdNsyE8C8JZvLXl67h+
         FcGftKLP/c7TBpp8dE+g9AMMSAindaFp/mCPtLuQEdjM2p86sTtSvgedWjzDkqGMkoc4
         TvYXTLUSrU328F3CUHovvrc1c+5H1Ih6739p+9igkYdm2ETP2larBp8xN6ItBS7GzX8l
         8tuV8Vza5kLB9HGC34WK/MdwwB4N3pfuzPmCUPiRzvorMMVNfFOsrRVJxig7zDQprqYo
         wV0s3Md4iRUUpq178sqsWOUTowSXYsNEaTpBaFUGWCwo0cKuIFbuwUpIzDku48sf8ycZ
         8qyA==
X-Gm-Message-State: AOAM531exgqZxAy1ghYNChzyY3lNlY6/gCM0RNsqr9c5Vo0GIKJS+zPB
        R+R7GqBLVhInVwAzM3k3svGCJw==
X-Google-Smtp-Source: ABdhPJxqcJ16ykQwMaTUp/UVxGBDYPP+sQh99V0G2ImLy+bXYAOPJ35tQXfKx7x8TvoMmeGtmXZnAg==
X-Received: by 2002:a17:906:a0ce:: with SMTP id bh14mr24253093ejb.434.1628549970159;
        Mon, 09 Aug 2021 15:59:30 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id q8sm8585719edv.95.2021.08.09.15.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:59:29 -0700 (PDT)
Date:   Tue, 10 Aug 2021 00:59:28 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/7] net: dsa: microchip: ksz8795: Fix PVID tag insertion
Message-ID: <20210809225927.GC17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809225753.GA17207@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ksz8795 has never actually enabled PVID tag insertion, and it also
programmed the PVID incorrectly.  To fix this:

* Allow tag insertion to be controlled per ingress port.  On most
  chips, set bit 2 in Global Control 19.  On KSZ88x3 this control
  flag doesn't exist.

* When adding a PVID:
  - Set the appropriate register bits to enable tag insertion on
    egress at every other port if this was the packet's ingress port.
  - Mask *out* the VID from the default tag, before or-ing in the new
    PVID.

* When removing a PVID:
  - Clear the same control bits to disable tag insertion.
  - Don't update the default tag.  This wasn't doing anything useful.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c     | 26 ++++++++++++++++++-------
 drivers/net/dsa/microchip/ksz8795_reg.h |  4 ++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b0e2b844478a..95842f7b2f1b 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1124,6 +1124,16 @@ static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
 	return 0;
 }
 
+static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
+{
+	if (ksz_is_ksz88x3(dev)) {
+		ksz_cfg(dev, REG_SW_INSERT_SRC_PVID,
+			0x03 << (4 - 2 * port), state);
+	} else {
+		ksz_pwrite8(dev, port, REG_PORT_CTRL_12, state ? 0x0f : 0x00);
+	}
+}
+
 static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan,
 			      struct netlink_ext_ack *extack)
@@ -1160,9 +1170,11 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 		u16 vid;
 
 		ksz_pread16(dev, port, REG_PORT_CTRL_VID, &vid);
-		vid &= 0xfff;
+		vid &= ~VLAN_VID_MASK;
 		vid |= new_pvid;
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
+
+		ksz8_port_enable_pvid(dev, port, true);
 	}
 
 	return 0;
@@ -1173,7 +1185,7 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, pvid, new_pvid = 0;
+	u16 data, pvid;
 	u8 fid, member, valid;
 
 	if (ksz_is_ksz88x3(dev))
@@ -1195,14 +1207,11 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 		valid = 0;
 	}
 
-	if (pvid == vlan->vid)
-		new_pvid = 1;
-
 	ksz8_to_vlan(dev, fid, member, valid, &data);
 	ksz8_w_vlan_table(dev, vlan->vid, data);
 
-	if (new_pvid != pvid)
-		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, pvid);
+	if (pvid == vlan->vid)
+		ksz8_port_enable_pvid(dev, port, false);
 
 	return 0;
 }
@@ -1438,6 +1447,9 @@ static int ksz8_setup(struct dsa_switch *ds)
 
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
 
+	if (!ksz_is_ksz88x3(dev))
+		ksz_cfg(dev, REG_SW_CTRL_19, SW_INS_TAG_ENABLE, true);
+
 	/* set broadcast storm protection 10% rate */
 	regmap_update_bits(dev->regmap[1], S_REPLACE_VID_CTRL,
 			   BROADCAST_STORM_RATE,
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index a32355624f31..6b40bc25f7ff 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -631,6 +631,10 @@
 #define REG_PORT_4_OUT_RATE_3		0xEE
 #define REG_PORT_5_OUT_RATE_3		0xFE
 
+/* 88x3 specific */
+
+#define REG_SW_INSERT_SRC_PVID		0xC2
+
 /* PME */
 
 #define SW_PME_OUTPUT_ENABLE		BIT(1)
-- 
2.20.1

