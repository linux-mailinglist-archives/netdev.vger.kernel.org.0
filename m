Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D879510868
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353787AbiDZTFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353764AbiDZTFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:05:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BB419982F;
        Tue, 26 Apr 2022 12:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 341B5619C5;
        Tue, 26 Apr 2022 19:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7995CC385A4;
        Tue, 26 Apr 2022 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999743;
        bh=J9fKvkWLHDd+6qz2ZBFVcWFT9ooivv7xE+aNdi+7aEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVftWVBv1iea8k/Y/8zcaFhY7s821InzRGZaGv22HE9Kf6YnzbNvW+p978tOh8Qk+
         NZzXoSYc29vsdBoX6b/Aao2n5MtERj6FECIpVGz/d21NxLnxIcSpwHW9wWQyriIMQ+
         r+LWRgg16N6bIjhA/WdiRF3w0SFRefOP8L7ngc3ieBji3W1XKGSglhcCDCT2P9DV0D
         xpgaICLOC+a4u1tvN4o7jCgvrlCcr8Jqr8WIVHxlO/m6OcIqbVUcF9LIho9yhnHu7X
         Vt1/fmNSMJjX/MUkqTPs5S/9/7Exvy66/AqBFY2r9Z/NMh/ESK6hTqmqt/LseImdQA
         JPamWXecQ8etw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     suresh kumar <suresh2514@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/15] bonding: do not discard lowest hash bit for non layer3+4 hashing
Date:   Tue, 26 Apr 2022 15:02:07 -0400
Message-Id: <20220426190216.2351413-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190216.2351413-1-sashal@kernel.org>
References: <20220426190216.2351413-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: suresh kumar <suresh2514@gmail.com>

[ Upstream commit 49aefd131739df552f83c566d0665744c30b1d70 ]

Commit b5f862180d70 was introduced to discard lowest hash bit for layer3+4 hashing
but it also removes last bit from non layer3+4 hashing

Below script shows layer2+3 hashing will result in same slave to be used with above commit.
$ cat hash.py
#/usr/bin/python3.6

h_dests=[0xa0, 0xa1]
h_source=0xe3
hproto=0x8
saddr=0x1e7aa8c0
daddr=0x17aa8c0

for h_dest in h_dests:
    hash = (h_dest ^ h_source ^ hproto ^ saddr ^ daddr)
    hash ^= hash >> 16
    hash ^= hash >> 8
    print(hash)

print("with last bit removed")
for h_dest in h_dests:
    hash = (h_dest ^ h_source ^ hproto ^ saddr ^ daddr)
    hash ^= hash >> 16
    hash ^= hash >> 8
    hash = hash >> 1
    print(hash)

Output:
$ python3.6 hash.py
522133332
522133333   <-------------- will result in both slaves being used

with last bit removed
261066666
261066666   <-------------- only single slave used

Signed-off-by: suresh kumar <suresh2514@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 46c3301a5e07..2e75b7e8f70b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3817,14 +3817,19 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb, const v
 	return true;
 }
 
-static u32 bond_ip_hash(u32 hash, struct flow_keys *flow)
+static u32 bond_ip_hash(u32 hash, struct flow_keys *flow, int xmit_policy)
 {
 	hash ^= (__force u32)flow_get_u32_dst(flow) ^
 		(__force u32)flow_get_u32_src(flow);
 	hash ^= (hash >> 16);
 	hash ^= (hash >> 8);
+
 	/* discard lowest hash bit to deal with the common even ports pattern */
-	return hash >> 1;
+	if (xmit_policy == BOND_XMIT_POLICY_LAYER34 ||
+		xmit_policy == BOND_XMIT_POLICY_ENCAP34)
+		return hash >> 1;
+
+	return hash;
 }
 
 /* Generate hash based on xmit policy. If @skb is given it is used to linearize
@@ -3854,7 +3859,7 @@ static u32 __bond_xmit_hash(struct bonding *bond, struct sk_buff *skb, const voi
 			memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	}
 
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, bond->params.xmit_policy);
 }
 
 /**
@@ -5012,7 +5017,7 @@ static u32 bond_sk_hash_l34(struct sock *sk)
 	/* L4 */
 	memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	/* L3 */
-	return bond_ip_hash(hash, &flow);
+	return bond_ip_hash(hash, &flow, BOND_XMIT_POLICY_LAYER34);
 }
 
 static struct net_device *__bond_sk_get_lower_dev(struct bonding *bond,
-- 
2.35.1

