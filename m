Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC3393A00
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhE1AF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:05:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60716 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236277AbhE1AFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:05:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14S017SV008093;
        Thu, 27 May 2021 17:01:22 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38sxpmd031-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:01:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 17:01:19 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 27 May 2021 17:01:15 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        "Nikolay Assa" <nassa@marvell.com>
Subject: [RFC PATCH v6 15/27] qed: Add IP services APIs support
Date:   Fri, 28 May 2021 02:58:50 +0300
Message-ID: <20210527235902.2185-16-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210527235902.2185-1-smalin@marvell.com>
References: <20210527235902.2185-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OfbWl9BiutQfxgrpuJoSZggurE8E1nLK
X-Proofpoint-GUID: OfbWl9BiutQfxgrpuJoSZggurE8E1nLK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_13:2021-05-27,2021-05-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Assa <nassa@marvell.com>

This patch introduces APIs which the NVMeTCP Offload device (qedn)
will use through the paired net-device (qede).
It includes APIs for:
- ipv4/ipv6 routing
- get VLAN from net-device
- TCP ports reservation

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Nikolay Assa <nassa@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 .../qlogic/qed/qed_nvmetcp_ip_services.c      | 239 ++++++++++++++++++
 .../linux/qed/qed_nvmetcp_ip_services_if.h    |  29 +++
 2 files changed, 268 insertions(+)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
 create mode 100644 include/linux/qed/qed_nvmetcp_ip_services_if.h

diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
new file mode 100644
index 000000000000..2904b1a0830a
--- /dev/null
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/param.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/kernel.h>
+#include <linux/stddef.h>
+#include <linux/errno.h>
+
+#include <net/tcp.h>
+
+#include <linux/qed/qed_nvmetcp_ip_services_if.h>
+
+#define QED_IP_RESOL_TIMEOUT  4
+
+int qed_route_ipv4(struct sockaddr_storage *local_addr,
+		   struct sockaddr_storage *remote_addr,
+		   struct sockaddr *hardware_address,
+		   struct net_device **ndev)
+{
+	struct neighbour *neigh = NULL;
+	__be32 *loc_ip, *rem_ip;
+	struct rtable *rt;
+	int rc = -ENXIO;
+	int retry;
+
+	loc_ip = &((struct sockaddr_in *)local_addr)->sin_addr.s_addr;
+	rem_ip = &((struct sockaddr_in *)remote_addr)->sin_addr.s_addr;
+	*ndev = NULL;
+	rt = ip_route_output(&init_net, *rem_ip, *loc_ip, 0/*tos*/, 0/*oif*/);
+	if (IS_ERR(rt)) {
+		pr_err("lookup route failed\n");
+		rc = PTR_ERR(rt);
+		goto return_err;
+	}
+
+	neigh = dst_neigh_lookup(&rt->dst, rem_ip);
+	if (!neigh) {
+		rc = -ENOMEM;
+		ip_rt_put(rt);
+		goto return_err;
+	}
+
+	*ndev = rt->dst.dev;
+	ip_rt_put(rt);
+
+	/* If not resolved, kick-off state machine towards resolution */
+	if (!(neigh->nud_state & NUD_VALID))
+		neigh_event_send(neigh, NULL);
+
+	/* query neighbor until resolved or timeout */
+	retry = QED_IP_RESOL_TIMEOUT;
+	while (!(neigh->nud_state & NUD_VALID) && retry > 0) {
+		msleep(1000);
+		retry--;
+	}
+
+	if (neigh->nud_state & NUD_VALID) {
+		/* copy resolved MAC address */
+		neigh_ha_snapshot(hardware_address->sa_data, neigh, *ndev);
+
+		hardware_address->sa_family = (*ndev)->type;
+		rc = 0;
+	}
+
+	neigh_release(neigh);
+	if (!(*loc_ip)) {
+		*loc_ip = inet_select_addr(*ndev, *rem_ip, RT_SCOPE_UNIVERSE);
+		local_addr->ss_family = AF_INET;
+	}
+
+return_err:
+
+	return rc;
+}
+EXPORT_SYMBOL(qed_route_ipv4);
+
+int qed_route_ipv6(struct sockaddr_storage *local_addr,
+		   struct sockaddr_storage *remote_addr,
+		   struct sockaddr *hardware_address,
+		   struct net_device **ndev)
+{
+	struct neighbour *neigh = NULL;
+	struct dst_entry *dst;
+	struct flowi6 fl6;
+	int rc = -ENXIO;
+	int retry;
+
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.saddr = ((struct sockaddr_in6 *)local_addr)->sin6_addr;
+	fl6.daddr = ((struct sockaddr_in6 *)remote_addr)->sin6_addr;
+
+	dst = ip6_route_output(&init_net, NULL, &fl6);
+	if (!dst || dst->error) {
+		if (dst) {
+			dst_release(dst);
+			pr_err("lookup route failed %d\n", dst->error);
+		}
+
+		goto out;
+	}
+
+	neigh = dst_neigh_lookup(dst, &fl6.daddr);
+	if (neigh) {
+		*ndev = ip6_dst_idev(dst)->dev;
+
+		/* If not resolved, kick-off state machine towards resolution */
+		if (!(neigh->nud_state & NUD_VALID))
+			neigh_event_send(neigh, NULL);
+
+		/* query neighbor until resolved or timeout */
+		retry = QED_IP_RESOL_TIMEOUT;
+		while (!(neigh->nud_state & NUD_VALID) && retry > 0) {
+			msleep(1000);
+			retry--;
+		}
+
+		if (neigh->nud_state & NUD_VALID) {
+			neigh_ha_snapshot((u8 *)hardware_address->sa_data, neigh, *ndev);
+
+			hardware_address->sa_family = (*ndev)->type;
+			rc = 0;
+		}
+
+		neigh_release(neigh);
+
+		if (ipv6_addr_any(&fl6.saddr)) {
+			if (ipv6_dev_get_saddr(dev_net(*ndev), *ndev,
+					       &fl6.daddr, 0, &fl6.saddr)) {
+				pr_err("Unable to find source IP address\n");
+				goto out;
+			}
+
+			local_addr->ss_family = AF_INET6;
+			((struct sockaddr_in6 *)local_addr)->sin6_addr =
+								fl6.saddr;
+		}
+	}
+
+	dst_release(dst);
+
+out:
+
+	return rc;
+}
+EXPORT_SYMBOL(qed_route_ipv6);
+
+void qed_vlan_get_ndev(struct net_device **ndev, u16 *vlan_id)
+{
+	if (is_vlan_dev(*ndev)) {
+		*vlan_id = vlan_dev_vlan_id(*ndev);
+		*ndev = vlan_dev_real_dev(*ndev);
+	}
+}
+EXPORT_SYMBOL(qed_vlan_get_ndev);
+
+struct pci_dev *qed_validate_ndev(struct net_device *ndev)
+{
+	struct pci_dev *pdev = NULL;
+	struct net_device *upper;
+
+	for_each_pci_dev(pdev) {
+		if (pdev && pdev->driver &&
+		    !strcmp(pdev->driver->name, "qede")) {
+			upper = pci_get_drvdata(pdev);
+			if (upper->ifindex == ndev->ifindex)
+				return pdev;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(qed_validate_ndev);
+
+__be16 qed_get_in_port(struct sockaddr_storage *sa)
+{
+	return sa->ss_family == AF_INET
+		? ((struct sockaddr_in *)sa)->sin_port
+		: ((struct sockaddr_in6 *)sa)->sin6_port;
+}
+EXPORT_SYMBOL(qed_get_in_port);
+
+int qed_fetch_tcp_port(struct sockaddr_storage local_ip_addr,
+		       struct socket **sock, u16 *port)
+{
+	struct sockaddr_storage sa;
+	int rc = 0;
+
+	rc = sock_create(local_ip_addr.ss_family, SOCK_STREAM, IPPROTO_TCP, sock);
+	if (rc) {
+		pr_warn("failed to create socket: %d\n", rc);
+		goto err;
+	}
+
+	(*sock)->sk->sk_allocation = GFP_KERNEL;
+	sk_set_memalloc((*sock)->sk);
+
+	rc = kernel_bind(*sock, (struct sockaddr *)&local_ip_addr,
+			 sizeof(local_ip_addr));
+
+	if (rc) {
+		pr_warn("failed to bind socket: %d\n", rc);
+		goto err_sock;
+	}
+
+	rc = kernel_getsockname(*sock, (struct sockaddr *)&sa);
+	if (rc < 0) {
+		pr_warn("getsockname() failed: %d\n", rc);
+		goto err_sock;
+	}
+
+	*port = ntohs(qed_get_in_port(&sa));
+
+	return 0;
+
+err_sock:
+	sock_release(*sock);
+	sock = NULL;
+err:
+
+	return rc;
+}
+EXPORT_SYMBOL(qed_fetch_tcp_port);
+
+void qed_return_tcp_port(struct socket *sock)
+{
+	if (sock && sock->sk) {
+		tcp_set_state(sock->sk, TCP_CLOSE);
+		sock_release(sock);
+	}
+}
+EXPORT_SYMBOL(qed_return_tcp_port);
diff --git a/include/linux/qed/qed_nvmetcp_ip_services_if.h b/include/linux/qed/qed_nvmetcp_ip_services_if.h
new file mode 100644
index 000000000000..3604aee53796
--- /dev/null
+++ b/include/linux/qed/qed_nvmetcp_ip_services_if.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#ifndef _QED_IP_SERVICES_IF_H
+#define _QED_IP_SERVICES_IF_H
+
+#include <linux/types.h>
+#include <net/route.h>
+#include <net/ip6_route.h>
+#include <linux/inetdevice.h>
+
+int qed_route_ipv4(struct sockaddr_storage *local_addr,
+		   struct sockaddr_storage *remote_addr,
+		   struct sockaddr *hardware_address,
+		   struct net_device **ndev);
+int qed_route_ipv6(struct sockaddr_storage *local_addr,
+		   struct sockaddr_storage *remote_addr,
+		   struct sockaddr *hardware_address,
+		   struct net_device **ndev);
+void qed_vlan_get_ndev(struct net_device **ndev, u16 *vlan_id);
+struct pci_dev *qed_validate_ndev(struct net_device *ndev);
+void qed_return_tcp_port(struct socket *sock);
+int qed_fetch_tcp_port(struct sockaddr_storage local_ip_addr,
+		       struct socket **sock, u16 *port);
+__be16 qed_get_in_port(struct sockaddr_storage *sa);
+
+#endif /* _QED_IP_SERVICES_IF_H */
-- 
2.22.0

