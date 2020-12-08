Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C172D360F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgLHWOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:14:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:58610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727914AbgLHWOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 17:14:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E700BAC55;
        Tue,  8 Dec 2020 22:13:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9261D60394; Tue,  8 Dec 2020 23:13:51 +0100 (CET)
Message-Id: <3487ee3a98e14cd526f55b6caaa959d2dcbcad9f.1607465316.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: fix stack overflow in ethnl_parse_bitset()
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Tue,  8 Dec 2020 23:13:51 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a stack overflow in bitmap_from_arr32() called from
ethnl_parse_bitset() when bitset from netlink message is longer than
target bitmap length. While ethnl_compact_sanity_checks() makes sure that
trailing part is all zeros (i.e. the request does not try to touch bits
kernel does not recognize), we also need to cap change_bits to nbits so
that we don't try to write past the prepared bitmaps.

Fixes: 88db6d1e4f62 ("ethtool: add ethnl_parse_bitset() helper")
Reported-by: syzbot+9d39fa49d4df294aab93@syzkaller.appspotmail.com
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/bitset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index 1fb3603d92ad..0515d6604b3b 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -628,6 +628,8 @@ int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
 			return ret;
 
 		change_bits = nla_get_u32(tb[ETHTOOL_A_BITSET_SIZE]);
+		if (change_bits > nbits)
+			change_bits = nbits;
 		bitmap_from_arr32(val, nla_data(tb[ETHTOOL_A_BITSET_VALUE]),
 				  change_bits);
 		if (change_bits < nbits)
-- 
2.29.2

