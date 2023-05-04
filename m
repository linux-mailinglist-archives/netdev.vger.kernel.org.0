Return-Path: <netdev+bounces-447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 861006F76D1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40D23280D43
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E9F719BAB;
	Thu,  4 May 2023 19:51:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E9019BA6
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A87EC433A0;
	Thu,  4 May 2023 19:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229909;
	bh=UPXs4s2DT25fIy4+DRbTtgc7cmejTYlS1uDyKUb3Jw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHbONe6dYvrzLQXgUDSFAnVOAKaudaOnw+qI2JvnX+eX6Q8AGJJWHiWU20+5vpeea
	 DCjSztweyp5wwFrPPbNtD9oBdV5oUAOuAWQHS4xGtgfsFiG6Tq4CXDfzB0Vq5tLqZr
	 Brd8FYTlXWooQl94mB2+CuTfUA9EyxAZ2bCbQb5JajLz6Ei02TX2g5B683313W3MHV
	 cQg3Ds1sV8E8LaLg7XwfGsrMoGIhhRwdseNluRkNjVjx/dzh1pawBPB/jCoxhe8685
	 tWoph03ZAcICDOXQx08evNQs6Fc8AQxmajwgP6JEPkXUTWiKpHYr29Sfqb+u74r5sE
	 D2KRogz2XGsJQ==
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
Subject: [PATCH AUTOSEL 4.19 05/13] net: Catch invalid index in XPS mapping
Date: Thu,  4 May 2023 15:51:22 -0400
Message-Id: <20230504195132.3808946-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504195132.3808946-1-sashal@kernel.org>
References: <20230504195132.3808946-1-sashal@kernel.org>
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
index b778f35965433..03903d3f1d695 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2303,6 +2303,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	bool active = false;
 	unsigned int nr_ids;
 
+	WARN_ON_ONCE(index >= dev->num_tx_queues);
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.39.2


