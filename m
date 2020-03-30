Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21ED1986BC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgC3VjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39047 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgC3VjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so23514473wrt.6
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QEGvlFHuJ++PMVP/Qb8PdtLYj0yJN3KYNQKnA8iFVT8=;
        b=UD7TUcqMYVqpISE7dKh2J2yC3BesD1noY41M4uk3hY/gMEsn49iZu/Ot+01oV5wmzH
         s0UmTmjbm+Ktoqmv/anGO5Zo7J67786G6fE2zksMVx5Skw5MD7WFOcwlKE74ywxi/hwv
         kGFojDKdZJgwCBmmmL3BOxAEi5Tjw35EeNV9Yr4w57gbSJffs7gCSpCwMd9cN3mullwj
         nMzZUv2uw8IjAegjSEybtTKiBNTKQF1JWweAEjGCxK8vo6/BwuKJTJQcg/oNzN3R8XgP
         0m1kPmlg80kP7K9ODQcSBLIF5GTSzEDmlYFhRgTDTvig8K2nCPOKLlSEBYWo+HJsW6hw
         uApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QEGvlFHuJ++PMVP/Qb8PdtLYj0yJN3KYNQKnA8iFVT8=;
        b=m3gaTN+fjPisZBy0V6O35Sdd32unyr+WWNFlDIMzmH5M7Ybd2tyVULHoU8VUws1+le
         4IGq3vbn9pOZbwQYhCnKcpoiW2vaUQRUMGsYPkOgNb9uNjmk5R+vH/N0V6+4cRFycX+k
         4PRyOe1L4OluBQWhZP3I9a9+k/5pP0ryh8OdkahPUfihynof0tmiE96yoBfbgB3eDXI/
         Q0vRYxuYuDu5Aw1DcLZu8D4/RRPSKhpJVhSSBEv2S1F6aNRxrybdaRDRWjj3vjq1Isl1
         Fi97V4rNkI2fUKgyDC7SzGcwa+fbqoC310J8FLnP48o5K7okkCxKsT/h5E5x5H9+5aN2
         YVHA==
X-Gm-Message-State: ANhLgQ3GvS0N3HB65RaXCzS2wCKQrZINvxF7v7ird91xec6yyvyqUSMt
        PF/bW67/VaEVqVuxliejvmZMwSan
X-Google-Smtp-Source: ADFU+vt7wRFhng2vaJ+yoWsO4ogeQ1MODchVgir9qBx8N59EBBZnsMlLz8hHVssk/9rFULqjASANIA==
X-Received: by 2002:a5d:4611:: with SMTP id t17mr17737091wrq.16.1585604360622;
        Mon, 30 Mar 2020 14:39:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 9/9] net: dsa: bcm_sf2: Support specifying VLAN tag egress rule
Date:   Mon, 30 Mar 2020 14:38:54 -0700
Message-Id: <20200330213854.4856-10-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port to which the ASP is connected on 7278 is not capable of
processing VLAN tags as part of the Ethernet frame, so allow an user to
configure the egress VLAN policy they want to see applied by purposing
the h_ext.data[1] field. Bit 0 is used to indicate that 0=tagged,
1=untagged.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 40 +++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 7b10a9f31538..f707edc641cf 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -13,6 +13,8 @@
 #include <net/dsa.h>
 #include <linux/bitmap.h>
 #include <net/flow_offload.h>
+#include <net/switchdev.h>
+#include <uapi/linux/if_bridge.h>
 
 #include "bcm_sf2.h"
 #include "bcm_sf2_regs.h"
@@ -847,7 +849,9 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	__u64 ring_cookie = fs->ring_cookie;
+	struct switchdev_obj_port_vlan vlan;
 	unsigned int queue_num, port_num;
+	u16 vid;
 	int ret;
 
 	/* This rule is a Wake-on-LAN filter and we must specifically
@@ -867,6 +871,34 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 	      dsa_is_cpu_port(ds, port_num)) ||
 	    port_num >= priv->hw_params.num_ports)
 		return -EINVAL;
+
+	/* If the rule is matching a particular VLAN, make sure that we honor
+	 * the matching and have it tagged or untagged on the destination port,
+	 * we do this on egress with a VLAN entry. The egress tagging attribute
+	 * is expected to be provided in h_ext.data[1] bit 0. A 1 means untagged,
+	 * a 0 means tagged.
+	 */
+	if (fs->flow_type & FLOW_EXT) {
+		/* We cannot support matching multiple VLAN IDs yet */
+		if ((be16_to_cpu(fs->m_ext.vlan_tci) & VLAN_VID_MASK) !=
+		    VLAN_VID_MASK)
+			return -EINVAL;
+
+		vid = be16_to_cpu(fs->h_ext.vlan_tci) & VLAN_VID_MASK;
+		vlan.vid_begin = vid;
+		vlan.vid_end = vid;
+		if (cpu_to_be32(fs->h_ext.data[1]) & 1)
+			vlan.flags = BRIDGE_VLAN_INFO_UNTAGGED;
+		else
+			vlan.flags = 0;
+
+		ret = ds->ops->port_vlan_prepare(ds, port_num, &vlan);
+		if (ret)
+			return ret;
+
+		ds->ops->port_vlan_add(ds, port_num, &vlan);
+	}
+
 	/*
 	 * We have a small oddity where Port 6 just does not have a
 	 * valid bit here (so we substract by one).
@@ -902,14 +934,18 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	int ret = -EINVAL;
 
 	/* Check for unsupported extensions */
-	if ((fs->flow_type & FLOW_MAC_EXT) ||
-	    fs->m_ext.data[1])
+	if (fs->flow_type & FLOW_MAC_EXT)
 		return -EINVAL;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
 	    fs->location > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
+	if ((fs->flow_type & FLOW_EXT) &&
+	    !(ds->ops->port_vlan_prepare || ds->ops->port_vlan_add ||
+	      ds->ops->port_vlan_del))
+		return -EOPNOTSUPP;
+
 	if (fs->location != RX_CLS_LOC_ANY &&
 	    test_bit(fs->location, priv->cfp.used))
 		return -EBUSY;
-- 
2.17.1

