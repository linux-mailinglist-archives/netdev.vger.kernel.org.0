Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684183BA604
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 00:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhGBWlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 18:41:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231486AbhGBWlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 18:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625265538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4DVEM1D9jBEhO6OfR2KMm1F4tVrlM/yE8xPKLiVKJm4=;
        b=ie/+HC2HQVcFBjqdBHEUQ489/TvlVU7LXozSxAcYM5pgjDq2Ctj35xHweHg2qXnTAmwBlL
        vXCh1F1dZX+26MBeRzuSXInkK4Y+PT6ChjG45+cMH56q73iQrIjX9JrEbBW6osBJUAboAi
        QKOu4NBEDuF7jymx0pmRUGipOhPQmtc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-80SXevfuOhe8Pz0CFGyJYw-1; Fri, 02 Jul 2021 18:38:57 -0400
X-MC-Unique: 80SXevfuOhe8Pz0CFGyJYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 377268030D7;
        Fri,  2 Jul 2021 22:38:56 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EFE95D740;
        Fri,  2 Jul 2021 22:38:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthias Treydte <mt@waldheinz.de>
Subject: [PATCH net] udp: properly flush normal packet at GRO time
Date:   Sat,  3 Jul 2021 00:38:43 +0200
Message-Id: <dfd058a9a43317713bf075bbbc99b23e7f7d6fc6.1625264879.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an UDP packet enters the GRO engine but is not eligible
for aggregation and is not targeting an UDP tunnel,
udp_gro_receive() will not set the flush bit, and packet
could delayed till the next napi flush.

Fix the issue ensuring non GROed packets traverse
skb_gro_flush_final().

Reported-and-tested-by: Matthias Treydte <mt@waldheinz.de>
Fixes: 18f25dc39990 ("udp: skip L4 aggregation for UDP tunnel packets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/udp_offload.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 7a670757f37a..b3aabc886763 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -551,8 +551,10 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 
 		if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
 		    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
-			pp = call_gro_receive(udp_gro_receive_segment, head, skb);
-		return pp;
+			return call_gro_receive(udp_gro_receive_segment, head, skb);
+
+		/* no GRO, be sure flush the current packet */
+		goto out;
 	}
 
 	if (NAPI_GRO_CB(skb)->encap_mark ||
-- 
2.26.3

