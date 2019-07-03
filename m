Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883A35E382
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfGCMJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:09:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41892 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfGCMJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:09:25 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190703120923euoutp02126bb404a6bec4aa3718e24e972fb5d9~t5GPvn4Gc2141521415euoutp023
        for <netdev@vger.kernel.org>; Wed,  3 Jul 2019 12:09:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190703120923euoutp02126bb404a6bec4aa3718e24e972fb5d9~t5GPvn4Gc2141521415euoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1562155763;
        bh=EAaWlzGCbN7kuloDJblzBSkq9mB9Yb8loWEXFJ3x8FI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=sfKBvO91Rk8zEsNoNvXvmUKReQkWWNqQ5dFfL/mHD25v9Y7j0Jdwg9fa3K8kpBVW1
         easiqLv9iCK2S3SiacnFiYA7qV8yQE7duQU9t+0JuOTPnUjvofT6+6dehovlupvqjl
         nOi+VM8LqVdrmSaRerm/WLfFujeFd5eYjA9LEydo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190703120922eucas1p201a9328a62ca5bea1866462f64378890~t5GPB9HYc3132631326eucas1p2l;
        Wed,  3 Jul 2019 12:09:22 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 2D.00.04298.2FA9C1D5; Wed,  3
        Jul 2019 13:09:22 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77~t5GOUX1Ih1247312473eucas1p2L;
        Wed,  3 Jul 2019 12:09:22 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190703120921eusmtrp172fc4f66baa50e60c702a594de8995ac~t5GOAMQZh0630506305eusmtrp1a;
        Wed,  3 Jul 2019 12:09:21 +0000 (GMT)
X-AuditID: cbfec7f2-f13ff700000010ca-71-5d1c9af2960e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id DB.57.04140.1FA9C1D5; Wed,  3
        Jul 2019 13:09:21 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190703120921eusmtip23925ada6b9adf7ce371179cdbfec550d~t5GNS7MlP1386113861eusmtip2a;
        Wed,  3 Jul 2019 12:09:20 +0000 (GMT)
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
Subject: [PATCH bpf v2] xdp: fix race on generic receive path
Date:   Wed,  3 Jul 2019 15:09:16 +0300
Message-Id: <20190703120916.19973-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSW0hTYRzv25lnx+HkNG9f8xINw4rSBB8OZFbkw3mIWFQPlmLHPHhJN9lx
        mgkmat7xsoqVLTUtXTNU5vAapcO0stSckVdaoTG7mU4tUaxtZ9Lb78r/x8eHIUKVkwhLkKbS
        cimVJEb53PaB9eFDy1U+UYctXf7Eyvo0j9jMbwWEpX8QJeofrCGEeiSPS4wXrPOIAXMeSnQ3
        30UIY7caJTSGl1at1pPoKH8GjruQ+seTHLKrapZH1j9d4JDFE2MIqdMWoaSq5BNClum1gLTo
        /CTYBX5oLJ2UkEbLg8Iu8eOrlfWclDyPq6U9o2g2yN1ZDJwxiIfA6gKLUzHgY0JcA6D6TpWD
        rADYPD7CY4kFwO+vlNztyi/jksNoBPC2aZTDkj8ANrR95thSKH4Qvm7qBzbsjovgUmeHvYHg
        vQjsGaxGbIYbfhRW1H6wh7j4Xqh5lGM/IcCPwJq1945zu2FTay9iK0O8nAff1RlR1giH86YZ
        B3aDXwf1PBb7wKGbpY7ydfgxbwGw5UIAVYYtDmscg/pvw9YCZp20H7Z0B7HyCajRtAGbDHFX
        OPHD/kqIFSrbVQgrC2BhvpBN+8ONvkaExSI4+dPiWEDCF7lz9gVCPAp+aZzhVAC/qv+3agHQ
        Ai9awSTH0UywlE4PZKhkRiGNC7wsS9YB63cZ2hpc7gSrYzEGgGNA7CKolXhHCZ2oNCYj2QAg
        hojdBc81u6KEglgq4xotl0XLFUk0YwDeGFfsJcjcYbooxOOoVPoKTafQ8m2XgzmLsoG+xHUt
        MnsidfpWi0+l2VdVlhk+y482JSqyRKVlIEKSDTZbFk8XmU/lyJbeuJw8Jzmz2hAgo1buSbWe
        kqkwl76pzLfhEcZWZbqgjoxJFEcvPvFVV6rP7zvbEVkzT4SGzLXd9/DVibdK8CxJ6MYeU4R5
        z4zsb3dz/u+AG2MhD8VcJp4KPoDIGeof08Y9NSoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xe7ofZ8nEGnx5pGvx5edtdos/bRsY
        LT4fOc5msXjhN2aLOedbWCyutP9ktzj2ooXNYte6mcwWl3fNYbNYcegEUGyBmMX2/n2MDjwe
        W1beZPLYOesuu8fiPS+ZPLpuXGL22LSqk81jevdDZo++LasYPT5vkgvgiNKzKcovLUlVyMgv
        LrFVija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DLmDdpMVNBi2hFz+4LbA2M
        zYJdjJwcEgImEh8uf2TvYuTiEBJYyijxec9adoiElMSPXxdYIWxhiT/Xutggir4xSvROm80M
        kmAT0JE4tfoII4gtAtTwccd2sEnMAieYJb7P+swEkhAWsJWYsOA6WBGLgKrEiqVNLCA2r4C1
        xPxvV1kgNshLrN5wgHkCI88CRoZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgUG97djPLTsY
        u94FH2IU4GBU4uH18JOOFWJNLCuuzD3EKMHBrCTCu3+FZKwQb0piZVVqUX58UWlOavEhRlOg
        5ROZpUST84ERl1cSb2hqaG5haWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgfGg
        sNpV6VVxEy42vpyzqYD5T3zS1etu+zet3Pb07I8s+cJCl3Khx8HRc40lPK6mBH49cqO9jCPP
        Mzk1vPn63Dlx7gZqF1bJTT/1xlH8e8usI8/MmKbtYnyoPqO7ec6bdp7mffMT2pjkjX+kOi1t
        93jJvu6uhc+yc4FnvDcLiaZxRU96znKNNU2JpTgj0VCLuag4EQA7azZxgAIAAA==
X-CMS-MailID: 20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77
References: <CGME20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77@eucas1p2.samsung.com>
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

Version 2:
    * spin_lock_irqsave --> spin_lock_bh.

 include/net/xdp_sock.h |  2 ++
 net/xdp/xsk.c          | 31 ++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 9 deletions(-)

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
index a14e8864e4fa..5e0637db92ea 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -123,13 +123,17 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	u64 addr;
 	int err;
 
-	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
-		return -EINVAL;
+	spin_lock_bh(&xs->rx_lock);
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
@@ -138,13 +142,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
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
 
+	spin_unlock_bh(&xs->rx_lock);
+
+	xs->sk.sk_data_ready(&xs->sk);
+	return 0;
+
+out_drop:
 	xs->rx_dropped++;
+out_unlock:
+	spin_unlock_bh(&xs->rx_lock);
 	return err;
 }
 
@@ -765,6 +777,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 
 	xs = xdp_sk(sk);
 	mutex_init(&xs->mutex);
+	spin_lock_init(&xs->rx_lock);
 	spin_lock_init(&xs->tx_completion_lock);
 
 	mutex_lock(&net->xdp.lock);
-- 
2.17.1

