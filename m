Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9387A2D3B5E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgLIGTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:19:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725878AbgLIGS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 01:18:57 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B961Qg9077381
        for <netdev@vger.kernel.org>; Wed, 9 Dec 2020 01:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1b74QM0HMMXtw2lLkrNqpxQE4CsBnJWQSpmBZJuxQho=;
 b=qlAmW9oolVXxFNp+dRc7H1lonTmRVbkoAZugeF/x/k+0x4/OPs+I7wLltvUoHbx/+W06
 5B5WN5x9hc1Wcx3S7YvIoX2Ozdn86pmBz4SAtv+X0rC+aiR63Wud651mCsmPWbr+Z68Q
 X5Tj/oNcuEVrZ/YFlM1yB1CWyeMja6eN1XKz5OLGoXB02DP0ADWNNnCdKCLq/QZxNSIo
 DSuzUbPNrZtMwG2cSlGM5X3tWCYDyPU1mRgyMRexzcs9GWK/Pkh3JN1v6Qf1sdc6dS8N
 9lD389OrsQEuzvX2lBuWurD1rm9YynC0GzitCXnGOqdW6knqZfVKwJmsXNF3xipdbDRK aw== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35adg3tnxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 01:18:15 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B961u6H015734
        for <netdev@vger.kernel.org>; Wed, 9 Dec 2020 06:18:15 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3581u9db8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:18:14 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B96IDsW11272512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 06:18:13 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 629916A047;
        Wed,  9 Dec 2020 06:18:13 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0E8C6A04D;
        Wed,  9 Dec 2020 06:18:12 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.139.133])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 06:18:12 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>, Nathan Lynch <nathanl@linux.ibm.com>
Subject: [PATCH net-next 1/3] net: core: introduce __netdev_notify_peers
Date:   Wed,  9 Dec 2020 00:18:09 -0600
Message-Id: <20201209061811.48524-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201209061811.48524-1-ljp@linux.ibm.com>
References: <20201209061811.48524-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_03:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=1 phishscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090037
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
index ce8fea2e2788..6aa1de86a2e0 100644
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

