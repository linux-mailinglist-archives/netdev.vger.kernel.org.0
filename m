Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF43E1AEAF
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 03:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfEMBMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 21:12:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7193 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727083AbfEMBMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 May 2019 21:12:47 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A8E123F419D8AE2CAE29;
        Mon, 13 May 2019 09:12:45 +0800 (CST)
Received: from localhost (10.175.101.78) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 May 2019
 09:12:36 +0800
From:   Weilong Chen <chenweilong@huawei.com>
To:     <chenweilong@huawei.com>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH net-next] ipv4: Add support to disable icmp timestamp
Date:   Mon, 13 May 2019 09:33:13 +0800
Message-ID: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.78]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remote host answers to an ICMP timestamp request.
This allows an attacker to know the time and date on your host.

This path is an another way contrast to iptables rules:
iptables -A input -p icmp --icmp-type timestamp-request -j DROP
iptables -A output -p icmp --icmp-type timestamp-reply -j DROP

Default is disabled to improve security.

enable:
	sysctl -w net.ipv4.icmp_timestamp_enable=1
disable
	sysctl -w net.ipv4.icmp_timestamp_enable=0
testing:
	hping3 --icmp --icmp-ts -V $IPADDR

Signed-off-by: Weilong Chen <chenweilong@huawei.com>
---
 include/net/ip.h           | 2 ++
 net/ipv4/icmp.c            | 5 +++++
 net/ipv4/sysctl_net_ipv4.c | 8 ++++++++
 3 files changed, 15 insertions(+)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2d3cce7..71840e4 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -718,6 +718,8 @@ bool icmp_global_allow(void);
 extern int sysctl_icmp_msgs_per_sec;
 extern int sysctl_icmp_msgs_burst;
 
+extern int sysctl_icmp_timestamp_enable;
+
 #ifdef CONFIG_PROC_FS
 int ip_misc_proc_init(void);
 #endif
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index f3a5893..d302189 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -232,6 +232,7 @@ static inline void icmp_xmit_unlock(struct sock *sk)
 
 int sysctl_icmp_msgs_per_sec __read_mostly = 1000;
 int sysctl_icmp_msgs_burst __read_mostly = 50;
+int sysctl_icmp_timestamp_enable __read_mostly;
 
 static struct {
 	spinlock_t	lock;
@@ -953,6 +954,10 @@ static bool icmp_echo(struct sk_buff *skb)
 static bool icmp_timestamp(struct sk_buff *skb)
 {
 	struct icmp_bxm icmp_param;
+
+	if (!sysctl_icmp_timestamp_enable)
+		goto out_err;
+
 	/*
 	 *	Too short.
 	 */
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 875867b..1fe467e 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -544,6 +544,14 @@ static struct ctl_table ipv4_table[] = {
 		.extra1		= &zero,
 	},
 	{
+		.procname	= "icmp_timestamp_enable",
+		.data		= &sysctl_icmp_timestamp_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+	},
+	{
 		.procname	= "udp_mem",
 		.data		= &sysctl_udp_mem,
 		.maxlen		= sizeof(sysctl_udp_mem),
-- 
2.7.4

