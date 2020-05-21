Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967531DD921
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbgEUVKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730588AbgEUVKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:10:55 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B403AC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:54 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l5so7718946edn.7
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7EJrLMpzY+C3z3PmCt7FDRoPiUWJj/HjfBBfF1vmR1U=;
        b=rD4HQ7K201xuPOQn9RFBl4hVm+Z5SZAumze+80WRgwEM8QraSYdTZNoEmN8O4s3lUx
         84aTXX16IwlOOdznEemOani896FegtlumwlxoEQE3PbKl3P8fT87VAR3b80399QYmZMh
         UhhdHNyJm+BKnEuSa9Qn7hwS8fnlUz2cIcVe+sWBi7sZEidmCnNNwX1WFUN6LVVg3g6H
         p2t/AsuHUhAL1zbCoGHdN675tTYNnSiawIS+Mp7iYCMyIVU49D95AGdBFC6EoPXemgKM
         Lp+/XImcIaM1fjFFFyHorztZYj2Pya0rgUjfAqLpgL7OIk67Z0TIe1sf4+I/hN3iVPhF
         0Ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7EJrLMpzY+C3z3PmCt7FDRoPiUWJj/HjfBBfF1vmR1U=;
        b=GHhEact4ZMsyraYgjzTQoSPfwcFPYeJ4pkrHNZR8cw5kSIaoLxSGud7w06ZOVE5yjv
         Octe1K9rdTdqtbcIHWfpMzIsY61P7iN9Ao191yb08etOpjLkcDq2XVucCTgvCyF+4I2M
         vxnxjh6MdvatnpJ+eeLysOlxkXHMU8QzH9xVOYhEIkG0i3lGzsStbT7i/ccjYp18z6is
         ylbwLfnvFy5FzEgD1rjoKrGqygy4Woyon5ulrrN4cGL1BEnAQ9PEpeIslzUQANFGmryV
         FPzlqzqpSq7C4QEBggDn/DmZ+LybMS4IG4xFkiFSG0YHIJK+i6IIBRVOAqevNPqlau5Y
         kTBQ==
X-Gm-Message-State: AOAM530g/Pp/icd4LJ9bJgSSfw6fWcTYJ+DG/XK2TVj7meIptjAA42Tp
        th5/iSdjvhM0rSfYOVhl094=
X-Google-Smtp-Source: ABdhPJyFJq1ZKCCu5no0kld4rDHa5vEzCC8Y/A4mQqDVAllguFNJ3knVYhbYWIryGEH+T3VzOs9j2g==
X-Received: by 2002:a05:6402:783:: with SMTP id d3mr544488edy.295.1590095453449;
        Thu, 21 May 2020 14:10:53 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:10:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 02/13] net: 8021q: vlan_dev: add vid tag to addresses of uc and mc lists
Date:   Fri, 22 May 2020 00:10:25 +0300
Message-Id: <20200521211036.668624-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Update vlan mc and uc addresses with VID tag while propagating
addresses to lower devices, do this only if address is not synced.
It allows at end driver level to distinguish addresses belonging
to vlan devices.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_vlan.h |  1 +
 net/8021q/vlan.h        |  2 ++
 net/8021q/vlan_core.c   | 13 +++++++++++++
 net/8021q/vlan_dev.c    | 26 ++++++++++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index b05e855f1ddd..20407f73cfee 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -131,6 +131,7 @@ extern struct net_device *__vlan_find_dev_deep_rcu(struct net_device *real_dev,
 extern int vlan_for_each(struct net_device *dev,
 			 int (*action)(struct net_device *dev, int vid,
 				       void *arg), void *arg);
+extern u16 vlan_dev_get_addr_vid(struct net_device *dev, const u8 *addr);
 extern struct net_device *vlan_dev_real_dev(const struct net_device *dev);
 extern u16 vlan_dev_vlan_id(const struct net_device *dev);
 extern __be16 vlan_dev_vlan_proto(const struct net_device *dev);
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index bb7ec1a3915d..e7f43d7fcc9a 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -6,6 +6,8 @@
 #include <linux/u64_stats_sync.h>
 #include <linux/list.h>
 
+#define NET_8021Q_VID_TSIZE	2
+
 /* if this changes, algorithm will have to be reworked because this
  * depends on completely exhausting the VLAN identifier space.  Thus
  * it gives constant time look-up, but in many cases it wastes memory.
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 78ec2e1b14d1..b528f09be9a3 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -453,6 +453,19 @@ bool vlan_uses_dev(const struct net_device *dev)
 }
 EXPORT_SYMBOL(vlan_uses_dev);
 
+u16 vlan_dev_get_addr_vid(struct net_device *dev, const u8 *addr)
+{
+	u16 vid = 0;
+
+	if (dev->vid_len != NET_8021Q_VID_TSIZE)
+		return vid;
+
+	vid = addr[dev->addr_len];
+	vid |= (addr[dev->addr_len + 1] & 0xf) << 8;
+	return vid;
+}
+EXPORT_SYMBOL(vlan_dev_get_addr_vid);
+
 static struct sk_buff *vlan_gro_receive(struct list_head *head,
 					struct sk_buff *skb)
 {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index f00bb57f0f60..c2c3e5ae535c 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -244,6 +244,14 @@ void vlan_dev_get_realdev_name(const struct net_device *dev, char *result)
 	strncpy(result, vlan_dev_priv(dev)->real_dev->name, 23);
 }
 
+static void vlan_dev_set_addr_vid(struct net_device *vlan_dev, u8 *addr)
+{
+	u16 vid = vlan_dev_vlan_id(vlan_dev);
+
+	addr[vlan_dev->addr_len] = vid & 0xff;
+	addr[vlan_dev->addr_len + 1] = (vid >> 8) & 0xf;
+}
+
 bool vlan_dev_inherit_address(struct net_device *dev,
 			      struct net_device *real_dev)
 {
@@ -482,8 +490,26 @@ static void vlan_dev_change_rx_flags(struct net_device *dev, int change)
 	}
 }
 
+static void vlan_dev_align_addr_vid(struct net_device *vlan_dev)
+{
+	struct net_device *real_dev = vlan_dev_real_dev(vlan_dev);
+	struct netdev_hw_addr *ha;
+
+	if (!real_dev->vid_len)
+		return;
+
+	netdev_for_each_mc_addr(ha, vlan_dev)
+		if (!ha->sync_cnt)
+			vlan_dev_set_addr_vid(vlan_dev, ha->addr);
+
+	netdev_for_each_uc_addr(ha, vlan_dev)
+		if (!ha->sync_cnt)
+			vlan_dev_set_addr_vid(vlan_dev, ha->addr);
+}
+
 static void vlan_dev_set_rx_mode(struct net_device *vlan_dev)
 {
+	vlan_dev_align_addr_vid(vlan_dev);
 	dev_mc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
 	dev_uc_sync(vlan_dev_priv(vlan_dev)->real_dev, vlan_dev);
 }
-- 
2.25.1

