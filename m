Return-Path: <netdev+bounces-10149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA7A72C8C7
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 694362811CD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928FC1B8ED;
	Mon, 12 Jun 2023 14:38:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861551B8E8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:38:44 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7113AEC
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:38:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 2B8EB22809;
	Mon, 12 Jun 2023 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686580720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C2k24IeuiVQYdJQsI/9NOx3TxeJ/ljqB1XUVmlBNT/4=;
	b=R0cDlkmbUWlIDzGjzuDQHgJoUfZdgNtIdLDZxWoCREougNEEnaIaonvMEJ3Ejq7FLkNiUW
	SZiqMBlG+qrxJ9uUeTZwKfkYH/m8qdSsDTU/XgkXpMgGu2e28rUbfXFucFTvGfFzTpPuX+
	nNFIBNr0OW+KJtUi+5m+rd50Qxoglw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686580720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C2k24IeuiVQYdJQsI/9NOx3TxeJ/ljqB1XUVmlBNT/4=;
	b=mplbfpxChyP9ketW9EONBQVPhvb/fBfpsSIu/a6QX7AwOoqOugGD9qgmeAt3FRgoymS46r
	R/rloCoYJGRVH0CQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id E094D2C143;
	Mon, 12 Jun 2023 14:38:39 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id C00CC51C4CB7; Mon, 12 Jun 2023 16:38:39 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/4] net/tls: fixes for NVMe-over-TLS
Date: Mon, 12 Jun 2023 16:38:29 +0200
Message-Id: <20230612143833.70805-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
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

Hi all,

here are some small fixes to get NVMe-over-TLS up and running.
The first two are just minor modifications to have MSG_EOR handled
for TLS, but the third implements the ->read_sock() callback for tls_sw
and I guess could do with some reviews.

As usual, comments and reviews are welcome.

Changes to the original submission:
- Add a testcase for MSG_EOR handling

Changes to v2:
- Bail out on conflicting message flags
- Rework flag handling

Hannes Reinecke (4):
  net/tls: handle MSG_EOR for tls_sw TX flow
  net/tls: handle MSG_EOR for tls_device TX flow
  net/tls: implement ->read_sock()
  selftests/net/tls: add test for MSG_EOR

 net/tls/tls.h                     |  2 +
 net/tls/tls_device.c              | 24 +++++++--
 net/tls/tls_main.c                |  2 +
 net/tls/tls_sw.c                  | 88 +++++++++++++++++++++++++++++--
 tools/testing/selftests/net/tls.c | 11 ++++
 5 files changed, 120 insertions(+), 7 deletions(-)

-- 
2.35.3


