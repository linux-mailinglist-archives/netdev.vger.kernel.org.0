Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B3814E04C
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 18:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgA3R55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 12:57:57 -0500
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:42272 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727319AbgA3R55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 12:57:57 -0500
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id CEB272E1268;
        Thu, 30 Jan 2020 20:57:53 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id MUIXhkItiU-vrkui8Po;
        Thu, 30 Jan 2020 20:57:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1580407073; bh=5nwEg3Gyjwmxi9K29K+Xb8SJK7cjEDemiXT/3omcg3E=;
        h=Message-ID:Subject:To:From:Date:Cc;
        b=k0bZfPbcwsneU43kKY7C3shRVSWDFVQanT6xpgQb1E+gGHJoLEtQZplUbJmG7b911
         FIq5O4WMka5whfepw+5Q7h9cI4a1i9uUKXvpATKrwU45JTVuVt34blD/Zrx8x/KqqQ
         WAwZZ1RRR4YBrucslf9EbJKknfvjlM1ISxH/zFoI=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:8ce3:6a43:8d67:ad0f])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id OVSza9LwXK-vrV0ZPbn;
        Thu, 30 Jan 2020 20:57:53 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Thu, 30 Jan 2020 20:57:49 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] netlink: add real_num_[tr]x_queues to ifinfo
Message-ID: <20200130175749.GA31391@zeil-osx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the number of active tx/rx queues to ifinfo message.

Now there are two ways of determining the number of active queues:
1) by counting entries in /sys/class/net/eth[0-9]+/queues/
2) by ioctl syscall if a driver implements ethtool_ops->get_channels()

Default mq qdisc sets up pfifo_fast only for active queues. So, if we want
to reproduce this behavior with custom leaf qdiscs, we should use one
of these methods which are foreign for the code where netlink was used.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/uapi/linux/if_link.h | 2 ++
 net/core/rtnetlink.c         | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8aec876..6566b63 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -169,6 +169,8 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_REAL_NUM_TX_QUEUES,
+	IFLA_REAL_NUM_RX_QUEUES,
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d9001b5..3ebae18 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1013,7 +1013,9 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(1) /* IFLA_CARRIER */
 	       + nla_total_size(4) /* IFLA_PROMISCUITY */
 	       + nla_total_size(4) /* IFLA_NUM_TX_QUEUES */
+	       + nla_total_size(4) /* IFLA_REAL_NUM_TX_QUEUES */
 	       + nla_total_size(4) /* IFLA_NUM_RX_QUEUES */
+	       + nla_total_size(4) /* IFLA_REAL_NUM_RX_QUEUES */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SIZE */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
@@ -1687,10 +1689,12 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_GROUP, dev->group) ||
 	    nla_put_u32(skb, IFLA_PROMISCUITY, dev->promiscuity) ||
 	    nla_put_u32(skb, IFLA_NUM_TX_QUEUES, dev->num_tx_queues) ||
+	    nla_put_u32(skb, IFLA_REAL_NUM_TX_QUEUES, dev->real_num_tx_queues) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
+	    nla_put_u32(skb, IFLA_REAL_NUM_RX_QUEUES, dev->real_num_rx_queues) ||
 #endif
 	    put_master_ifindex(skb, dev) ||
 	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
@@ -1803,7 +1807,9 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_EXT_MASK]		= { .type = NLA_U32 },
 	[IFLA_PROMISCUITY]	= { .type = NLA_U32 },
 	[IFLA_NUM_TX_QUEUES]	= { .type = NLA_U32 },
+	[IFLA_REAL_NUM_TX_QUEUES] = { .type = NLA_U32 },
 	[IFLA_NUM_RX_QUEUES]	= { .type = NLA_U32 },
+	[IFLA_REAL_NUM_RX_QUEUES] = { .type = NLA_U32 },
 	[IFLA_GSO_MAX_SEGS]	= { .type = NLA_U32 },
 	[IFLA_GSO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_PHYS_PORT_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_ITEM_ID_LEN },
-- 
2.7.4

