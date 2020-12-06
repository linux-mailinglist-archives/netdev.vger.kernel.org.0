Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C434F2D00A2
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 06:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgLFFWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 00:22:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbgLFFWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 00:22:11 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B654FUu148068
        for <netdev@vger.kernel.org>; Sun, 6 Dec 2020 00:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YsIsNBEpt+DuNtORw4rI79CDkiPop8oxPl4zA30zRd8=;
 b=IiT5CmQRW3pSiqmLuuaodgVgGUFIjIcppaJtVbb+hx9HI2JoQny3uLkpsGJHnsLzYT2l
 BpAwPEVCxZvuuQPXAoAJfbJc4yH5hfB3G5cDwHuK8/5xE9IPVktBAgYsSTcr1O6KRhkQ
 8ly2SVllkplAq9OvI0ginAUcNRf7aJwW0mENMgzASVCU9BcSo5zlcJSSzhtQAE0HqmFp
 PELc+j3u7rOV4Kuc21P3q1wC0ZWJRUsZr44EYs+U60gdrvfqKYwxnrYr6misQZilochN
 YW/95JvBOPQ4VkUHvOkQVltqvK9r7oFtHCSScEyZWOuxXkrd37M+9v3BwDT9h2HKjoqp jA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 358rf9gmhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 00:21:29 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B65HrF9000473
        for <netdev@vger.kernel.org>; Sun, 6 Dec 2020 05:21:29 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3581u90hde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 05:21:29 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B65LSlt6291982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 6 Dec 2020 05:21:28 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47F00124053;
        Sun,  6 Dec 2020 05:21:28 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6740124052;
        Sun,  6 Dec 2020 05:21:27 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.129.222])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun,  6 Dec 2020 05:21:27 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>, Nathan Lynch <nathanl@linux.ibm.com>
Subject: [RFC PATCH net-next 1/3] net: core: introduce netdev_notify_peers_locked
Date:   Sat,  5 Dec 2020 23:21:25 -0600
Message-Id: <20201206052127.21450-2-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201206052127.21450-1-ljp@linux.ibm.com>
References: <20201206052127.21450-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-06_02:2020-12-04,2020-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=1 mlxscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some use cases for netdev_notify_peers in the context
when rtnl lock is already held. Introduce lockless version
of netdev_notify_peers call to save the extra code to call
	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);

Suggested-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..dec16d462672 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4492,6 +4492,7 @@ int dev_set_promiscuity(struct net_device *dev, int inc);
 int dev_set_allmulti(struct net_device *dev, int inc);
 void netdev_state_change(struct net_device *dev);
 void netdev_notify_peers(struct net_device *dev);
+void netdev_notify_peers_locked(struct net_device *dev);
 void netdev_features_change(struct net_device *dev);
 /* Load a device via the kmod */
 void dev_load(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 82dc6b48e45f..20c1ab886222 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1488,6 +1488,25 @@ void netdev_notify_peers(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_notify_peers);
 
+/**
+ * netdev_notify_peers_locked - notify network peers about existence of @dev,
+ * to be called in the context when rtnl lock is already held.
+ * @dev: network device
+ *
+ * Generate traffic such that interested network peers are aware of
+ * @dev, such as by generating a gratuitous ARP. This may be used when
+ * a device wants to inform the rest of the network about some sort of
+ * reconfiguration such as a failover event or virtual machine
+ * migration.
+ */
+void netdev_notify_peers_locked(struct net_device *dev)
+{
+	ASSERT_RTNL();
+	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
+	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
+}
+EXPORT_SYMBOL(netdev_notify_peers_locked);
+
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-- 
2.23.0

