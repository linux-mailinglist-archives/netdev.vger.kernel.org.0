Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53ED9DD1CC
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbfJRWFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbfJRWFw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F98222C6;
        Fri, 18 Oct 2019 22:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436351;
        bh=b/VTm9YJ1NJyWJzB9JlmSk2ByMW0IN3eqaHT/MLyop0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bf/2qEGtvoEcwAf4RRZZYCaYdgKRj1UFxLH5qby1z7AhEg1Y53ERk3vLAX5ftD/au
         vb3s/QLUqRckuocTjrPlE/GHBk13w2d5XRpKpqxezOoz8norSLFEPJnPI7BPxntDuX
         e36qa/KUP9suiQNfpzfoCoaaiaBK0ROQ3y2SnN00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 016/100] netfilter: ipset: Make invalid MAC address checks consistent
Date:   Fri, 18 Oct 2019 18:04:01 -0400
Message-Id: <20191018220525.9042-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 29edbc3ebdb0faa934114f14bf12fc0b784d4f1b ]

Set types bitmap:ipmac and hash:ipmac check that MAC addresses
are not all zeroes.

Introduce one missing check, and make the remaining ones
consistent, using is_zero_ether_addr() instead of comparing
against an array containing zeroes.

This was already done for hash:mac sets in commit 26c97c5d8dac
("netfilter: ipset: Use is_zero_ether_addr instead of static and
memcmp").

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |  3 +++
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 11 ++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 4f01321e793ce..794e0335a8648 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -235,6 +235,9 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
+	if (is_zero_ether_addr(e.ether))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 16ec822e40447..25560ea742d66 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -36,9 +36,6 @@ MODULE_ALIAS("ip_set_hash:ip,mac");
 /* Type specific function prefix */
 #define HTYPE		hash_ipmac
 
-/* Zero valued element is not supported */
-static const unsigned char invalid_ether[ETH_ALEN] = { 0 };
-
 /* IPv4 variant */
 
 /* Member elements */
@@ -104,7 +101,7 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
@@ -140,7 +137,7 @@ hash_ipmac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 	memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -IPSET_ERR_HASH_ELEM;
 
 	return adtfn(set, &e, &ext, &ext, flags);
@@ -220,7 +217,7 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
 
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
@@ -260,7 +257,7 @@ hash_ipmac6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
-	if (ether_addr_equal(e.ether, invalid_ether))
+	if (is_zero_ether_addr(e.ether))
 		return -IPSET_ERR_HASH_ELEM;
 
 	return adtfn(set, &e, &ext, &ext, flags);
-- 
2.20.1

