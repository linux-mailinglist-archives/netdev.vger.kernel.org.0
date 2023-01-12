Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD36667B4
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbjALAd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjALAcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:32:50 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279F73C702
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:47 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id d10-20020a631d4a000000b00491da16dc44so7384802pgm.16
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9HiOxp6nL9rgfcG8VeROEZk1Js7SkRS/8tPXwFvw4So=;
        b=A9C7eRdNNdoSIEq7Tb6NgSTf4CVXC0HggBc9nmQBbeyp850aePbYk0xU21ybKMRQJn
         acTbCT7u8egaeZ8jcSiJEHQdFYonfqf3j/ycJAuFRVD6NyzyM2p31NLtoULYXZYYp9t8
         Fse6m2TcgxDR+aSaIEiqZPlZ35BdjTejjq2TX8Hyd00CjEnVZpGy4MgCCaPsb1LprGnW
         E0Rfk+HWL8AYmpKcnjV/X5DO0eBO7UekZGtWYip+gKt3FjKCWFsdCJFZd5SHzAp+bsvV
         avwzjuRtt9sRgZzLEgcXUtqXSOWmh6a5638y0DQl8NlInLCqMtPX7HIU+wH574SoVORA
         g04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HiOxp6nL9rgfcG8VeROEZk1Js7SkRS/8tPXwFvw4So=;
        b=KRv0nBl0l5SR9tEkY2stsiT3PJPIuQmFEh/7qQFijAZWiGEQYAmU6fMvatLiV5aBMD
         OLvai17vuIfrdGETVfpCK2frq6Kmmz9B6bPsuBQaO5d/kP0r/P2rK9aBWo7Og2KvBS2n
         nHg8NitoE+1ThYlPPit4SulPJhtJxpIoxOUSJRuGnbbxoRnkzj25ZjburQ0A0Q4e6q4A
         9pDaSaRxHgNiEfUMiR/eCv/W+3Ls+9geE1GWuta6STZMrMxo7VDMMYQvn/oWRKxsqWk/
         JZgFZ1qgr9/nrXbLSwFMmsJ9qINAdw+LZjkmNAZhG7SaBHWRtQMiiStp4amBATZsfV1l
         d7Hw==
X-Gm-Message-State: AFqh2kq6LM1F0p0YKYAtqeomGNfOzlMWmvPSgiIMLZsHbBES+ppcDDu6
        1WHSEF9xezdHyHhXiYSALU5cchM=
X-Google-Smtp-Source: AMrXdXup6/c3QY5KhbQwFC+yex18VAChiAKmxvBrcMvCVaOHtQ6VOW/gWFZszbiF4YLCNlB3HuQ6Gsk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1254:b0:583:402e:b5d8 with SMTP id
 u20-20020a056a00125400b00583402eb5d8mr2249864pfi.58.1673483566861; Wed, 11
 Jan 2023 16:32:46 -0800 (PST)
Date:   Wed, 11 Jan 2023 16:32:22 -0800
In-Reply-To: <20230112003230.3779451-1-sdf@google.com>
Mime-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230112003230.3779451-10-sdf@google.com>
Subject: [PATCH bpf-next v7 09/17] veth: Introduce veth_xdp_buff wrapper for xdp_buff
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
2.39.0.314.g84b9a713c41-goog

