Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C478141D0
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfEESRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbfEESRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 14:17:17 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C70FB20644;
        Sun,  5 May 2019 18:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557080236;
        bh=f5UTt53/hiC1ATkmjmeJpnLDBqFmgKMrcq12M7JKY/w=;
        h=From:To:Cc:Subject:Date:From;
        b=WfUmMEM3vmyLkSSfLP/GFP0pZhA2YtD7k97krKJmZr0rdjgrSnn3TdzqcnrTh/cs5
         bxS2euUltISlWZaUtPdjn6YyOaWpVI+ftpSY8BEph41nPcKkhLWgwdqjQ9LTCgpSgV
         lLJtCp9USs+y4JvHDVubxBQrbzKART2tusyFALuU=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled
Date:   Sun,  5 May 2019 11:16:20 -0700
Message-Id: <20190505181620.12220-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Define __ipv4_neigh_lookup_noref to return NULL when CONFIG_INET is disabled.

Fixes: 4b2a2bfeb3f0 ("neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/arp.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/net/arp.h b/include/net/arp.h
index 977aabfcdc03..c8f580a0e6b1 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -18,6 +18,7 @@ static inline u32 arp_hashfn(const void *pkey, const struct net_device *dev, u32
 	return val * hash_rnd[0];
 }
 
+#ifdef CONFIG_INET
 static inline struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev, u32 key)
 {
 	if (dev->flags & (IFF_LOOPBACK | IFF_POINTOPOINT))
@@ -25,6 +26,13 @@ static inline struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev
 
 	return ___neigh_lookup_noref(&arp_tbl, neigh_key_eq32, arp_hashfn, &key, dev);
 }
+#else
+static inline
+struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev, u32 key)
+{
+	return NULL;
+}
+#endif
 
 static inline struct neighbour *__ipv4_neigh_lookup(struct net_device *dev, u32 key)
 {
-- 
2.11.0

