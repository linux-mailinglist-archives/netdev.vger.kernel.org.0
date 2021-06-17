Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88213AB041
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhFQJw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:52:57 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37645 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhFQJw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 05:52:57 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A047183640;
        Thu, 17 Jun 2021 21:50:48 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1623923448;
        bh=M8bmR2iJi0VOyBFSDntDt2/tdkzurmv5MvFp3dNBnfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=e71jPPS00N1cETg7YP2JcSyGCswQ616/7hkqOWx6FBfxJWu2gw0y4mVD6rrvoN1uN
         p87+jzvE4Vwef/tgRa2CU9xjH96Ab1pSsmGpX7xXyn9hxEiHSBzfcwVNWkb1KVZxLa
         /9EWhmusWJyJuXU66fQHIDune4eRfhQ6dL++I4WBkG1KxZKfV/C/JDNUs5hCpYfzFc
         M6Yr6b4L2JXlju8BYHGAMJu6Ysnt6hu2f85U6qCUpTuBN+uT25yNCT59pCrEwlCJEg
         RF8OQrk+Yxe0plemaBQMNl2F/EEif/uNSjba1AiC9vQnNklwJmBSPX75OIGUimYSi3
         1lL8P09/zU7Mg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60cb1af80000>; Thu, 17 Jun 2021 21:50:48 +1200
Received: from callums-dl.ws.atlnz.lc (callums-dl.ws.atlnz.lc [10.33.22.16])
        by pat.atlnz.lc (Postfix) with ESMTP id 76FD413EE13;
        Thu, 17 Jun 2021 21:50:48 +1200 (NZST)
Received: by callums-dl.ws.atlnz.lc (Postfix, from userid 1764)
        id 724D4A028D; Thu, 17 Jun 2021 21:50:48 +1200 (NZST)
From:   Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
To:     dsahern@kernel.org, nikolay@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.luessing@c0d3.blue,
        Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Subject: [PATCH 1/1] net: Allow all multicast packets to be received on a interface.
Date:   Thu, 17 Jun 2021 21:50:20 +1200
Message-Id: <20210617095020.28628-2-callum.sinclair@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617095020.28628-1-callum.sinclair@alliedtelesis.co.nz>
References: <20210617095020.28628-1-callum.sinclair@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=r6YtysWOX24A:10 a=ep1ps3Mf0jJyYw2WOb0A:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To receive IGMP or MLD packets on a IP socket on any interface the
multicast group needs to be explicitly joined. This works well for when
the multicast group the user is interested in is known, but does not
provide an easy way to snoop all packets in the 224.0.0.0/8 or the
FF00::/8 range.

Define a new sysctl to allow a given interface to become a IGMP or MLD
snooper. When set the interface will allow any IGMP or MLD packet to be
received on sockets bound to these devices.
---
 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 include/linux/inetdevice.h             |  1 +
 include/linux/ipv6.h                   |  1 +
 include/uapi/linux/ip.h                |  1 +
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/netconf.h           |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv4/devinet.c                     |  7 +++++++
 net/ipv4/igmp.c                        |  5 +++++
 net/ipv6/addrconf.c                    | 14 ++++++++++++++
 net/ipv6/mcast.c                       |  5 +++++
 11 files changed, 45 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/netwo=
rking/ip-sysctl.rst
index a5c250044500..12f82da52684 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1357,6 +1357,14 @@ mc_forwarding - BOOLEAN
 	conf/all/mc_forwarding must also be set to TRUE to enable multicast
 	routing	for the interface
=20
+mc_snooping - BOOLEAN
+	Enable multicast snooping on the interface. This allows any given
+	multicast group to be received without explicitly being joined.
+	The kernel needs to be compiled with CONFIG_MROUTE and/or
+	CONFIG_IPV6_MROUTE.
+	conf/all/mc_snooping must also be set to TRUE to enable multicast
+	snooping for the interface.
+
 medium_id - INTEGER
 	Integer value used to differentiate the devices by the medium they
 	are attached to. Two devices can have different id values when
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 53aa0343bf69..071edf7d4f9c 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -95,6 +95,7 @@ static inline void ipv4_devconf_setall(struct in_device=
 *in_dev)
