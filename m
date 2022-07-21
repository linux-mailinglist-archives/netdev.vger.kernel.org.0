Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048AC57D4C6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiGUU2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGUU2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:28:16 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8C2193FA;
        Thu, 21 Jul 2022 13:28:14 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LK2QRQ017955;
        Thu, 21 Jul 2022 22:27:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=oOcCUTVsGNBleOSh/FjP99rUsWnolJ+a+d9HVll019Y=;
 b=gRaEJP9aRe/GN11TyfB6kT7fUBGH7xAO4loAT4E6WD6Eh3OdfpytEg3dnb3h6sgTguin
 AqN1Eo0aPum2s0u7NMB3U3tqbn0gqsxdi+Kebr/Jg8jbyuo5inPX4DPUvXKbrn1F1HQM
 yUfYfCboZ8Q00ak6dB3LifvDtSlKPIj4YqTDhz4gF/dU90ZEs+J5GYHkWCErQsUb42ie
 3TgV0wzgEdUF7U0S5dc4hpLbrA6rpHZjDgP3RNviqYHQbsdccXc3eK62eIgJhKycqb1D
 bUUv4xmfAv7FfuDuREIXZWzIn0kuxef94y5+8WmSvFpdLKOtwF08sGKhl4CjBiwq+Dmm LQ== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hbhb5d6c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 22:27:41 +0200
Received: from Orpheus.nch.westermo.com (172.29.100.2) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Thu, 21 Jul 2022 22:27:40 +0200
From:   Matthias May <matthias.may@westermo.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <nicolas.dichtel@6wind.com>,
        <eyal.birger@gmail.com>, <linux-kernel@vger.kernel.org>,
        Matthias May <matthias.may@westermo.com>
Subject: [PATCH net-next] ip_tunnels: allow VXLAN/GENEVE to inherit TOS/TTL from VLAN
Date:   Thu, 21 Jul 2022 22:27:19 +0200
Message-ID: <20220721202718.10092-1-matthias.may@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.29.100.2]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: 5yHu0hAYP6Nh7wSHsFLeuODHOXm4-pz2
X-Proofpoint-GUID: 5yHu0hAYP6Nh7wSHsFLeuODHOXm4-pz2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code allows for VXLAN and GENEVE to inherit the TOS
respective the TTL when skb-protocol is ETH_P_IP or ETH_P_IPV6.
However when the payload is VLAN encapsulated, then this inheriting
does not work, because the visible skb-protocol is of type
ETH_P_8021Q or ETH_P_8021AD.

Instead of skb->protocol use skb_protocol().

Signed-off-by: Matthias May <matthias.may@westermo.com>
---
 include/net/ip_tunnels.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index c24fa934221d..d76c3f6a1f3f 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -387,9 +387,11 @@ static inline int ip_tunnel_encap(struct sk_buff *skb, struct ip_tunnel *t,
 static inline u8 ip_tunnel_get_dsfield(const struct iphdr *iph,
 				       const struct sk_buff *skb)
 {
-	if (skb->protocol == htons(ETH_P_IP))
+	__be16 payload_protocol = skb_protocol(skb, true);
+
+	if (payload_protocol == htons(ETH_P_IP))
 		return iph->tos;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (payload_protocol == htons(ETH_P_IPV6))
 		return ipv6_get_dsfield((const struct ipv6hdr *)iph);
 	else
 		return 0;
@@ -398,9 +400,11 @@ static inline u8 ip_tunnel_get_dsfield(const struct iphdr *iph,
 static inline u8 ip_tunnel_get_ttl(const struct iphdr *iph,
 				       const struct sk_buff *skb)
 {
-	if (skb->protocol == htons(ETH_P_IP))
+	__be16 payload_protocol = skb_protocol(skb, true);
+
+	if (payload_protocol == htons(ETH_P_IP))
 		return iph->ttl;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (payload_protocol == htons(ETH_P_IPV6))
 		return ((const struct ipv6hdr *)iph)->hop_limit;
 	else
 		return 0;
-- 
2.35.1

