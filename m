Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2740D4F79
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbfJLL5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfJLLza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 07:55:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1DAC18C4268;
        Sat, 12 Oct 2019 11:55:29 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-41.brq.redhat.com [10.40.204.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B89E601A3;
        Sat, 12 Oct 2019 11:55:27 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     lkp@intel.com
Cc:     davem@davemloft.net, dcaratti@redhat.com,
        john.hurley@netronome.com, kbuild-all@01.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net v2 1/2] net: avoid errors when trying to pop MLPS header on non-MPLS packets
Date:   Sat, 12 Oct 2019 13:55:06 +0200
Message-Id: <c5ae8eb218491967eebe0c20ec6c035a794b30be.1570878412.git.dcaratti@redhat.com>
In-Reply-To: <cover.1570878412.git.dcaratti@redhat.com>
References: <cover.1570878412.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Sat, 12 Oct 2019 11:55:29 +0000 (UTC)
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

For the OVS use-case, this is acceptable because __ovs_nla_copy_actions()
already ensures that MPLS 'pop' operation only occurs with packets having
an MPLS Ethernet type (and there are no other callers in current code, so
the semantic change should be ok).

v2: better documentation of use-cases for skb_mpls_pop(), thanks to Simon
    Horman

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: John Hurley <john.hurley@netronome.com>
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

