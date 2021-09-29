Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A441BFE2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbhI2H2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:48 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33136 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244658AbhI2H2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:31 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id CD2F2214E5; Wed, 29 Sep 2021 15:26:49 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 09/10] mctp: Set route MTU via netlink
Date:   Wed, 29 Sep 2021 15:26:13 +0800
Message-Id: <20210929072614.854015-10-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A route's RTAX_MTU can be set in nested RTAX_METRICS

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/route.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index acc5bb39e16d..e20f3096d067 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1026,10 +1026,15 @@ static int mctp_route_nlparse(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return 0;
 }
 
+static const struct nla_policy rta_metrics_policy[RTAX_MAX + 1] = {
+	[RTAX_MTU]		= { .type = NLA_U32 },
+};
+
 static int mctp_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[RTA_MAX + 1];
+	struct nlattr *tbx[RTAX_MAX + 1];
 	mctp_eid_t daddr_start;
 	struct mctp_dev *mdev;
 	struct rtmsg *rtm;
@@ -1046,8 +1051,15 @@ static int mctp_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	/* TODO: parse mtu from nlparse */
 	mtu = 0;
+	if (tb[RTA_METRICS]) {
+		rc = nla_parse_nested(tbx, RTAX_MAX, tb[RTA_METRICS],
+				      rta_metrics_policy, NULL);
+		if (rc < 0)
+			return rc;
+		if (tbx[RTAX_MTU])
+			mtu = nla_get_u32(tbx[RTAX_MTU]);
+	}
 
 	if (rtm->rtm_type != RTN_UNICAST)
 		return -EINVAL;
-- 
2.30.2

