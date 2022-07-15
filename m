Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA5C576AE9
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiGOXzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiGOXzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:55:43 -0400
X-Greylist: delayed 1798 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 16:55:41 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71438951FE;
        Fri, 15 Jul 2022 16:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=l7nuWYxWUVjm0xFc+FYu5FtE4ko865NXIUjDmd1KE7k=; b=Xjhw3
        PWfy8PH+g/wF6G0m0ESFeDBNMWHRfUUJZz3snzevmakUa5jsGmyrWCJjSvo84gJrzlTsmFp7LR73V
        d3SPyxmTMJ6ZRvJqyrHp+cKXZjd5sMCKOKN5RoAdiR+liKNPdk2N9THnK4BQuscMeCdSmXK+1y+ji
        OMw3Umg47NTppEhX8V3lpAmIRPs0zooGDeOJ3Hj+Vfpn7RTDMp2vVEwkVWmTO0rNEkknGFVVcSLra
        hKaU8WERWqpXJSr2tqqnOCG4VznQMOKmyjWQm0snDDgP2xqPxU1XkWJNlfjZG9RuB/KKZUQzzH/0E
        XqYdCA4krtoSqxTfEc0wTdRDyFI3Q==;
Message-Id: <79d24310226bc4eb037892b5c097ec4ad4819a03.1657920926.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657920926.git.linux_oss@crudebyte.com>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Fri, 15 Jul 2022 23:33:09 +0200
Subject: [PATCH v6 10/11] net/9p: add 'pooled_rbuffers' flag to struct
 p9_trans_module
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preparatory change for the subsequent patch: the RDMA
transport pulls the buffers for its 9p response messages from a
shared pool. [1] So this case has to be considered when choosing
an appropriate response message size in the subsequent patch.

Link: https://lore.kernel.org/all/Ys3jjg52EIyITPua@codewreck.org/ [1]
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 include/net/9p/transport.h | 5 +++++
 net/9p/trans_fd.c          | 1 +
 net/9p/trans_rdma.c        | 1 +
 net/9p/trans_virtio.c      | 1 +
 net/9p/trans_xen.c         | 1 +
 5 files changed, 9 insertions(+)

diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index ff842f963071..766ec07c9599 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -19,6 +19,10 @@
  * @list: used to maintain a list of currently available transports
  * @name: the human-readable name of the transport
  * @maxsize: transport provided maximum packet size
+ * @pooled_rbuffers: currently only set for RDMA transport which pulls the
+ *                   response buffers from a shared pool, and accordingly
+ *                   we're less flexible when choosing the response message
+ *                   size in this case
  * @def: set if this transport should be considered the default
  * @create: member function to create a new connection on this transport
  * @close: member function to discard a connection on this transport
@@ -38,6 +42,7 @@ struct p9_trans_module {
 	struct list_head list;
 	char *name;		/* name of transport */
 	int maxsize;		/* max message size of transport */
+	bool pooled_rbuffers;
 	int def;		/* this transport should be default */
 	struct module *owner;
 	int (*create)(struct p9_client *client,
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8f8f95e39b03..eecbb5332bea 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1081,6 +1081,7 @@ p9_fd_create(struct p9_client *client, const char *addr, char *args)
 static struct p9_trans_module p9_tcp_trans = {
 	.name = "tcp",
 	.maxsize = MAX_SOCK_BUF,
+	.pooled_rbuffers = false,
 	.def = 0,
 	.create = p9_fd_create_tcp,
 	.close = p9_fd_close,
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 88e563826674..24f287baee70 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -739,6 +739,7 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 static struct p9_trans_module p9_rdma_trans = {
 	.name = "rdma",
 	.maxsize = P9_RDMA_MAXSIZE,
+	.pooled_rbuffers = true,
 	.def = 0,
 	.owner = THIS_MODULE,
 	.create = rdma_create_trans,
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 52d00cb3c105..d47b28b3f02a 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -1011,6 +1011,7 @@ static struct p9_trans_module p9_virtio_trans = {
 	 */
 	.maxsize = PAGE_SIZE *
 		((VIRTQUEUE_SG_NSGL_DEFAULT * SG_USER_PAGES_PER_LIST) - 3),
+	.pooled_rbuffers = false,
 	.def = 1,
 	.owner = THIS_MODULE,
 };
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 833cd3792c51..3434a080abfa 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -246,6 +246,7 @@ static irqreturn_t xen_9pfs_front_event_handler(int irq, void *r)
 static struct p9_trans_module p9_xen_trans = {
 	.name = "xen",
 	.maxsize = 1 << (XEN_9PFS_RING_ORDER + XEN_PAGE_SHIFT - 2),
+	.pooled_rbuffers = false,
 	.def = 1,
 	.create = p9_xen_create,
 	.close = p9_xen_close,
-- 
2.30.2

