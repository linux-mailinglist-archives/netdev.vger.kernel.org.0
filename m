Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FA464ADB7
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiLMChH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiLMCgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:36:51 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49FD1DA75
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:20 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 84-20020a630257000000b00477f88d334eso8763620pgc.11
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d8hcKXQLNNQ4WAgQXpWd59iukIOCYOBUZwXa1y2qCeI=;
        b=X02gtD4dAC/yQa/roDaEjtKXDqiYXTGbbQzFNXNkEXDcU0XIjrnb7WBa5AcE/ls0K4
         wrl7BBUJ/9dpHFLA/zg+IGS9i2Y//8UE/UHzYgEh7z0cCMdX/vTMKkds7ihxeu0nxF1A
         4Hyl758h2etOysY52RCSpNjHy5yslAJMdQSSqR47wDnNxpAW/vXu9uC5CIYrRu58JTn2
         7SkCx7KVmusAbCGB6ZIInjrw7Lqk3z/Mq9/GbZBsHPXE1b7mCVC9WcWZMMyiG8nL6zsX
         k6xNL2utwZHIQv1FUs+bCqjA1LheiGrrIqwl3xiKOMFBtvEpuImE9aGIudpD8Tb5RVcJ
         xe6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d8hcKXQLNNQ4WAgQXpWd59iukIOCYOBUZwXa1y2qCeI=;
        b=MOVOTJ8oDxKej2NyoYwHOFghDUqI+9XUdYotqTeVtJ77wMWvkIiMxPjgMh8QQK0R8M
         St5rZ1VznrpuprManIRBUpmZcc6QnMsEzd5Jvi8Y6hDv8XXU4dpb62EYIcLyut1Rgfxf
         8pQWBYvL21dopNnSH+G9n8uaU4Faj8yTHqqE5LiQeN+eWlWdSMsZaloYQulw/hR0SXTA
         irFACFD448oyhSmtAJ/3CZu8zzh/HTaQgpvvycZObMw4cyJZDmD1Li4DyWm5VNuF3NhR
         PVDQGULoc3Oj4VCiSuYKanBXwXxHQkORT5YoruQ4qFub0OxRIzuysYKgU/FEeEF8hBHW
         ZF3Q==
X-Gm-Message-State: ANoB5pn9ED+JaQ1jUDGj/8MXQ/8TYQVSAS8bZb0+1/YekDRy3Twp0qbm
        hiKHzuakcOTh0rZsd3+F8RzTNJw=
X-Google-Smtp-Source: AA0mqf6//DJzqTv5zHLOXNZ5ezU8ozVCcxgYuAbglp754hLu10S9H7MxyeauJF2EIfRBCIOMJi7vVvQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:d358:b0:20d:d531:97cc with SMTP id
 i24-20020a17090ad35800b0020dd53197ccmr107286pjx.164.1670898980424; Mon, 12
 Dec 2022 18:36:20 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:35:58 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-9-sdf@google.com>
Subject: [PATCH bpf-next v4 08/15] veth: Support RX XDP metadata
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
 drivers/net/veth.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 04ffd8cb2945..d5491e7a2798 100644
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
@@ -1601,6 +1604,21 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
+{
+	*timestamp = ktime_get_mono_fast_ns();
+	return 0;
+}
+
+static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
+{
+	struct veth_xdp_buff *_ctx = (void *)ctx;
+
+	if (_ctx->skb)
+		*hash = skb_get_hash(_ctx->skb);
+	return 0;
+}
+
 static const struct net_device_ops veth_netdev_ops = {
 	.ndo_init            = veth_dev_init,
 	.ndo_open            = veth_open,
@@ -1622,6 +1640,11 @@ static const struct net_device_ops veth_netdev_ops = {
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
@@ -1638,6 +1661,7 @@ static void veth_setup(struct net_device *dev)
 	dev->priv_flags |= IFF_PHONY_HEADROOM;
 
 	dev->netdev_ops = &veth_netdev_ops;
+	dev->xdp_metadata_ops = &veth_xdp_metadata_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
 	dev->features |= NETIF_F_LLTX;
 	dev->features |= VETH_FEATURES;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

