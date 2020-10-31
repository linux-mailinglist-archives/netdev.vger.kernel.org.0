Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3C82A1988
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJaS1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:27:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgJaS1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:27:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYvan-004XVY-A9; Sat, 31 Oct 2020 19:27:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: 9p: Fix kerneldoc warnings of missing parameters etc
Date:   Sat, 31 Oct 2020 19:26:55 +0100
Message-Id: <20201031182655.1082065-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/9p/client.c:420: warning: Function parameter or member 'c' not described in 'p9_client_cb'
net/9p/client.c:420: warning: Function parameter or member 'req' not described in 'p9_client_cb'
net/9p/client.c:420: warning: Function parameter or member 'status' not described in 'p9_client_cb'
net/9p/client.c:568: warning: Function parameter or member 'uidata' not described in 'p9_check_zc_errors'
net/9p/trans_common.c:23: warning: Function parameter or member 'nr_pages' not described in 'p9_release_pages'
net/9p/trans_common.c:23: warning: Function parameter or member 'pages' not described in 'p9_release_pages'
net/9p/trans_fd.c:132: warning: Function parameter or member 'rreq' not described in 'p9_conn'
net/9p/trans_fd.c:132: warning: Function parameter or member 'wreq' not described in 'p9_conn'
net/9p/trans_fd.c:56: warning: Function parameter or member 'privport' not described in 'p9_fd_opts'
net/9p/trans_rdma.c:113: warning: Function parameter or member 'cqe' not described in 'p9_rdma_context'
net/9p/trans_rdma.c:129: warning: Function parameter or member 'privport' not described in 'p9_rdma_opts'
net/9p/trans_virtio.c:215: warning: Function parameter or member 'limit' not described in 'pack_sg_list_p'
net/9p/trans_virtio.c:83: warning: Function parameter or member 'chan_list' not described in 'virtio_chan'
net/9p/trans_virtio.c:83: warning: Function parameter or member 'p9_max_pages' not described in 'virtio_chan'
net/9p/trans_virtio.c:83: warning: Function parameter or member 'ring_bufs_avail' not described in 'virtio_chan'
net/9p/trans_virtio.c:83: warning: Function parameter or member 'tag' not described in 'virtio_chan'
net/9p/trans_virtio.c:83: warning: Function parameter or member 'vc_wq' not described in 'virtio_chan'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/9p/client.c       | 6 ++++--
 net/9p/trans_common.c | 4 +++-
 net/9p/trans_fd.c     | 4 +++-
 net/9p/trans_rdma.c   | 2 ++
 net/9p/trans_virtio.c | 9 +++++++--
 5 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 09f1ec589b80..785a7bb6a539 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -412,8 +412,9 @@ static void p9_tag_cleanup(struct p9_client *c)
 
 /**
  * p9_client_cb - call back from transport to client
- * c: client state
- * req: request received
+ * @c: client state
+ * @req: request received
+ * @status: request status, one of REQ_STATUS_*
  *
  */
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
@@ -555,6 +556,7 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
  * p9_check_zc_errors - check 9p packet for error return and process it
  * @c: current client instance
  * @req: request to parse and check for error conditions
+ * @uidata: external buffer containing error
  * @in_hdrlen: Size of response protocol buffer.
  *
  * returns error code if one is discovered, otherwise returns 0
diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index 3dff68f05fb9..6ea5ea548cd4 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -17,7 +17,9 @@
 #include "trans_common.h"
 
 /**
- *  p9_release_pages - Release pages after the transaction.
+ * p9_release_pages - Release pages after the transaction.
+ * @pages: array of pages to be put
+ * @nr_pages: size of array
  */
 void p9_release_pages(struct page **pages, int nr_pages)
 {
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8f528e783a6c..fa158397bb63 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -45,7 +45,7 @@ static struct p9_trans_module p9_fd_trans;
  * @rfd: file descriptor for reading (trans=fd)
  * @wfd: file descriptor for writing (trans=fd)
  * @port: port to connect to (trans=tcp)
- *
+ * @privport: port is privileged
  */
 
 struct p9_fd_opts {
@@ -95,6 +95,8 @@ struct p9_poll_wait {
  * @err: error state
  * @req_list: accounting for requests which have been sent
  * @unsent_req_list: accounting for requests that haven't been sent
+ * @rreq: read request
+ * @wreq: write request
  * @req: current request being processed (if any)
  * @tmp_buf: temporary buffer to read in header
  * @rc: temporary fcall for reading current frame
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 2885ff9c76f0..af0a8a6cd3fd 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -99,6 +99,7 @@ struct p9_rdma_req;
 /**
  * struct p9_rdma_context - Keeps track of in-process WR
  *
+ * @cqe: completion queue entry
  * @busa: Bus address to unmap when the WR completes
  * @req: Keeps track of requests (send)
  * @rc: Keepts track of replies (receive)
@@ -115,6 +116,7 @@ struct p9_rdma_context {
 /**
  * struct p9_rdma_opts - Collection of mount options
  * @port: port of connection
+ * @privport: Whether a privileged port may be used
  * @sq_depth: The requested depth of the SQ. This really doesn't need
  * to be any deeper than the number of threads used in the client
  * @rq_depth: The depth of the RQ. Should be greater than or equal to SQ depth
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index a3cd90a74012..93f2f8654882 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -50,7 +50,11 @@ static atomic_t vp_pinned = ATOMIC_INIT(0);
  * @client: client instance
  * @vdev: virtio dev associated with this channel
  * @vq: virtio queue associated with this channel
+ * @ring_bufs_avail: flag to indicate there is some available in the ring buf
+ * @vc_wq: wait queue for waiting for thing to be added to ring buf
+ * @p9_max_pages: maximum number of pinned pages
  * @sg: scatter gather list which is used to pack a request (protected?)
+ * @chan_list: linked list of channels
  *
  * We keep all per-channel information in a structure.
  * This structure is allocated within the devices dev->mem space.
@@ -74,8 +78,8 @@ struct virtio_chan {
 	unsigned long p9_max_pages;
 	/* Scatterlist: can be too big for stack. */
 	struct scatterlist sg[VIRTQUEUE_NUM];
-	/*
-	 * tag name to identify a mount null terminated
+	/**
+	 * @tag: name to identify a mount null terminated
 	 */
 	char *tag;
 
@@ -204,6 +208,7 @@ static int p9_virtio_cancelled(struct p9_client *client, struct p9_req_t *req)
  * this takes a list of pages.
  * @sg: scatter/gather list to pack into
  * @start: which segment of the sg_list to start at
+ * @limit: maximum number of pages in sg list.
  * @pdata: a list of pages to add into sg.
  * @nr_pages: number of pages to pack into the scatter/gather list
  * @offs: amount of data in the beginning of first page _not_ to pack
-- 
2.28.0

