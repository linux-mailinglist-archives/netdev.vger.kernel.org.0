Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5151198597
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgC3UlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:41:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34082 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729362AbgC3UlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:41:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id 65so23366657wrl.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wqNx6CCTVOyAKkUzrI3jqaOAfiE0T7tCB7uuiyvXY3Q=;
        b=W+ATFBA6VA6Ta8p45mFZ6qkNIf2d0UYzZclHKR9/SA3bLurMbJK8K1dsU6Z6myPfy4
         cC+/4mntbmmPAdhdYGCZMyZ4eNWvLYtpKFtVkJN01WHUDIXz/kQxqMkbLUAMHAbxbZa2
         w006Lax3V2+XcpPY3xhABFeqf4COh08+eYt+24NuAvxXdt37vON7D1o8Z5WjW/8GCbwV
         K3ub/L0RxNuHC/2af68ElLDYnGLslDpiCs8ZOAiuPWXtD1zj+qRAymb4FIpWyNXtFZ+6
         JpDApzG1/ZNY0WSxcKitb4Po/Ku+EJYpSWFIUbL09Wp//gTOACOTw+tRHwLXWQ8WHGuy
         Dr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wqNx6CCTVOyAKkUzrI3jqaOAfiE0T7tCB7uuiyvXY3Q=;
        b=oKPb/Rs28r1O7+Yv76PoH7CKBwy5xpYH0VGb6iqsBkf6gp8A+yqpeMKe72Ud4HrPl0
         K73leFe/3qlciQaMWa4jTN9jIv0AbcgfZWbRscOSxoK6z2/Y9/TLfKjsKqyFDWXFnQPh
         m6x2V8UjkkE1wxcwyp8nzSqZ2nFfDLzt6yhDgpBJXnc5aPFKzTdGh7jNujeJ/zgtGJgb
         l4JLk78d0hIdugyAY33OfXbU7F8V0oUU5rYpdW1aZ9VVcHbZEao3BjnAXo1CiWDrh7KV
         tLY7LTl2ak06F2O4661VcZh0cg2hOTLEcGkk42tPq3qw1FtlT1eR9nycor1faCRVGMVk
         AYSg==
X-Gm-Message-State: ANhLgQ3zp4Q/I5A+nwwjG0ERSzbybrVPxuhK3ByjJfv2o6Qxfg85Zqe8
        VBE8/zk1PydHeIuXb1ckOFsNbiKR
X-Google-Smtp-Source: ADFU+vv/8SY1k09MKrb2uHI3cJjx9dcx/kQEYst3zmM9AgJBigZmaEcKHjlDEfZ7c9MSbIvq3bdK9w==
X-Received: by 2002:a5d:460f:: with SMTP id t15mr16787165wrq.413.1585600860401;
        Mon, 30 Mar 2020 13:41:00 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 9/9] net: dsa: bcm_sf2: Support specifying VLAN tag egress rule
Date:   Mon, 30 Mar 2020 13:40:32 -0700
Message-Id: <20200330204032.26313-10-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port to which the ASP is connected on 7278 is not capable of
processing VLAN tags as part of the Ethernet frame, so allow an user to
configure the egress VLAN policy they want to see applied by purposing
the h_ext.data[1] field. Bit 0 is used to indicate that 0=untagged,
1=tagged.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 40 +++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index 7b10a9f31538..1a26232ecd47 100644
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
+	 * is expected to be provided in h_ext.data[1] bit 0. A 1 means tagged,
+	 * a 0 means untagged.
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

