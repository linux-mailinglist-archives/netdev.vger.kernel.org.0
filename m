Return-Path: <netdev+bounces-9259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6CC57284D4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68C09281739
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BAE174D3;
	Thu,  8 Jun 2023 16:23:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1058A171C1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327A7C433EF;
	Thu,  8 Jun 2023 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686241427;
	bh=WEICZEGdDQFJNFpgOBbKbkGhPRAZCQCa+Bjj77ghnuI=;
	h=From:To:Cc:Subject:Date:From;
	b=ras8ZUhlw5G2N07+gmBUK8Khz9qsszlaKxnE9QL5nzzV7HkZORBLVFbFXsXgFTTCv
	 hyrNkEf7LRPZehdAfekGp31Z0E0ZejLyLYoXo3pjE9AzNCgb16sP5coyq+iR/ZUWv3
	 66mFLrs40f6boJiTnbpbHb8HXoHgu0v2CPt6IZF9vB0YuYanxOYIV2g0IEFUAe57+5
	 WMiMN9XtibW6S/PFxH+1MVmpVoXRFxbGU9EOzXqZ/KqXwvoQYT+VnmZLQFaY0PI1rg
	 XxYBzq0FMD+V8NKeToQ/34rxRfWf4DgWcdIUxO2sfCdJWvOMJ5Jna9+AZ0HKE5Gh7a
	 4vmpWLKVRJLTA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: ethtool: correct MAX attribute value for stats
Date: Thu,  8 Jun 2023 09:23:44 -0700
Message-Id: <20230608162344.1210365-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling YNL generated code compiler complains about
array-initializer-out-of-bounds. Turns out the MAX value
for STATS_GRP uses the value for STATS.

This may lead to random corruptions in user space (kernel
itself doesn't use this value as it never parses stats).

Fixes: f09ea6fb1272 ("ethtool: add a new command for reading standard stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool_netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 1ebf8d455f07..73e2c10dc2cc 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -783,7 +783,7 @@ enum {
 
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_GRP_CNT,
-	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
+	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_GRP_CNT - 1)
 };
 
 enum {
-- 
2.40.1


