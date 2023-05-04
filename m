Return-Path: <netdev+bounces-399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B31936F75D2
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DCF71C214CF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028E711C9D;
	Thu,  4 May 2023 19:47:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E3211C96
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F8AC4339E;
	Thu,  4 May 2023 19:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229622;
	bh=rBaENMPcYH9khGCnR9G8YZifplk6iDBMO+D/7Fp0kkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2GAaN8uS9LASk+7hqDtxroBxlHyf+aytQQquk837rHHXtW2yyQcQ8TGW8GKK+8uK
	 qjfxQ9WAC95Q2AvwPZtMSYylqc8Jd0kerqSoW88muqSWsY0ItGq70d64Tksop2ukaw
	 vcHtAsYe4fF+HWG+A4KNglTopgh4iKtaCJpiubNGraF/1lPC9jRMWRwXe3rLtwEIJ1
	 8NP4Y/4CI0fRBIXiKPCO1vNbhEC3MKBziot8QyMLzr1z2PI69SAHz1a5GyfRGBuFL3
	 vSTjJ0kfC1Tgh00ecH5FTF9kLeJr/K+F3JyHK0b7TrsL3PdAg/bIle18u9aA9iufn+
	 7xHvQrsvGfa+g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Nick Child <nnac123@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 13/49] netdev: Enforce index cap in netdev_get_tx_queue
Date: Thu,  4 May 2023 15:45:50 -0400
Message-Id: <20230504194626.3807438-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194626.3807438-1-sashal@kernel.org>
References: <20230504194626.3807438-1-sashal@kernel.org>
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

[ Upstream commit 1cc6571f562774f1d928dc8b3cff50829b86e970 ]

When requesting a TX queue at a given index, warn on out-of-bounds
referencing if the index is greater than the allocated number of
queues.

Specifically, since this function is used heavily in the networking
stack use DEBUG_NET_WARN_ON_ONCE to avoid executing a new branch on
every packet.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Link: https://lore.kernel.org/r/20230321150725.127229-2-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b072449b0f1ac..eac51e22a52a8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2428,6 +2428,7 @@ static inline
 struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
 					 unsigned int index)
 {
+	DEBUG_NET_WARN_ON_ONCE(index >= dev->num_tx_queues);
 	return &dev->_tx[index];
 }
 
-- 
2.39.2


