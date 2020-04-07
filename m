Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C641A033F
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgDGAIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgDGABb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A07AD2080C;
        Tue,  7 Apr 2020 00:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217690;
        bh=51H9TY8V5noS4FlXlFD3P5jsli5RDi0dx8xUt4ONeBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOzLd5rE2PdQIUK0DlF6Plp4SVGb8wwfgKmtJG9r7hJUq5HcVlSH/bC8kGqWG/+Mn
         k/QYuYpvB3iOhnW27S9zaVxtKgkj6IQ2EVDQUlmzBpUwTgKWzT3As9+11aXSxrFpkJ
         iU40OzbtPJwYjzu+BSFj86y2dxpS/DFTxhxtt0hA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 25/35] selftests/net: add definition for SOL_DCCP to fix compilation errors for old libc
Date:   Mon,  6 Apr 2020 20:00:47 -0400
Message-Id: <20200407000058.16423-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 83a9b6f639e9f6b632337f9776de17d51d969c77 ]

Many systems build/test up-to-date kernels with older libcs, and
an older glibc (2.17) lacks the definition of SOL_DCCP in
/usr/include/bits/socket.h (it was added in the 4.6 timeframe).

Adding the definition to the test program avoids a compilation
failure that gets in the way of building tools/testing/selftests/net.
The test itself will work once the definition is added; either
skipping due to DCCP not being configured in the kernel under test
or passing, so there are no other more up-to-date glibc dependencies
here it seems beyond that missing definition.

Fixes: 11fb60d1089f ("selftests: net: reuseport_addr_any: add DCCP")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/reuseport_addr_any.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/reuseport_addr_any.c b/tools/testing/selftests/net/reuseport_addr_any.c
index c6233935fed14..b8475cb29be7a 100644
--- a/tools/testing/selftests/net/reuseport_addr_any.c
+++ b/tools/testing/selftests/net/reuseport_addr_any.c
@@ -21,6 +21,10 @@
 #include <sys/socket.h>
 #include <unistd.h>
 
+#ifndef SOL_DCCP
+#define SOL_DCCP 269
+#endif
+
 static const char *IP4_ADDR = "127.0.0.1";
 static const char *IP6_ADDR = "::1";
 static const char *IP4_MAPPED6 = "::ffff:127.0.0.1";
-- 
2.20.1

