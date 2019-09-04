Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DBEA8179
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 13:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfIDLtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 07:49:41 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33466 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729741AbfIDLtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 07:49:40 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so8028363pfl.0;
        Wed, 04 Sep 2019 04:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JL4I7qJK1zHSi0GRrPR9nlrsbzmktVefiaQA4nZlrlw=;
        b=nIu6h6KLuq6Z+MtxcgPMv+wPSoUNkbj968x5Y1t3TH2wuTl7VmOLWcvzhZto6lvOhi
         dtOLjtvK4S/NNM6t0Ot6Nv695zGNzeyKDgUJXkjCV7zgVcrJ9gtiIjDPBIOZnPolDcSA
         ZD1OF90ZzifXV8HPFYeqayUIVj4frr7N3MsBSzrGeY6+8BMWL8+nDUIb6OrTAFNZJUwR
         DtaLnJWpybv77sI/Ksa5JqDe4gSEnH33GEzjpZzRnayZYG9cpvXE+zAiA3HoxNA0b/cU
         Wf0mkY1atg0XxIfbtj9EGnkJg+WCDlGn5LIZJDrMdEMhi3JuESW4L79nHPmJZ1Btfx3b
         J1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JL4I7qJK1zHSi0GRrPR9nlrsbzmktVefiaQA4nZlrlw=;
        b=KFPLIlfrAKbkzOI7z6+cF5dHBm89LfNP6zkdXhJr+gBeUIXiu8Vj/t8bngJG8EMZYw
         yCRaaT+h5kfM6SXiNPLUJTmMNNTvXOCbAWnxmXew4vTNUNgZEg7JmYfZXmjMYeR3P45G
         sTV1Vsl/mPzcdvAMnyPewX05vJAkfAOusF6cZv+bqtcH09xLtIPbP9hMcidR0ac3ggUs
         Sun3JONRr8+mpX6aNIxMv0gOmLIDaGIuIHr28tn0S3+/gQgaPfj05F+27UZwRJa41umQ
         /fxFfUEjLs5GBGElcFZoukDxOkVXVdw5WbSUUZVSg4j8In3r8GlQAuJKbCoDbla8O/gO
         l14g==
X-Gm-Message-State: APjAAAX89kvg3IH+Jn978vKGpPcQG1CmZuYTSOdMOkBFN1t7JMYsCKZK
        VfwHPX7i2DJvrU8K/15saTU=
X-Google-Smtp-Source: APXvYqx7DxpIowBefikDeI3MT9xUqQsb/Fyc2npFDukKFRamw9d9Pi/VR+n291Q9z208QdsgkL8vRQ==
X-Received: by 2002:aa7:83d1:: with SMTP id j17mr39346096pfn.35.1567597779950;
        Wed, 04 Sep 2019 04:49:39 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id b126sm48257008pfa.177.2019.09.04.04.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 04:49:39 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v3 3/4] xsk: use state member for socket synchronization
Date:   Wed,  4 Sep 2019 13:49:12 +0200
Message-Id: <20190904114913.17217-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904114913.17217-1-bjorn.topel@gmail.com>
References: <20190904114913.17217-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Prior the state variable was introduced by Ilya, the dev member was
used to determine whether the socket was bound or not. However, when
dev was read, proper SMP barriers and READ_ONCE were missing. In order
to address the missing barriers and READ_ONCE, we start using the
state variable as a point of synchronization. The state member
read/write is paired with proper SMP barriers, and from this follows
that the members described above does not need READ_ONCE if used in
conjunction with state check.

In all syscalls and the xsk_rcv path we check if state is
XSK_BOUND. If that is the case we do a SMP read barrier, and this
implies that the dev, umem and all rings are correctly setup. Note
that no READ_ONCE are needed for these variable if used when state is
XSK_BOUND (plus the read barrier).

To summarize: The members struct xdp_sock members dev, queue_id, umem,
fq, cq, tx, rx, and state were read lock-less, with incorrect barriers
and missing {READ, WRITE}_ONCE. Now, umem, fq, cq, tx, rx, and state
are read lock-less. When these members are updated, WRITE_ONCE is
used. When read, READ_ONCE are only used when read outside the control
mutex (e.g. mmap) or, not synchronized with the state member
(XSK_BOUND plus smp_rmb())

