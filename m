Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1613B8C03
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 04:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238609AbhGACSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 22:18:33 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:33803 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234257AbhGACSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 22:18:32 -0400
X-UUID: 7a6e163fe3ba47bd8806663946434be4-20210701
X-UUID: 7a6e163fe3ba47bd8806663946434be4-20210701
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1093462285; Thu, 01 Jul 2021 10:15:59 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 1 Jul 2021 10:15:51 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 1 Jul 2021 10:15:51 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <Rocco.Yue@gmail.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH] net: ipv6: don't generate link-local address in any addr_gen_mode
Date:   Thu, 1 Jul 2021 09:59:40 +0800
Message-ID: <20210701015940.29726-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides an ipv6 proc file named
"disable_gen_linklocal_addr", its absolute path is as follows:
"/proc/sys/net/ipv6/conf/<iface>/disable_gen_linklocal_addr".

When the "disable_gen_linklocal_addr" value of a device is 1,
it means that this device does not need the Linux kernel to
automatically generate the ipv6 link-local address no matter
which IN6_ADDR_GEN_MODE is used.

The reasons why the kernel does not need to automatically
generate the ipv6 link-local address are as follows:

(1) In the 3GPP TS 29.061, here is a description as follows:
"in order to avoid any conflict between the link-local address
of the MS and that of the GGSN, the Interface-Identifier used
by the MS to build its link-local address shall be assigned by
the GGSN. The GGSN ensures the uniqueness of this Interface-
Identifier. The MT shall then enforce the use of this
Interface-Identifier by the TE"

In other words, in the cellular network, GGSN determines whether
to reply a solicited RA message by identifying the low 64 bits
of the source address of the received RS message. Therefore,
cellular network device's ipv6 link-local address should be set
as the format of fe80::(GGSN assigned IID).

For example: When using a new kernel and ARPHRD_RAWIP, kernel
will generate an EUI64 format ipv6 link-local address, and the
Linux kernel will uses this link-local address to send RS message.
The result is that the GGSN will not reply to the RS message with
a solicited RA message.

Although the combination of IN6_ADDR_GEN_MODE_NONE + ARPHRD_NONE
can avoid the above problem (1), when the addr_gen_mode is changed
to the IN6_ADDR_GEN_MODE_STABLE_PRIVACY, the above problem still
exist. The detail as follows:

(2) Among global mobile operators, some operators have already
request MT (Mobile Terminal) to support RFC7217, such as AT&T.
This means that the device not only needs the IID assigned by the
GGSN to build the ipv6 link-local address to trigger the RS message,
but also needs to use the stable privacy mode to build the ipv6
global address after receiving the RA.

Obviously using APRHRD_NONE and IN6_ADDR_GEN_MODE_STABLE_PRIVACY
mode cannot achieve this.

In summary, using the "disable_gen_linklocal_addr" proc file can
disable kernel auto generate ipv6 link-local address no matter
which addr_gen_mode is used.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/linux/ipv6.h      |  1 +
 include/uapi/linux/ipv6.h |  1 +
 net/ipv6/addrconf.c       | 16 ++++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 70b2ad3b9884..60c5da76e207 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -76,6 +76,7 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+	__s32		disable_gen_linklocal_addr;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775fe91..0449d908b8c2 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -190,6 +190,7 @@ enum {
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_RA_DEFRTR_METRIC,
+	DEVCONF_DISABLE_GEN_LINKLOCAL_ADDR,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 701eb82acd1c..0035f935b25a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -237,6 +237,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.disable_gen_linklocal_addr = 0,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -293,6 +294,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.disable_gen_linklocal_addr = 0,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -3352,6 +3354,12 @@ static void addrconf_dev_config(struct net_device *dev)
 	if (IS_ERR(idev))
 		return;
 
+	if (idev->cnf.disable_gen_linklocal_addr) {
+		pr_info("%s: IPv6 link-local address being disabled\n",
+			idev->dev->name);
+		return;
+	}
+
 	/* this device type has no EUI support */
 	if (dev->type == ARPHRD_NONE &&
 	    idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_EUI64)
@@ -5526,6 +5534,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
 	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
+	array[DEVCONF_DISABLE_GEN_LINKLOCAL_ADDR] = cnf->disable_gen_linklocal_addr;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6932,6 +6941,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "disable_gen_linklocal_addr",
+		.data		= &ipv6_devconf.disable_gen_linklocal_addr,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		/* sentinel */
 	}
-- 
2.18.0

