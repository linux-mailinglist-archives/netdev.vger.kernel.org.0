Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37A12CD30B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgLCJ5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:57:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgLCJ5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606989378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ROUni+5+hlmN9xcuEOCW71LsD1ILUUmE4H/6ndhm9LY=;
        b=Me0NGRA0Aa+FI7bNC9iLD2sCr7WsqaxchYTY3Myyvz5O/6t7DREo7BSG7JgkGZhVga8q/t
        b4TLzoL+zn4W+ORSZtyDKA8df0SQ3A7DiumaeSLjV2sePRS2yE1GVCjo9fdBrp+lJb4ZPj
        LflpUYWGRkT6N7YbeuAPXHBOpvGo65A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-8267N-g4NoePsxM1QS2dJQ-1; Thu, 03 Dec 2020 04:56:14 -0500
X-MC-Unique: 8267N-g4NoePsxM1QS2dJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CE458558E7;
        Thu,  3 Dec 2020 09:56:12 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1373419C48;
        Thu,  3 Dec 2020 09:56:10 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        John Hurley <john.hurley@netronome.com>
Cc:     gnault@redhat.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net] net: openvswitch: ensure LSE is pullable before reading it
Date:   Thu,  3 Dec 2020 10:46:06 +0100
Message-Id: <aa099f245d93218b84b5c056b67b6058ccf81a66.1606987185.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when openvswitch is configured to mangle the LSE, the current value is
read from the packet dereferencing 4 bytes at mpls_hdr(): ensure that
the label is contained in the skb "linear" area.

Found by code inspection.

Fixes: d27cf5c59a12 ("net: core: add MPLS update core helper and use in OvS")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/openvswitch/actions.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 5829a020b81c..c3a664871cb5 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -199,6 +199,9 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be32 lse;
 	int err;
 
+	if (!pskb_may_pull(skb, skb_network_offset(skb) + MPLS_HLEN))
+		return -ENOMEM;
+
 	stack = mpls_hdr(skb);
 	lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
 	err = skb_mpls_update_lse(skb, lse);
-- 
2.28.0

