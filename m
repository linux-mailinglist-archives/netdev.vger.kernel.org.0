Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726C5257F1F
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgHaQ60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:58:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727929AbgHaQ6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:58:20 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGUa9C143542
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=wNiqS/mUQJ+UzDtDXdalpv64KQ+6EVfFBcSSCFewRII=;
 b=q1Psz8lX+Ykg1cJYGGDOoNU3daW7XMIwe24kTxGeOYpnZsN7tQwf2fK66zcTS5hTbTIE
 3fE5q+1bXXhm06jCUPoDS48ukqNg9p40nG66baoOebWgljKtN4Jhx1HDGofw7VM7ccrF
 a4Z8XkeHJz90CBViC3cIWPQNrb+kGe3UruYlEGAM0EcDq6i+M3hrrSyLAJCSZoncfa9p
 rXWDnqhq7ARsz4ZcN7WOVtibL0PPhSNMGTH1evngIaf7IdH5oqVarUJBkgG44nL9VwtV
 hlbY8B9D7SXJqaDPYr5olEQwJhSkf80BkiiJClcxHYVrrYoWAB3KRMqUUqED/4Ad3xj2 Bg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33949n9nfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:19 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VGr0ha027543
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:18 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 337en99fyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:18 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VGwH0s49676568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:58:18 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18D5B2066;
        Mon, 31 Aug 2020 16:58:17 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 363F7B205F;
        Mon, 31 Aug 2020 16:58:17 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 16:58:17 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next 1/5] ibmvnic: Create failover sysfs as part of an attribute group
Date:   Mon, 31 Aug 2020 11:58:09 -0500
Message-Id: <1598893093-14280-2-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_07:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 bulkscore=0 suspectscore=3 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a sysfs attribute group and make failover sysfs file a
member.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 86a83e5..91b9cc3 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5047,7 +5047,7 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 	return rc;
 }
 
-static struct device_attribute dev_attr_failover;
+static const struct attribute_group *dev_attr_groups[];
 
 static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 {
@@ -5126,9 +5126,9 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
 	netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
 
-	rc = device_create_file(&dev->dev, &dev_attr_failover);
+	rc = sysfs_create_groups(&dev->dev.kobj, dev_attr_groups);
 	if (rc)
-		goto ibmvnic_dev_file_err;
+		goto ibmvnic_dev_groups_err;
 
 	netif_carrier_off(netdev);
 	rc = register_netdev(netdev);
@@ -5145,14 +5145,11 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	return 0;
 
 ibmvnic_register_fail:
-	device_remove_file(&dev->dev, &dev_attr_failover);
-
-ibmvnic_dev_file_err:
+	sysfs_remove_groups(&dev->dev.kobj, dev_attr_groups);
+ibmvnic_dev_groups_err:
 	release_stats_token(adapter);
-
 ibmvnic_stats_fail:
 	release_stats_buffers(adapter);
-
 ibmvnic_init_fail:
 	release_sub_crqs(adapter, 1);
 	release_crq_queue(adapter);
@@ -5194,13 +5191,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
 
 	rtnl_unlock();
 	mutex_destroy(&adapter->fw_lock);
-	device_remove_file(&dev->dev, &dev_attr_failover);
+	sysfs_remove_groups(&dev->dev.kobj, dev_attr_groups);
 	free_netdev(netdev);
 	dev_set_drvdata(&dev->dev, NULL);
 
 	return 0;
 }
 
+static struct device_attribute dev_attr_failover;
+
 static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
@@ -5237,6 +5236,20 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_WO(failover);
 
+static struct attribute *dev_attrs[] = {
+	&dev_attr_failover.attr,
+	NULL,
+};
+
+static struct attribute_group dev_attr_group = {
+	.attrs = dev_attrs,
+};
+
+static const struct attribute_group *dev_attr_groups[] = {
+	&dev_attr_group,
+	NULL,
+};
+
 static unsigned long ibmvnic_get_desired_dma(struct vio_dev *vdev)
 {
 	struct net_device *netdev = dev_get_drvdata(&vdev->dev);
-- 
1.8.3.1

