Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C56E15CBC8
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 21:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgBMUOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 15:14:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727827AbgBMUOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 15:14:24 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DKDds7110206;
        Thu, 13 Feb 2020 15:14:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y4wuu9sj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 15:14:17 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01DKEG23136204;
        Thu, 13 Feb 2020 15:14:17 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y4wuu9shp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 15:14:16 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01DKDZe5009128;
        Thu, 13 Feb 2020 20:14:16 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 2y5bc00tjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Feb 2020 20:14:16 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01DKEFtx54067610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 20:14:15 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB459AE05F;
        Thu, 13 Feb 2020 20:14:15 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E851AE064;
        Thu, 13 Feb 2020 20:14:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.24.11.154])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 Feb 2020 20:14:15 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v4, 1/2] ethtool: Factored out similar ethtool link settings for virtual devices to core
Date:   Thu, 13 Feb 2020 14:14:09 -0600
Message-Id: <20200213201410.6912-2-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213201410.6912-1-cforno12@linux.vnet.ibm.com>
References: <20200213201410.6912-1-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_07:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 priorityscore=1501 suspectscore=1 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three virtual devices (ibmveth, virtio_net, and netvsc) all have
similar code to get link settings and validate ethtool command. To
eliminate duplication of code, it is factored out into core/ethtool.c.

Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
---
 include/linux/ethtool.h |  7 +++++++
 net/ethtool/ioctl.c     | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 95991e43..149f982 100644
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
@@ -420,4 +422,9 @@ struct ethtool_rx_flow_rule *
 ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input);
 void ethtool_rx_flow_rule_destroy(struct ethtool_rx_flow_rule *rule);
 
+bool ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd);
+int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
+				       const struct ethtool_link_ksettings *cmd,
+				       u32 *dev_speed, u8 *dev_duplex);
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b987052..88b1a42 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -459,6 +459,25 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
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
+EXPORT_SYMBOL(ethtool_virtdev_validate_cmd);
+
 /* convert a kernel internal ethtool_link_ksettings to
  * ethtool_link_usettings in user space. return 0 on success, errno on
  * error.
@@ -581,6 +600,27 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
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
+	    !dev->ethtool_ops->virtdev_validate_link_ksettings(cmd))
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
1.8.3.1

