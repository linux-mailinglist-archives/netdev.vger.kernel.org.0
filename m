Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E7F2D1186
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgLGNNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:13:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725918AbgLGNNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:13:24 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7Ca8JT185854;
        Mon, 7 Dec 2020 08:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=xF6vuKki1hD6hsjFDlarsHTO8drtuWQkslHhhAaMTRU=;
 b=bXQUbsy58PC8dAvCOZBeAdPKHjutuK9YSl1fDgCZ2tIt7ZnkRG68Yvb01qXI1v7rH9dF
 MAFzmJjBRP8KXPnsLN3hbwWhhtMrMhPZ7Z/yg3eVkunU9zzIXo1rFIU1vl5KRViBBPW7
 OxVTqHaTIcfdi+EQx2HNLKqoLCVBhkL07nHTPMSyL8ojypeUr2R0S1ozErwahbmA80yN
 SqOzsLPwrKmRWDSGvB/LZkjTF9LzumuqH/MjLTRKDhR/BWGhFljdk1rF8tWfvsupM7+/
 XaMSlAv3gXqVCaAgd8ziEI7rBO6XqoGJ06xwTxvspu2na4s5qcPhZZFKP6dxTI6rvuMI +w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359ka3k3m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 08:12:41 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7DCUEl001484;
        Mon, 7 Dec 2020 13:12:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3581fhjgpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:12:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7DCaO022872362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 13:12:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D44911C05E;
        Mon,  7 Dec 2020 13:12:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 572DA11C05B;
        Mon,  7 Dec 2020 13:12:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 13:12:36 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/6] s390/ccwgroup: use bus->dev_groups for bus-based sysfs attributes
Date:   Mon,  7 Dec 2020 14:12:29 +0100
Message-Id: <20201207131233.90383-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207131233.90383-1-jwi@linux.ibm.com>
References: <20201207131233.90383-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 suspectscore=2 bulkscore=0 mlxlogscore=834
 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bus drivers have their own way of describing the sysfs attributes that
all devices on a bus should provide.
Switch ccwgroup_attr_groups over to use bus->dev_groups, and thus
free up dev->groups for usage by the ccwgroup device drivers.

While adjusting the attribute naming, use ATTRIBUTE_GROUPS() to get rid
of some boilerplate code.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/cio/ccwgroup.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 483a9ecfcbb1..444385da5792 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -210,18 +210,12 @@ static ssize_t ccwgroup_ungroup_store(struct device *dev,
 static DEVICE_ATTR(ungroup, 0200, NULL, ccwgroup_ungroup_store);
 static DEVICE_ATTR(online, 0644, ccwgroup_online_show, ccwgroup_online_store);
 
-static struct attribute *ccwgroup_attrs[] = {
+static struct attribute *ccwgroup_dev_attrs[] = {
 	&dev_attr_online.attr,
 	&dev_attr_ungroup.attr,
 	NULL,
 };
-static struct attribute_group ccwgroup_attr_group = {
-	.attrs = ccwgroup_attrs,
-};
-static const struct attribute_group *ccwgroup_attr_groups[] = {
-	&ccwgroup_attr_group,
-	NULL,
-};
+ATTRIBUTE_GROUPS(ccwgroup_dev);
 
 static void ccwgroup_ungroup_workfn(struct work_struct *work)
 {
@@ -384,7 +378,6 @@ int ccwgroup_create_dev(struct device *parent, struct ccwgroup_driver *gdrv,
 	}
 
 	dev_set_name(&gdev->dev, "%s", dev_name(&gdev->cdev[0]->dev));
-	gdev->dev.groups = ccwgroup_attr_groups;
 
 	if (gdrv) {
 		gdev->dev.driver = &gdrv->driver;
@@ -487,6 +480,7 @@ static void ccwgroup_shutdown(struct device *dev)
 
 static struct bus_type ccwgroup_bus_type = {
 	.name   = "ccwgroup",
+	.dev_groups = ccwgroup_dev_groups,
 	.remove = ccwgroup_remove,
 	.shutdown = ccwgroup_shutdown,
 };
-- 
2.17.1

