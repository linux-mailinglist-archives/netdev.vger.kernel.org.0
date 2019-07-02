Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DC15D1DA
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfGBOgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:36:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48784 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfGBOgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:36:43 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190702143641euoutp02ef6f245b2f7ed3f4e83cb33a2d6b910c~tndkX_TyF3141331413euoutp02C
        for <netdev@vger.kernel.org>; Tue,  2 Jul 2019 14:36:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190702143641euoutp02ef6f245b2f7ed3f4e83cb33a2d6b910c~tndkX_TyF3141331413euoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1562078201;
        bh=YpYeNN1TGrFuWCqAhHcyDXrmBcZYv/UR2QixBnssc+c=;
        h=From:To:Cc:Subject:Date:References:From;
        b=M646SgWvZI+Gj4wTaEWTJXxgIrNgPC6JKN9ULmoStBNXpeGDEP45F9jLdTcE+Shbc
         nIUKseswnEV7HlbxVteq0G0J5kMzyBsiZ2ry7rINs2q4l8yh2sFmoXnZMcN/QYlXIA
         IiEOsb0VWMAijQDKnxOikQMLuePESx3I4RK6r36I=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190702143640eucas1p1b36fab77634a29a67c0049134b7a1fa8~tndjpX6V20113701137eucas1p1p;
        Tue,  2 Jul 2019 14:36:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 79.DF.04298.8FB6B1D5; Tue,  2
        Jul 2019 15:36:40 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad~tndi5rEEt0918309183eucas1p2q;
        Tue,  2 Jul 2019 14:36:39 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190702143639eusmtrp25f7ebb722c15cdac9546ec9befeb0038~tndirgQTU0560205602eusmtrp2Q;
        Tue,  2 Jul 2019 14:36:39 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-5b-5d1b6bf8759a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 03.F1.04140.7FB6B1D5; Tue,  2
        Jul 2019 15:36:39 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190702143638eusmtip246513031767f2b789b4d1c8b3cd4f41e~tndh6eUtk1070710707eusmtip24;
        Tue,  2 Jul 2019 14:36:38 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] xdp: fix race on generic receive path
Date:   Tue,  2 Jul 2019 17:36:34 +0300
Message-Id: <20190702143634.19688-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSa0hTcRT3vzvvruLiNjVPW1mu+qCVJkTdtNLI4OKHEAIrddTMi5pu2q4z
        zQ+pDLMZ5qMaqaRl4ZMSGfPRQ11DLcF8EQ4RFaNmYpEzcc00t6v07XfO73HO+fMnMFG5q5hI
        VmYwKqU8VYq78w29tsHDKykS2RHzsJhask0IqNWCFkRZTX04Vft0GaOqPmn41Ngdm4DqtWhw
        qvPlY4wa7azCqXpj/0avZgfVdv8dCveg9Q1mHt1RMSmga9/M8Wjt+AhGtzbexWld0QxGF+sb
        EW1t9Y0iYtxPJjCpyZmMKuj0Vfek9eHL6cveWVNLlXgumt2uRW4EkEdhPm+Zp0XuhIisRzD5
        4pGAK5YQzE/OuHKFFcFQvoW3ZSkr7UEcUYfgz1gFnytWEHR8sPMdKpw8BB+bTMiBvUgx/Gpv
        c+ZiZDcGr/ueYFpEEJ5kCOQOgUPDJw/AVHm5Uy8kQyHvvQbnpu2BppZuzOEFskgA+a2TuMML
        ZATMai5wGk/43qcXcHgXrHdUb256G6Y0c4jzFiLQGdc2iTDQzw8KHDkY6Q+vOoO4yDPw820k
        B7fB+ILzibANWGbQYVxbCIUFIi5jP9h76jAOi8H8w7q5AA0W+7DzEBEpg8/mPLwE+Vb8H1WD
        UCPyYdSsIpFhg5XMzUBWrmDVysTAa2mKVrTxVQbW+hbb0e+ReCMiCST1ENZESWQiV3kmm60w
        IiAwqZewq36nTCRMkGffYlRpV1TqVIY1IgnBl/oIc1ymY0VkojyDSWGYdEa1xfIIN3Eugv7a
        Sv8Yt/C5dFPEpeC9dnXI6LflMMz/mCR698GvC1ZF1+DxYrFuoXRldeDeCX1skfZZstVbKZXs
        KycWBc02WZxOG9ZrM/TPxV3MPjuWHP2wmt9843n39QejAXHzkQOmc1nTEq+JU+tsQE68xcem
        TrC7NBhC/vp9CS0hzjf4Sflskjw4AFOx8n9fnHy6JgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xe7rfs6VjDf5sV7P48vM2u8Wftg2M
        Fp+PHGezWLzwG7PFnPMtLBZX2n+yWxx70cJmsWvdTGaLy7vmsFmsOHQCKLZAzGJ7/z5GBx6P
        LStvMnnsnHWX3WPxnpdMHl03LjF7bFrVyeYxvfshs0ffllWMHp83yQVwROnZFOWXlqQqZOQX
        l9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehl/L8YWfBNtOL+l9lsDYyP
        BbsYOTkkBEwkJk08yNjFyMUhJLCUUWLlg/eMEAkpiR+/LrBC2MISf651sUEUfWOUmNa0G6yI
        TUBH4tTqI2C2CFDDxx3b2UGKmAVOMEt8n/WZqYuRg0NYwEqi4YIESA2LgKrE/cmTwep5Bawl
        Gg+3sEEskJdYveEA8wRGngWMDKsYRVJLi3PTc4uN9IoTc4tL89L1kvNzNzECA3rbsZ9bdjB2
        vQs+xCjAwajEw+vhJx0rxJpYVlyZe4hRgoNZSYR3/wrJWCHelMTKqtSi/Pii0pzU4kOMpkDL
        JzJLiSbnA6MtryTe0NTQ3MLS0NzY3NjMQkmct0PgYIyQQHpiSWp2ampBahFMHxMHp1QD485V
        lodOMC6/Xcww48atuM57M/mOHFks5V+/6MH0XDFpq0bGhEMdR4p8UntVC+6v1zU/Wlwj5CLw
        6q4801c9txtuDyf8CIq6pc7AG7OD02L/J5tPks92/bzxtO6u/h47CUmHLNell752Pnreepg/
        P8x00iupiEWi/d6s8z5adG/Nfup7IfigrBJLcUaioRZzUXEiAMJy8L9+AgAA
