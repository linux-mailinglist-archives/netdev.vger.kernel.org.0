Return-Path: <netdev+bounces-10150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9409472C8C8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DD692811B4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5851C747;
	Mon, 12 Jun 2023 14:38:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12921C742
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:38:44 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707B9D2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:38:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 2979922807;
	Mon, 12 Jun 2023 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686580720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UnoDd1ud8H0idMsQDGdSV9a0/2M3xPxf+OAC9kFme/U=;
	b=TnkXIxB/OSXqVHqH15krrp6iQM5cql7frcztU13RFgC8knD3ApJjQLirsc+ImDy3zNeMVs
	UiiOmCKQ+gPo0lQNCbqu0q1cdiRZImfQl/WSsbPxp3BjV5C8P24LPOjftj6KHtiMT4rpGv
	oR+p3ld9vfp/grtjX+ejyOGBfNJ3BTY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686580720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UnoDd1ud8H0idMsQDGdSV9a0/2M3xPxf+OAC9kFme/U=;
	b=ZWflSIEhbOKa7kKx8R2OCl2VAFbAiBAgaI58KbzupxnNO2W07Rovp2z8V7uoupcrypeXpt
	mTphTwwfQJHj5bAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id 002732C146;
	Mon, 12 Jun 2023 14:38:39 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id DF00C51C4CBF; Mon, 12 Jun 2023 16:38:39 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] selftests/net/tls: add test for MSG_EOR
Date: Mon, 12 Jun 2023 16:38:33 +0200
Message-Id: <20230612143833.70805-5-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230612143833.70805-1-hare@suse.de>
References: <20230612143833.70805-1-hare@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As the recent patch is modifying the behaviour for TLS re MSG_EOR
handling we should be having a test for it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 tools/testing/selftests/net/tls.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e699548d4247..c1cd1446c7e2 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -476,6 +476,17 @@ TEST_F(tls, msg_more_unsent)
 	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_DONTWAIT), -1);
 }
 
+TEST_F(tls, msg_eor)
+{
+	char const *test_str = "test_read";
+	int send_len = 10;
+	char buf[10];
+
+	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_EOR), send_len);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_WAITALL), send_len);
+	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
+}
+
 TEST_F(tls, sendmsg_single)
 {
 	struct msghdr msg;
-- 
2.35.3


