Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D3A8C937
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfHNChb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbfHNCMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9194620842;
        Wed, 14 Aug 2019 02:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748763;
        bh=A4y1ARP/e8BbnlPNPU2pwntKCCChXAtXGo+CGADsbV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdovAA/itkTWZxWQCPYFDuXETfTU6cPhdCVX4O5DidU6rrIB1e2C7HHg+jIww5827
         7aaYJK9uRrC52w0LZW0JRiwaoYHrL7pwwDmo102UCpvMFEvMBSUgCWQFt4U3LSSqPL
         OznNCav7okOeQXqrqCCZ6WCrWohOXi//z7HOi77k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, Chen Yi <yiche@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 055/123] netfilter: ipset: Actually allow destination MAC address for hash:ip,mac sets too
Date:   Tue, 13 Aug 2019 22:09:39 -0400
Message-Id: <20190814021047.14828-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit b89d15480d0cacacae1a0fe0b3da01b529f2914f ]

In commit 8cc4ccf58379 ("ipset: Allow matching on destination MAC address
for mac and ipmac sets"), ipset.git commit 1543514c46a7, I removed the
KADT check that prevents matching on destination MAC addresses for
hash:mac sets, but forgot to remove the same check for hash:ip,mac set.

Drop this check: functionality is now commented in man pages and there's
no reason to restrict to source MAC address matching anymore.

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_ipmac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index faf59b6a998fe..eb14434083203 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -89,10 +89,6 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_ipmac4_elem e = { .ip = 0, { .foo[0] = 0, .foo[1] = 0 } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	 /* MAC can be src only */
-	if (!(opt->flags & IPSET_DIM_TWO_SRC))
-		return 0;
-
 	if (skb_mac_header(skb) < skb->head ||
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
-- 
2.20.1

