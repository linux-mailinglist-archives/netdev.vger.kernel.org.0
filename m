Return-Path: <netdev+bounces-10252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B4172D380
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E4031C20BEC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFC82341C;
	Mon, 12 Jun 2023 21:49:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F5022D60
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CC3C433D2;
	Mon, 12 Jun 2023 21:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686606590;
	bh=IJihOlmWMddOykv9Y5at7DU8A+a+FtVTvPEcmiTR1Pg=;
	h=From:To:Cc:Subject:Date:From;
	b=WtiNeuyuXNp1PIMUstC00GdTneG7JCSu02QTsW2dm+4Wd7nlpNUOhEmfTn1t5hf2R
	 YZGOZx3kzMQdFPpEew2Lrb0ZPUIyE6d7EzHQnLQDeTtj+DjMM9SHxX6HuU7qa16uv2
	 ZbXwMqA8PUn18BspMbpeDm3Iz7jonHYvCntnuGqZ8/8KB7WRCSTeGbFbrCTkboiPZv
	 xzl6mQBg3wMYULnP7EtahmD18QOBNofcrwt3zmbx2nj2+aejUXUMAOMXRBaLyyZZCD
	 LF8c/qbhPPO08LqkNFMZd9jHKGBr4yL//o/d/1rKWw6uQNXv5bNOs2VaJ//P/dx4nF
	 2QSigYmZuBY9w==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/2] net: create device lookup API with reference tracking
Date: Mon, 12 Jun 2023 14:49:42 -0700
Message-Id: <20230612214944.1837648-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We still see dev_hold() / dev_put() calls without reference tracker
getting added in new code. dev_get_by_name() / dev_get_by_index()
seem to be one of the sources of those. Provide appropriate helpers.
Allocating the tracker can obviously be done with an additional call
to netdev_tracker_alloc(), but a single API feels cleaner.

v2:
 - fix a dev_put() in ethtool
v1: https://lore.kernel.org/all/20230609183207.1466075-1-kuba@kernel.org/

Jakub Kicinski (2):
  net: create device lookup API with reference tracking
  netpoll: allocate netdev tracker right away

 include/linux/netdevice.h |  4 +++
 net/core/dev.c            | 75 ++++++++++++++++++++++++++-------------
 net/core/netpoll.c        |  5 ++-
 net/ethtool/netlink.c     | 10 +++---
 net/ipv6/route.c          | 12 +++----
 5 files changed, 68 insertions(+), 38 deletions(-)

-- 
2.40.1


