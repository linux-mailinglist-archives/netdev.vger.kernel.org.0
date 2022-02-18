Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABFB4BB0BE
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiBRE0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:26:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiBRE0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:26:22 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E7013F77
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 20:26:02 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 08191202F9; Fri, 18 Feb 2022 12:25:57 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH net-next 2/2] mctp: add address validity checking for packet receive
Date:   Fri, 18 Feb 2022 12:25:54 +0800
Message-Id: <20220218042554.564787-3-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218042554.564787-1-jk@codeconstruct.com.au>
References: <20220218042554.564787-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds some basic sanity checks for the source and dest
headers of packets on initial receive.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 6a11d78cfbab..fe6c8bf1ec2c 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1092,6 +1092,17 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 	if (mh->ver < MCTP_VER_MIN || mh->ver > MCTP_VER_MAX)
 		goto err_drop;
 
+	/* source must be valid unicast or null; drop reserved ranges and
+	 * broadcast
+	 */
+	if (!(mctp_address_unicast(mh->src) || mctp_address_null(mh->src)))
+		goto err_drop;
+
+	/* dest address: as above, but allow broadcast */
+	if (!(mctp_address_unicast(mh->dest) || mctp_address_null(mh->dest) ||
+	      mctp_address_broadcast(mh->dest)))
+		goto err_drop;
+
 	/* MCTP drivers must populate halen/haddr */
 	if (dev->type == ARPHRD_MCTP) {
 		cb = mctp_cb(skb);
-- 
2.34.1

