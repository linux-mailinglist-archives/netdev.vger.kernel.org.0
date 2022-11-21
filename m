Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85498632C0F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiKUS0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiKUS0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:26:02 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EB4CFEB8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:26:01 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-368994f4bc0so120311247b3.14
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 10:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wPmPkc5zN4giDUb/1je/PGUtX+no8JSv+Kak++hjwtw=;
        b=nGfSDe2DYoxrfRJM92Demm7pOqfd7RPX22MBlXes4IY7HfiP5o0gVQa4NY18BS7O3V
         ijUK8jdXFdYCL01B3H5kIIo9vRVZ8bvATKG4HhZAEp28q0uOFHHbgjfPTY1agIOjyQJy
         CiUwKVBs92/QDd48/cZYuDFWrUCVsBkCfYXQLatyNh56Bps4QCp+83aXOaEq4CLrf+1q
         FpFx+jw3f5Hxrgn/yLI9tKsF1+Dw4lWFkEcBvCaJKW50nrqHN2PuBKfIopRRoKLak24J
         qCC6r2WODR39cXj0X8pj0gkBrSR+A/KeplR8T90XKvkqVxycIHUna7tm/9z9gQhxaRVN
         2Kaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wPmPkc5zN4giDUb/1je/PGUtX+no8JSv+Kak++hjwtw=;
        b=rb/lIUfmNlelAvLH1GE1xaTTxiEtgxsWryuq0PMe74d/5Gx0v4Vu7pyOJs1rrXU6nY
         9ukC4jUJOISSwqJ4vIkGux4kqpzFx+kiSLYsS4Rhzx0jtjTx8g4mY8LM0wXD6BeOh3pH
         fBWLF1ILJqFfb/zpSXen8G8wYEhEI3jkOerRbAJ9WbrsMIBe/M2HYtE2QTAVG6mzkOQW
         A/IOf0qsMTSrnH30Oj3BvxV5OxBgUjrtuawfEJBPtZsu9qNcNK0RN9bYiZ2Z0fhcdf+u
         MpqJZ016g2EHQGlrDoQK+lnphMF+00TDEqJJW/slYMf48UI4GzV4xaxib2QEbsBZk2ld
         qFbg==
X-Gm-Message-State: ANoB5pmR/1EPvCoBID2jTlXMxZbuCOOgUEM70FTNqRBSaAzvd5LOQL85
        2vTGY/JkDWjyOdteAl2FwpRgqB4=
X-Google-Smtp-Source: AA0mqf7Zvrdzts6EXSee4UxjaQCvfRToP6ufXZ+7H0SjWmKi3dLmD4QUHbSFIPNlx2zeDuusPo3f0KU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:2355:0:b0:6dd:c522:e3ba with SMTP id
 j82-20020a252355000000b006ddc522e3bamr18834148ybj.8.1669055160955; Mon, 21
 Nov 2022 10:26:00 -0800 (PST)
Date:   Mon, 21 Nov 2022 10:25:48 -0800
In-Reply-To: <20221121182552.2152891-1-sdf@google.com>
Mime-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221121182552.2152891-5-sdf@google.com>
Subject: [PATCH bpf-next v2 4/8] veth: Support RX XDP metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
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

The goal is to enable end-to-end testing of the metadata for AF_XDP.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
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
 drivers/net/veth.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bbabc592d431..fdbca2aee33a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -118,6 +118,7 @@ static struct {
 
 struct veth_xdp_buff {
 	struct xdp_buff xdp;
+	struct sk_buff *skb;
 };
 
 static int veth_get_link_ksettings(struct net_device *dev,
@@ -602,6 +603,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 
 		xdp_convert_frame_to_buff(frame, xdp);
 		xdp->rxq = &rq->xdp_rxq;
+		vxbuf.skb = NULL;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 
@@ -823,6 +825,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	__skb_push(skb, skb->data - skb_mac_header(skb));
 	if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
 		goto drop;
+	vxbuf.skb = skb;
 
 	orig_data = xdp->data;
 	orig_data_end = xdp->data_end;
@@ -1665,6 +1668,30 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+static bool veth_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
+{
+	return true;
+}
+
+static u64 veth_xdp_rx_timestamp(const struct xdp_md *ctx)
+{
+	return ktime_get_mono_fast_ns();
+}
+
+static bool veth_xdp_rx_hash_supported(const struct xdp_md *ctx)
+{
+	return true;
+}
+
+static u32 veth_xdp_rx_hash(const struct xdp_md *ctx)
+{
+	struct veth_xdp_buff *_ctx = (void *)ctx;
+
+	if (_ctx->skb)
+		return skb_get_hash(_ctx->skb);
+	return 0;
+}
+
 static const struct net_device_ops veth_netdev_ops = {
 	.ndo_init            = veth_dev_init,
 	.ndo_open            = veth_open,
@@ -1684,6 +1711,11 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_bpf		= veth_xdp,
 	.ndo_xdp_xmit		= veth_ndo_xdp_xmit,
 	.ndo_get_peer_dev	= veth_peer_dev,
+
+	.ndo_xdp_rx_timestamp_supported = veth_xdp_rx_timestamp_supported,
+	.ndo_xdp_rx_timestamp	= veth_xdp_rx_timestamp,
+	.ndo_xdp_rx_hash_supported = veth_xdp_rx_hash_supported,
+	.ndo_xdp_rx_hash	= veth_xdp_rx_hash,
 };
 
 #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
-- 
2.38.1.584.g0f3c55d4c2-goog

