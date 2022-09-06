Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5A95AE4DA
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 11:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiIFJ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 05:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiIFJ4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 05:56:10 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA5A872B5B
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 02:56:05 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id AE3846002A;
        Tue,  6 Sep 2022 11:56:04 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1oVVJM-0003ue-KW; Tue, 06 Sep 2022 11:56:04 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next] rtnetlink: advertise allmulti counter
Date:   Tue,  6 Sep 2022 11:55:58 +0200
Message-Id: <20220906095558.15031-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like what was done with IFLA_PROMISCUITY, add IFLA_ALLMULTI to advertise
the allmulti counter.
The flag IFF_ALLMULTI is advertised only if it was directly set by a
userland app.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/if_link.h | 1 +
 net/core/rtnetlink.c         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e36d9d2c65a7..0bfa9a99ebb6 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -370,6 +370,7 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
+	IFLA_ALLMULTI,		/* Allmulti count: > 0 means acts ALLMULTI */
 
 	__IFLA_MAX
 };
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f5e87fe57c83..8de9fb32db08 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1057,6 +1057,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4) /* IFLA_MASTER */
 	       + nla_total_size(1) /* IFLA_CARRIER */
 	       + nla_total_size(4) /* IFLA_PROMISCUITY */
+	       + nla_total_size(4) /* IFLA_ALLMULTI */
 	       + nla_total_size(4) /* IFLA_NUM_TX_QUEUES */
 	       + nla_total_size(4) /* IFLA_NUM_RX_QUEUES */
 	       + nla_total_size(4) /* IFLA_GSO_MAX_SEGS */
@@ -1765,6 +1766,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_MAX_MTU, dev->max_mtu) ||
 	    nla_put_u32(skb, IFLA_GROUP, dev->group) ||
 	    nla_put_u32(skb, IFLA_PROMISCUITY, dev->promiscuity) ||
+	    nla_put_u32(skb, IFLA_ALLMULTI, dev->allmulti) ||
 	    nla_put_u32(skb, IFLA_NUM_TX_QUEUES, dev->num_tx_queues) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SEGS, dev->gso_max_segs) ||
 	    nla_put_u32(skb, IFLA_GSO_MAX_SIZE, dev->gso_max_size) ||
@@ -1926,6 +1928,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_GRO_MAX_SIZE]	= { .type = NLA_U32 },
 	[IFLA_TSO_MAX_SIZE]	= { .type = NLA_REJECT },
 	[IFLA_TSO_MAX_SEGS]	= { .type = NLA_REJECT },
+	[IFLA_ALLMULTI]		= { .type = NLA_REJECT },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
-- 
2.33.0