X-CMS-MailID: 20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike driver mode, generic xdp receive could be triggered
by different threads on different CPU cores at the same time
leading to the fill and rx queue breakage. For example, this
could happen while sending packets from two processes to the
first interface of veth pair while the second part of it is
open with AF_XDP socket.

Need to take a lock for each generic receive to avoid race.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 include/net/xdp_sock.h |  2 ++
 net/xdp/xsk.c          | 32 +++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d60f8a..ac3c047d058c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -67,6 +67,8 @@ struct xdp_sock {
 	 * in the SKB destructor callback.
 	 */
 	spinlock_t tx_completion_lock;
+	/* Protects generic receive. */
+	spinlock_t rx_lock;
 	u64 rx_dropped;
 };
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..19f41d2b670c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	u32 metalen = xdp->data - xdp->data_meta;
 	u32 len = xdp->data_end - xdp->data;
+	unsigned long flags;
 	void *buffer;
 	u64 addr;
 	int err;
 
-	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
-		return -EINVAL;
+	spin_lock_irqsave(&xs->rx_lock, flags);
+
+	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 
 	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
 	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
-		xs->rx_dropped++;
-		return -ENOSPC;
+		err = -ENOSPC;
+		goto out_drop;
 	}
 
 	addr += xs->umem->headroom;
@@ -138,13 +143,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	memcpy(buffer, xdp->data_meta, len + metalen);
 	addr += metalen;
 	err = xskq_produce_batch_desc(xs->rx, addr, len);
-	if (!err) {
-		xskq_discard_addr(xs->umem->fq);
-		xsk_flush(xs);
-		return 0;
-	}
+	if (err)
+		goto out_drop;
+
+	xskq_discard_addr(xs->umem->fq);
+	xskq_produce_flush_desc(xs->rx);
 
+	spin_unlock_irqrestore(&xs->rx_lock, flags);
+
+	xs->sk.sk_data_ready(&xs->sk);
+	return 0;
+
+out_drop:
 	xs->rx_dropped++;
+out_unlock:
+	spin_unlock_irqrestore(&xs->rx_lock, flags);
 	return err;
 }
 
@@ -765,6 +778,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 
 	xs = xdp_sk(sk);
 	mutex_init(&xs->mutex);
+	spin_lock_init(&xs->rx_lock);
 	spin_lock_init(&xs->tx_completion_lock);
 
 	mutex_lock(&net->xdp.lock);
-- 
2.17.1

