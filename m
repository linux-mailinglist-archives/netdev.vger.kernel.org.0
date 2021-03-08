Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFAF330B47
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 11:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhCHKcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 05:32:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231573AbhCHKcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 05:32:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615199541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zcy5xcdGGN35eazC/lO+is09Xlo672aYbcHfkf4+zRk=;
        b=KfZPvGqWp67HgHWHJDEROfpHcEELDXa5NVEOSYbWuYrI/w9vU47UWFHnd3tcIVoRblZbcM
        5Ib4dXCX/jtdBfqxfT5RoGNiiNzUJfK1X7a+TK1o1T8MaazdJs1VodsfTJd51UlykYYjNk
        vdRYp2w3sFCRu5t/xGJxRr4K1A5qJOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-EYHkyZTlP6StQW-80_eghw-1; Mon, 08 Mar 2021 05:32:19 -0500
X-MC-Unique: EYHkyZTlP6StQW-80_eghw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3611A8015AD;
        Mon,  8 Mar 2021 10:32:18 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-113-99.ams2.redhat.com [10.36.113.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F31F7094A;
        Mon,  8 Mar 2021 10:32:15 +0000 (UTC)
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org, bnemeth@redhat.com
Subject: [PATCH v2 1/2] net: check if protocol extracted by virtio_net_hdr_set_proto is correct
Date:   Mon,  8 Mar 2021 11:31:25 +0100
Message-Id: <8f2cb8f8614d86bba02df73c1a0665179583f1c3.1615199056.git.bnemeth@redhat.com>
In-Reply-To: <cover.1615199056.git.bnemeth@redhat.com>
References: <cover.1615199056.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
set) based on the type in the virtio net hdr, but the skb could contain
anything since it could come from packet_snd through a raw socket. If
there is a mismatch between what virtio_net_hdr_set_proto sets and
the actual protocol, then the skb could be handled incorrectly later
on.

An example where this poses an issue is with the subsequent call to
skb_flow_dissect_flow_keys_basic which relies on skb->protocol being set
correctly. A specially crafted packet could fool
skb_flow_dissect_flow_keys_basic preventing EINVAL to be returned.

Avoid blindly trusting the information provided by the virtio net header
by checking that the protocol in the packet actually matches the
protocol set by virtio_net_hdr_set_proto. Note that since the protocol
is only checked if skb->dev implements header_ops->parse_protocol,
packets from devices without the implementation are not checked at this
stage.

Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
---
 include/linux/virtio_net.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index e8a924eeea3d..6c478eee0452 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -79,8 +79,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		if (gso_type && skb->network_header) {
 			struct flow_keys_basic keys;
 
-			if (!skb->protocol)
+			if (!skb->protocol) {
+				const struct ethhdr *eth = skb_eth_hdr(skb);
+				__be16 etype = dev_parse_header_protocol(skb);
+
 				virtio_net_hdr_set_proto(skb, hdr);
+				if (etype && etype != skb->protocol)
+					return -EINVAL;
+			}
 retry:
 			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
 							      NULL, 0, 0, 0,
-- 
2.29.2

