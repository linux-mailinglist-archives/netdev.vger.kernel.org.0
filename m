Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B406CF431
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 22:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjC2UOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 16:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjC2UOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 16:14:07 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3894C3B
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 13:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680120847; x=1711656847;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SAxQkR6ZXDF7Dosi7nX6Tq9Da4pUuETSz7sB5pHJdzg=;
  b=qVEeQcssj1oTDZ3FNe226DeeuOmeovICW0d/IuJAbufOAXuapElvBf1C
   eMzIFeFIrfE9bKTmLcQ4ez3t2p4tA/kuY1nD0KVqbcOX3IZR6S/8DLQAp
   6+jzhCmz3HZCCZh5xiZdluHiSGr2HPCC7F+9ZWzJmRJcKaKYXOFc8SYBp
   k=;
X-IronPort-AV: E=Sophos;i="5.98,301,1673913600"; 
   d="scan'208";a="312759424"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 20:14:03 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id 59560A2888;
        Wed, 29 Mar 2023 20:14:02 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 29 Mar 2023 20:14:01 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.9) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 29 Mar 2023 20:13:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH v3 net-next] tcp: Refine SYN handling for PAWS.
Date:   Wed, 29 Mar 2023 13:13:48 -0700
Message-ID: <20230329201348.79003-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.9]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our Network Load Balancer (NLB) [0] has multiple nodes with different
IP addresses, and each node forwards TCP flows from clients to backend
targets.  NLB has an option to preserve the client's source IP address
and port when routing packets to backend targets. [1]

When a client connects to two different NLB nodes, they may select the
same backend target.  Then, if the client has used the same source IP
and port, the two flows at the backend side will have the same 4-tuple.

While testing around such cases, I saw these sequences on the backend
target.

IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2819965599, win 62727, options [mss 8365,sackOK,TS val 1029816180 ecr 0,nop,wscale 7], length 0
IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3040695044, ack 2819965600, win 62643, options [mss 8961,sackOK,TS val 1224784076 ecr 1029816180,nop,wscale 7], length 0
IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 1, win 491, options [nop,nop,TS val 1029816181 ecr 1224784076], length 0
IP 10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 2681819307, win 62727, options [mss 8365,sackOK,TS val 572088282 ecr 0,nop,wscale 7], length 0
IP 10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 1, win 490, options [nop,nop,TS val 1224794914 ecr 1029816181,nop,nop,sack 1 {4156821004:4156821005}], length 0

It seems to be working correctly, but the last ACK was generated by
tcp_send_dupack() and PAWSEstab was increased.  This is because the
second connection has a smaller timestamp than the first one.

In this case, we should send a dup ACK in tcp_send_challenge_ack()
to increase the correct counter and rate-limit it properly.

Let's check the SYN flag after the PAWS tests to avoid adding unnecessary
overhead for most packets.

Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html [0]
Link: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation [1]
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
---
v3:
  - Remove Fixes tag

v2: https://lore.kernel.org/netdev/20230328184257.62219-1-kuniyu@amazon.com/
  - Respin for net-next
  - Update changelog about challenge ACK vs dup ACK
  - Add Reviewed-by tag

v1: https://lore.kernel.org/netdev/20230327230628.45660-1-kuniyu@amazon.com/
---
---
 net/ipv4/tcp_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2b75cd9e2e92..a057330d6f59 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5714,6 +5714,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	    tp->rx_opt.saw_tstamp &&
 	    tcp_paws_discard(sk, skb)) {
 		if (!th->rst) {
+			if (unlikely(th->syn))
+				goto syn_challenge;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 			if (!tcp_oow_rate_limited(sock_net(sk), skb,
 						  LINUX_MIB_TCPACKSKIPPEDPAWS,
-- 
2.30.2

