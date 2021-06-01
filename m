Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D627E397065
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhFAJb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:31:56 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:60595 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233237AbhFAJbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 05:31:55 -0400
X-UUID: a16ecd614e454d858890c1adc31bfaac-20210601
X-UUID: a16ecd614e454d858890c1adc31bfaac-20210601
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 400033471; Tue, 01 Jun 2021 17:30:10 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 1 Jun 2021 17:30:02 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 17:30:01 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <rocco.yue@gmail.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH] ipv6: create ra_mtu proc file to only record mtu in RA
Date:   Tue, 1 Jun 2021 17:16:19 +0800
Message-ID: <20210601091619.19372-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel provides a "/proc/sys/net/ipv6/conf/<iface>/mtu" file,
which can temporarily record the mtu value of the last received
RA message when ra mtu is lower than the interface mtu, but this
proc has following limitations:
(1) when the interface mtu (/sys/class/net/<iface>/mtu) is
updeated, mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) will be
updated to the value of interface mtu;
(2) mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) only affect
ipv6 connection, and not affect ipv4.

Therefore, when the mtu option is carried in the RA message,
there will be a problem that the user sometimes cannot obtain
ra mtu value by reading mtu6.

Waiting for RA to arrive, setting the interface mtu after
reading mtu6 can avoid above problem. But device can't do this,
on the one hand, the device should first ensure that the ipv4
function is normal, and on the other hand, the time point of
receiving the RA message from the network is not certain.

For this patch set, if RA message carries the mtu option,
"proc/sys/net/ipv6/conf/<iface>/ra_mtu" will be updated to the
mtu value carried in the last RA message received, and ra_mtu
is an independent proc file, which is not affected by the update
of interface mtu value.

In this way, If the MTU values that the device receives from the
network in the PCO IPv4 and the RA IPv6 procedures are different,
the user space process can read ra_mtu to get the mtu value carried
in the RA message without worrying about the issue of ipv4 being
stuck due to the late arrival of RA message. After comparing the
value of ra_mtu and ipv4 mtu, then the device can use the lower
MTU value for both IPv4 and IPv6.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/linux/ipv6.h      |  1 +
 include/uapi/linux/ipv6.h |  1 +
 net/ipv6/addrconf.c       | 10 ++++++++++
 net/ipv6/ndisc.c          |  5 +++++
 4 files changed, 17 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 70b2ad3b9884..1679b7ce6780 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -13,6 +13,7 @@ struct ipv6_devconf {
 	__s32		forwarding;
 	__s32		hop_limit;
 	__s32		mtu6;
+	__s32		ra_mtu;
 	__s32		accept_ra;
 	__s32		accept_redirects;
 	__s32		autoconf;
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775fe91..1214befaea9f 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -140,6 +140,7 @@ enum {
 	DEVCONF_FORWARDING = 0,
 	DEVCONF_HOPLIMIT,
 	DEVCONF_MTU6,
+	DEVCONF_RA_MTU,
 	DEVCONF_ACCEPT_RA,
 	DEVCONF_ACCEPT_REDIRECTS,
 	DEVCONF_AUTOCONF,
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b0ef65eb9bd2..d2cd30bd25b3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -187,6 +187,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.forwarding		= 0,
 	.hop_limit		= IPV6_DEFAULT_HOPLIMIT,
 	.mtu6			= IPV6_MIN_MTU,
+	.ra_mtu			= 0,
 	.accept_ra		= 1,
 	.accept_redirects	= 1,
 	.autoconf		= 1,
@@ -243,6 +244,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.forwarding		= 0,
 	.hop_limit		= IPV6_DEFAULT_HOPLIMIT,
 	.mtu6			= IPV6_MIN_MTU,
+	.ra_mtu			= 0,
 	.accept_ra		= 1,
 	.accept_redirects	= 1,
 	.autoconf		= 1,
@@ -5460,6 +5462,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_FORWARDING] = cnf->forwarding;
 	array[DEVCONF_HOPLIMIT] = cnf->hop_limit;
 	array[DEVCONF_MTU6] = cnf->mtu6;
+	array[DEVCONF_RA_MTU] = cnf->ra_mtu;
 	array[DEVCONF_ACCEPT_RA] = cnf->accept_ra;
 	array[DEVCONF_ACCEPT_REDIRECTS] = cnf->accept_redirects;
 	array[DEVCONF_AUTOCONF] = cnf->autoconf;
@@ -6565,6 +6568,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= addrconf_sysctl_mtu,
 	},
+	{
+		.procname	= "ra_mtu",
+		.data		= &ipv6_devconf.ra_mtu,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "accept_ra",
 		.data		= &ipv6_devconf.accept_ra,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index c467c6419893..1da626267662 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1496,6 +1496,11 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
 		mtu = ntohl(n);
 
+		if (in6_dev->cnf.ra_mtu != mtu) {
+			in6_dev->cnf.ra_mtu = mtu;
+			ND_PRINTK(2, info, "update ra_mtu to %d\n", in6_dev->cnf.ra_mtu);
+		}
+
 		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
 			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
 		} else if (in6_dev->cnf.mtu6 != mtu) {
-- 
2.18.0

