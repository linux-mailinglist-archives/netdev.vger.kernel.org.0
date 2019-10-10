Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C53D309D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfJJSoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfJJSoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 14:44:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 188EE30832EA;
        Thu, 10 Oct 2019 18:44:06 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-138.brq.redhat.com [10.40.204.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 828815D784;
        Thu, 10 Oct 2019 18:44:04 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 1/2] net: avoid errors when trying to pop MLPS header on non-MPLS packets
Date:   Thu, 10 Oct 2019 20:43:52 +0200
Message-Id: <9343e3ce8aed5d0e109ab0805fb452e8f55f0130.1570732834.git.dcaratti@redhat.com>
In-Reply-To: <cover.1570732834.git.dcaratti@redhat.com>
References: <cover.1570732834.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 10 Oct 2019 18:44:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following script:

 # tc qdisc add dev eth0 clsact
 # tc filter add dev eth0 egress matchall action mpls pop

implicitly makes the kernel drop all packets transmitted by eth0, if they
don't have a MPLS header. This behavior is uncommon: other encapsulations
(like VLAN) just let the packet pass unmodified. Since the result of MPLS
'pop' operation would be the same regardless of the presence / absence of
MPLS header(s) in the original packet, we can let skb_mpls_pop() return 0
when dealing with non-MPLS packets.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 529133611ea2..cd59ccd6da57 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5536,7 +5536,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
 	int err;
 
 	if (unlikely(!eth_p_mpls(skb->protocol)))
-		return -EINVAL;
+		return 0;
 
 	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
 	if (unlikely(err))
-- 
2.21.0

