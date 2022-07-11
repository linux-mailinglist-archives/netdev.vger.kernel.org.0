Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F4756FBB5
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiGKJet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiGKJdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:33:24 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DC47AC08;
        Mon, 11 Jul 2022 02:18:02 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26B5tOZi024300;
        Mon, 11 Jul 2022 11:17:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=12052020;
 bh=shaOQQbPhoHi9LUOr7y8jZFfkryYxuyVMRZCJiTHuj8=;
 b=uSxCHcol8BaecD5lwAL3r4OWekg2DUe+Yn9aeVgdI6EpjT7IABqx308JEIVN4RsYTDpP
 zBZovdMTSUSkt9ImSHA5TNR2PAXiMXVAgUYkix3gqbLT1b3JkoF6JjEbbX6Bl97/1CQg
 ziE6hdY+w5ajNE+RgYK6e6Ch+2nXMuCsEohHdoZRdO4t+mb10TU0ED10mYHQ1ZkdU5Pu
 N4Jv2ktigrNXrIx+diDZzZtRK6GSRp3i16PkmBJRC1+VTSxRHa0x972fMBNJqtxJKt2J
 S/mYmIhjDKcHmt1f97YEOAyJ3TpIZWEY4gnZuQIIMs0VVl0czgvZD+jAxbdSAu6449R4 IA== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h6wp61x80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 11:17:42 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Mon, 11 Jul 2022 11:17:41 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH 2/4 net-next] ip6_gre: set DSCP for non-IP
Date:   Mon, 11 Jul 2022 11:17:20 +0200
Message-ID: <20220711091722.14485-3-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220711091722.14485-1-matthias.may@westermo.com>
References: <20220711091722.14485-1-matthias.may@westermo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: scdlbC51bDbrNf4zylNAa2qtefHwz_ze
X-Proofpoint-GUID: scdlbC51bDbrNf4zylNAa2qtefHwz_ze
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code always forces a dscp of 0 for all non-IP frames.
However when setting a specific TOS with the command

ip link add name tep0 type ip6gretap local fdd1:ced0:5d88:3fce::1
remote fdd1:ced0:5d88:3fce::2 tos 0xa0

one would expect all GRE encapsulated frames to have a TOS of 0xA0.
and not only when the payload is IPv4/IPv6.

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 net/ipv6/ip6_gre.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a9051df0625d..5fe0db88bea8 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -701,6 +701,33 @@ static int prepare_ip6gre_xmit_ipv6(struct sk_buff *skb,
 	return 0;
 }
 
+static int prepare_ip6gre_xmit_other(struct sk_buff *skb,
+				     struct net_device *dev,
+				     struct flowi6 *fl6, __u8 *dsfield,
+				     int *encap_limit)
+{
+	struct ip6_tnl *t = netdev_priv(dev);
+
+	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
+		*encap_limit = t->parms.encap_limit;
+
+	memcpy(fl6, &t->fl.u.ip6, sizeof(*fl6));
+
+	if (t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS)
+		*dsfield = 0;
+	else
+		*dsfield = ip6_tclass(t->parms.flowinfo);
+
+	if (t->parms.flags & IP6_TNL_F_USE_ORIG_FWMARK)
+		fl6->flowi6_mark = skb->mark;
+	else
+		fl6->flowi6_mark = t->parms.fwmark;
+
+	fl6->flowi6_uid = sock_net_uid(dev_net(dev), NULL);
+
+	return 0;
+}
+
 static struct ip_tunnel_info *skb_tunnel_info_txcheck(struct sk_buff *skb)
 {
 	struct ip_tunnel_info *tun_info;
@@ -868,20 +895,18 @@ static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 	struct ip6_tnl *t = netdev_priv(dev);
 	int encap_limit = -1;
 	struct flowi6 fl6;
+	__u8 dsfield = 0;
 	__u32 mtu;
 	int err;
 
-	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-		encap_limit = t->parms.encap_limit;
-
-	if (!t->parms.collect_md)
-		memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
+	if (!t->parms.collect_md &&
+	    prepare_ip6gre_xmit_other(skb, dev, &fl6, &dsfield, &encap_limit))
+		return -1;
 
 	err = gre_handle_offloads(skb, !!(t->parms.o_flags & TUNNEL_CSUM));
 	if (err)
 		return err;
-
-	err = __gre6_xmit(skb, dev, 0, &fl6, encap_limit, &mtu, skb->protocol);
+	err = __gre6_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu, skb->protocol);
 
 	return err;
 }
-- 
2.35.1

