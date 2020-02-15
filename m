Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C5015FBCD
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 01:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgBOAzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 19:55:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:54098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgBOAzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 19:55:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1B636AC7C;
        Sat, 15 Feb 2020 00:55:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4D202E03D6; Sat, 15 Feb 2020 01:55:53 +0100 (CET)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: fix application of verbose no_mask bitset
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-Id: <20200215005553.4D202E03D6@unicorn.suse.cz>
Date:   Sat, 15 Feb 2020 01:55:53 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bitset without mask in a _SET request means we want exactly the bits in
the bitset to be set. This works correctly for compact format but when
verbose format is parsed, ethnl_update_bitset32_verbose() only sets the
bits present in the request bitset but does not clear the rest. This can
cause incorrect results like

  lion:~ # ethtool eth0 | grep Wake
          Supports Wake-on: pumbg
          Wake-on: g
  lion:~ # ethtool -s eth0 wol u
  lion:~ # ethtool eth0 | grep Wake
          Supports Wake-on: pumbg
          Wake-on: ug

when the second ethtool command issues request

ETHTOOL_MSG_WOL_SET
    ETHTOOL_A_WOL_HEADER
        ETHTOOL_A_HEADER_DEV_NAME = "eth0"
    ETHTOOL_A_WOL_MODES
        ETHTOOL_A_BITSET_NOMASK
        ETHTOOL_A_BITSET_BITS
            ETHTOOL_A_BITSET_BITS_BIT
                ETHTOOL_BITSET_BIT_INDEX = 1

Fix the logic by clearing the whole target bitmap before we start iterating
through the request bits.

Fixes: 10b518d4e6dd ("ethtool: netlink bitset handling")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/bitset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index fce45dac4205..8977fe1f3946 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -447,7 +447,10 @@ ethnl_update_bitset32_verbose(u32 *bitmap, unsigned int nbits,
 				    "mask only allowed in compact bitset");
 		return -EINVAL;
 	}
+
 	no_mask = tb[ETHTOOL_A_BITSET_NOMASK];
+	if (no_mask)
+		ethnl_bitmap32_clear(bitmap, 0, nbits, mod);
 
 	nla_for_each_nested(bit_attr, tb[ETHTOOL_A_BITSET_BITS], rem) {
 		bool old_val, new_val;
-- 
2.25.0