=20
 #define IN_DEV_FORWARD(in_dev)		IN_DEV_CONF_GET((in_dev), FORWARDING)
 #define IN_DEV_MFORWARD(in_dev)		IN_DEV_ANDCONF((in_dev), MC_FORWARDING)
+#define IN_DEV_MSNOOPING(in_dev)	IN_DEV_ANDCONF((in_dev), MC_SNOOPING)
 #define IN_DEV_BFORWARD(in_dev)		IN_DEV_ANDCONF((in_dev), BC_FORWARDING)
 #define IN_DEV_RPFILTER(in_dev)		IN_DEV_MAXCONF((in_dev), RP_FILTER)
 #define IN_DEV_SRC_VMARK(in_dev)    	IN_DEV_ORCONF((in_dev), SRC_VMARK)
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 70b2ad3b9884..d88c34b1b3ae 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -52,6 +52,7 @@ struct ipv6_devconf {
 #endif
 #ifdef CONFIG_IPV6_MROUTE
 	__s32		mc_forwarding;
+	__s32		mc_snooping;
 #endif
 	__s32		disable_ipv6;
 	__s32		drop_unicast_in_l2_multicast;
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..07956b4613d0 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -169,6 +169,7 @@ enum
 	IPV4_DEVCONF_DROP_UNICAST_IN_L2_MULTICAST,
 	IPV4_DEVCONF_DROP_GRATUITOUS_ARP,
 	IPV4_DEVCONF_BC_FORWARDING,
+	IPV4_DEVCONF_MC_SNOOPING,
 	__IPV4_DEVCONF_MAX
 };
=20
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775fe91..aa9389e1c1fd 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -190,6 +190,7 @@ enum {
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_RA_DEFRTR_METRIC,
+	DEVCONF_MC_SNOOPING,
 	DEVCONF_MAX
 };
=20
diff --git a/include/uapi/linux/netconf.h b/include/uapi/linux/netconf.h
index fac4edd55379..5259742a700b 100644
--- a/include/uapi/linux/netconf.h
+++ b/include/uapi/linux/netconf.h
@@ -19,6 +19,7 @@ enum {
 	NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN,
 	NETCONFA_INPUT,
 	NETCONFA_BC_FORWARDING,
+	NETCONFA_MC_SNOOPING,
 	__NETCONFA_MAX
 };
 #define NETCONFA_MAX	(__NETCONFA_MAX - 1)
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 1e05d3caa712..1b7be9dc78de 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -482,6 +482,7 @@ enum
 	NET_IPV4_CONF_PROMOTE_SECONDARIES=3D20,
 	NET_IPV4_CONF_ARP_ACCEPT=3D21,
 	NET_IPV4_CONF_ARP_NOTIFY=3D22,
+	NET_IPV4_CONF_MC_SNOOPING=3D23,
 };
=20
 /* /proc/sys/net/ipv4/netfilter */
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 50deeff48c8b..3e4ac6aead9d 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2014,6 +2014,8 @@ static int inet_netconf_msgsize_devconf(int type)
 		size +=3D nla_total_size(4);
 	if (all || type =3D=3D NETCONFA_MC_FORWARDING)
 		size +=3D nla_total_size(4);
+	if (all || type =3D=3D NETCONFA_MC_SNOOPING)
+		size +=3D nla_total_size(4);
 	if (all || type =3D=3D NETCONFA_BC_FORWARDING)
 		size +=3D nla_total_size(4);
 	if (all || type =3D=3D NETCONFA_PROXY_NEIGH)
@@ -2062,6 +2064,10 @@ static int inet_netconf_fill_devconf(struct sk_buf=
f *skb, int ifindex,
 	    nla_put_s32(skb, NETCONFA_MC_FORWARDING,
 			IPV4_DEVCONF(*devconf, MC_FORWARDING)) < 0)
 		goto nla_put_failure;
+	if ((all || type =3D=3D NETCONFA_MC_SNOOPING) &&
+	    nla_put_s32(skb, NETCONFA_MC_SNOOPING,
+			IPV4_DEVCONF(*devconf, NETCONFA_MC_SNOOPING)) < 0)
+		goto nla_put_failure;
 	if ((all || type =3D=3D NETCONFA_BC_FORWARDING) &&
 	    nla_put_s32(skb, NETCONFA_BC_FORWARDING,
 			IPV4_DEVCONF(*devconf, BC_FORWARDING)) < 0)
