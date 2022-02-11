Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD654B2B89
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 18:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243717AbiBKRPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 12:15:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiBKRPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 12:15:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F94A95
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 09:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB51961B32
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 17:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7963C340ED;
        Fri, 11 Feb 2022 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644599711;
        bh=ZHF8Jm9QfWDGLZU4YNLDBqA54J6UCWlVJMZ3wExu1cY=;
        h=From:To:Cc:Subject:Date:From;
        b=f+26O75iXZPjTpJqWsirBOVoDP5UboVz69LdR24G4zy56ZTcM+ON/OcMtvsByMipo
         0Jejt+UMRXGukXFqIn1y9Np6YvWchnDHid/BAbyMQFk5x411Nf0z0XjNQGPUlgpxe+
         JDWG2qEG1L7oLcBCgoPaW8CAYAR8TkJpV+4T7nxvS/8iLQ4Bq2cBQULpxyyoSmRjML
         unAuWgUpZp0us1DZu1VHQlWdYrQLjjS7rUTEXYVOvVuEyumhIdaUwKLyapJbjfO2/8
         7EsAGnF4oP53x0YklPqajwPR8URBWsnzOovScCUGYUS1pX+ZZo3JLMhEMGypx+jACq
         FIMN6fatMq7WA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     menglong8.dong@gmail.com, edumazet@google.com, willemb@google.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] ipv6: Add reasons for skb drops to __udp6_lib_rcv
Date:   Fri, 11 Feb 2022 09:15:07 -0800
Message-Id: <20220211171507.3969-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reasons to __udp6_lib_rcv for skb drops. The only twist is that the
NO_SOCKET takes precedence over the CSUM or other counters for that
path (motivation behind this patch - csum counter was misleading).

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv6/udp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index c6872596b408..7f0fa9bd9ffe 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -912,6 +912,7 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		   int proto)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
 	struct udphdr *uh;
@@ -988,6 +989,8 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 		return udp6_unicast_rcv_skb(sk, skb, uh);
 	}
 
+	reason = SKB_DROP_REASON_NO_SOCKET;
+
 	if (!uh->check)
 		goto report_csum_error;
 
@@ -1000,10 +1003,12 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP6_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
 	icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0);
 
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 
 short_packet:
+	if (reason == SKB_DROP_REASON_NOT_SPECIFIED)
+		reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 	net_dbg_ratelimited("UDP%sv6: short packet: From [%pI6c]:%u %d/%d to [%pI6c]:%u\n",
 			    proto == IPPROTO_UDPLITE ? "-Lite" : "",
 			    saddr, ntohs(uh->source),
@@ -1014,10 +1019,12 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 report_csum_error:
 	udp6_csum_zero_error(skb);
 csum_error:
+	if (reason == SKB_DROP_REASON_NOT_SPECIFIED)
+		reason = SKB_DROP_REASON_UDP_CSUM;
 	__UDP6_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 discard:
 	__UDP6_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 }
 
-- 
2.25.1

