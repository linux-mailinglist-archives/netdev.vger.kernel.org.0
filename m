Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CC3542C00
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 11:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiFHJw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 05:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbiFHJwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 05:52:14 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5137B40FD2F;
        Wed,  8 Jun 2022 02:22:23 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 2589Jjp3001157
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 8 Jun 2022 11:19:45 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Anton Makarov <am@3a-alliance.com>
Subject: [net] net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using flowi_l3mdev
Date:   Wed,  8 Jun 2022 11:19:17 +0200
Message-Id: <20220608091917.20345-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
reset for port devices") adds a new entry (flowi_l3mdev) in the common
flow struct used for indicating the l3mdev index for later rule and
table matching.
The l3mdev_update_flow() has been adapted to properly set the
flowi_l3mdev based on the flowi_oif/flowi_iif. In fact, when a valid
flowi_iif is supplied to the l3mdev_update_flow(), this function can
update the flowi_l3mdev entry only if it has not yet been set (i.e., the
flowi_l3mdev entry is equal to 0).

The SRv6 End.DT6 behavior in VRF mode leverages a VRF device in order to
force the routing lookup into the associated routing table. This routing
operation is performed by seg6_lookup_any_nextop() preparing a flowi6
data structure used by ip6_route_input_lookup() which, in turn,
(indirectly) invokes l3mdev_update_flow().

However, seg6_lookup_any_nexthop() does not initialize the new
flowi_l3mdev entry which is filled with random garbage data. This
prevents l3mdev_update_flow() from properly updating the flowi_l3mdev
with the VRF index, and thus SRv6 End.DT6 (VRF mode)/DT46 behaviors are
broken.

This patch correctly initializes the flowi6 instance allocated and used
by seg6_lookup_any_nexhtop(). Specifically, the entire flowi6 instance
is wiped out: in case new entries are added to flowi/flowi6 (as happened
with the flowi_l3mdev entry), we should no longer have incorrectly
initialized values. As a result of this operation, the value of
flowi_l3mdev is also set to 0.

The proposed fix can be tested easily. Starting from the commit
referenced in the Fixes, selftests [1],[2] indicate that the SRv6
End.DT6 (VRF mode)/DT46 behaviors no longer work correctly. By applying
this patch, those behaviors are back to work properly again.

[1] - tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
[2] - tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Anton Makarov <am@3a-alliance.com>
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 9fbe243a0e81..98a34287439c 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -218,6 +218,7 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 	struct flowi6 fl6;
 	int dev_flags = 0;
 
+	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_iif = skb->dev->ifindex;
 	fl6.daddr = nhaddr ? *nhaddr : hdr->daddr;
 	fl6.saddr = hdr->saddr;
-- 
2.20.1

