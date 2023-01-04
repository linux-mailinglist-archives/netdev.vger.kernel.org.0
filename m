Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A8F65DF7A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240541AbjADWAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240207AbjADWAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 17:00:22 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA8541010
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 14:00:07 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id k21-20020aa78215000000b00575ab46ca2cso16590510pfi.20
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 14:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=42wm0a27iiQaqPiSJuj7splEpSMGU4ZjOPqnU9s94do=;
        b=k3XKm53A73H1G14794cQS0avTc3XA8JX/GFT1FuxQcPckDyDbGIPKIi0ocagThsLFI
         EADZVMRcvk8uy+x4BKC8JxrdS3rsiRfeChoYT+epRNG1YwT8z/2d4C9bLg6iEw81J5AT
         4XyO+DCp11XUEUIUiHanIVXWTc9OA81Gh3e4Cdgixt6UXKj6BCRNAFA5Rtxj3frdLWfm
         qy8vIjazU+FIKShNAbUSveDlmrdgMOtkWzwD3MLaKR5A5ewxrM6TeIwMzjOgarEDPK23
         H/Pq7sTY4cvtMMN6vOGu4+nYsymB6sPaZ2GM/7Bpev4obdtbNTd8cvunscN/0KWupn0h
         4kgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42wm0a27iiQaqPiSJuj7splEpSMGU4ZjOPqnU9s94do=;
        b=MZLgOoEmGl+MS65lNV0pN4anXHH17iyBfugwKAZXWC5kut16c8eY8L6CyyDnaUuhAm
         tMwMH5eVL3w4/wVLt7Ia7iBcEUb82fBaA831QuFpcuHfd2gAjyf5mvP03DQ13XN/ZUjS
         iJkzbeA3W1qv7W3eGgjeQhUKL9uyRWqZYwRmzYAbSpfU+CLjH3XjgNyrxIwoTT+AvZod
         MAy1m9ywN6/tQhBbjON+cGu/4x8DjtIx101d6b+6TaVnGI5xsz0V27hCPAKarjkhZOCs
         lfn4wyQeUQtKgBMX9ceLeDlSe2viynkG79XOBcJKwn5wlBIkRNzMUfelvgs6gXoRfiFs
         u73Q==
X-Gm-Message-State: AFqh2kpsTYxikRXbXNr5zh1bBc5iUyinCUGuThvjG7wn0XcTqvJ2MEEb
        zEsYGdPYp8Fi4Dm+hh/8toDTitI=
X-Google-Smtp-Source: AMrXdXt0cCRdNR5czKiU3+Ddrl7ukwPVKOG/rhsNk7JkIChwoVeTSXzpIFM5VOImyPn3XROgS9wwNvI=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:6081:b0:226:659c:c5b2 with SMTP id
 z1-20020a17090a608100b00226659cc5b2mr1351234pji.238.1672869607075; Wed, 04
 Jan 2023 14:00:07 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:42 -0800
In-Reply-To: <20230104215949.529093-1-sdf@google.com>
Mime-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-11-sdf@google.com>
Subject: [PATCH bpf-next v6 10/17] veth: Support RX XDP metadata
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
 drivers/net/veth.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 04ffd8cb2945..71966de4e942 100644
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
@@ -1601,6 +1604,28 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
+{
+	struct veth_xdp_buff *_ctx = (void *)ctx;
+
+	if (!_ctx->skb)
+		return -EOPNOTSUPP;
+
+	*timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
+	return 0;
+}
+
+static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
+{
+	struct veth_xdp_buff *_ctx = (void *)ctx;
+
+	if (!_ctx->skb)
+		return -EOPNOTSUPP;
+
+	*hash = skb_get_hash(_ctx->skb);
+	return 0;
+}
+
 static const struct net_device_ops veth_netdev_ops = {
 	.ndo_init            = veth_dev_init,
 	.ndo_open            = veth_open,
@@ -1622,6 +1647,11 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_get_peer_dev	= veth_peer_dev,
 };
 
+static const struct xdp_metadata_ops veth_xdp_metadata_ops = {
+	.xmo_rx_timestamp		= veth_xdp_rx_timestamp,
+	.xmo_rx_hash			= veth_xdp_rx_hash,
+};
+
 #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
 		       NETIF_F_RXCSUM | NETIF_F_SCTP_CRC | NETIF_F_HIGHDMA | \
 		       NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL | \
@@ -1638,6 +1668,7 @@ static void veth_setup(struct net_device *dev)
 	dev->priv_flags |= IFF_PHONY_HEADROOM;
 
 	dev->netdev_ops = &veth_netdev_ops;
+	dev->xdp_metadata_ops = &veth_xdp_metadata_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
 	dev->features |= NETIF_F_LLTX;
 	dev->features |= VETH_FEATURES;
-- 
2.39.0.314.g84b9a713c41-goog

