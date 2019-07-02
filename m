Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E345CF12
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGBMFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:05:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34996 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfGBMFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:05:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so737541wml.0
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 05:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZeZkNBqQvCAlH/hG07VtX1l/wTFKdXlR218Y21cdaA=;
        b=VfM/JxZtMLXdHJ304kMnAg+hNAShLmLB+f4aXwzJ40luxY0rk5+bKx12dupRbLqRIC
         TwCGJTdwyrt1kqFtmp/6+lGZmtXRf//2toowM4iGF9qtZ4XL8nzCGwKj5Xwb0gF7Rdf7
         ZDakyGjX7DTyaxGt/YkAd5+o1aNYkoZICShuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZeZkNBqQvCAlH/hG07VtX1l/wTFKdXlR218Y21cdaA=;
        b=s/JX5rL6gfKJG1yHeVTQmYQ+2fFyPH8YIyLe9LVxcQF5mMtjgiOTE3XO1NU1zT/jc1
         JyJ3OWYpMGRoVtZTyxulvGP13C+AL2nN9+96TFQi8asXprSubzr/H7zOl4/jO2IMq0OY
         +yLtBfIYpsXrkXkxKakg4X06oTb7MqUh1VsfcnmIBEx4nu/ovEEYSP01jIk0jq9hif8V
         4rI8PHUlsm7o+Fxq9m8FVJQtkPn8qs3qAaEbwOgv+B5Ths6+Wdfl95rjUH+RpiYtwRHb
         VV9bE3nAfutBPumEG0eoNaB61Xj2Y0fMmoV6uhA4JpAhBQvPEbKMS59L90g/O5xKYg6d
         5B7g==
X-Gm-Message-State: APjAAAUx1M7Op4jjLN1WnslgybOIHdEhuOS1hiUdc/YHqa834T78xV5I
        3VkLNmh0/wreo95vg4tQuqUFTGTtiv0=
X-Google-Smtp-Source: APXvYqytdprwFvV9n4ofcfgurfK6tThS7bCfZ36HkC9giWMgFD/S8bTrG5sypK+LW+CqDK0VEgs2qg==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr3083565wmd.122.1562069104211;
        Tue, 02 Jul 2019 05:05:04 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x5sm2542655wmf.33.2019.07.02.05.05.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 05:05:03 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        martin@linuxlounge.net, bridge@lists.linux-foundation.org,
        yoshfuji@linux-ipv6.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 2/4] net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
Date:   Tue,  2 Jul 2019 15:00:19 +0300
Message-Id: <20190702120021.13096-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
References: <20190702120021.13096-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We get a pointer to the ipv6 hdr in br_ip6_multicast_query but we may
call pskb_may_pull afterwards and end up using a stale pointer.
So use the header directly, it's just 1 place where it's needed.

Fixes: 08b202b67264 ("bridge br_multicast: IPv6 MLD support.")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index f37897e7b97b..3d8deac2353d 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1279,7 +1279,6 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 				  u16 vid)
 {
 	unsigned int transport_len = ipv6_transport_len(skb);
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	struct mld_msg *mld;
 	struct net_bridge_mdb_entry *mp;
 	struct mld2_query *mld2q;
@@ -1323,7 +1322,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 
 	if (is_general_query) {
 		saddr.proto = htons(ETH_P_IPV6);
-		saddr.u.ip6 = ip6h->saddr;
+		saddr.u.ip6 = ipv6_hdr(skb)->saddr;
 
 		br_multicast_query_received(br, port, &br->ip6_other_query,
 					    &saddr, max_delay);
-- 
2.21.0

