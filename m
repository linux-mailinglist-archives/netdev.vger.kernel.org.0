Return-Path: <netdev+bounces-8164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE87722F11
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAE9D1C20D43
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C28B23D4F;
	Mon,  5 Jun 2023 19:01:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6323820EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41C6C433EF;
	Mon,  5 Jun 2023 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685991670;
	bh=Htlnq5V6KaRjMvA/0Vth5Zw4m09LdLWdVGS/WYIH8GA=;
	h=From:To:Cc:Subject:Date:From;
	b=Og4jDFngRfVS8UkQBNwLsr6099iT5GHaMF4OiY4DfisOIgSmd394y/AHcSSRJNgNJ
	 Nv/Ika/YNLZrDKSo2hpWfHt6yDRKRIrHCKMLMfuGl+olMSXsBWo7wDAmDrBYW/JKUM
	 q/KhLvk2Cm7vquNhEJVtCLYWiIqaewDXHGdmUNEmOXentmX67LrZ6E4mnwo5oQxO/t
	 BvQ6WaUAlg8OGhjJ8/eJEhl3MZqj8xHE9y3zcovH+RMpN8M1RoveG40SWFFICtgy31
	 DO1Pa+17F/9J8TBWcLn6+5Nh5qg5aAucy8OWe3KfCtT9aIj3HUq7wvRQUAEDxdyy6J
	 4vHzNSpTbVm6Q==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	simon.horman@corigine.com,
	sdf@google.com,
	willemdebruijn.kernel@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/4] tools: ynl: user space C
Date: Mon,  5 Jun 2023 12:01:04 -0700
Message-Id: <20230605190108.809439-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the code gen which is already in tree to generate a user space
library for a handful of simple families. I find YNL C quite useful
in some WIP projects, and I think others may find it useful, too.
I was hoping someone will pick this work up and finish it...
but it seems that Python YNL has largely stolen the thunder.
Python may not be great for selftest, tho, and actually this lib
is more fully-featured. The Python script was meant as a quick demo,
funny how those things go.

v3:
 - change the C standard s/gnu99/gnu11/ 
v2: https://lore.kernel.org/all/20230604175843.662084-1-kuba@kernel.org/
 - fix kdoc on patch 2
v1: https://lore.kernel.org/all/20230603052547.631384-1-kuba@kernel.org/

Jakub Kicinski (4):
  tools: ynl-gen: clean up stray new lines at the end of reply-less
    requests
  tools: ynl: user space helpers
  tools: ynl: support fou and netdev in C
  tools: ynl: add sample for netdev

 .../userspace-api/netlink/intro-specs.rst     |  79 ++
 tools/net/ynl/Makefile                        |  19 +
 tools/net/ynl/generated/Makefile              |  45 +
 tools/net/ynl/generated/fou-user.c            | 340 +++++++
 tools/net/ynl/generated/fou-user.h            | 337 +++++++
 tools/net/ynl/generated/netdev-user.c         | 250 +++++
 tools/net/ynl/generated/netdev-user.h         |  88 ++
 tools/net/ynl/lib/Makefile                    |  28 +
 tools/net/ynl/lib/ynl.c                       | 901 ++++++++++++++++++
 tools/net/ynl/lib/ynl.h                       | 237 +++++
 tools/net/ynl/samples/.gitignore              |   1 +
 tools/net/ynl/samples/Makefile                |  28 +
 tools/net/ynl/samples/netdev.c                | 108 +++
 tools/net/ynl/ynl-gen-c.py                    |   7 +-
 tools/net/ynl/ynl-regen.sh                    |   2 +-
 15 files changed, 2466 insertions(+), 4 deletions(-)
 create mode 100644 tools/net/ynl/Makefile
 create mode 100644 tools/net/ynl/generated/Makefile
 create mode 100644 tools/net/ynl/generated/fou-user.c
 create mode 100644 tools/net/ynl/generated/fou-user.h
 create mode 100644 tools/net/ynl/generated/netdev-user.c
 create mode 100644 tools/net/ynl/generated/netdev-user.h
 create mode 100644 tools/net/ynl/lib/Makefile
 create mode 100644 tools/net/ynl/lib/ynl.c
 create mode 100644 tools/net/ynl/lib/ynl.h
 create mode 100644 tools/net/ynl/samples/.gitignore
 create mode 100644 tools/net/ynl/samples/Makefile
 create mode 100644 tools/net/ynl/samples/netdev.c

-- 
2.40.1