Note that dev and queue_id do not need a WRITE_ONCE or READ_ONCE, due
to the introduce state synchronization (XSK_BOUND plus smp_rmb()).

Introducing the state check also fixes a race, found by syzcaller, in
xsk_poll() where umem could be accessed when stale.

Suggested-by: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 54 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 8c9056f06989..c2f1af3b6a7c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -186,10 +186,23 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	return err;
 }
 
+static bool xsk_is_bound(struct xdp_sock *xs)
+{
+	if (READ_ONCE(xs->state) == XSK_BOUND) {
+		/* Matches smp_wmb() in bind(). */
+		smp_rmb();
+		return true;
+	}
+	return false;
+}
+
 int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	u32 len;
 
+	if (!xsk_is_bound(xs))
+		return -EINVAL;
+
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
@@ -387,7 +400,7 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 
-	if (unlikely(!xs->dev))
+	if (unlikely(!xsk_is_bound(xs)))
 		return -ENXIO;
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
 		return -ENETDOWN;
@@ -403,10 +416,15 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
 	unsigned int mask = datagram_poll(file, sock, wait);
-	struct sock *sk = sock->sk;
-	struct xdp_sock *xs = xdp_sk(sk);
-	struct net_device *dev = xs->dev;
-	struct xdp_umem *umem = xs->umem;
+	struct xdp_sock *xs = xdp_sk(sock->sk);
+	struct net_device *dev;
+	struct xdp_umem *umem;
+
+	if (unlikely(!xsk_is_bound(xs)))
+		return mask;
+
+	dev = xs->dev;
+	umem = xs->umem;
 
 	if (umem->need_wakeup)
 		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
@@ -442,10 +460,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 {
 	struct net_device *dev = xs->dev;
 
-	if (!dev || xs->state != XSK_BOUND)
+	if (xs->state != XSK_BOUND)
 		return;
-
-	xs->state = XSK_UNBOUND;
+	WRITE_ONCE(xs->state, XSK_UNBOUND);
 
 	/* Wait for driver to stop using the xdp socket. */
 	xdp_del_sk_umem(xs->umem, xs);
@@ -520,7 +537,9 @@ static int xsk_release(struct socket *sock)
 	local_bh_enable();
 
 	xsk_delete_from_maps(xs);
+	mutex_lock(&xs->mutex);
 	xsk_unbind_dev(xs);
+	mutex_unlock(&xs->mutex);
 
 	xskq_destroy(xs->rx);
 	xskq_destroy(xs->tx);
@@ -632,12 +651,12 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		}
 
 		umem_xs = xdp_sk(sock->sk);
-		if (!umem_xs->umem) {
-			/* No umem to inherit. */
+		if (!xsk_is_bound(umem_xs)) {
 			err = -EBADF;
 			sockfd_put(sock);
 			goto out_unlock;
-		} else if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
+		}
+		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
 			err = -EINVAL;
 			sockfd_put(sock);
 			goto out_unlock;
@@ -671,10 +690,15 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xdp_add_sk_umem(xs->umem, xs);
 
 out_unlock:
-	if (err)
+	if (err) {
 		dev_put(dev);
-	else
-		xs->state = XSK_BOUND;
+	} else {
+		/* Matches smp_rmb() in bind() for shared umem
+		 * sockets, and xsk_is_bound().
+		 */
+		smp_wmb();
+		WRITE_ONCE(xs->state, XSK_BOUND);
+	}
 out_release:
 	mutex_unlock(&xs->mutex);
 	rtnl_unlock();
@@ -927,7 +951,7 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	unsigned long pfn;
 	struct page *qpg;
 
-	if (xs->state != XSK_READY)
+	if (READ_ONCE(xs->state) != XSK_READY)
 		return -EBUSY;
 
 	if (offset == XDP_PGOFF_RX_RING) {
-- 
2.20.1

