Return-Path: <netdev+bounces-11277-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C17A7325B5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4A62815C9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 761DF658;
	Fri, 16 Jun 2023 03:12:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196D964D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59976C433C0;
	Fri, 16 Jun 2023 03:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686885176;
	bh=Yh60SXBhgr7aEjrKg+EBAV+IIyJjLlVS8qH8nu661KQ=;
	h=From:To:Cc:Subject:Date:From;
	b=gA6QGeNyvJreziwmz8QJL/wsHXGUmDQGBXvK7Ik/x1N26asR1AcujhaXbME58l5iH
	 DPJLJdLAzlN3jx1zBh5sMsq/h4jSsQTk7wEEQqv+BFLuPRHmEfeEZ/KX9iUtOFqLsM
	 BKtBKFc07gEgmbYR9U68HIz7iUx3u6F0zYDPEoP8XMo/uVyl53jykeqsWw6qdzGkXr
	 kNRHO7xEW4l0eRSeKTc7SUh51oqgNZLy0swXN0NAwMP5TQyFh7FUVrT1esdG4s9YIU
	 GcJ0+ffRsSezO4nslTcioZa5Yto6WKRc5jlYc9/HYOm0Qs2oMN9fy+s8FBBiPsoxyN
	 GvdFnqwfcRX6g==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH net-next] tools: ynl: change the comment about header guards
Date: Thu, 15 Jun 2023 20:12:52 -0700
Message-Id: <20230616031252.2306420-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Przemek suggests that I shouldn't accuse GCC of witchcraft,
there is a simpler explanation for why we need manual define.

scripts/headers_install.sh modifies the guard.

This also solves the mystery of why I needed to include
the header conditionally. I had the wrong guards for most
cases but ethtool.

Suggested-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/Makefile.deps | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/net/ynl/Makefile.deps b/tools/net/ynl/Makefile.deps
index 524fc4bb586b..cbf4cdfc4fed 100644
--- a/tools/net/ynl/Makefile.deps
+++ b/tools/net/ynl/Makefile.deps
@@ -9,20 +9,16 @@
 
 UAPI_PATH:=../../../../include/uapi/
 
-# If the header does not exist at all in the system path - let the
-# compiler fall back to the kernel header via -Idirafter.
-# GCC seems to ignore header guard if the header is different, so we need
-# to specify the -D$(hdr_guard).
+# scripts/headers_install.sh strips "_UAPI" from header guards so we
+# need the explicit -D to avoid multiple definitions.
 # And we need to define HASH indirectly because GNU Make 4.2 wants it escaped
 # and Gnu Make 4.4 wants it without escaping.
 
 HASH := \#
 
-get_hdr_inc=$(if $(shell echo "$(HASH)include <linux/$(2)>" | \
-			 cpp >>/dev/null 2>/dev/null && echo yes),\
-		-D$(1) -include $(UAPI_PATH)/linux/$(2))
+get_hdr_inc=-D$(1) -include $(UAPI_PATH)/linux/$(2)
 
-CFLAGS_devlink:=$(call get_hdr_inc,_UAPI_LINUX_DEVLINK_H_,devlink.h)
+CFLAGS_devlink:=$(call get_hdr_inc,_LINUX_DEVLINK_H_,devlink.h)
 CFLAGS_ethtool:=$(call get_hdr_inc,_LINUX_ETHTOOL_NETLINK_H_,ethtool_netlink.h)
-CFLAGS_handshake:=$(call get_hdr_inc,_UAPI_LINUX_HANDSHAKE_H,handshake.h)
-CFLAGS_netdev:=$(call get_hdr_inc,_UAPI_LINUX_NETDEV_H,netdev.h)
+CFLAGS_handshake:=$(call get_hdr_inc,_LINUX_HANDSHAKE_H,handshake.h)
+CFLAGS_netdev:=$(call get_hdr_inc,_LINUX_NETDEV_H,netdev.h)
-- 
2.40.1


