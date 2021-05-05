Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554CB373EA7
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhEEPhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 11:37:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233452AbhEEPhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 11:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620228977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YvdbRSXKsl8EcPxFehFnLQSd8UpCqfqK+GUz+J8sAXY=;
        b=fVryZplKwS+5docWhG94YaASvP2LuXxgRvvVozCIhVbKHYR0/hN2djYMOEHw/sK7baRhCO
        JJj8Cr4xpr2dUapXVQiM4Hw2VTp/ScRgcrFtUw9+IFYcyDXpEJOmQyjDPV2IggRQVTA0/D
        9leWRvq0orMRCeIpCEO4R0Cxr5hbL+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-RbHIzzb1NyW_vZtDVdgy0w-1; Wed, 05 May 2021 11:36:15 -0400
X-MC-Unique: RbHIzzb1NyW_vZtDVdgy0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4CBA107ACCD;
        Wed,  5 May 2021 15:36:13 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-175.ams2.redhat.com [10.36.113.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3305D5C1A3;
        Wed,  5 May 2021 15:36:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH net 3/4] udp: fix outer header csum for SKB_GSO_FRAGLIST over UDP tunnel
Date:   Wed,  5 May 2021 17:35:03 +0200
Message-Id: <82e982530f74f7b736071f041918c22919b734d8.1620223174.git.pabeni@redhat.com>
In-Reply-To: <cover.1620223174.git.pabeni@redhat.com>
References: <cover.1620223174.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following scenario:

    GRO -> SKB_GSO_FRAGLIST aggregation -> forward ->
      xmit over UDP tunnel

SKB_GSO_FRAGLIST packet traverse an UDP tunnel in the xmit path.
The tunnel code sets up the outer header csum via udp_set_csum()
and the latter assumes that each GSO packet is CHECKSUM_PARTIAL.

Since the introduction of SKB_GSO_FRAGLIST and veth GRO, the above
assumption is not true anymore as SKB_GSO_FRAGLIST are
CHECKSUM_UNNECESSARY, and the csum for the outer header will be
left uninitialized.

All the above will cause wrong outer UDP header checksum when the
mentioned packet will be xmitted on some real NIC.

This change addresses the issue explicitly checking for both gso and
CHECKSUM_PARTIAL in udp_set_csum(), so that the mentioned packet will
be processed correctly.

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..055fceb18bea 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -857,7 +857,7 @@ void udp_set_csum(bool nocheck, struct sk_buff *skb,
 
 	if (nocheck) {
 		uh->check = 0;
-	} else if (skb_is_gso(skb)) {
+	} else if (skb_is_gso(skb) && skb->ip_summed == CHECKSUM_PARTIAL) {
 		uh->check = ~udp_v4_check(len, saddr, daddr, 0);
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		uh->check = 0;
-- 
2.26.2

