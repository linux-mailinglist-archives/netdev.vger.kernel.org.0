Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F1224EFC6
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 23:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgHWVA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 17:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgHWVA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 17:00:57 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852EFC061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:00:56 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w25so7351404ljo.12
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/uQG4/eeVpHy56uC+GghYBZxeH2U6FillnYvCar+c0=;
        b=GvfmVngGBKz4vYvmxSB361oZp1f40UdjlDjENbvlTYuHkbsbs0kOFMpvYOJjmM6u3F
         CjuuI3g/8835ZSfXXAXSz5RytwV0csOJ4NEVdkxDhIPdwTqhBn66T4Hb0W2fIO9zwVsC
         4KChdivN76nG4kQKRTW43tF0fsPXSYjpkDn8/iDCdk4nH+3KoN3g+rcveZs6rI258o6f
         UAHOvHgFeoUJj+i1jXO+xncPWuiYCXIIH/0jPluY3ijj4K7m2nrusvX26GV4pHofqbA2
         lLeZw/7xghFf4WpDs1obqK2WrARr+yGq+MWnxwMZr5TuFs2x/WwxnTgKCsjmbbjsyJeg
         J4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/uQG4/eeVpHy56uC+GghYBZxeH2U6FillnYvCar+c0=;
        b=lTinMUAxbt9adzXK0n9f6s+leKwK5E4nVRH04CRjsAMNNRDtBpGHqoOucQJsLfHVj/
         snQyzbSDVQpz+D/4cHdj130TkkVfo/ufKwbBFIZVvQYNkwiWTBU7GvLepqSCUzLvLqXN
         s7wZql/rgJxt4zePL/PxqogFjo3Hc3C0HpsuVqJmO5ISX4B3aV3wEvqtZ/zjBhtVx0aN
         3S+kQ0cMcU68a3dlHWfajYXAMzNZNAM9V3mNWiRtMLLFXM1jWnThacRI1JynQ34sv71X
         CjnIQ3174nZT6AgeIwswYLW2U27i2Lfi461AVE+4q5t0yXTJ4hml+rBTWFRrgm2RguiT
         sHbg==
X-Gm-Message-State: AOAM530+XQj30XdyXMcmakkrhKWn90CdpXex9Q7ktbznaEpVoZfXQSu9
        svZluC3Y2Eo2g8wMog+ShWjTgg==
X-Google-Smtp-Source: ABdhPJzc7ccdRtDkCCSDDf1bf5m7XBoBgS3acEhVjJ5leOpKeIfqkQCNBR9qby1HQGo9oqRC06rfqA==
X-Received: by 2002:a2e:a28d:: with SMTP id k13mr1181292lja.11.1598216454452;
        Sun, 23 Aug 2020 14:00:54 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id y9sm1786184ljm.89.2020.08.23.14.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 14:00:53 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 2/2] net: dsa: rtl8366: Refactor VLAN/PVID init
Date:   Sun, 23 Aug 2020 22:59:44 +0200
Message-Id: <20200823205944.127796-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823205944.127796-1-linus.walleij@linaro.org>
References: <20200823205944.127796-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLANs and PVIDs on the RTL8366 utilizes a "member
configuration" (MC) which is largely unexplained in the
code.

This set-up requires a special ordering: rtl8366_set_pvid()
must be called first, followed by rtl8366_set_vlan(),
else the MC will not be properly allocated. Relax this
by factoring out the code obtaining an MC and reuse
the helper in both rtl8366_set_pvid() and
rtl8366_set_vlan() so we remove this strict ordering
requirement.

In the process, add some better comments and debug prints
so people who read the code understand what is going on.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/realtek-smi-core.h |   4 +-
 drivers/net/dsa/rtl8366.c          | 277 +++++++++++++++--------------
 2 files changed, 150 insertions(+), 131 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 9a63b51e1d82..6f2dab7e33d6 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -25,6 +25,9 @@ struct rtl8366_mib_counter {
 	const char	*name;
 };
 
+/**
+ * struct rtl8366_vlan_mc - Virtual LAN member configuration
+ */
 struct rtl8366_vlan_mc {
 	u16	vid;
 	u16	untag;
@@ -119,7 +122,6 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi);
 int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used);
 int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 		     u32 untag, u32 fid);
-int rtl8366_get_pvid(struct realtek_smi *smi, int port, int *val);
 int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 		     unsigned int vid);
 int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 7c34c991c834..c956d463bb1d 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -36,12 +36,116 @@ int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used)
 }
 EXPORT_SYMBOL_GPL(rtl8366_mc_is_used);
 
