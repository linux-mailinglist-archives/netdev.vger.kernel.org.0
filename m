Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD89031ED62
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhBRRdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:33:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231401AbhBRPD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 10:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613660494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=96TuIx8B9Sg12x8R4gtF94r3wYssraiv2dr3ZsuIF9U=;
        b=euPEXhFTD8bf3GzU4plmcvoFGB068ByXbFWrvi3iBVq1Bu3yQB4/6hFwKGQBlJY+1vHobh
        zGxeLw0+d+aAuiLlT3utUhXtHH0J/leqhCRd9uI3woMCUXZRj+nZVIsrlIfhDV4HI/1H6T
        3KMAbXm8sCYuZhNIxxH1ZdiBqNGssZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-yooqRrcDNXe02Q1acWS98Q-1; Thu, 18 Feb 2021 10:01:32 -0500
X-MC-Unique: yooqRrcDNXe02Q1acWS98Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4225480196C;
        Thu, 18 Feb 2021 15:01:31 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-114-242.ams2.redhat.com [10.36.114.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9035100AE2B;
        Thu, 18 Feb 2021 15:01:25 +0000 (UTC)
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org, bnemeth@redhat.com
Subject: [PATCH] net: check if protocol extracted by virtio_net_hdr_set_proto is correct
Date:   Thu, 18 Feb 2021 15:57:54 +0100
Message-Id: <5e910d11a14da17c41317417fc41d3a9d472c6e7.1613659844.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
set) based on the type in the virtio net hdr, but the skb could contain
anything since it could come from packet_snd through a raw socket. If
there is a mismatch between what virtio_net_hdr_set_proto sets and
the actual protocol, then the skb could be handled incorrectly later
on by gso.

The network header of gso packets starts at 14 bytes, but a specially
crafted packet could fool the call to skb_flow_dissect_flow_keys_basic
as the network header offset in the skb could be incorrect.
Consequently, EINVAL is not returned.

There are even packets that can cause an infinite loop. For example, a
packet with ethernet type ETH_P_MPLS_UC (which is unnoticed by
virtio_net_hdr_to_skb) that is sent to a geneve interface will be
handled by geneve_build_skb. In turn, it calls
udp_tunnel_handle_offloads which then calls skb_reset_inner_headers.
After that, the packet gets passed to mpls_gso_segment. That function
calculates the mpls header length by taking the difference between
network_header and inner_network_header. Since the two are equal
(due to the earlier call to skb_reset_inner_headers), it will calculate
a header of length 0, and it will not pull any headers. Then, it will
call skb_mac_gso_segment which will again call mpls_gso_segment, etc...
This leads to the infinite loop.

For that reason, address the root cause of the issue: don't blindly
trust the information provided by the virtio net header. Instead,
check if the protocol in the packet actually matches the protocol set by
virtio_net_hdr_set_proto.

Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
---
 include/linux/virtio_net.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index e8a924eeea3d..cf2c53563f22 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -79,8 +79,13 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		if (gso_type && skb->network_header) {
 			struct flow_keys_basic keys;
 
-			if (!skb->protocol)
+			if (!skb->protocol) {
+				const struct ethhdr *eth = skb_eth_hdr(skb);
+
 				virtio_net_hdr_set_proto(skb, hdr);
+				if (skb->protocol != eth->h_proto)
+					return -EINVAL;
+			}
 retry:
 			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
 							      NULL, 0, 0, 0,
-- 
2.29.2

