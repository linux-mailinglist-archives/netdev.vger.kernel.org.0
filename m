Return-Path: <netdev+bounces-453-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9DD66F76DF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16E741C20CBE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793D7F51A;
	Thu,  4 May 2023 19:52:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF7F1952F
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C731C4339C;
	Thu,  4 May 2023 19:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229944;
	bh=EDJ8xgwfZmJvZP/oI0VldhPcP6EQrhu6jfQi+R/yZhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8AARW1ycx1Gg/7v949706hN4B4J9LusE1nUtPP/txW/NjOIl50H8ztC8r+zFMNoa
	 CBpHL8Ox4Ws+IkgvtXD1hWKijzZl3E7sljMbF9QmnJDjZ+PIprrtQqMBNfdD5bshPL
	 VbIE1DDiXDmvGp/vXf0Xd8u5mdTtxrTopgMSpv1uVA9znOcjLAUrMX2U+FbiWgEtQK
	 79r3apbSq4xBgEAcSNXhgvoIvwk3dPCMj6Ue6a7mDb0OnMOawhKsssINTcjdz0aOV4
	 05Rl5tiHUFiJJQgi1yiQ9H0vADZ25QoH4oYC8E+1nMqVht87zeS0Bf4UvqyR48vEwT
	 m+dTefCzQuYmA==
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
Subject: [PATCH AUTOSEL 4.14 05/13] net: Catch invalid index in XPS mapping
Date: Thu,  4 May 2023 15:51:57 -0400
Message-Id: <20230504195207.3809116-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504195207.3809116-1-sashal@kernel.org>
References: <20230504195207.3809116-1-sashal@kernel.org>
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
index 86f762a1cf7ac..a4d68da682322 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2165,6 +2165,8 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 	struct xps_map *map, *new_map;
 	bool active = false;
 
+	WARN_ON_ONCE(index >= dev->num_tx_queues);
+
 	if (dev->num_tc) {
 		num_tc = dev->num_tc;
 		tc = netdev_txq_to_tc(dev, index);
-- 
2.39.2


