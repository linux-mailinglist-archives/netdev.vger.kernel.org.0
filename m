Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791102C5D1C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 21:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391194AbgKZUjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 15:39:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390892AbgKZUjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 15:39:32 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKVdlW111292;
        Thu, 26 Nov 2020 15:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=+0ByRpuQQw53UYtb0zcMiGcEdq+VMtqGFIwCYFMWQbY=;
 b=MyByl0HdZ9zGUOwV++z4SUNOYXUyRisaANptlB5fMKZyRsNveM1pb7QY7+K6q6lk2OwU
 FKe1LuiaYlgpXxr2eqZiW8b9/zRA5veiME+g+Ky3ROR4VKiKfl92rMJB+WYQYGqROhTI
 6j6z8RJpTk1/MEvoK/wrk22AbgAG2hv2C2NeTuF2YzOLDmUZ6irTtm24AuMfhUl4d81+
 ijUmmDpXEN5jAssH2ZlrhDUKGqVvEDn6G3F3y02ETOOTEEoUamqys6hnYWFaA1i0dEMP
 ZlhXQgHDnhfOuKe2EY0OrAAa8xIYb0nWTGopB7c2rpvXsaRZXZyiC7sR8VJ0Wk8suWxI jQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352jy28rh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 15:39:28 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQKXqiK017612;
        Thu, 26 Nov 2020 20:39:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3518j8j1bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 20:39:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQKdOX66882002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 20:39:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED67DA4040;
        Thu, 26 Nov 2020 20:39:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7C9FA404D;
        Thu, 26 Nov 2020 20:39:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 20:39:23 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v6 05/14] net/smc: Add diagnostic information to smc ib-device
Date:   Thu, 26 Nov 2020 21:39:07 +0100
Message-Id: <20201126203916.56071-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126203916.56071-1-kgraul@linux.ibm.com>
References: <20201126203916.56071-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_09:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260124
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

