Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC0F39F31
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfFHLkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbfFHLkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29082214DA;
        Sat,  8 Jun 2019 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994012;
        bh=9OHKxlOu0OcMXy6Rvg73TkXgsUQWNl1t0sYS7fFm8y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3SxtI+eR6H01Hc7lVWk0CEbe/CGUlK37Qry0W0RhmW5Cf3kxZL+Z/xs0cSo/UIy6
         kCzrEGUDaWHAyOlBbfLdO5JiEKRGLAAVCntuM+wq9DO/SjqMcplsu7x25Z1H/jIJcX
         ITulAjMMDL0Gaw4w4kNRDApNNaGFSSsP788yTZS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Marc Haber <mh+netdev@zugschlus.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 15/70] netfilter: nat: fix udp checksum corruption
Date:   Sat,  8 Jun 2019 07:38:54 -0400
Message-Id: <20190608113950.8033-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6bac76db1da3cb162c425d58ae421486f8e43955 ]

Due to copy&paste error nf_nat_mangle_udp_packet passes IPPROTO_TCP,
resulting in incorrect udp checksum when payload had to be mangled.

Fixes: dac3fe72596f9 ("netfilter: nat: remove csum_recalc hook")
Reported-by: Marc Haber <mh+netdev@zugschlus.de>
Tested-by: Marc Haber <mh+netdev@zugschlus.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index ccc06f7539d7..53aeb12b70fb 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -170,7 +170,7 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 	if (!udph->check && skb->ip_summed != CHECKSUM_PARTIAL)
 		return true;
 
-	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_TCP,
+	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_UDP,
 			   udph, &udph->check, datalen, oldlen);
 
 	return true;
-- 
2.20.1

