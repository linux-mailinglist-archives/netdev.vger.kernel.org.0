Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5528716B066
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgBXTmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:42:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:35926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgBXTmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 14:42:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 14C45AD8E;
        Mon, 24 Feb 2020 19:42:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 426B4E1E06; Mon, 24 Feb 2020 20:42:12 +0100 (CET)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: limit bitset size
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-Id: <20200224194212.426B4E1E06@unicorn.suse.cz>
Date:   Mon, 24 Feb 2020 20:42:12 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported that ethnl_compact_sanity_checks() can be tricked into
reading past the end of ETHTOOL_A_BITSET_VALUE and ETHTOOL_A_BITSET_MASK
attributes and even the message by passing a value between (u32)(-31)
and (u32)(-1) as ETHTOOL_A_BITSET_SIZE.

The problem is that DIV_ROUND_UP(attr_nbits, 32) is 0 for such values so
that zero length ETHTOOL_A_BITSET_VALUE will pass the length check but
ethnl_bitmap32_not_zero() check would try to access up to 512 MB of
attribute "payload".

Prevent this overflow byt limiting the bitset size. Technically, compact
bitset format would allow bitset sizes up to almost 2^18 (so that the
nest size does not exceed U16_MAX) but bitsets used by ethtool are much
shorter. S16_MAX, the largest value which can be directly used as an
upper limit in policy, should be a reasonable compromise.

Fixes: 10b518d4e6dd ("ethtool: netlink bitset handling")
Reported-by: syzbot+7fd4ed5b4234ab1fdccd@syzkaller.appspotmail.com
Reported-by: syzbot+709b7a64d57978247e44@syzkaller.appspotmail.com
Reported-by: syzbot+983cb8fb2d17a7af549d@syzkaller.appspotmail.com
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/bitset.c | 3 ++-
 net/ethtool/bitset.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index 8977fe1f3946..ef9197541cb3 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -305,7 +305,8 @@ int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, const u32 *val,
 static const struct nla_policy bitset_policy[ETHTOOL_A_BITSET_MAX + 1] = {
 	[ETHTOOL_A_BITSET_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_BITSET_NOMASK]	= { .type = NLA_FLAG },
-	[ETHTOOL_A_BITSET_SIZE]		= { .type = NLA_U32 },
+	[ETHTOOL_A_BITSET_SIZE]		= NLA_POLICY_MAX(NLA_U32,
+							 ETHNL_MAX_BITSET_SIZE),
 	[ETHTOOL_A_BITSET_BITS]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_BITSET_VALUE]	= { .type = NLA_BINARY },
 	[ETHTOOL_A_BITSET_MASK]		= { .type = NLA_BINARY },
diff --git a/net/ethtool/bitset.h b/net/ethtool/bitset.h
index b8247e34109d..b849f9d19676 100644
--- a/net/ethtool/bitset.h
+++ b/net/ethtool/bitset.h
@@ -3,6 +3,8 @@
 #ifndef _NET_ETHTOOL_BITSET_H
 #define _NET_ETHTOOL_BITSET_H
 
+#define ETHNL_MAX_BITSET_SIZE S16_MAX
+
 typedef const char (*const ethnl_string_array_t)[ETH_GSTRING_LEN];
 
 int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact);
-- 
2.25.1

