Return-Path: <netdev+bounces-190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BB96F5C3F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB2C21C20F5D
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6A0107B9;
	Wed,  3 May 2023 16:51:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B043829A8
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 16:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185EAC433D2;
	Wed,  3 May 2023 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683132691;
	bh=M8lryoUmAA6sx3rYKw65Tn0VGSZTygtu7QyJjJyCR2M=;
	h=From:To:Cc:Subject:Date:From;
	b=CqcfvbitMQjXI0TbP15GGkq9MxZ0huJYF5ZcDKMsEUxPtQd41QKJNhqcF6vX1XxzE
	 vxpzg4UBs7gXTCTCgfmaUyAuxTXz3oYyVcbkibnZt0WcxSa5aCkIpHByBZ7shgltbR
	 aKVlaIjdvV+1sgpsKQHGDes6tc6u1jG2mf9OcIwBf9bcl17mHLhhFo+/IKgYWj8VTg
	 5Zpt58I3Omv4FbYiDwxeo5oT5aFCc4Y45ft5t1p6Y6b/sd2m5RPu3njGJ1meBMwoUy
	 BlN2Qw9mi5hIUGxmZf+Fo/1g3vXR+or054oj2fYqlYVk8XayJQhOI5+HHiFSCuNQ9E
	 vTrKVwvng0eDw==
From: David Ahern <dsahern@kernel.org>
To: mkubecek@suse.cz
Cc: netdev@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH ethtool] rxclass: Fix return code in rxclass_rule_ins
Date: Wed,  3 May 2023 10:51:06 -0600
Message-Id: <20230503165106.9584-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ethtool is not exiting non-0 when -N fails. e.g.,

$ sudo ethtool -N eth0 flow-type tcp4 src-ip 1.2.3.4 action 3 loc 1023
rmgr: Cannot insert RX class rule: No such device
$ echo $?
0

Update rxclass_rule_ins to return err.

Fixes: 8d63f72ccdcb ("Add RX packet classification interface")
Cc: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 rxclass.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rxclass.c b/rxclass.c
index 6cf81fdafc85..66cf00ba7728 100644
--- a/rxclass.c
+++ b/rxclass.c
@@ -598,7 +598,7 @@ int rxclass_rule_ins(struct cmd_context *ctx,
 	else if (loc & RX_CLS_LOC_SPECIAL)
 		printf("Added rule with ID %d\n", nfccmd.fs.location);
 
-	return 0;
+	return err;
 }
 
 int rxclass_rule_del(struct cmd_context *ctx, __u32 loc)
-- 
2.25.1

