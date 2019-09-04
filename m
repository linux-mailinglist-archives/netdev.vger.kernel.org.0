Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96651A8C3F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732892AbfIDQLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732006AbfIDQA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75EC42341E;
        Wed,  4 Sep 2019 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612828;
        bh=8OfmWXLfzPUy31L8L3yXbaG3s9YW31QmNCHxQ4GyPOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKBAFr4vd1BMLJlEywTMKbstSC9hwXq37nNBHZtPojTmc58E2VosCd8WEtXx/sjxV
         aDTMHLePiZ8hk7mEa7aRWyXbSsp5VHiJseHS6TjuxOk69TcPovEzs+2D0ihf4z5egB
         xIcBg2s65VGEwMYuCeG7Qdi9AnmSTKgbVj+s/yjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Todd Seidelmann <tseidelmann@linode.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/52] netfilter: ebtables: Fix argument order to ADD_COUNTER
Date:   Wed,  4 Sep 2019 11:59:28 -0400
Message-Id: <20190904160004.3671-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Todd Seidelmann <tseidelmann@linode.com>

[ Upstream commit f20faa06d83de440bec8e200870784c3458793c4 ]

The ordering of arguments to the x_tables ADD_COUNTER macro
appears to be wrong in ebtables (cf. ip_tables.c, ip6_tables.c,
and arp_tables.c).

This causes data corruption in the ebtables userspace tools
because they get incorrect packet & byte counts from the kernel.

Fixes: d72133e628803 ("netfilter: ebtables: use ADD_COUNTER macro")
Signed-off-by: Todd Seidelmann <tseidelmann@linode.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 62ffc989a44a2..7d249afa1466c 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -225,7 +225,7 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 			return NF_DROP;
 		}
 
-		ADD_COUNTER(*(counter_base + i), 1, skb->len);
+		ADD_COUNTER(*(counter_base + i), skb->len, 1);
 
 		/* these should only watch: not modify, nor tell us
 		 * what to do with the packet
@@ -963,8 +963,8 @@ static void get_counters(const struct ebt_counter *oldcounters,
 			continue;
 		counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
 		for (i = 0; i < nentries; i++)
-			ADD_COUNTER(counters[i], counter_base[i].pcnt,
-				    counter_base[i].bcnt);
+			ADD_COUNTER(counters[i], counter_base[i].bcnt,
+				    counter_base[i].pcnt);
 	}
 }
 
@@ -1289,7 +1289,7 @@ static int do_update_counters(struct net *net, const char *name,
 
 	/* we add to the counters of the first cpu */
 	for (i = 0; i < num_counters; i++)
-		ADD_COUNTER(t->private->counters[i], tmp[i].pcnt, tmp[i].bcnt);
+		ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);
 
 	write_unlock_bh(&t->lock);
 	ret = 0;
-- 
2.20.1

