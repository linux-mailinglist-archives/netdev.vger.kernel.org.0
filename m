Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B60F33241A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCILcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:32:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230391AbhCILcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615289524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JLtjyaNx7txhs1Vm8nCVq1O+TkZawPukZciG8bRkP4=;
        b=V+VBVbEFlD8mHIzNufDvFxUOOw9alivmxgFTxusJiPd90Y5GV0rvRLhYCazlYIjgL52sM8
        orPcjK1+jHuDpbcdkPoh2fYYJEROovZX4gjmYnNHzfmAkBN6uXa8HbXmuYk1CTj5K7vjLv
        d8LS++B7lnkPoxVl2Jwb88+Xd3U4x6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-TlcjiSazPJKbseQBygacSQ-1; Tue, 09 Mar 2021 06:32:03 -0500
X-MC-Unique: TlcjiSazPJKbseQBygacSQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2307801989;
        Tue,  9 Mar 2021 11:32:00 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-115-104.ams2.redhat.com [10.36.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C7C15B4A9;
        Tue,  9 Mar 2021 11:31:58 +0000 (UTC)
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        dsahern@gmail.com, davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org, bnemeth@redhat.com
Subject: [PATCH net v3 1/2] net: check if protocol extracted by virtio_net_hdr_set_proto is correct
Date:   Tue,  9 Mar 2021 12:31:00 +0100
Message-Id: <b07e88b0d023fd7c6f5bbee27ae1cb33e52b9546.1615288658.git.bnemeth@redhat.com>
In-Reply-To: <cover.1615288658.git.bnemeth@redhat.com>
References: <cover.1615288658.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 include/linux/virtio_net.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index e8a924eeea3d..6b5fcfa1e555 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -79,8 +79,13 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		if (gso_type && skb->network_header) {
 			struct flow_keys_basic keys;
 
-			if (!skb->protocol)
+			if (!skb->protocol) {
+				__be16 protocol = dev_parse_header_protocol(skb);
+
 				virtio_net_hdr_set_proto(skb, hdr);
+				if (protocol && protocol != skb->protocol)
+					return -EINVAL;
+			}
 retry:
 			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
 							      NULL, 0, 0, 0,
-- 
2.29.2

