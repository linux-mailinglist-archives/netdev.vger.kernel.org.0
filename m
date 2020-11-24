Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3031B2C2F4A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404099AbgKXRvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:51:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14086 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404080AbgKXRvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:51:13 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHWCaj088143;
        Tue, 24 Nov 2020 12:51:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+0ByRpuQQw53UYtb0zcMiGcEdq+VMtqGFIwCYFMWQbY=;
 b=Rf2XBJoms/ZHvX8oNohyRV3SG3T+22FwNme8O6C6cNLwNlIPROIW5SEzr0ePSPIbFiSj
 R7XZeJw+cBpnt79vsMp2t2CSRjSwQealAsCSmonVVSwtnk0L6oi1cF3bAbDhv/jDa3OK
 nUR6T7xAJdOWvmjwV2/ZhSavDg6XR8nK1vs8YwJA2Zgc96ka5b+IAon3EPMHpIH21eu2
 0tTqF0VQ/4JW174d/yDpW6vUIR90ODyOnBdDGurWZDHlCFAtWd0dmdZafGD8nHE4/2Ek
 oinNt/yYnI13ISIKV3iYVobqb75Czj7B4fpL/0zvrHag9u1BtPHyyzgA5cq5eKozEIU3 7A== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350vbvfd3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:51:09 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHghdX010446;
        Tue, 24 Nov 2020 17:51:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 34xt5hbvph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:51:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHp4lK2884266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:51:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1D5DA4040;
        Tue, 24 Nov 2020 17:51:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C335A405E;
        Tue, 24 Nov 2020 17:51:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:51:04 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v5 05/14] net/smc: Add diagnostic information to smc ib-device
Date:   Tue, 24 Nov 2020 18:50:38 +0100
Message-Id: <20201124175047.56949-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124175047.56949-1-kgraul@linux.ibm.com>
References: <20201124175047.56949-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

During smc ib-device creation, add network device ifindex to smc
ib-device structure. Register for netdevice changes and update ib-device
accordingly. This is needed for diagnostic purposes.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_ib.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_ib.h   |  2 ++
 net/smc/smc_pnet.c |  2 ++
 3 files changed, 48 insertions(+)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index fc766b537ac7..61b025c912a9 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -557,6 +557,49 @@ static void smc_ib_cleanup_per_ibdev(struct smc_ib_device *smcibdev)
 
 static struct ib_client smc_ib_client;
 
+static void smc_copy_netdev_ifindex(struct smc_ib_device *smcibdev, int port)
+{
+	struct ib_device *ibdev = smcibdev->ibdev;
+	struct net_device *ndev;
+
+	if (!ibdev->ops.get_netdev)
+		return;
+	ndev = ibdev->ops.get_netdev(ibdev, port + 1);
+	if (ndev) {
+		smcibdev->ndev_ifidx[port] = ndev->ifindex;
+		dev_put(ndev);
+	}
+}
+
+void smc_ib_ndev_change(struct net_device *ndev, unsigned long event)
+{
+	struct smc_ib_device *smcibdev;
+	struct ib_device *libdev;
+	struct net_device *lndev;
+	u8 port_cnt;
+	int i;
+
+	mutex_lock(&smc_ib_devices.mutex);
+	list_for_each_entry(smcibdev, &smc_ib_devices.list, list) {
+		port_cnt = smcibdev->ibdev->phys_port_cnt;
+		for (i = 0; i < min_t(size_t, port_cnt, SMC_MAX_PORTS); i++) {
+			libdev = smcibdev->ibdev;
+			if (!libdev->ops.get_netdev)
+				continue;
+			lndev = libdev->ops.get_netdev(libdev, i + 1);
+			if (lndev)
+				dev_put(lndev);
+			if (lndev != ndev)
+				continue;
+			if (event == NETDEV_REGISTER)
+				smcibdev->ndev_ifidx[i] = ndev->ifindex;
+			if (event == NETDEV_UNREGISTER)
+				smcibdev->ndev_ifidx[i] = 0;
+		}
+	}
+	mutex_unlock(&smc_ib_devices.mutex);
+}
+
 /* callback function for ib_register_client() */
 static int smc_ib_add_dev(struct ib_device *ibdev)
 {
@@ -596,6 +639,7 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 		if (smc_pnetid_by_dev_port(ibdev->dev.parent, i,
 					   smcibdev->pnetid[i]))
 			smc_pnetid_by_table_ib(smcibdev, i + 1);
+		smc_copy_netdev_ifindex(smcibdev, i);
 		pr_warn_ratelimited("smc:    ib device %s port %d has pnetid "
 				    "%.16s%s\n",
 				    smcibdev->ibdev->name, i + 1,
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 3b85360a473b..ab37da341fa8 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -55,11 +55,13 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	struct mutex		mutex;		/* protect dev setup+cleanup */
 	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];
 						/* number of links per port */
+	int			ndev_ifidx[SMC_MAX_PORTS]; /* ndev if indexes */
 };
 
 struct smc_buf_desc;
 struct smc_link;
 
+void smc_ib_ndev_change(struct net_device *ndev, unsigned long event);
 int smc_ib_register_client(void) __init;
 void smc_ib_unregister_client(void);
 bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport);
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index f3c18b991d35..6f6d33edb135 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -827,9 +827,11 @@ static int smc_pnet_netdev_event(struct notifier_block *this,
 	case NETDEV_REBOOT:
 	case NETDEV_UNREGISTER:
 		smc_pnet_remove_by_ndev(event_dev);
+		smc_ib_ndev_change(event_dev, event);
 		return NOTIFY_OK;
 	case NETDEV_REGISTER:
 		smc_pnet_add_by_ndev(event_dev);
+		smc_ib_ndev_change(event_dev, event);
 		return NOTIFY_OK;
 	case NETDEV_UP:
 		smc_pnet_add_base_pnetid(net, event_dev, ndev_pnetid);
-- 
2.17.1

