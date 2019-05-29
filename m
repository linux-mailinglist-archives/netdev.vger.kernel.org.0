Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D122DA84
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfE2KZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:25:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40611 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfE2KZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:25:47 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hVvmD-0003j5-I6; Wed, 29 May 2019 10:25:45 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 4/4] ipv6: frags: Use inet_frag_pull_head() in ip6_expire_frag_queue()
Date:   Wed, 29 May 2019 12:25:42 +0200
Message-Id: <20190529102542.17742-5-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529102542.17742-1-stefan.bader@canonical.com>
References: <20190529102542.17742-1-stefan.bader@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With frag code shared between IPv4 and IPv6 it is now possible
to use inet_frag_pull_head() in ip6_expire_frag_queue() in order
to properly extract the first skb from the frags queue.
Since this really takes the skb out of the list, it no longer
needs to be protected against removal (which implicitly fixes
a crash that will happen somewhere in the call to icmp6_send()
when the use count is forcefully checked to be 1.

 kernel BUG at linux-4.4.0/net/core/skbuff.c:1207!
 RIP: 0010:[<ffffffff81740953>]
  [<ffffffff81740953>] pskb_expand_head+0x243/0x250
  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 net/ipv6/reassembly.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 020cf70273c9..2bd45abc2516 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -110,16 +110,14 @@ void ip6_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	IP6_INC_STATS_BH(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
 
 	/* Don't send error if the first segment did not arrive. */
-	head = fq->q.fragments;
-	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
+	if (!(fq->q.flags & INET_FRAG_FIRST_IN))
+		goto out;
+
+	head = inet_frag_pull_head(&fq->q);
+	if (!head)
 		goto out;
 
-	/* But use as source device on which LAST ARRIVED
-	 * segment was received. And do not use fq->dev
-	 * pointer directly, device might already disappeared.
-	 */
 	head->dev = dev;
-	skb_get(head);
 	spin_unlock(&fq->q.lock);
 
 	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
-- 
2.17.1

