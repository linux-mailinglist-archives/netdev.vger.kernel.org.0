Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2941669647D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjBNNUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjBNNUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:20:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FEE2658D;
        Tue, 14 Feb 2023 05:20:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BEB9B81D5D;
        Tue, 14 Feb 2023 13:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3C2C433D2;
        Tue, 14 Feb 2023 13:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676380828;
        bh=QSNzfjDyD1D0CyaWZ5xpZ1cspur47SIVwpCpx1kP5uA=;
        h=From:To:Cc:Subject:Date:From;
        b=i07/HRMlK5b+wFq9NbkvN7kofxmDDRuxlAKgYpYBUfJQQ/J+YJQLBtuNwEPIx1pMF
         ZgLtxJ7dKdwMQ/HJy1agHC80+JbhGbRlUaju2Gidn+u1tIu3sFUzXVjPPobsPyvdst
         RrCL567tF8na20h0ERXDah1QCdb7aC2dZ8Vd7JR8hJs8/2gVijoDq7eXHc54cRuMqV
         JzGCLRQqT10PbUkKvGIjJCpqvZgibV2tPzidZ4HEoHsZkYJt6+IjcMWwfi9A6NRKBD
         2I1JpiK6ASQO0AKAckz2OFB8XhQZjIUNgVlqeDuZVm/OwOcylWZZ2m96J9a2tlxlBR
         bNHSK7fEEcsrA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Felix Fietkau <nbd@nbd.name>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: avoid u32_encode_bits() warning
Date:   Tue, 14 Feb 2023 14:20:21 +0100
Message-Id: <20230214132025.1532147-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-9 triggers a false-postive warning in ieee80211_mlo_multicast_tx()
for u32_encode_bits(ffs(links) - 1, ...), since ffs() can return zero
on an empty bitmask, and the negative argument to u32_encode_bits()
is then out of range:

In file included from include/linux/ieee80211.h:21,
                 from include/net/cfg80211.h:23,
                 from net/mac80211/tx.c:23:
In function 'u32_encode_bits',
    inlined from 'ieee80211_mlo_multicast_tx' at net/mac80211/tx.c:4437:17,
    inlined from 'ieee80211_subif_start_xmit' at net/mac80211/tx.c:4485:3:
include/linux/bitfield.h:177:3: error: call to '__field_overflow' declared with attribute error: value doesn't fit into mask
  177 |   __field_overflow();     \
      |   ^~~~~~~~~~~~~~~~~~
include/linux/bitfield.h:197:2: note: in expansion of macro '____MAKE_OP'
  197 |  ____MAKE_OP(u##size,u##size,,)
      |  ^~~~~~~~~~~
include/linux/bitfield.h:200:1: note: in expansion of macro '__MAKE_OP'
  200 | __MAKE_OP(32)
      | ^~~~~~~~~

Newer compiler versions do not cause problems with the zero argument
because they do not consider this a __builtin_constant_p().
It's also harmless since the hweight16() check already guarantees
that this cannot be 0.

Replace the ffs() with an equivalent find_first_bit() check that
matches the later for_each_set_bit() style and avoids the warning.

Fixes: 963d0e8d08d9 ("wifi: mac80211: optionally implement MLO multicast TX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index defe97a31724..118648af979c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4434,7 +4434,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
 
 	if (hweight16(links) == 1) {
-		ctrl_flags |= u32_encode_bits(ffs(links) - 1,
+		ctrl_flags |= u32_encode_bits(find_first_bit(&links, 16) - 1,
 					      IEEE80211_TX_CTRL_MLO_LINK);
 
 		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
-- 
2.39.1

