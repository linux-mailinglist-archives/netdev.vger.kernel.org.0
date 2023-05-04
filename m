Return-Path: <netdev+bounces-353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0346A6F73C0
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:46:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 526461C213A8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F612773F;
	Thu,  4 May 2023 19:42:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8120BE7C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EC7C433B0;
	Thu,  4 May 2023 19:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229357;
	bh=vKK2eCpyB6uJ5aOf6LN5RwkQuxnFUtTZC2kmn+oUDEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFdn/dqbu/6HC/0E3VkbVCBbmcQ9VWiZzC/UW1U/gKojfp47+Fi/nKiv73PaCcqau
	 v9wSAuYSmL+bI9nJAwaewrCXfuQDb1DhjodAjUB8AhMyQs9fOrDF0poKfgLNYfQKrU
	 QALd5I3rhitL0WRyHtfnRqzGv9OSeRavq02vJcK4Mi1P4VwJW/0tfmFSeuO8/DHK14
	 7FjA9e7jXBDMBGNDGncrvg/iKEXEPANbOVrGdyLIfsOj+X54lQ0Q75ju/3oIQrZ/31
	 xrlu6ZtCmbIC9qmVl/8CfYoXaY5dcyX6m1BYEWni5TILARVKr7bkzNsCb+mThJe/2z
	 gR1fiydXPVEQA==
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
Subject: [PATCH AUTOSEL 6.3 18/59] netdev: Enforce index cap in netdev_get_tx_queue
Date: Thu,  4 May 2023 15:41:01 -0400
Message-Id: <20230504194142.3805425-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
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
index c35f04f636f15..7db9f960221d3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2463,6 +2463,7 @@ static inline
 struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
 					 unsigned int index)
 {
+	DEBUG_NET_WARN_ON_ONCE(index >= dev->num_tx_queues);
 	return &dev->_tx[index];
 }
 
-- 
2.39.2


