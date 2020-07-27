Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB33A22FC72
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgG0WqK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:46:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726846AbgG0WqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:46:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06RMhEqg012449
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:08 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32ggdmhknw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:08 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id C7AA03FAB6F65; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 06/21] include: add netgpu UAPI and kernel definitions
Date:   Mon, 27 Jul 2020 15:44:29 -0700
Message-ID: <20200727224444.2987641-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1034 bulkscore=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

This provides the interface to the netgpu module.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/netgpu.h       | 66 ++++++++++++++++++++++++++++++++++++
 include/uapi/misc/netgpu.h | 69 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 include/net/netgpu.h
 create mode 100644 include/uapi/misc/netgpu.h

diff --git a/include/net/netgpu.h b/include/net/netgpu.h
new file mode 100644
index 000000000000..14bd19412c38
--- /dev/null
+++ b/include/net/netgpu.h
@@ -0,0 +1,66 @@
+#ifndef _NET_NETGPU_H
+#define _NET_NETGPU_H
+
+#include <uapi/misc/netgpu.h>		/* IOCTL defines */
+#include <uapi/misc/shqueue.h>
+
+enum {
+	NETGPU_MEMTYPE_HOST,
+	NETGPU_MEMTYPE_CUDA,
+
+	NETGPU_MEMTYPE_MAX,
+};
+
+struct netgpu_pgcache {
+	struct netgpu_pgcache *next;
+	struct page *page[];
+};
+
+struct netgpu_ifq {
+	struct shared_queue fill;
+	struct wait_queue_head fill_wait;
+	struct netgpu_ctx *ctx;
+	int queue_id;
+	spinlock_t pgcache_lock;
+	struct netgpu_pgcache *napi_cache;
+	struct netgpu_pgcache *spare_cache;
+	struct netgpu_pgcache *any_cache;
+	int napi_cache_count;
+	int any_cache_count;
+	struct list_head ifq_node;
+};
+
+struct netgpu_skq {
+	struct shared_queue rx;
+	struct shared_queue cq;		/* for requested completions */
+	struct netgpu_ctx *ctx;
+	void (*sk_destruct)(struct sock *sk);
+	void (*sk_data_ready)(struct sock *sk);
+};
+
+struct netgpu_ctx {
+	struct xarray xa;		/* contains dmamaps */
+	refcount_t ref;
+	struct net_device *dev;
+	struct list_head ifq_list;
+};
+
+struct net_device;
+struct netgpu_ops;
+struct socket;
+
+dma_addr_t netgpu_get_dma(struct netgpu_ctx *ctx, struct page *page);
+int netgpu_get_page(struct netgpu_ifq *ifq, struct page **page,
+		    dma_addr_t *dma);
+void netgpu_put_page(struct netgpu_ifq *ifq, struct page *page, bool napi);
+int netgpu_get_pages(struct sock *sk, struct page **pages, unsigned long addr,
+		     int count);
+
+int netgpu_socket_mmap(struct file *file, struct socket *sock,
+		       struct vm_area_struct *vma);
+int netgpu_attach_socket(struct sock *sk, void __user *arg);
+
+int netgpu_register(struct netgpu_ops *ops);
+void netgpu_unregister(int memtype);
+
+#endif /* _NET_NETGPU_H */
diff --git a/include/uapi/misc/netgpu.h b/include/uapi/misc/netgpu.h
new file mode 100644
index 000000000000..1fa8a1d719ee
--- /dev/null
+++ b/include/uapi/misc/netgpu.h
@@ -0,0 +1,69 @@
+#ifndef _UAPI_MISC_NETGPU_H
+#define _UAPI_MISC_NETGPU_H
+
+#include <linux/ioctl.h>
+
+#define NETGPU_OFF_FILL_ID	(0ULL << 12)
+#define NETGPU_OFF_RX_ID	(1ULL << 12)
+#define NETGPU_OFF_CQ_ID	(2ULL << 12)
+
+struct netgpu_queue_offsets {
+	unsigned prod;
+	unsigned cons;
+	unsigned data;
+	unsigned resv;
+};
+
+struct netgpu_user_queue {
+	unsigned elt_sz;
+	unsigned entries;
+	unsigned mask;
+	unsigned map_sz;
+	unsigned map_off;
+	struct netgpu_queue_offsets off;
+};
+
+enum netgpu_memtype {
+	MEMTYPE_HOST,
+	MEMTYPE_CUDA,
+
+	MEMTYPE_MAX,
+};
+
+/* VA memory provided by a specific PCI device. */
+struct netgpu_region_param {
+	struct iovec iov;
+	enum netgpu_memtype memtype;
+};
+
+struct netgpu_attach_param {
+	int mem_fd;
+	int mem_idx;
+};
+
+struct netgpu_socket_param {
+	unsigned resv;
+	int ctx_fd;
+	struct netgpu_user_queue rx;
+	struct netgpu_user_queue cq;
+};
+
+struct netgpu_ifq_param {
+	unsigned resv;
+	unsigned ifq_fd;		/* OUT parameter */
+	unsigned queue_id;		/* IN/OUT, IN: -1 if don't care */
+	struct netgpu_user_queue fill;
+};
+
+struct netgpu_ctx_param {
+	unsigned resv;
+	unsigned ifindex;
+};
+
+#define NETGPU_CTX_IOCTL_ATTACH_DEV	_IOR( 0, 1, int)
+#define NETGPU_CTX_IOCTL_BIND_QUEUE	_IOWR(0, 2, struct netgpu_ifq_param)
+#define NETGPU_CTX_IOCTL_ATTACH_REGION	_IOW( 0, 3, struct netgpu_attach_param)
+#define NETGPU_MEM_IOCTL_ADD_REGION	_IOR( 0, 4, struct netgpu_region_param)
+#define NETGPU_SOCK_IOCTL_ATTACH_QUEUES	(SIOCPROTOPRIVATE + 0)
+
+#endif /* _UAPI_MISC_NETGPU_H */
-- 
2.24.1

