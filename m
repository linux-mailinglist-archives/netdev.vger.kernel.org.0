Return-Path: <netdev+bounces-439-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 725466F76C7
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5194D280E0E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BB6101F7;
	Thu,  4 May 2023 19:51:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7CE111BE
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C42C4339C;
	Thu,  4 May 2023 19:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229861;
	bh=oyC3VBu1GT95DmqeVEJB3ixryq3YgShqX3+9xq4nxTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tq8bOf/omd1tKFI9g2iizIu/P4QU6ZuxWiOkmofW9aoKo4ruDsHRHTcPIsR4hm3v9
	 btHtDiH9PKs7k8uT4DketGmMaJhWVV7UgmFUiCbfWjbrPIHjiAwsrtIcMgzsS4fcfd
	 569/lLFnmYzQtoosgQ5N2CAMWO7T9OeOQi11kPj1xGA0zAO+9dNfihZn82GF0eFsMT
	 Pu+skYLl3wNRJimfaA1B+u70eVxqEgAxSZcpwKiqAPt27maVrKM8DYPtG0Qp1FmRnE
	 a5+2jhnFZIiGEDTmSIyQmeBTvUxfa5yeDfsRr7Q8QxUnoadW8G6N2e1KjIG1UzQqkC
	 BiABXepwBdThQ==
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
Subject: [PATCH AUTOSEL 5.4 06/18] net: Catch invalid index in XPS mapping
Date: Thu,  4 May 2023 15:50:28 -0400
Message-Id: <20230504195042.3808716-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504195042.3808716-1-sashal@kernel.org>
References: <20230504195042.3808716-1-sashal@kernel.org>
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
index 1a4e20c4ba053..2a3b56abd7f47 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2244,6 +2244,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	bool active = false;
 	unsigned int nr_ids;
 
+	WARN_ON_ONCE(index >= dev->num_tx_queues);
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.39.2


