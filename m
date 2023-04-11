Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851526DD3B7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjDKHK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjDKHKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:10:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAB22D66;
        Tue, 11 Apr 2023 00:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B81CE6223F;
        Tue, 11 Apr 2023 07:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F59C4339E;
        Tue, 11 Apr 2023 07:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681197053;
        bh=MCcu2L3rtcfTV+OZljKLRwOcSdgy7kjk2D3O8GnMt4s=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=uih8j8Xibt5ZIW9rOv4ApSnJC434b/7Q39A6DJF9HYTM34gKgqiDpX2IgNa6Akaxp
         w9WX1uuGTBlZ7TjUa0apjlkJqIOapsQ+AtcCBFDkgwNa0cnPYB4X4wOEbS5SJdApSi
         Cj+kGWhtx3L5iiOtkILAO8wU7dbVG5On1ZKD/6OFkgntI9CpX71eaTzAxT3uZYuKJ4
         56r7cJJCPfMso1XY8YDqyBlvs9DUwbfg+Q+kuVsCJ8NpjXxtV/gZr1eBKNIG+IGJcP
         0QbDw1e8VJNOgscydiv01YJKwui2AcphZUbW1a2rNdI3pGcikt7lE+iY6Fk+UHGxDF
         G6MzwYpwWXxtw==
From:   Simon Horman <horms@kernel.org>
Date:   Tue, 11 Apr 2023 09:10:40 +0200
Subject: [PATCH nf-next v2 2/4] ipvs: Consistently use array_size() in
 ip_vs_conn_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230409-ipvs-cleanup-v2-2-204cd17da708@kernel.org>
References: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
In-Reply-To: <20230409-ipvs-cleanup-v2-0-204cd17da708@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consistently use array_size() to calculate the size of ip_vs_conn_tab
in bytes.

Flagged by Coccinelle:
 WARNING: array_size is already used (line 1498) to compute the same size

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
v2
* Retain division by 1024, which was lost in v1
---
 net/netfilter/ipvs/ip_vs_conn.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 13534e02346c..84d273a84dc8 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1481,6 +1481,7 @@ void __net_exit ip_vs_conn_net_cleanup(struct netns_ipvs *ipvs)
 
 int __init ip_vs_conn_init(void)
 {
+	size_t tab_array_size;
 	int idx;
 
 	/* Compute size and mask */
@@ -1494,8 +1495,9 @@ int __init ip_vs_conn_init(void)
 	/*
 	 * Allocate the connection hash table and initialize its list heads
 	 */
-	ip_vs_conn_tab = vmalloc(array_size(ip_vs_conn_tab_size,
-					    sizeof(*ip_vs_conn_tab)));
+	tab_array_size = array_size(ip_vs_conn_tab_size,
+				    sizeof(*ip_vs_conn_tab));
+	ip_vs_conn_tab = vmalloc(tab_array_size);
 	if (!ip_vs_conn_tab)
 		return -ENOMEM;
 
@@ -1508,10 +1510,8 @@ int __init ip_vs_conn_init(void)
 		return -ENOMEM;
 	}
 
-	pr_info("Connection hash table configured "
-		"(size=%d, memory=%ldKbytes)\n",
-		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
+	pr_info("Connection hash table configured (size=%d, memory=%zdKbytes)\n",
+		ip_vs_conn_tab_size / 1024, tab_array_size);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 

-- 
2.30.2