+/**
+ * rtl8366_obtain_mc() - retrieve or allocate a VLAN member configuration
+ * @smi: the Realtek SMI device instance
+ * @vid: the VLAN ID to look up or allocate
+ * @vlanmc: the pointer will be assigned to a pointer to a valid member config
+ * if successful
+ * @index: the pointer will be assigned to the index of the valid member config
+ * if successful
+ * @return: 0 or error number
+ */
+static int rtl8366_obtain_mc(struct realtek_smi *smi, int vid,
+			     struct rtl8366_vlan_mc *vlanmc, int *index)
+{
+	struct rtl8366_vlan_4k vlan4k;
+	int ret;
+	int i;
+
+	/* Try to find an existing member config entry for this VID */
+	for (i = 0; i < smi->num_vlan_mc; i++) {
+		ret = smi->ops->get_vlan_mc(smi, i, vlanmc);
+		if (ret) {
+			dev_err(smi->dev, "error searching for VLAN MC %d for VID %d\n",
+				i, vid);
+			return ret;
+		}
+
+		if (vid == vlanmc->vid) {
+			*index = i;
+			return 0;
+		}
+	}
+
+	/* We have no MC entry for this VID, try to find an empty one */
+	for (i = 0; i < smi->num_vlan_mc; i++) {
+		ret = smi->ops->get_vlan_mc(smi, i, vlanmc);
+		if (ret) {
+			dev_err(smi->dev, "error searching for VLAN MC %d for VID %d\n",
+				i, vid);
+			return ret;
+		}
+
+		if (vlanmc->vid == 0 && vlanmc->member == 0) {
+			/* Update the entry from the 4K table */
+			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
+			if (ret) {
+				dev_err(smi->dev, "error looking for 4K VLAN MC %d for VID %d\n",
+					i, vid);
+				return ret;
+			}
+
+			vlanmc->vid = vid;
+			vlanmc->member = vlan4k.member;
+			vlanmc->untag = vlan4k.untag;
+			vlanmc->fid = vlan4k.fid;
+			ret = smi->ops->set_vlan_mc(smi, i, vlanmc);
+			if (ret) {
+				dev_err(smi->dev, "unable to set/update VLAN MC %d for VID %d\n",
+					i, vid);
+				return ret;
+			}
+
+			dev_dbg(smi->dev, "created new MC at index %d for VID %d\n",
+				i, vid);
+			*index = i;
+			return 0;
+		}
+	}
+
+	/* MC table is full, try to find an unused entry and replace it */
+	for (i = 0; i < smi->num_vlan_mc; i++) {
+		int used;
+
+		ret = rtl8366_mc_is_used(smi, i, &used);
+		if (ret)
+			return ret;
+
+		if (!used) {
+			/* Update the entry from the 4K table */
+			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
+			if (ret)
+				return ret;
+
+			vlanmc->vid = vid;
+			vlanmc->member = vlan4k.member;
+			vlanmc->untag = vlan4k.untag;
+			vlanmc->fid = vlan4k.fid;
+			ret = smi->ops->set_vlan_mc(smi, i, vlanmc);
+			if (ret) {
+				dev_err(smi->dev, "unable to set/update VLAN MC %d for VID %d\n",
+					i, vid);
+				return ret;
+			}
+			dev_dbg(smi->dev, "recycled MC at index %i for VID %d\n",
+				i, vid);
+			*index = i;
+			return 0;
+		}
+	}
+
+	dev_err(smi->dev, "all VLAN member configurations are in use\n");
+	return -EINVAL;
+}
+
 int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 		     u32 untag, u32 fid)
 {
+	struct rtl8366_vlan_mc vlanmc;
 	struct rtl8366_vlan_4k vlan4k;
+	int index;
 	int ret;
-	int i;
 
 	if (!smi->ops->is_vlan_valid(smi, vid))
 		return -EINVAL;
@@ -66,136 +170,56 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 		"resulting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, vlan4k.member, vlan4k.untag);
 
-	/* Try to find an existing MC entry for this VID */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		struct rtl8366_vlan_mc vlanmc;
-
-		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-		if (ret)
-			return ret;
-
-		if (vid == vlanmc.vid) {
-			/* update the MC entry */
-			vlanmc.member |= member;
-			vlanmc.untag |= untag;
-			vlanmc.fid = fid;
-
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-
-			dev_dbg(smi->dev,
-				"resulting VLAN%d MC members: 0x%02x, untagged: 0x%02x\n",
-				vid, vlanmc.member, vlanmc.untag);
-
-			break;
-		}
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(rtl8366_set_vlan);
-
-int rtl8366_get_pvid(struct realtek_smi *smi, int port, int *val)
-{
-	struct rtl8366_vlan_mc vlanmc;
-	int ret;
-	int index;
-
-	ret = smi->ops->get_mc_index(smi, port, &index);
+	/* Find or allocate a member config for this VID */
+	ret = rtl8366_obtain_mc(smi, vid, &vlanmc, &index);
 	if (ret)
 		return ret;
 
-	ret = smi->ops->get_vlan_mc(smi, index, &vlanmc);
+	/* Update the MC entry */
+	vlanmc.member |= member;
+	vlanmc.untag |= untag;
+	vlanmc.fid = fid;
+
+	/* Commit updates to the MC entry */
+	ret = smi->ops->set_vlan_mc(smi, index, &vlanmc);
 	if (ret)
-		return ret;
+		dev_err(smi->dev, "failed to commit changes to VLAN MC index %d for VID %d\n",
+			index, vid);
+	else
+		dev_dbg(smi->dev,
+			"resulting VLAN%d MC members: 0x%02x, untagged: 0x%02x\n",
+			vid, vlanmc.member, vlanmc.untag);
 
-	*val = vlanmc.vid;
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(rtl8366_get_pvid);
+EXPORT_SYMBOL_GPL(rtl8366_set_vlan);
 
 int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 		     unsigned int vid)
 {
 	struct rtl8366_vlan_mc vlanmc;
-	struct rtl8366_vlan_4k vlan4k;
+	int index;
 	int ret;
-	int i;
 
 	if (!smi->ops->is_vlan_valid(smi, vid))
 		return -EINVAL;
 
-	/* Try to find an existing MC entry for this VID */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-		if (ret)
-			return ret;
-
-		if (vid == vlanmc.vid) {
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-			if (ret)
-				return ret;
-
-			ret = smi->ops->set_mc_index(smi, port, i);
-			return ret;
-		}
-	}
-
-	/* We have no MC entry for this VID, try to find an empty one */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-		if (ret)
-			return ret;
-
-		if (vlanmc.vid == 0 && vlanmc.member == 0) {
-			/* Update the entry from the 4K table */
-			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
-			if (ret)
-				return ret;
-
-			vlanmc.vid = vid;
-			vlanmc.member = vlan4k.member;
-			vlanmc.untag = vlan4k.untag;
-			vlanmc.fid = vlan4k.fid;
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-			if (ret)
-				return ret;
-
-			ret = smi->ops->set_mc_index(smi, port, i);
-			return ret;
-		}
-	}
-
-	/* MC table is full, try to find an unused entry and replace it */
-	for (i = 0; i < smi->num_vlan_mc; i++) {
-		int used;
-
-		ret = rtl8366_mc_is_used(smi, i, &used);
-		if (ret)
-			return ret;
-
-		if (!used) {
-			/* Update the entry from the 4K table */
-			ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
-			if (ret)
-				return ret;
-
-			vlanmc.vid = vid;
-			vlanmc.member = vlan4k.member;
-			vlanmc.untag = vlan4k.untag;
-			vlanmc.fid = vlan4k.fid;
-			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-			if (ret)
-				return ret;
+	/* Find or allocate a member config for this VID */
+	ret = rtl8366_obtain_mc(smi, vid, &vlanmc, &index);
+	if (ret)
+		return ret;
 
-			ret = smi->ops->set_mc_index(smi, port, i);
-			return ret;
-		}
+	ret = smi->ops->set_mc_index(smi, port, index);
+	if (ret) {
+		dev_err(smi->dev, "set PVID: failed to set MC index %d for port %d\n",
+			index, port);
+		return ret;
 	}
 
-	dev_err(smi->dev,
-		"all VLAN member configurations are in use\n");
+	dev_dbg(smi->dev, "set PVID: the PVID for port %d set to %d using existing MC index %d\n",
+		port, vid, index);
 
-	return -ENOSPC;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rtl8366_set_pvid);
 
