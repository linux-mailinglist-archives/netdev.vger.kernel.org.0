Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87B333241D
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhCILcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:32:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230399AbhCILcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:32:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615289527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cf0QMVa+tzpe3b3+8CoGD2oHk5WObOuzjL75R7Y/Sow=;
        b=eCIZceVL5PLZ1S1qJYqI8wJcwNIRfmQXGJnoUAvpnEdocJnw0raRdRoqiPg42giBhaqpgp
        iE1dZ3e4eoPY4+qdv6sGpsMk7FA6ku7hOuervHvbgRkEzREzuyG2im69nItgrQNuon4Ms7
        A+6RnsDpBUUdc2JmDalnimtfvTS6SxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-be4yljztPlytGZMQC_CBkA-1; Tue, 09 Mar 2021 06:32:04 -0500
X-MC-Unique: be4yljztPlytGZMQC_CBkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ED20801503;
        Tue,  9 Mar 2021 11:32:03 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-115-104.ams2.redhat.com [10.36.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 381B06062F;
        Tue,  9 Mar 2021 11:32:01 +0000 (UTC)
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        dsahern@gmail.com, davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org, bnemeth@redhat.com
Subject: [PATCH net v3 2/2] net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0
Date:   Tue,  9 Mar 2021 12:31:01 +0100
Message-Id: <9b79f43d2dfec8b2cb8e896b5591e7b1c3cc1f6c.1615288658.git.bnemeth@redhat.com>
In-Reply-To: <cover.1615288658.git.bnemeth@redhat.com>
References: <cover.1615288658.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A packet with skb_inner_network_header(skb) == skb_network_header(skb)
and ETH_P_MPLS_UC will prevent mpls_gso_segment from pulling any headers
from the packet. Subsequently, the call to skb_mac_gso_segment will
again call mpls_gso_segment with the same packet leading to an infinite
loop. In addition, ensure that the header length is a multiple of four,
which should hold irrespective of the number of stacked labels.

Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
---
 net/mpls/mpls_gso.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index b1690149b6fa..1482259de9b5 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -14,6 +14,7 @@
 #include <linux/netdev_features.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <net/mpls.h>
 
 static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
@@ -27,6 +28,8 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 
 	skb_reset_network_header(skb);
 	mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
+	if (unlikely(!mpls_hlen || mpls_hlen % MPLS_HLEN))
+		goto out;
 	if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
 		goto out;
 
-- 
2.29.2

