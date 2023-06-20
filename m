Return-Path: <netdev+bounces-12177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3ED736942
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8F0280E8B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E096C101C8;
	Tue, 20 Jun 2023 10:29:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2620FC01
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:29:08 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFFF102
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:29:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 052842188B;
	Tue, 20 Jun 2023 10:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1687256945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qtiWsqvyZaCWU0PRWOqBZXRVP/g/OKzx3YKj1ldYBcM=;
	b=dGicWHsDvUifjlA4pY/ZPltQnb4UsKtFcwJ2QVcTFWKE1rRMMeIzvtePqPcPcWAlSPgRuH
	3czwdnVC5CC0d/043kdj9GmA2+0jW/irf481K3v1xSjHGc9w23D0Riv8qOzIhk2ZaMnTZ+
	V3ey8YeO6dMwGeOL8MnFsTdFfUISRfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1687256945;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qtiWsqvyZaCWU0PRWOqBZXRVP/g/OKzx3YKj1ldYBcM=;
	b=iHVwrcQpVSjFm4qFNPx5IpeKhyWIudn3B1rR2O9jWl1LjuFTHaakMvvnpxSxBts5f9Mx4i
	m3nMGr2fEE42o9DQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id D37692C141;
	Tue, 20 Jun 2023 10:29:04 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id BFC6551C51F7; Tue, 20 Jun 2023 12:29:04 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 0/4] net/tls: fixes for NVMe-over-TLS
Date: Tue, 20 Jun 2023 12:28:52 +0200
Message-Id: <20230620102856.56074-1-hare@suse.de>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,

here are some small fixes to get NVMe-over-TLS up and running.
The first thre are just minor modifications to have MSG_EOR handled
for TLS (and adding a test for it), but the last implements the
->read_sock() callback for tls_sw and I guess could do with some
reviews.
It does work with my NVMe-TLS test harness, but what do I know :-)

As usual, comments and reviews are welcome.

Changes to the original submission:
- Add a testcase for MSG_EOR handling

Changes to v2:
- Bail out on conflicting message flags
- Rework flag handling

Changes to v3:
- Return -EINVAL on conflicting flags
- Rebase on top of net-next

Changes to v4:
- Add tlx_rx_reader_lock() to read_sock
- Add MSG_EOR handling to tls_sw_readpages()

Hannes Reinecke (4):
  net/tls: handle MSG_EOR for tls_sw TX flow
  net/tls: handle MSG_EOR for tls_device TX flow
  selftests/net/tls: add test for MSG_EOR
  net/tls: implement ->read_sock()

 net/tls/tls.h                     |  2 +
 net/tls/tls_device.c              | 25 +++++++--
 net/tls/tls_main.c                |  2 +
 net/tls/tls_sw.c                  | 87 +++++++++++++++++++++++++++++--
 tools/testing/selftests/net/tls.c | 11 ++++
 5 files changed, 119 insertions(+), 8 deletions(-)

-- 
2.35.3


