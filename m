Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9A06DC544
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDJJnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjDJJm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:42:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDFF19AA;
        Mon, 10 Apr 2023 02:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 827CF61177;
        Mon, 10 Apr 2023 09:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81627C4339E;
        Mon, 10 Apr 2023 09:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681119777;
        bh=6m5PiOkagnIAlt7Cy5yE3jV1Nce7jFt6TO8B1ewEaws=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=b0tisPuid0mXwdWES0cf7hBLAnWkYc0j15tv31gt7jPGz2gUA3LllrL1gcMbnJBa/
         1FJGdCJdBgiPSMWv4uIvhuruYpjI34ihVqzrUeNNwRJ3hf1m+p7qYtEJ8322hY9PfR
         d649F/WYj4Bgtxw8vtUqEjx4kZ7zFT3TaTRa++od2xNYqtNttEaTQsUbsoVPChldh8
         dQv45edlPEOcA01zRZ92ZNe4dEuiLG0EJdjw4g6u003mHYMfPluGbn1G0Z+THLV9jc
         duPACRtZLWz1Es1tt0CiQKNqkwUhkaLr0UGgdZv7tDTuP5JUGWo/7n7I7kV1KGDzxT
         O4BpjEHF/jWNw==
From:   Simon Horman <horms@kernel.org>
Date:   Mon, 10 Apr 2023 11:42:36 +0200
Subject: [PATCH nf-next 2/4] ipvs: Consistently use array_size() in
 ip_vs_conn_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230409-ipvs-cleanup-v1-2-98cdc242feb0@kernel.org>
References: <20230409-ipvs-cleanup-v1-0-98cdc242feb0@kernel.org>
In-Reply-To: <20230409-ipvs-cleanup-v1-0-98cdc242feb0@kernel.org>
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
 net/netfilter/ipvs/ip_vs_conn.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 13534e02346c..da0d8b42d5a3 100644
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
+		ip_vs_conn_tab_size, tab_array_size);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 

-- 
2.30.2

