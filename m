Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D50643B75
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiLFCqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiLFCqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:46:25 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDF6252B2
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:46:05 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id z4-20020a17090ab10400b002195a146546so18158405pjq.9
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SzXogjIzoRMtGz3qf2OXFTX6uh6o2Pg0lmLXO515upU=;
        b=fE3/mCQDWTHc0cieBS6LWbwMD2MaY4GiFErL7T7VZ6K81vosuugj2NU/GpHtiJxs6y
         SgXd5y2wZfNfpF39ZosNx8XBsJX/XjeYlNI2dArNBzsCADJ2rWiMsRXHLiEOgodGNeOp
         vYJAE6BlyrkNJhZpcJtvUWlPbp73s+FTzyWMD7WEkKX6FzB5SLCRpshAhT2JqEYH2j+Y
         PKK9ZKbI/CJLZ664AK+Ar6liYAT/2OKSlmAxCgtUUoKJYseXn2GnfpJB2gRs41RJA1eJ
         mTZIVmk+weDwBkFd0hzSMWiFyXM7oKMVDS3oTUmuPvdYZbQ0TMrbzW16vciZGxOrNh8p
         NsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzXogjIzoRMtGz3qf2OXFTX6uh6o2Pg0lmLXO515upU=;
        b=Z55a66PjseiomR/a9Pm4kaVzIVXxXK4DvhpC4eGgZiAZow3VE4gRpRpxfurrnYh4pI
         gFoI6QsXGi8e/f0PHZcW+SmFaY0Zfs2DJoS4GSVg+eOkBFOKVSu0/iBAIwFR9yjp1BNP
         s6M2MwavifTM307/HAOvf1EzE5TLCYFuUZwOo1Xct3KdR7LkR3pnNqEzCSq1CpXIjhKN
         OJt0MiAPX8b8q8ee5V96vxsFNF7rusCOmF1QcxFWPwIB95ZoxTmjaT1wCFRcTPyIGelS
         E00KdtrIlauJ4nBj6QZD3ap3IrKmyrj80MPhs70uN3oNCabn52naiizzCJZ2BzlQj0rG
         inHw==
X-Gm-Message-State: ANoB5pnhw5uVRrTJfG233jpX+WlQdVrIDIwCt0mI+GKA5dfEvBE1WmFf
        efg2ylQBMp4uMFLVPZ5Npe/YVzM=
X-Google-Smtp-Source: AA0mqf5p0oPGMegJ4tB/4oONpYIL3mMpGTuIbSrRWseQ31uO04j4I0O78cVXjTtPKiGmLD3jGFDXhpY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:f89:b0:219:5b3b:2b9f with SMTP id
 ft9-20020a17090b0f8900b002195b3b2b9fmr3170949pjb.2.1670294764176; Mon, 05 Dec
 2022 18:46:04 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:47 -0800
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
Mime-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-6-sdf@google.com>
Subject: [PATCH bpf-next v3 05/12] veth: Support RX XDP metadata
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
index 04ffd8cb2945..d15302672493 100644
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
@@ -1601,6 +1604,30 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
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
@@ -1620,6 +1647,11 @@ static const struct net_device_ops veth_netdev_ops = {
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
2.39.0.rc0.267.gcb52ba06e7-goog

