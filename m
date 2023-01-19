Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1EE674627
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjASWdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjASWcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:32:19 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE3CAED81
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:54 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id e184-20020a6369c1000000b0049de6cfcc40so1613791pgc.19
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O4z5qqP9Nc43B4/q9Us09feHQoYXdne8/ZU78zUUv/E=;
        b=Gxkq+aPmZ6VT2Y+myeBNNDHGkkGoAjqQnka1V7KXkM24URID6HeXTt8+9fKOVDkFDE
         9hyr9kM9juZu75USVw51eU82QkXJojMOkTbp2bHQQ3eFrFKXy78e2VEboes0/xrnlrol
         kt/i2zwh1uu0kSRZtK0ZYY5uN3gMXpCk99QrU7R2PuuyxkKnak60WfFeYaCB1/kf+yop
         7PiBEyIqeT6T1ZsqleMmAQZ/Z4MYFIfdyTwUOqHtI0HXBoXrbpyISMIU95Y2b/mIqYFS
         l+DPAQ/AYgB92UGjK2c4YJpkwCUvExLrBvhN7LoagkD/5Uz49VcmJIx+dg1Ni3OzljHz
         7mHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4z5qqP9Nc43B4/q9Us09feHQoYXdne8/ZU78zUUv/E=;
        b=f7cfGs+pMD40n063p/6JNV1u4jbyQjF0a1sPGRVbMWMAS5YRxIDt2m9LDTNvEbnXtn
         zGESJTy1B+VtwN5bG+9WaA5RPPmXV7pNOZhipUZw871S4yEBLVjFfWM5N7r+WEQw9jOT
         VdGplEQT+6xTXQ+BI6S3GoamGG8Xo4Z35g03pENMEBPf/JkqzrHP4vkkvptnN4Fm1/3D
         qd06qQGiknJ3X4TaMZdwHCgVq3uRVchE52t56fuat03mT5Qc2/CiFiA5Bg6HLiFWwBAt
         XFugVAPlSx6PC/Frjv3rixyb0nieBdcIIbnJgxScumg1zp3sq1xeb4lu+G7txqhAkByC
         FdDg==
X-Gm-Message-State: AFqh2krfd/FN5+AL9y9cNJBbRkK1jiTyk3uGtHN5085Jahqiw1ur6RaG
        BN3lrzVjF7bZmcyqKkRvWAr7IMA=
X-Google-Smtp-Source: AMrXdXsq0q8gRYbt4JJAhH2hkItAAS5HD1LSimCJwKkOen4jnvx0GARn2Ot8pJzMwdxJlvQKEjehNdk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:f518:b0:227:208f:65f with SMTP id
 cs24-20020a17090af51800b00227208f065fmr1232212pjb.32.1674166553613; Thu, 19
 Jan 2023 14:15:53 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:15:28 -0800
In-Reply-To: <20230119221536.3349901-1-sdf@google.com>
Mime-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119221536.3349901-10-sdf@google.com>
Subject: [PATCH bpf-next v8 09/17] veth: Introduce veth_xdp_buff wrapper for xdp_buff
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional changes. Boilerplate to allow stuffing more data after xdp_buff.

Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/veth.c | 56 +++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index dfc7d87fad59..70f50602287a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -116,6 +116,10 @@ static struct {
 	{ "peer_ifindex" },
 };
 
