Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1712B9BD
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfL0SHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:07:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbfL0SCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:02:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 978B121775;
        Fri, 27 Dec 2019 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469752;
        bh=Axm9hXdZ97HQ91q0zUCS0GRR7u5ItH7c2RXBxanXijs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6p4xwwHAYNWjZax/UlOpS8fdyMwr5sKhdnboQ9ROu05n+KLvPWLm93wd7Nl2EyMX
         EbUjY4bl8PNvKYewBPXm7Mo2eEgKhUe0GN4xHhJl4zm78c5uWQJStoWy/ZeuFcWq4M
         nvmFiyeaRAE31dzdQ/SB8A//S/MKjnAjeVIyUDFU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Oliverio <marco.oliverio@tanaza.com>,
        Rocco Folino <rocco.folino@tanaza.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/57] netfilter: nf_queue: enqueue skbs with NULL dst
Date:   Fri, 27 Dec 2019 13:01:32 -0500
Message-Id: <20191227180222.7076-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Oliverio <marco.oliverio@tanaza.com>

[ Upstream commit 0b9173f4688dfa7c5d723426be1d979c24ce3d51 ]

Bridge packets that are forwarded have skb->dst == NULL and get
dropped by the check introduced by
b60a77386b1d4868f72f6353d35dabe5fbe981f2 (net: make skb_dst_force
return true when dst is refcounted).

To fix this we check skb_dst() before skb_dst_force(), so we don't
drop skb packet with dst == NULL. This holds also for skb at the
PRE_ROUTING hook so we remove the second check.

Fixes: b60a77386b1d ("net: make skb_dst_force return true when dst is refcounted")
Signed-off-by: Marco Oliverio <marco.oliverio@tanaza.com>
Signed-off-by: Rocco Folino <rocco.folino@tanaza.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 37efcc1c8887..b06ef4c62522 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -138,7 +138,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
-	if (!skb_dst_force(skb) && state->hook != NF_INET_PRE_ROUTING) {
+	if (skb_dst(skb) && !skb_dst_force(skb)) {
 		status = -ENETDOWN;
 		goto err;
 	}
-- 
2.20.1

