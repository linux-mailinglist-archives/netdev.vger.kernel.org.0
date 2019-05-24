Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271E42A08C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404305AbfEXVnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404254AbfEXVnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 17:43:15 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0114821848;
        Fri, 24 May 2019 21:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734194;
        bh=OcANpfCmWq3ne9zc1GN27Qfu6n6euQgmwHnYBxjn8I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNqXxX2RJMgor4V3cBDii1d43iuPfhjim/eV7f/63lPmegDittg1RXMeDz166KYZQ
         BKR6aWGOeQ+6TYKlcJilrIoCJBe2JKIUC+CJlCKVH2shm9gsIfPl/jpF/Jk8koZosj
         WByZDOtrpdOGBzoUAOHmcMm/yKvyLqE3cVOkiMKY=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     sharpd@cumulusnetworks.com, sworley@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 1/6] net: nexthop uapi
Date:   Fri, 24 May 2019 14:43:03 -0700
Message-Id: <20190524214308.18615-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190524214308.18615-1-dsahern@kernel.org>
References: <20190524214308.18615-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

New UAPI for nexthops as standalone objects:
- defines netlink ancillary header, struct nhmsg
- RTM commands for nexthop objects, RTM_*NEXTHOP,
- RTNLGRP for nexthop notifications, RTNLGRP_NEXTHOP,
- Attributes for creating nexthops, NHA_*
- Attribute for route specs to specify a nexthop by id, RTA_NH_ID.

The nexthop attributes and semantics follow the route and RTA ones for
device, gateway and lwt encap. Unique to nexthop objects are a blackhole
and a group which contains references to other nexthop objects. With the
exception of blackhole and group, nexthop objects MUST contain a device.
Gateway and encap are optional. Nexthop groups can only reference other
pre-existing nexthops by id. If the NHA_ID attribute is present that id
is used for the nexthop. If not specified, one is auto assigned.

Dump requests can include attributes:
- NHA_GROUPS to return only nexthop groups,
- NHA_MASTER to limit dumps to nexthops with devices enslaved to the
  given master (e.g., VRF)
- NHA_OIF to limit dumps to nexthops using given device

nlmsg_route_perms in selinux code is updated for the new RTM comands.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/uapi/linux/nexthop.h   | 56 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/rtnetlink.h | 10 ++++++++
 security/selinux/nlmsgtab.c    |  5 +++-
 3 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/nexthop.h

diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
new file mode 100644
index 000000000000..7b61867e9848
--- /dev/null
+++ b/include/uapi/linux/nexthop.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_NEXTHOP_H
+#define _UAPI_LINUX_NEXTHOP_H
+
+#include <linux/types.h>
+
+struct nhmsg {
+	unsigned char	nh_family;
+	unsigned char	nh_scope;     /* return only */
+	unsigned char	nh_protocol;  /* Routing protocol that installed nh */
+	unsigned char	resvd;
+	unsigned int	nh_flags;     /* RTNH_F flags */
+};
+
+/* entry in a nexthop group */
+struct nexthop_grp {
+	__u32	id;	  /* nexthop id - must exist */
+	__u8	weight;   /* weight of this nexthop */
+	__u8	resvd1;
+	__u16	resvd2;
+};
+
+enum {
+	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
+	__NEXTHOP_GRP_TYPE_MAX,
+};
+
+#define NEXTHOP_GRP_TYPE_MAX (__NEXTHOP_GRP_TYPE_MAX - 1)
+
+enum {
+	NHA_UNSPEC,
+	NHA_ID,		/* u32; id for nexthop. id == 0 means auto-assign */
+
+	NHA_GROUP,	/* array of nexthop_grp */
+	NHA_GROUP_TYPE,	/* u16 one of NEXTHOP_GRP_TYPE */
+	/* if NHA_GROUP attribute is added, no other attributes can be set */
+
+	NHA_BLACKHOLE,	/* flag; nexthop used to blackhole packets */
+	/* if NHA_BLACKHOLE is added, OIF, GATEWAY, ENCAP can not be set */
+
+	NHA_OIF,	/* u32; nexthop device */
+	NHA_GATEWAY,	/* be32 (IPv4) or in6_addr (IPv6) gw address */
+	NHA_ENCAP_TYPE, /* u16; lwt encap type */
+	NHA_ENCAP,	/* lwt encap data */
+
+	/* NHA_OIF can be appended to dump request to return only
+	 * nexthops using given device
+	 */
+	NHA_GROUPS,	/* flag; only return nexthop groups in dump */
+	NHA_MASTER,	/* u32;  only return nexthops with given master dev */
+
+	__NHA_MAX,
+};
+
+#define NHA_MAX	(__NHA_MAX - 1)
+#endif
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 46399367627f..ce2a623abb75 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -157,6 +157,13 @@ enum {
 	RTM_GETCHAIN,
 #define RTM_GETCHAIN RTM_GETCHAIN
 
+	RTM_NEWNEXTHOP = 104,
+#define RTM_NEWNEXTHOP	RTM_NEWNEXTHOP
+	RTM_DELNEXTHOP,
+#define RTM_DELNEXTHOP	RTM_DELNEXTHOP
+	RTM_GETNEXTHOP,
+#define RTM_GETNEXTHOP	RTM_GETNEXTHOP
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
@@ -342,6 +349,7 @@ enum rtattr_type_t {
 	RTA_IP_PROTO,
 	RTA_SPORT,
 	RTA_DPORT,
+	RTA_NH_ID,
 	__RTA_MAX
 };
 
@@ -704,6 +712,8 @@ enum rtnetlink_groups {
 #define RTNLGRP_IPV4_MROUTE_R	RTNLGRP_IPV4_MROUTE_R
 	RTNLGRP_IPV6_MROUTE_R,
 #define RTNLGRP_IPV6_MROUTE_R	RTNLGRP_IPV6_MROUTE_R
+	RTNLGRP_NEXTHOP,
+#define RTNLGRP_NEXTHOP		RTNLGRP_NEXTHOP
 	__RTNLGRP_MAX
 };
 #define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 9cec81209617..2c75d823d8e2 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -83,6 +83,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWCHAIN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELCHAIN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETCHAIN,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_NEWNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -166,7 +169,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWCHAIN + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOP + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.11.0

