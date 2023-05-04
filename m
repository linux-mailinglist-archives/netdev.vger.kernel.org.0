Return-Path: <netdev+bounces-378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 114716F7502
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472E11C2143E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197E413AE3;
	Thu,  4 May 2023 19:45:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C8E13ADB
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD7EC433D2;
	Thu,  4 May 2023 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229499;
	bh=2+TVHQ0x7JBkdhdD8gcqJKqlfWReNNJ0PvWqGtk0d9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn/Bkh3/nAd/ZC9D3y2taSH5Q7dCGltkohtUZafSVfd3cryRPEkLSZyb+lwJHqVeJ
	 VSocJH7kCco0nfWCgVFGBXbI0LMIJWqYY8YYqGSvGWVmxmK15NGwzgXWNjqNNPE+LG
	 AmcQEi9DRH2lyiSC8d2KvmeKman9kDEWqeiBdc3M2iqp3/dbLcOC/m2DRSKf9UzMZu
	 M9YHpITREITasIio6/BH8G0mbWnJk0pFzP1DDqwGfb6PIMUXu0REd80tI40FtiAy0/
	 GB//XvE/Di0AJma6HPDYbIwzgbdIDXeSOgQdmLf16c8yOs/EiJ544UrBVvG58ANI99
	 TeqFF6qNDPXXw==
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
Subject: [PATCH AUTOSEL 6.2 15/53] netdev: Enforce index cap in netdev_get_tx_queue
Date: Thu,  4 May 2023 15:43:35 -0400
Message-Id: <20230504194413.3806354-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194413.3806354-1-sashal@kernel.org>
References: <20230504194413.3806354-1-sashal@kernel.org>
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
index 84668547fee63..138cb4d552e73 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2445,6 +2445,7 @@ static inline
 struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
 					 unsigned int index)
 {
+	DEBUG_NET_WARN_ON_ONCE(index >= dev->num_tx_queues);
 	return &dev->_tx[index];
 }
 
-- 
2.39.2


