Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C005D1740C2
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 21:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgB1UM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 15:12:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14346 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbgB1UM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 15:12:29 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SJwX7U170907;
        Fri, 28 Feb 2020 15:12:23 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepy3yvrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Feb 2020 15:12:20 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01SJwvK6171492;
        Fri, 28 Feb 2020 15:12:18 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yepy3yvq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Feb 2020 15:12:18 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01SK66FN001663;
        Fri, 28 Feb 2020 20:12:16 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 2yepv30nve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Feb 2020 20:12:16 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01SKCF6K60424564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 20:12:15 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 362056A04D;
        Fri, 28 Feb 2020 20:12:15 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88B856A047;
        Fri, 28 Feb 2020 20:12:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.163.83.215])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Feb 2020 20:12:14 +0000 (GMT)
From:   Cris Forno <cforno12@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v7, 1/2] ethtool: Factored out similar ethtool link settings for virtual devices to core
Date:   Fri, 28 Feb 2020 14:12:04 -0600
Message-Id: <20200228201205.15846-2-cforno12@linux.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200228201205.15846-1-cforno12@linux.ibm.com>
References: <20200228201205.15846-1-cforno12@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_07:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cris Forno <cforno12@linux.vnet.ibm.com>

Three virtual devices (ibmveth, virtio_net, and netvsc) all have
similar code to set link settings and validate ethtool command. To
eliminate duplication of code, it is factored out into core/ethtool.c.

Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
---
 include/linux/ethtool.h |  6 ++++++
 net/ethtool/ioctl.c     | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 95991e4300bf..23373978cb3c 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -420,4 +420,10 @@ struct ethtool_rx_flow_rule *
 ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input);
 void ethtool_rx_flow_rule_destroy(struct ethtool_rx_flow_rule *rule);
 
+bool ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd);
+int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
+				       const struct ethtool_link_ksettings *cmd,
+				       u32 *dev_speed, u8 *dev_duplex);
+
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b987052d91ef..f2fe8e5896dc 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -459,6 +459,24 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
 	return 0;
 }
 
+/* Check if the user is trying to change anything besides speed/duplex */
+bool ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
+{
+	struct ethtool_link_settings base2 = {};
+
+	base2.speed = cmd->base.speed;
+	base2.port = PORT_OTHER;
+	base2.duplex = cmd->base.duplex;
+	base2.cmd = cmd->base.cmd;
+	base2.link_mode_masks_nwords = cmd->base.link_mode_masks_nwords;
+
+	return !memcmp(&base2, &cmd->base, sizeof(base2)) &&
+		bitmap_empty(cmd->link_modes.supported,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
+		bitmap_empty(cmd->link_modes.lp_advertising,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 /* convert a kernel internal ethtool_link_ksettings to
  * ethtool_link_usettings in user space. return 0 on success, errno on
  * error.
@@ -581,6 +599,27 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 	return err;
 }
 
+int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
+				       const struct ethtool_link_ksettings *cmd,
+				       u32 *dev_speed, u8 *dev_duplex)
+{
+	u32 speed;
+	u8 duplex;
+
+	speed = cmd->base.speed;
+	duplex = cmd->base.duplex;
+	/* don't allow custom speed and duplex */
+	if (!ethtool_validate_speed(speed) ||
+	    !ethtool_validate_duplex(duplex) ||
+	    !ethtool_virtdev_validate_cmd(cmd))
+		return -EINVAL;
+	*dev_speed = speed;
+	*dev_duplex = duplex;
+
+	return 0;
+}
+EXPORT_SYMBOL(ethtool_virtdev_set_link_ksettings);
+
 /* Query device for its ethtool_cmd settings.
  *
  * Backward compatibility note: for compatibility with legacy ethtool, this is
-- 
2.25.0

