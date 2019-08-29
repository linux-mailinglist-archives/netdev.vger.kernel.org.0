Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5278A173A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfH2Kuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbfH2Kuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CE2E2341B;
        Thu, 29 Aug 2019 10:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075834;
        bh=16fTqFdG9M6Y56zMIAUmBN+BNC2ON1gMz7VKsrMtRFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZasuvFj07H2Ibug+zXTjiSK56l0voJTwT3mQasMiq5MSF/B0KPAc3QgRBThCiXEd
         aorFFL//OUT/hy5ecfEgCyX3ZFQVVXCbdn9Eo2X8BJMr/bPbjCe3LdR4oDEoQx4iIM
         cm232DrWVY3pdUis8B6lLZy2ODPLxaBT1FehNdgY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, Chen Yi <yiche@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/29] netfilter: ipset: Actually allow destination MAC address for hash:ip,mac sets too
Date:   Thu, 29 Aug 2019 06:50:01 -0400
Message-Id: <20190829105009.2265-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
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
index fd87de3ed55b3..75c21c8b76514 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -95,10 +95,6 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
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

