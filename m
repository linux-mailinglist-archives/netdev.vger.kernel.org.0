Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D1611765E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLITz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:55:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:43356 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726354AbfLITz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:55:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2BA2AD75;
        Mon,  9 Dec 2019 19:55:25 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E9D83E03B3; Mon,  9 Dec 2019 20:55:24 +0100 (CET)
Message-Id: <0f4b780d5dd38109768d863781b0ce6de9ef4fbb.1575920565.git.mkubecek@suse.cz>
In-Reply-To: <cover.1575920565.git.mkubecek@suse.cz>
References: <cover.1575920565.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 1/5] rtnetlink: provide permanent hardware address in
 RTM_NEWLINK
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Mon,  9 Dec 2019 20:55:24 +0100 (CET)
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
Acked-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/uapi/linux/if_link.h | 1 +
 net/core/rtnetlink.c         | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8aec8769d944..1d69f637c5d6 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -169,6 +169,7 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_PERM_ADDRESS,
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 02916f43bf63..20bc406f3871 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1041,6 +1041,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_MIN_MTU */
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
 	       + rtnl_prop_list_size(dev)
+	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
 	       + 0;
 }
 
@@ -1757,6 +1758,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_s32(skb, IFLA_NEW_IFINDEX, new_ifindex) < 0)
 		goto nla_put_failure;
 
+	if (memchr_inv(dev->perm_addr, '\0', dev->addr_len) &&
+	    nla_put(skb, IFLA_PERM_ADDRESS, dev->addr_len, dev->perm_addr))
+		goto nla_put_failure;
 
 	rcu_read_lock();
 	if (rtnl_fill_link_af(skb, dev, ext_filter_mask))
@@ -1822,6 +1826,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROP_LIST]	= { .type = NLA_NESTED },
 	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
 				    .len = ALTIFNAMSIZ - 1 },
+	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
-- 
2.24.0

