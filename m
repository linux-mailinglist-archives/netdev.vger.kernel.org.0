Return-Path: <netdev+bounces-418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52DA36F768E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59EF81C21363
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF67B17AAD;
	Thu,  4 May 2023 19:48:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2F517AAC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68CDC4339E;
	Thu,  4 May 2023 19:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229730;
	bh=ap9ES+0J9zF9fx9c4TX8dKCjJ0YlaLD8/Kl/HGurlRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNsOgYe7ybTEr/Uosx539mc+VC0p8loKZcNt/8swnsuzqEVyniwmVievmRjRoIzZ/
	 GDV8fibSsCc3dGtKEjZOF7L3Bgogg4u4rVXW4PxqzGDWkzIbkwSSA+bSNgshUoEWLu
	 UZQUsZ8pmRdJQCs8yyB5PbzhZY/sAXnu/jp/kcwvtTAbb5rE585pggVe0cW9z7tSG0
	 NQUC//kgVrAUBpY1KAAdat+SEunhpZS7tvHiYknEzRSBSlR09ebHu5RzL4jxGzOw4R
	 Kh9VbJWD4Sy/2DiMOZq+b767tgHCnr0Ft3ht4fOLo0m5hix8NOM/he73mKyiiEXpkF
	 ccT3ls2gtzy4g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Nick Child <nnac123@linux.ibm.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	kuniyu@amazon.com,
	liuhangbin@gmail.com,
	jiri@resnulli.us,
	andy.ren@getcruise.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/30] net: Catch invalid index in XPS mapping
Date: Thu,  4 May 2023 15:48:02 -0400
Message-Id: <20230504194824.3808028-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194824.3808028-1-sashal@kernel.org>
References: <20230504194824.3808028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 5dd0dfd55baec0742ba8f5625a0dd064aca7db16 ]

When setting the XPS value of a TX queue, warn the user once if the
index of the queue is greater than the number of allocated TX queues.

Previously, this scenario went uncaught. In the best case, it resulted
in unnecessary allocations. In the worst case, it resulted in
out-of-bounds memory references through calls to `netdev_get_tx_queue(
dev, index)`. Therefore, it is important to inform the user but not
worth returning an error and risk downing the netdevice.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Link: https://lore.kernel.org/r/20230321150725.127229-1-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7fc8ae7f3cd5b..5c1cd25e851c7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2574,6 +2574,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	struct xps_map *map, *new_map;
 	unsigned int nr_ids;
 
+	WARN_ON_ONCE(index >= dev->num_tx_queues);
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.39.2


