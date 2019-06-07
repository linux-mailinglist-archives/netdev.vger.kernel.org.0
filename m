Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CEF398F8
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbfFGWiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731751AbfFGWiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:19 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A1620840;
        Fri,  7 Jun 2019 22:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947099;
        bh=UIstGdJB++uCNT+ZZwRcDYZ7xxWQ4yA79qmUZ+sEvoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeDjve2VLC9o3L7iRCS5UNoC8ylI5tb0m43iRvA+A+RVwbXEB2/NvUhUu4baTipvH
         4kmxJXUsEPu+D8v7KdWnTqx7ceYo9f5DfpXMB9iN0qJ9SXi3TuLZ/d8gevwGHcDVtQ
         0eRu7EtgYtaRWwYMA3TkReC4pTGkuPwohDac0qEA=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 04/10] uapi: Import nexthop object API
Date:   Fri,  7 Jun 2019 15:38:10 -0700
Message-Id: <20190607223816.27512-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add nexthop.h from kernel with the uapi for nexthop objects.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/uapi/linux/nexthop.h | 56 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 include/uapi/linux/nexthop.h

diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
new file mode 100644
index 000000000000..b56c5b895476
--- /dev/null
+++ b/include/uapi/linux/nexthop.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_NEXTHOP_H
+#define _LINUX_NEXTHOP_H
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
-- 
2.11.0

