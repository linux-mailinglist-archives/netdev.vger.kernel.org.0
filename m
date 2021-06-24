Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749F83B2EF0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhFXMdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhFXMc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:32:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB46C061760
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gGZaECOQuaiwn+numAlhP+P5/O9waNNMX3buiX5lvnY=; b=TyilwAzLNJY8NmlbJJpbhaa2wG
        htWpR1HaS/9kimT13H+1s11hni0lPrtgrlIEuW3Q8fb1WrGs8gMrGRXgI8mQ/vB46j7yL4/y7/viL
        OqVf7s7COcTismmD+2tA4dq2vDKU+YviyBc0wo/ZflMje/bW81r9TGzsY9kt4GaBUexIOMyxkjaST
        ut9KTKxm+ickd4VtxLdc9G43mWRr3GgIO1cl92iZdgUWgETEKJAdn8QkJ0dZB648D3/gP0WERoGyK
        6It6vejArXP4hA+Q+rouC4qfoEd9zmH5bSvlkqZwmV1KmXIlfZG0gT1XVqYfLgRIBY4qU1W4Bb1Zj
        iMnu6b4A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUZ-00BEEP-6t; Thu, 24 Jun 2021 12:30:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUf-005Sf5-NC; Thu, 24 Jun 2021 13:30:05 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v3 4/5] net: tun: fix tun_xdp_one() for IFF_TUN mode
Date:   Thu, 24 Jun 2021 13:30:04 +0100
Message-Id: <20210624123005.1301761-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624123005.1301761-1-dwmw2@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In tun_get_user(), skb->protocol is either taken from the tun_pi header
or inferred from the first byte of the packet in IFF_TUN mode, while
eth_type_trans() is called only in the IFF_TAP mode where the payload
is expected to be an Ethernet frame.

The equivalent code path in tun_xdp_one() was unconditionally using
eth_type_trans(), which is the wrong thing to do in IFF_TUN mode and
corrupts packets.

Pull the logic out to a separate tun_skb_set_protocol() function, and
call it from both tun_get_user() and tun_xdp_one().

XX: It is not entirely clear to me why it's OK to call eth_type_trans()
in some cases without first checking that enough of the Ethernet header
is linearly present by calling pskb_may_pull(). Such a check was never
present in the tun_xdp_one() code path, and commit 96aa1b22bd6bb ("tun:
correct header offsets in napi frags mode") deliberately added it *only*
for the IFF_NAPI_FRAGS mode.

I would like to see specific explanations of *why* it's ever valid and
necessary (is it so much faster?) to skip the pskb_may_pull() by setting
the 'no_pull_check' flag to tun_skb_set_protocol(), but for now I'll
settle for faithfully preserving the existing behaviour and pretending
it's someone else's problem.

Cc: Willem de Bruijn <willemb@google.com>
Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/net/tun.c | 95 +++++++++++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 32 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1b553f79adb0..9379fa86fae9 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1641,6 +1641,47 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 	return NULL;
 }
 
+static int tun_skb_set_protocol(struct tun_struct *tun, struct sk_buff *skb,
+				__be16 pi_proto, bool no_pull_check)
+{
+	switch (tun->flags & TUN_TYPE_MASK) {
+	case IFF_TUN:
+		if (tun->flags & IFF_NO_PI) {
+			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
+
+			switch (ip_version) {
+			case 4:
+				pi_proto = htons(ETH_P_IP);
+				break;
+			case 6:
+				pi_proto = htons(ETH_P_IPV6);
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+
+		skb_reset_mac_header(skb);
+		skb->protocol = pi_proto;
+		skb->dev = tun->dev;
+		break;
+	case IFF_TAP:
+		/* As an optimisation, no_pull_check can be set in the cases
+		 * where the caller *knows* that eth_type_trans() will be OK
+		 * because the Ethernet header is linearised at skb->data.
+		 *
+		 * XX: Or so I was reliably assured when I moved this code
+		 * and didn't make it unconditional. dwmw2.
+		 */
+		if (!no_pull_check && !pskb_may_pull(skb, ETH_HLEN))
+			return -ENOMEM;
+
+		skb->protocol = eth_type_trans(skb, tun->dev);
+		break;
+	}
+	return 0;
+}
+
 /* Get packet from user space buffer */
 static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			    void *msg_control, struct iov_iter *from,
@@ -1784,37 +1825,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		return -EINVAL;
 	}
 
-	switch (tun->flags & TUN_TYPE_MASK) {
-	case IFF_TUN:
-		if (tun->flags & IFF_NO_PI) {
-			u8 ip_version = skb->len ? (skb->data[0] >> 4) : 0;
-
-			switch (ip_version) {
-			case 4:
-				pi.proto = htons(ETH_P_IP);
-				break;
-			case 6:
-				pi.proto = htons(ETH_P_IPV6);
-				break;
-			default:
-				atomic_long_inc(&tun->dev->rx_dropped);
-				kfree_skb(skb);
-				return -EINVAL;
-			}
-		}
-
-		skb_reset_mac_header(skb);
-		skb->protocol = pi.proto;
-		skb->dev = tun->dev;
-		break;
-	case IFF_TAP:
-		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
-			err = -ENOMEM;
-			goto drop;
-		}
-		skb->protocol = eth_type_trans(skb, tun->dev);
-		break;
-	}
+	err = tun_skb_set_protocol(tun, skb, pi.proto, !frags);
+	if (err)
+		goto drop;
 
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
@@ -2335,12 +2348,24 @@ static int tun_xdp_one(struct tun_struct *tun,
 	struct virtio_net_hdr *gso = NULL;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
+	__be16 proto = 0;
 	u32 rxhash = 0, act;
 	int buflen = hdr->buflen;
 	int err = 0;
 	bool skb_xdp = false;
 	struct page *page;
 
+	if (!(tun->flags & IFF_NO_PI)) {
+		struct tun_pi *pi = tun_hdr;
+		tun_hdr += sizeof(*pi);
+
+		if (tun_hdr > xdp->data) {
+			atomic_long_inc(&tun->rx_frame_errors);
+			return -EINVAL;
+		}
+		proto = pi->proto;
+	}
+
 	if (tun->flags & IFF_VNET_HDR) {
 		gso = tun_hdr;
 		tun_hdr += sizeof(*gso);
@@ -2413,7 +2438,13 @@ static int tun_xdp_one(struct tun_struct *tun,
 		goto out;
 	}
 
-	skb->protocol = eth_type_trans(skb, tun->dev);
+	err = tun_skb_set_protocol(tun, skb, proto, true);
+	if (err) {
+		atomic_long_inc(&tun->dev->rx_dropped);
+		kfree_skb(skb);
+		goto out;
+	}
+
 	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb);
 	skb_record_rx_queue(skb, tfile->queue_index);
-- 
2.31.1

