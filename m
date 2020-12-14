Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011ED2DA27A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503565AbgLNVUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:20:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3058 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503456AbgLNVUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:20:14 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEL3SeE022532
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 16:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g/UGOVxkTb7+BI1rK7MXmu9Hy/Oazee+sp1yohbwXRs=;
 b=TkND/T+NuTE3g+W6MtIuxHiz/BUDDzSnhB/lSB5VRXZKfTmrlAt9e3VheamxTL/zlOH/
 nfqv6pmE1GukATyxMgP8wuyIFZO7RPEromhz7iTSOxmKS+wPf8dKYD8NN/mVlcQMmLwP
 ZeRqkG7d1e1BRDRKMwcQqHa4MehRRB8mZLhNRXzLm/e2d4zwqHrxRP2WiBIPKoT20ijI
 4A1eqUXIHdq+ZzPGAsGf85YYjqD8vIbaui5bToULjj/Jjxe8i4Qx0M/e5HyaNx4DG6ix
 nVACnAX1BZ/LbzZXg+oUfGG9zo5BnKjfDGAgThg5JnV0KlhoCRbZ/22yHKi8Ep/rZgF+ eA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35ebf6fvck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 16:19:33 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BELGpw7019562
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:32 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 35d525hqy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:32 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BELJVRa30081324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:19:31 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92CE52805A;
        Mon, 14 Dec 2020 21:19:31 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BE6628059;
        Mon, 14 Dec 2020 21:19:31 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.237.30])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 21:19:31 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>, Nathan Lynch <nathanl@linux.ibm.com>
Subject: [PATCH net-next v2 1/3] net: core: introduce __netdev_notify_peers
Date:   Mon, 14 Dec 2020 15:19:28 -0600
Message-Id: <20201214211930.80778-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201214211930.80778-1-ljp@linux.ibm.com>
References: <20201214211930.80778-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_11:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some use cases for netdev_notify_peers in the context
when rtnl lock is already held. Introduce lockless version
of netdev_notify_peers call to save the extra code to call
	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
After that, convert netdev_notify_peers to call the new helper.

Suggested-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bf167993c05..259be67644e3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4547,6 +4547,7 @@ void __dev_set_rx_mode(struct net_device *dev);
 int dev_set_promiscuity(struct net_device *dev, int inc);
 int dev_set_allmulti(struct net_device *dev, int inc);
 void netdev_state_change(struct net_device *dev);
+void __netdev_notify_peers(struct net_device *dev);
 void netdev_notify_peers(struct net_device *dev);
 void netdev_features_change(struct net_device *dev);
 /* Load a device via the kmod */
diff --git a/net/core/dev.c b/net/core/dev.c
index bde98cfd166f..43e3b176a30a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1456,6 +1456,25 @@ void netdev_state_change(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_state_change);
 
+/**
+ * __netdev_notify_peers - notify network peers about existence of @dev,
+ * to be called when rtnl lock is already held.
+ * @dev: network device
+ *
+ * Generate traffic such that interested network peers are aware of
+ * @dev, such as by generating a gratuitous ARP. This may be used when
+ * a device wants to inform the rest of the network about some sort of
+ * reconfiguration such as a failover event or virtual machine
+ * migration.
+ */
+void __netdev_notify_peers(struct net_device *dev)
+{
+	ASSERT_RTNL();
+	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
+	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
+}
+EXPORT_SYMBOL(__netdev_notify_peers);
+
 /**
  * netdev_notify_peers - notify network peers about existence of @dev
  * @dev: network device
@@ -1469,8 +1488,7 @@ EXPORT_SYMBOL(netdev_state_change);
 void netdev_notify_peers(struct net_device *dev)
 {
 	rtnl_lock();
-	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
-	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
+	__netdev_notify_peers(dev);
 	rtnl_unlock();
 }
 EXPORT_SYMBOL(netdev_notify_peers);
-- 
2.23.0