@@ -2506,6 +2512,7 @@ static struct devinet_sysctl_table {
 		DEVINET_SYSCTL_COMPLEX_ENTRY(FORWARDING, "forwarding",
 					     devinet_sysctl_forward),
 		DEVINET_SYSCTL_RO_ENTRY(MC_FORWARDING, "mc_forwarding"),
+		DEVINET_SYSCTL_RW_ENTRY(MC_SNOOPING, "mc_snooping"),
 		DEVINET_SYSCTL_RW_ENTRY(BC_FORWARDING, "bc_forwarding"),
=20
 		DEVINET_SYSCTL_RW_ENTRY(ACCEPT_REDIRECTS, "accept_redirects"),
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7b272bbed2b4..cd5a837dfb0c 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2692,6 +2692,11 @@ int ip_check_mc_rcu(struct in_device *in_dev, __be=
32 mc_addr, __be32 src_addr, u
 	struct ip_sf_list *psf;
 	int rv =3D 0;
=20
+#ifdef CONFIG_IP_MROUTE
+	if (IN_DEV_MSNOOPING(in_dev))
+		return 1;
+#endif /* CONFIG_IP_MROUTE */
+
 	mc_hash =3D rcu_dereference(in_dev->mc_hash);
 	if (mc_hash) {
 		u32 hash =3D hash_32((__force u32)mc_addr, MC_HASH_SZ_LOG);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 048570900fdf..b92ac4e8f37d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -502,6 +502,8 @@ static int inet6_netconf_msgsize_devconf(int type)
 #ifdef CONFIG_IPV6_MROUTE
 	if (all || type =3D=3D NETCONFA_MC_FORWARDING)
 		size +=3D nla_total_size(4);
+	if (all || type =3D=3D NETCONFA_MC_SNOOPING)
+		size +=3D nla_total_size(4);
 #endif
 	if (all || type =3D=3D NETCONFA_PROXY_NEIGH)
 		size +=3D nla_total_size(4);
@@ -546,6 +548,10 @@ static int inet6_netconf_fill_devconf(struct sk_buff=
 *skb, int ifindex,
 	    nla_put_s32(skb, NETCONFA_MC_FORWARDING,
 			devconf->mc_forwarding) < 0)
 		goto nla_put_failure;
+	if ((all || type =3D=3D NETCONFA_MC_SNOOPING) &&
+	    nla_put_s32(skb, NETCONFA_MC_SNOOPING,
+			devconf->mc_snooping) < 0)
+		goto nla_put_failure;
 #endif
 	if ((all || type =3D=3D NETCONFA_PROXY_NEIGH) &&
 	    nla_put_s32(skb, NETCONFA_PROXY_NEIGH, devconf->proxy_ndp) < 0)
@@ -5503,6 +5509,7 @@ static inline void ipv6_store_devconf(struct ipv6_d=
evconf *cnf,
 #endif
 #ifdef CONFIG_IPV6_MROUTE
 	array[DEVCONF_MC_FORWARDING] =3D cnf->mc_forwarding;
+	array[DEVCONF_MC_SNOOPING] =3D cnf->mc_snooping;
 #endif
 	array[DEVCONF_DISABLE_IPV6] =3D cnf->disable_ipv6;
 	array[DEVCONF_ACCEPT_DAD] =3D cnf->accept_dad;
@@ -6786,6 +6793,13 @@ static const struct ctl_table addrconf_sysctl[] =3D=
 {
 		.mode		=3D 0444,
 		.proc_handler	=3D proc_dointvec,
 	},
+	{
+		.procname	=3D "mc_snooping",
+		.data		=3D &ipv6_devconf.mc_snooping,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec,
+	},
 #endif
 	{
 		.procname	=3D "disable_ipv6",
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 54ec163fbafa..25046ee8276f 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1013,6 +1013,11 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, c=
onst struct in6_addr *group,
 	struct ifmcaddr6 *mc;
 	bool rv =3D false;
=20
+#ifdef CONFIG_IPV6_MROUTE
+	if (dev_net(dev)->ipv6.devconf_all->mc_snooping)
+		return true;
+#endif
+
 	rcu_read_lock();
 	idev =3D __in6_dev_get(dev);
 	if (idev) {
--=20
2.32.0

