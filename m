Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725E82CABB0
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbgLATVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:21:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730825AbgLATVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:21:45 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1J20p7176563;
        Tue, 1 Dec 2020 14:21:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+0ByRpuQQw53UYtb0zcMiGcEdq+VMtqGFIwCYFMWQbY=;
 b=ZteGnsQnX58690Wnv+vBCnPJtcVU+sq0sKVbsC7Lgzlx1WGcgxWOnqk1hmwIv9mxug97
 d77b6GrYjskk31pxjLWw1HC+EzyzxJ4dmjKkPiPvEMpgmX2v0/w5JcXvbliGKh6LTG/9
 JqaK0cXBpncaGzNJjM6T9YkXuuaouEkFFVBPaWL3u74cAckANzpBW1x1qSq+RXcTvkl+
 1ZYuiGtipdUY1vl9wC4UiSfrJam39YanorZ9CwjJZJQfKnJY9q2c44zSO6JyRc355PZh
 gqJStCOB33F/L5hT0gODErCsrxfsPmGhDVrR7S+lTb1pyfucU8Dvy5sinmKip2eSJQvB +Q== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 355k52jwh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 14:21:01 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JHi2g019505;
        Tue, 1 Dec 2020 19:20:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 353e689t17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 19:20:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B1JKvD864094608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Dec 2020 19:20:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F411AAE045;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA5EFAE051;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Dec 2020 19:20:56 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v7 05/14] net/smc: Add diagnostic information to smc ib-device
Date:   Tue,  1 Dec 2020 20:20:40 +0100
Message-Id: <20201201192049.53517-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201192049.53517-1-kgraul@linux.ibm.com>
References: <20201201192049.53517-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010112
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

