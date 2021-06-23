Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22AA3B1439
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFWG5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:57:14 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:33332 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhFWG5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:57:10 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 30EBF800055;
        Wed, 23 Jun 2021 08:54:53 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 08:54:53 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 08:54:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 63EBA31804F1; Wed, 23 Jun 2021 08:54:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/6] xfrm: remove the fragment check for ipv6 beet mode
Date:   Wed, 23 Jun 2021 08:54:47 +0200
Message-ID: <20210623065449.2143405-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210623065449.2143405-1-steffen.klassert@secunet.com>
References: <20210623065449.2143405-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

In commit 68dc022d04eb ("xfrm: BEET mode doesn't support fragments
for inner packets"), it tried to fix the issue that in TX side the
packet is fragmented before the ESP encapping while in the RX side
the fragments always get reassembled before decapping with ESP.

This is not true for IPv6. IPv6 is different, and it's using exthdr
to save fragment info, as well as the ESP info. Exthdrs are added
in TX and processed in RX both in order. So in the above case, the
ESP decapping will be done earlier than the fragment reassembling
in TX side.

Here just remove the fragment check for the IPv6 inner packets to
recover the fragments support for BEET mode.

Fixes: 68dc022d04eb ("xfrm: BEET mode doesn't support fragments for inner packets")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4cb0ff4dcf4..ac907b9d32d1 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -711,15 +711,8 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	unsigned int ptr = 0;
 	int err;
 
-	if (x->outer_mode.encap == XFRM_MODE_BEET &&
-	    ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL) >= 0) {
-		net_warn_ratelimited("BEET mode doesn't support inner IPv6 fragments\n");
-		return -EAFNOSUPPORT;
-	}
-
 	err = xfrm6_tunnel_check_size(skb);
 	if (err)
 		return err;
-- 
2.25.1

