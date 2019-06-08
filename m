Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C920339EE9
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfFHLrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbfFHLqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:46:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BBB62168B;
        Sat,  8 Jun 2019 11:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994411;
        bh=nSqYJfl3Uq/zPFW2AfQZzQeuHfLrwlL8BNpdW0P80Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwLWCjx0RKNZ3qrRtUfeUlwYKCV6uu1qoVPYur2oUD28+L6n1fCcRphksA7PZqyvX
         jMkD/dVj6vbSuZoR8xupq00KaJ67ywqr3aApzzvoY9BRlkpqYeQK+u9wuened9A1Al
         ASRdPN2ompHcoq/yQ856dYbh2zeD63oee67v1yVQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jagdish Motwani <jagdish.motwani@sophos.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/31] netfilter: nf_queue: fix reinject verdict handling
Date:   Sat,  8 Jun 2019 07:46:14 -0400
Message-Id: <20190608114646.9415-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114646.9415-1-sashal@kernel.org>
References: <20190608114646.9415-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jagdish Motwani <jagdish.motwani@sophos.com>

[ Upstream commit 946c0d8e6ed43dae6527e878d0077c1e11015db0 ]

This patch fixes netfilter hook traversal when there are more than 1 hooks
returning NF_QUEUE verdict. When the first queue reinjects the packet,
'nf_reinject' starts traversing hooks with a proper hook_index. However,
if it again receives a NF_QUEUE verdict (by some other netfilter hook), it
queues the packet with a wrong hook_index. So, when the second queue
reinjects the packet, it re-executes hooks in between.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")
Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index f7e21953b1de..8260b1e73bbd 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -193,6 +193,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 repeat:
 		verdict = nf_hook_entry_hookfn(hook, skb, state);
 		if (verdict != NF_ACCEPT) {
+			*index = i;
 			if (verdict != NF_REPEAT)
 				return verdict;
 			goto repeat;
-- 
2.20.1

