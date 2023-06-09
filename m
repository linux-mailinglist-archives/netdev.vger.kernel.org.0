Return-Path: <netdev+bounces-9539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E944729AB8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD0831C21040
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88418174D8;
	Fri,  9 Jun 2023 12:53:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E158174C1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:53:11 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F78449C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:52:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 6FE771FDF8;
	Fri,  9 Jun 2023 12:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686315119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0+625xAt/GWNGUnJXNHxbBPosu3ZRwk7r/86eu6Zc3g=;
	b=SYPkffJQy4TukfRwt4mcaSBx5kyHHZPTGAnzFieczmvRc968LARaAWXnuXBDqXWPEFiTrN
	ZOM8+qxjSY7lwzuLdKCOTNsl2c0GOPHVPYYOLsat6Tf3CKU7T1309fjie7omblEjVldRHg
	kA3qKzSv6VWoKHuk7RkC3vCtSDY0Y90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686315119;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0+625xAt/GWNGUnJXNHxbBPosu3ZRwk7r/86eu6Zc3g=;
	b=t7kLopSD4CDcSC6ONrdfLQk2LBiHfPlXmdtnsiXaSIfTrVRhDCH7K9KPvE4UXtyLSeSeK/
	If4IlGHxluWAkqAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id 59B912C142;
	Fri,  9 Jun 2023 12:51:59 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id 4701D51C48BD; Fri,  9 Jun 2023 14:51:59 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/4] net/tls: fixes for NVMe-over-TLS
Date: Fri,  9 Jun 2023 14:51:49 +0200
Message-Id: <20230609125153.3919-1-hare@suse.de>
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
The first two are just minor modifications to have MSG_EOR handled
for TLS, but the third implements the ->read_sock() callback for tls_sw
and I guess could do with some reviews.

As usual, comments and reviews are welcome.

Changes to the original submission:
- Add a testcase for MSG_EOR handling

Hannes Reinecke (4):
  net/tls: handle MSG_EOR for tls_sw TX flow
  net/tls: handle MSG_EOR for tls_device TX flow
  net/tls: implement ->read_sock()
  selftests/net/tls: add test for MSG_EOR

 net/tls/tls.h                     |  2 +
 net/tls/tls_device.c              |  8 ++-
 net/tls/tls_main.c                |  2 +
 net/tls/tls_sw.c                  | 82 +++++++++++++++++++++++++++++--
 tools/testing/selftests/net/tls.c | 11 +++++
 5 files changed, 101 insertions(+), 4 deletions(-)

-- 
2.35.3


