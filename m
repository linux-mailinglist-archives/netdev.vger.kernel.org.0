Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382FD4CFDE3
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbiCGMMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiCGMMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:12:44 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DAA7B566
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 04:11:49 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1937520504
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:11:47 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bD4dFW4b3Svn for <netdev@vger.kernel.org>;
        Mon,  7 Mar 2022 13:11:46 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 94DA620536
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:11:46 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 8F3AA80004A
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:11:46 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 7 Mar 2022 13:11:46 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 13:11:46 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DF4613182EA1; Mon,  7 Mar 2022 13:11:45 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH ipsec 2/3] esp: Fix BEET mode inter address family tunneling on GSO
Date:   Mon, 7 Mar 2022 13:11:40 +0100
Message-ID: <20220307121141.1921944-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307121141.1921944-1-steffen.klassert@secunet.com>
References: <20220307121141.1921944-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xfrm{4,6}_beet_gso_segment() functions did not correctly set the
SKB_GSO_IPXIP4 and SKB_GSO_IPXIP6 gso types for the address family
tunneling case. Fix this by setting these gso types.

Fixes: 384a46ea7bdc7 ("esp4: add gso_segment for esp4 beet mode")
Fixes: 7f9e40eb18a99 ("esp6: add gso_segment for esp6 beet mode")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 3 +++
 net/ipv6/esp6_offload.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index d87f02a6e934..146d4d54830c 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -160,6 +160,9 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
 	}
 
+	if (proto == IPPROTO_IPV6)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_IPXIP4;
+
 	__skb_pull(skb, skb_transport_offset(skb));
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment))
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index ba5e81cd569c..e61172d50817 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -199,6 +199,9 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 			ipv6_skip_exthdr(skb, 0, &proto, &frag);
 	}
 
+	if (proto == IPPROTO_IPIP)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_IPXIP6;
+
 	__skb_pull(skb, skb_transport_offset(skb));
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment))
-- 
2.25.1