+struct veth_xdp_buff {
+	struct xdp_buff xdp;
+};
+
 static int veth_get_link_ksettings(struct net_device *dev,
 				   struct ethtool_link_ksettings *cmd)
 {
@@ -592,23 +596,24 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (likely(xdp_prog)) {
-		struct xdp_buff xdp;
+		struct veth_xdp_buff vxbuf;
+		struct xdp_buff *xdp = &vxbuf.xdp;
 		u32 act;
 
-		xdp_convert_frame_to_buff(frame, &xdp);
-		xdp.rxq = &rq->xdp_rxq;
+		xdp_convert_frame_to_buff(frame, xdp);
+		xdp->rxq = &rq->xdp_rxq;
 
-		act = bpf_prog_run_xdp(xdp_prog, &xdp);
+		act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 		switch (act) {
 		case XDP_PASS:
-			if (xdp_update_frame_from_buff(&xdp, frame))
+			if (xdp_update_frame_from_buff(xdp, frame))
 				goto err_xdp;
 			break;
 		case XDP_TX:
 			orig_frame = *frame;
-			xdp.rxq->mem = frame->mem;
-			if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
+			xdp->rxq->mem = frame->mem;
+			if (unlikely(veth_xdp_tx(rq, xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
 				frame = &orig_frame;
 				stats->rx_drops++;
@@ -619,8 +624,8 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 			goto xdp_xmit;
 		case XDP_REDIRECT:
 			orig_frame = *frame;
-			xdp.rxq->mem = frame->mem;
-			if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
+			xdp->rxq->mem = frame->mem;
+			if (xdp_do_redirect(rq->dev, xdp, xdp_prog)) {
 				frame = &orig_frame;
 				stats->rx_drops++;
 				goto err_xdp;
@@ -801,7 +806,8 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 {
 	void *orig_data, *orig_data_end;
 	struct bpf_prog *xdp_prog;
-	struct xdp_buff xdp;
+	struct veth_xdp_buff vxbuf;
+	struct xdp_buff *xdp = &vxbuf.xdp;
 	u32 act, metalen;
 	int off;
 
@@ -815,22 +821,22 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	}
 
 	__skb_push(skb, skb->data - skb_mac_header(skb));
-	if (veth_convert_skb_to_xdp_buff(rq, &xdp, &skb))
+	if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
 		goto drop;
 
-	orig_data = xdp.data;
-	orig_data_end = xdp.data_end;
+	orig_data = xdp->data;
+	orig_data_end = xdp->data_end;
 
-	act = bpf_prog_run_xdp(xdp_prog, &xdp);
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	switch (act) {
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		veth_xdp_get(&xdp);
+		veth_xdp_get(xdp);
 		consume_skb(skb);
-		xdp.rxq->mem = rq->xdp_mem;
-		if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
+		xdp->rxq->mem = rq->xdp_mem;
+		if (unlikely(veth_xdp_tx(rq, xdp, bq) < 0)) {
 			trace_xdp_exception(rq->dev, xdp_prog, act);
 			stats->rx_drops++;
 			goto err_xdp;
@@ -839,10 +845,10 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		rcu_read_unlock();
 		goto xdp_xmit;
 	case XDP_REDIRECT:
-		veth_xdp_get(&xdp);
+		veth_xdp_get(xdp);
 		consume_skb(skb);
-		xdp.rxq->mem = rq->xdp_mem;
-		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
+		xdp->rxq->mem = rq->xdp_mem;
+		if (xdp_do_redirect(rq->dev, xdp, xdp_prog)) {
 			stats->rx_drops++;
 			goto err_xdp;
 		}
@@ -862,7 +868,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	rcu_read_unlock();
 
 	/* check if bpf_xdp_adjust_head was used */
-	off = orig_data - xdp.data;
+	off = orig_data - xdp->data;
 	if (off > 0)
 		__skb_push(skb, off);
 	else if (off < 0)
@@ -871,21 +877,21 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	skb_reset_mac_header(skb);
 
 	/* check if bpf_xdp_adjust_tail was used */
-	off = xdp.data_end - orig_data_end;
+	off = xdp->data_end - orig_data_end;
 	if (off != 0)
 		__skb_put(skb, off); /* positive on grow, negative on shrink */
 
 	/* XDP frag metadata (e.g. nr_frags) are updated in eBPF helpers
 	 * (e.g. bpf_xdp_adjust_tail), we need to update data_len here.
 	 */
-	if (xdp_buff_has_frags(&xdp))
+	if (xdp_buff_has_frags(xdp))
 		skb->data_len = skb_shinfo(skb)->xdp_frags_size;
 	else
 		skb->data_len = 0;
 
 	skb->protocol = eth_type_trans(skb, rq->dev);
 
-	metalen = xdp.data - xdp.data_meta;
+	metalen = xdp->data - xdp->data_meta;
 	if (metalen)
 		skb_metadata_set(skb, metalen);
 out:
@@ -898,7 +904,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	return NULL;
 err_xdp:
 	rcu_read_unlock();
-	xdp_return_buff(&xdp);
+	xdp_return_buff(xdp);
 xdp_xmit:
 	return NULL;
 }
-- 
2.39.0.246.g2a6d74b583-goog

