Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6F58802
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfF0RJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:09:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfF0RJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:09:26 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RH6Qp9116401;
        Thu, 27 Jun 2019 13:09:20 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2td0nambgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 13:09:19 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5RH4ss4000379;
        Thu, 27 Jun 2019 17:09:18 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 2t9by77rp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 17:09:18 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RH9Guo61669748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 17:09:16 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 727797805C;
        Thu, 27 Jun 2019 17:09:16 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E36F78063;
        Thu, 27 Jun 2019 17:09:16 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 17:09:15 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, bjking1@us.ibm.com,
        pradeep@us.ibm.com, dnbanerg@us.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] net/ibmvnic: Report last valid speed and duplex values to ethtool
Date:   Thu, 27 Jun 2019 12:09:13 -0500
Message-Id: <1561655353-17114-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch resolves an issue with sensitive bonding modes
that require valid speed and duplex settings to function
properly. Currently, the adapter will report that device
speed and duplex is unknown if the communication link
with firmware is unavailable. This decision can break LACP
configurations if the timing is right.

For example, if invalid speeds are reported, the slave
device's link state is set to a transitional "fail" state
and the LACP port is disabled. However, if valid speeds
are reported later but the link state has not been altered,
the LACP port will remain disabled. If the link state then
transitions back to "up" from "fail," it results in a state
such that the slave reports valid speed/duplex and is up,
but the LACP port will remain disabled.

Workaround this by reporting the last recorded speed
and duplex settings unless the device has never been
activated. In that case or when the hypervisor gives
invalid values, continue to report unknown speed or
duplex to ethtool.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3da6800..7c14e33 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2276,10 +2276,8 @@ static int ibmvnic_get_link_ksettings(struct net_device *netdev,
 	int rc;
 
 	rc = send_query_phys_parms(adapter);
-	if (rc) {
-		adapter->speed = SPEED_UNKNOWN;
-		adapter->duplex = DUPLEX_UNKNOWN;
-	}
+	if (rc)
+		netdev_warn(netdev, "Device query of current speed and duplex settings failed; reported values may be stale.\n");
 	cmd->base.speed = adapter->speed;
 	cmd->base.duplex = adapter->duplex;
 	cmd->base.port = PORT_FIBRE;
@@ -4834,6 +4832,8 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	dev_set_drvdata(&dev->dev, netdev);
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
+	adapter->speed = SPEED_UNKNOWN;
+	adapter->duplex = DUPLEX_UNKNOWN;
 
 	ether_addr_copy(adapter->mac_addr, mac_addr_p);
 	ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
-- 
1.8.3.1

