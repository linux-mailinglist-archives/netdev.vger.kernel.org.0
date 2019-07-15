Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4C69401
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404618AbfGOOsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732749AbfGOOsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:48:41 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D242067C;
        Mon, 15 Jul 2019 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563202120;
        bh=OTWwnrkCMDKcr0hVMwbDlU6k6COSOlAGByKRjTcrQw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ow/IARIc389hWKe4+l3XLtv1nmd0pFtMSqTOwlQuOZQ5dLQQVyXzbFTUb/Wi1tmyx
         tGKhrO95gekjHbblf5hDY4CVa7cv9SF023hgxmiqJIRPWyk9J2xrD1PRTHnZJKE+9o
         rZqji4w1cuvRjlbNY83ssuy/sMyg+Stp/sIxQ/0E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josua Mayer <josua.mayer@jm0.eu>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Michael Scott <mike@foundries.io>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 51/53] Bluetooth: 6lowpan: search for destination address in all peers
Date:   Mon, 15 Jul 2019 10:45:33 -0400
Message-Id: <20190715144535.11636-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua.mayer@jm0.eu>

[ Upstream commit b188b03270b7f8568fc714101ce82fbf5e811c5a ]

Handle overlooked case where the target address is assigned to a peer
and neither route nor gateway exist.

For one peer, no checks are performed to see if it is meant to receive
packets for a given address.

As soon as there is a second peer however, checks are performed
to deal with routes and gateways for handling complex setups with
multiple hops to a target address.
This logic assumed that no route and no gateway imply that the
destination address can not be reached, which is false in case of a
direct peer.

Acked-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Tested-by: Michael Scott <mike@foundries.io>
Signed-off-by: Josua Mayer <josua.mayer@jm0.eu>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 795ddd8b2f77..4cd6b8d811ff 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -184,10 +184,16 @@ static inline struct lowpan_peer *peer_lookup_dst(struct lowpan_dev *dev,
 	}
 
 	if (!rt) {
-		nexthop = &lowpan_cb(skb)->gw;
-
-		if (ipv6_addr_any(nexthop))
-			return NULL;
+		if (ipv6_addr_any(&lowpan_cb(skb)->gw)) {
+			/* There is neither route nor gateway,
+			 * probably the destination is a direct peer.
+			 */
+			nexthop = daddr;
+		} else {
+			/* There is a known gateway
+			 */
+			nexthop = &lowpan_cb(skb)->gw;
+		}
 	} else {
 		nexthop = rt6_nexthop(rt, daddr);
 
-- 
2.20.1

