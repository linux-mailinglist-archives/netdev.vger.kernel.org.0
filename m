Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04495CEDF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGBLtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:49:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:38270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbfGBLtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:49:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65B2FB090;
        Tue,  2 Jul 2019 11:49:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1945BE0159; Tue,  2 Jul 2019 13:49:44 +0200 (CEST)
Message-Id: <b6e0aefbcb58297b3ec0a12ee4be8e5194eee61a.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 01/15] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:49:44 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Permanent hardware address of a network device was traditionally provided
via ethtool ioctl interface but as Jiri Pirko pointed out in a review of
ethtool netlink interface, rtnetlink is much more suitable for it so let's
add it to the RTM_NEWLINK message.

Add IFLA_PERM_ADDRESS attribute to RTM_NEWLINK messages unless the
permanent address is all zeros (i.e. device driver did not fill it). As
permanent address is not modifiable, reject userspace requests containing
IFLA_PERM_ADDRESS attribute.

Note: we already provide permanent hardware address for bond slaves;
unfortunately we cannot drop that attribute for backward compatibility
reasons.

v5 -> v6: only add the attribute if permanent address is not zero

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/uapi/linux/if_link.h | 1 +
 net/core/rtnetlink.c         | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6f75bda2c2d7..1c79d6283a4d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -167,6 +167,7 @@ enum {
 	IFLA_NEW_IFINDEX,
 	IFLA_MIN_MTU,
 	IFLA_MAX_MTU,
+	IFLA_PERM_ADDRESS,
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..9aae53e8914e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1027,6 +1027,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_CARRIER_DOWN_COUNT */
 	       + nla_total_size(4)  /* IFLA_MIN_MTU */
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
+	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
 	       + 0;
 }
 
@@ -1691,6 +1692,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_s32(skb, IFLA_NEW_IFINDEX, new_ifindex) < 0)
 		goto nla_put_failure;
 
+	if (memchr_inv(dev->perm_addr, '\0', dev->addr_len) &&
+	    nla_put(skb, IFLA_PERM_ADDRESS, dev->addr_len, dev->perm_addr))
+		goto nla_put_failure;
 
 	rcu_read_lock();
 	if (rtnl_fill_link_af(skb, dev, ext_filter_mask))
@@ -1750,6 +1754,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
 	[IFLA_MIN_MTU]		= { .type = NLA_U32 },
 	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
+	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
-- 
2.22.0

