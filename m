Return-Path: <netdev+bounces-9661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0953F72A249
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59B171C2110E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479AE1427F;
	Fri,  9 Jun 2023 18:32:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5BD21CE0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD1BC433D2;
	Fri,  9 Jun 2023 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686335531;
	bh=qRPz1M5fT8BnFhIvgVRsjl79zE8OdVmAmnBI1IOqkOs=;
	h=From:To:Cc:Subject:Date:From;
	b=AYFWXj83lSXIvoAFbrGEbweJnXXPb2TVsVTbv7iI0DwibNV8OVtekOuw6fOZk7tX2
	 khiClRDDHU0nBSKT0o/aQSnedz+cgt2xRk/h7DrJ+kUv5JMKBqaROSnSvqqwc7KV9B
	 zIZXrlKEvUn5JtkT827WT3B9YjnFtzZzJhYfN5C0M5pI7ukxsinIaNbCK+MVtsLVrT
	 UrjUZUBG3CgpqWppr2Ua2HL2mcnYviepE806XZF14onJp497CJYxiFtAS5h8t4bNhY
	 zQRs+Dxn/eKTEnvt7k1ypfyOmf34vapDuLiujLbjt64NWYWuCGGXkRiioDuPLPzzbJ
	 CEGZPU70+cZyg==
From: Jakub Kicinski <kuba@kernel.org>
To: edumazet@google.com
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	dsahern@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] net: create device lookup API with reference tracking
Date: Fri,  9 Jun 2023 11:32:05 -0700
Message-Id: <20230609183207.1466075-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We still see dev_hold() / dev_put() calls without reference tracker
getting added in the new code. dev_get_by_name() / dev_get_by_index()
seem to be one of the sources of those. Provide appropriate helpers.
Allocating the tracker can obviously be done with an additional call
to netdev_tracker_alloc(), but a single API feels cleaner.

Eric, LMK if you prefer to keep the current flow, maybe it's just me.

Jakub Kicinski (2):
  net: create device lookup API with reference tracking
  netpoll: allocate netdev tracker right away

 include/linux/netdevice.h |  4 +++
 net/core/dev.c            | 75 ++++++++++++++++++++++++++-------------
 net/core/netpoll.c        |  5 ++-
 net/ethtool/netlink.c     |  8 ++---
 net/ipv6/route.c          | 12 +++----
 5 files changed, 67 insertions(+), 37 deletions(-)

-- 
2.40.1


