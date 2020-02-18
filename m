Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F485162D72
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgBRRwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:52:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726705AbgBRRwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:52:39 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IHnFRk127012;
        Tue, 18 Feb 2020 12:52:33 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6d621kth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:52:33 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01IHnJ5M127159;
        Tue, 18 Feb 2020 12:52:32 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6d621ksq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 12:52:32 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01IHotqq026288;
        Tue, 18 Feb 2020 17:52:31 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 2y6896c0su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Feb 2020 17:52:30 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01IHqTqW46006652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 17:52:30 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D12FA13604F;
        Tue, 18 Feb 2020 17:52:29 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65D7E136051;
        Tue, 18 Feb 2020 17:52:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.24.11.154])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Feb 2020 17:52:29 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, mkubecek@suse.cz,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH, net-next, v5, 1/2] ethtool: Factored out similar ethtool link settings for virtual devices to core
Date:   Tue, 18 Feb 2020 11:52:26 -0600
Message-Id: <20200218175227.8511-2-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com>
References: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_05:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=1 adultscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three virtual devices (ibmveth, virtio_net, and netvsc) all have
similar code to get link settings and validate ethtool command. To
eliminate duplication of code, it is factored out into core/ethtool.c.

Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
---
 include/linux/ethtool.h |  8 ++++++++
 net/ethtool/ioctl.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 95991e43..fbc38f0 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -420,4 +420,12 @@ struct ethtool_rx_flow_rule *
 ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input);
 void ethtool_rx_flow_rule_destroy(struct ethtool_rx_flow_rule *rule);
 
+bool ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd);
+int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
+				       const struct ethtool_link_ksettings *cmd,
+				       u32 *dev_speed, u8 *dev_duplex,
+				       bool (*ethtool_virtdev_validate_cmd)
+				       (const struct ethtool_link_ksettings *));
+
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b987052..173e083 100644
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
@@ -581,6 +600,32 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 	return err;
 }
 
+int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
+				       const struct ethtool_link_ksettings *cmd,
+				       u32 *dev_speed, u8 *dev_duplex,
+				       bool (*dev_virtdev_validate_cmd)
+				       (const struct ethtool_link_ksettings *))
+{
+	bool (*validate)(const struct ethtool_link_ksettings *);
+	u32 speed;
+	u8 duplex;
+
+	validate = dev_virtdev_validate_cmd ? dev_virtdev_validate_cmd :
+		ethtool_virtdev_validate_cmd;
+	speed = cmd->base.speed;
+	duplex = cmd->base.duplex;
+	/* don't allow custom speed and duplex */
+	if (!ethtool_validate_speed(speed) ||
+	    !ethtool_validate_duplex(duplex) ||
+	    !(*validate)(cmd))
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

