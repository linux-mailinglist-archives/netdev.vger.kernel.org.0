Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C623A500997
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbiDNJWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiDNJWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:22:17 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E655313DC8
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:19:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6F70F20600;
        Thu, 14 Apr 2022 11:19:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jTqAxcLIwqm5; Thu, 14 Apr 2022 11:19:47 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C49BC2060D;
        Thu, 14 Apr 2022 11:19:47 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id BF8A580004A;
        Thu, 14 Apr 2022 11:19:47 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Apr 2022 11:19:47 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 14 Apr
 2022 11:19:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E379F3182EAE; Thu, 14 Apr 2022 11:19:46 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup
Date:   Thu, 14 Apr 2022 11:19:42 +0200
Message-ID: <20220414091943.3000372-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414091943.3000372-1-steffen.klassert@secunet.com>
References: <20220414091943.3000372-1-steffen.klassert@secunet.com>
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

From: David Ahern <dsahern@kernel.org>

The commit referenced in the Fixes tag no longer changes the
flow oif to the l3mdev ifindex. A xfrm use case was expecting
the flowi_oif to be the VRF if relevant and the change broke
that test. Update xfrm_bundle_create to pass oif if set and any
potential flowi_l3mdev if oif is not set.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 19aa994f5d2c..00bd0ecff5a1 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2593,12 +2593,14 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 
 		if (xfrm[i]->props.mode != XFRM_MODE_TRANSPORT) {
 			__u32 mark = 0;
+			int oif;
 
 			if (xfrm[i]->props.smark.v || xfrm[i]->props.smark.m)
 				mark = xfrm_smark_get(fl->flowi_mark, xfrm[i]);
 
 			family = xfrm[i]->props.family;
-			dst = xfrm_dst_lookup(xfrm[i], tos, fl->flowi_oif,
+			oif = fl->flowi_oif ? : fl->flowi_l3mdev;
+			dst = xfrm_dst_lookup(xfrm[i], tos, oif,
 					      &saddr, &daddr, family, mark);
 			err = PTR_ERR(dst);
 			if (IS_ERR(dst))
-- 
2.25.1