@@ -395,7 +419,8 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		if (!smi->ops->is_vlan_valid(smi, vid))
 			return;
 
-	dev_info(smi->dev, "add VLAN on port %d, %s, %s\n",
+	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
+		 vlan->vid_begin,
 		 port,
 		 untagged ? "untagged" : "tagged",
 		 pvid ? " PVID" : "no PVID");
@@ -404,34 +429,26 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		dev_err(smi->dev, "port is DSA or CPU port\n");
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		int pvid_val = 0;
-
-		dev_info(smi->dev, "add VLAN %04x\n", vid);
 		member |= BIT(port);
 
 		if (untagged)
 			untag |= BIT(port);
 
-		/* To ensure that we have a valid MC entry for this VLAN,
-		 * initialize the port VLAN ID here.
-		 */
-		ret = rtl8366_get_pvid(smi, port, &pvid_val);
-		if (ret < 0) {
-			dev_err(smi->dev, "could not lookup PVID for port %d\n",
-				port);
-			return;
-		}
-		if (pvid_val == 0) {
-			ret = rtl8366_set_pvid(smi, port, vid);
-			if (ret < 0)
-				return;
-		}
-
 		ret = rtl8366_set_vlan(smi, vid, member, untag, 0);
 		if (ret)
 			dev_err(smi->dev,
 				"failed to set up VLAN %04x",
 				vid);
+
+		ret = rtl8366_set_pvid(smi, port, vid);
+		if (ret)
+			dev_err(smi->dev,
+				"failed to set PVID on port %d to VLAN %04x",
+				port, vid);
+
+		if (!ret)
+			dev_dbg(smi->dev, "VLAN add: added VLAN %04x with PVID on port %d\n",
+				vid, port);
 	}
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
-- 
2.26.2

