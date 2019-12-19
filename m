Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F17126E1C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLSTlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:41:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727218AbfLSTlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 14:41:17 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJJcJwX038744;
        Thu, 19 Dec 2019 14:41:15 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0a8rg1j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 14:41:15 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBJJcXfn040741;
        Thu, 19 Dec 2019 14:41:14 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0a8rg1hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 14:41:14 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBJJeVnA022603;
        Thu, 19 Dec 2019 19:41:13 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 2wvqc7ddv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 19:41:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBJJfCoh16450046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 19:41:12 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A88E1BE053;
        Thu, 19 Dec 2019 19:41:12 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA928BE04F;
        Thu, 19 Dec 2019 19:41:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.22.203])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Dec 2019 19:41:10 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v3, 1/2] Three virtual devices (ibmveth, virtio_net, and netvsc) all have similar code to set/get link settings and validate ethtool command. To eliminate duplication of code, it is factored out into core/ethtool.c.
Date:   Thu, 19 Dec 2019 13:40:56 -0600
Message-Id: <20191219194057.4208-2-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=1
 lowpriorityscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
---
 include/linux/ethtool.h |  2 ++
 net/core/ethtool.c      | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 95991e43..1b0417b 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -394,6 +394,8 @@ struct ethtool_ops {
 					  struct ethtool_coalesce *);
 	int	(*set_per_queue_coalesce)(struct net_device *, u32,
 					  struct ethtool_coalesce *);
+	bool    (*virtdev_validate_link_ksettings)(const struct
+						   ethtool_link_ksettings *);
 	int	(*get_link_ksettings)(struct net_device *,
 				      struct ethtool_link_ksettings *);
 	int	(*set_link_ksettings)(struct net_device *,
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index cd9bc67..4091a94 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
 	return 0;
 }
 
+/* Check if the user is trying to change anything besides speed/duplex */
+static bool
+ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
+{
+	struct ethtool_link_ksettings diff1 = *cmd;
+	struct ethtool_link_ksettings diff2 = {};
+
+	/* cmd is always set so we need to clear it, validate the port type
+	 * and also without autonegotiation we can ignore advertising
+	 */
+	diff1.base.speed = 0;
+	diff2.base.port = PORT_OTHER;
+	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
+	diff1.base.duplex = 0;
+	diff1.base.cmd = 0;
+	diff1.base.link_mode_masks_nwords = 0;
+
+	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
+		bitmap_empty(diff1.link_modes.supported,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
+		bitmap_empty(diff1.link_modes.advertising,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
+		bitmap_empty(diff1.link_modes.lp_advertising,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 /* convert a kernel internal ethtool_link_ksettings to
  * ethtool_link_usettings in user space. return 0 on success, errno on
  * error.
@@ -660,6 +686,17 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 	return store_link_ksettings_for_user(useraddr, &link_ksettings);
 }
 
+static int
+ethtool_virtdev_get_link_ksettings(struct net_device *dev,
+				   struct ethtool_link_ksettings *cmd,
+				   u32 *speed, u8 *duplex)
+{
+	cmd->base.speed = *speed;
+	cmd->base.duplex = *duplex;
+	cmd->base.port = PORT_OTHER;
+	return 0;
+}
+
 /* Update device ethtool_link_settings. */
 static int ethtool_set_link_ksettings(struct net_device *dev,
 				      void __user *useraddr)
@@ -696,6 +733,27 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 	return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
 }
 
+static int
+ethtool_virtdev_set_link_ksettings(struct net_device *dev,
+				   const struct ethtool_link_ksettings *cmd,
+				   u32 *dev_speed, u8 *dev_duplex)
+{
+	u32 speed;
+	u8 duplex;
+
+	speed = cmd->base.speed;
+	duplex = cmd->base.duplex;
+	/* don't allow custom speed and duplex */
+	if (!ethtool_validate_speed(speed) ||
+	    !ethtool_validate_duplex(duplex) ||
+	    !dev->ethtool_ops->virtdev_validate_link_ksettings(cmd))
+		return -EINVAL;
+	*dev_speed = speed;
+	*dev_duplex = duplex;
+
+	return 0;
+}
+
 /* Query device for its ethtool_cmd settings.
  *
  * Backward compatibility note: for compatibility with legacy ethtool, this is
-- 
1.8.3.1

