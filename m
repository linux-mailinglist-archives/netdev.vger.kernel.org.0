Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C1363C87C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbiK2Tf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbiK2TfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:35:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9BB30579
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:35:01 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id f4-20020a17090a700400b0021925293dcfso6542758pjk.8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wPmPkc5zN4giDUb/1je/PGUtX+no8JSv+Kak++hjwtw=;
        b=MNY8BvZ09pHzqv0MGpyAb2uDcgHShpvSuC9lTAmNeh1Fs963q9LxEASSeJ71yjwa8k
         F+C15Q+WAe+R50x9nXYu8STSpM/n4LPeF71xU0f60rx5ac7QBwYYW5T5WJ9OQmw+INFu
         tMuV2+14BrTrpuT76neAOrMuRurHqFOPXezTw8s8ND91WrURg4pjUCsOpU8XrdgAA65Q
         gkE7lBJfxIUC++xnvLi2dboa2aruzMrURfzV+hrmoVoCBZ8JutLps+CiKdLSbre6BgVt
         7jc3i4/F6WeWXlcA/6KcylDI55gm3Ap8yrfPjblwFsB+HizGNkHmvRkneYZyrmzVoDtE
         isDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wPmPkc5zN4giDUb/1je/PGUtX+no8JSv+Kak++hjwtw=;
        b=w69JZnNasi/NMDeyBqG2tZ+cFAvvLfOTF09djGVFtvggYsvlpbweYn66GWNJz6RWOS
         n7OeGZz8UVq9tsMjUIDxCFeAe4tUL9XGgQG1gLdTYRxX3bnC68+HaFY9sVUjOxWRMZwp
         14NSGkKtWvS8wAiDdY6jDxonT/991D9fHxngLEmgI3gnA6/pGNsnHI/vXF4Moo3hkE8/
         yhxk39BeHbfB6LbktfcbJ2ikkG2VKm/F23KpZS7fwJ9Myos0qSu9ws7Ce5aD9PhVX8oY
         yKqz16qHCiXg17UUzz2eJsZQobQlLW2rw39jWGy/V92iFZnaSZkV0CHvjcLjRRp3m48S
         Nw7g==
X-Gm-Message-State: ANoB5pnZwM9i6tc3CufcZLntbX3eTaXrWV+E9Qmxn296YXXoJDLh+SaB
        OztXDQ3kJTI8Ee085iqQb4OJpHw=
X-Google-Smtp-Source: AA0mqf7hDYXc10wDSV6aDgnImYUx4Ev4XgaVuwQ0D8DNXI8+yJt2K8vAMnUY2g5A2FXR24jzrU+iAxg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:cf0e:b0:186:6723:9217 with SMTP id
 i14-20020a170902cf0e00b0018667239217mr38917968plg.160.1669750500886; Tue, 29
 Nov 2022 11:35:00 -0800 (PST)
Date:   Tue, 29 Nov 2022 11:34:45 -0800
In-Reply-To: <20221129193452.3448944-1-sdf@google.com>
Mime-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129193452.3448944-5-sdf@google.com>
Subject: [PATCH bpf-next v3 04/11] veth: Support RX XDP metadata
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

