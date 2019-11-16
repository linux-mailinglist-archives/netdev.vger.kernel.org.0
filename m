Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07BE6FEE4C
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbfKPPuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbfKPPuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:37 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BA0C21826;
        Sat, 16 Nov 2019 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919437;
        bh=J8nLv1zzZihBjk9Qf7MzVMFSXvKTV4N1SPSE8aD/4sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4oN34CRscBUNuzo+SWpGe5qJh/A8oNkWrK8nzZpTkgVNz6X9fiGTZyqiamHSgbCx
         N+vpzCKiDVKPmLozJle2BObN2u4g4hFk/JZhYQGNvJdvLlk+4lX05LEG69B/79Fu9F
         3/4qYKzAlOP+1DsTIPbPXLyTYhjykvhHWH/U4KZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Manning <mmanning@vyatta.att-mail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 136/150] vrf: mark skb for multicast or link-local as enslaved to VRF
Date:   Sat, 16 Nov 2019 10:47:14 -0500
Message-Id: <20191116154729.9573-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Manning <mmanning@vyatta.att-mail.com>

[ Upstream commit 6f12fa775530195a501fb090d092c637f32d0cc5 ]

The skb for packets that are multicast or to a link-local address are
not marked as being enslaved to a VRF, if they are received on a socket
bound to the VRF. This is needed for ND and it is preferable for the
kernel not to have to deal with the additional use-cases if ll or mcast
packets are handled as enslaved. However, this does not allow service
instances listening on unbound and bound to VRF sockets to distinguish
the VRF used, if packets are sent as multicast or to a link-local
address. The fix is for the VRF driver to also mark these skb as being
enslaved to the VRF.

Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 03e4fcdfeab73..e0cea5c05f0e2 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -996,24 +996,23 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 				   struct sk_buff *skb)
 {
 	int orig_iif = skb->skb_iif;
-	bool need_strict;
+	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
+	bool is_ndisc = ipv6_ndisc_frame(skb);
 
-	/* loopback traffic; do not push through packet taps again.
-	 * Reset pkt_type for upper layers to process skb
+	/* loopback, multicast & non-ND link-local traffic; do not push through
+	 * packet taps again. Reset pkt_type for upper layers to process skb
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK) {
+	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
-		skb->pkt_type = PACKET_HOST;
+		if (skb->pkt_type == PACKET_LOOPBACK)
+			skb->pkt_type = PACKET_HOST;
 		goto out;
 	}
 
-	/* if packet is NDISC or addressed to multicast or link-local
-	 * then keep the ingress interface
-	 */
-	need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
-	if (!ipv6_ndisc_frame(skb) && !need_strict) {
+	/* if packet is NDISC then keep the ingress interface */
+	if (!is_ndisc) {
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
-- 
2.20.1

