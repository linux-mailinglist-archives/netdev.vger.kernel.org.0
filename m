Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E010544A130
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbhKIBHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:07:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237935AbhKIBGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:06:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93DC861A08;
        Tue,  9 Nov 2021 01:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419762;
        bh=pKhH/t9S/manekTLD5/XhoBYKn7pRmMlwLKnyU9Itno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyx2Z+G5hABC2D3HXqBskXZ9xNdvMg7KRmt2dHiDoRCxalvOePWS84cWBG5iOs1Mf
         7zh1UlAe6wN7ZOhMk/rbuCbDCWLcZZsP0dJ3P9LJ0mUDOmFnD8kQntp5VySwXXBPh5
         W7qJx5mgQGmxlcveWkRWg6KyJ33MA3HEvhsD6wwYdna5fbpN3oGRLa8uPIx7jiXryN
         V2ehDaHaya2JcF3M35dgKE5DH3avDPYm4bo9bFtau+bpWf9GRc0CrGzSdNay6ltlvZ
         2Cx8MBFyPc3ZBBlq5t6st67PhVXkWWERAgjtUIl79ZaYQ/36tsEs1HpCV0gSOzz4v1
         eLUz0QML6qM9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 028/138] selftests: net: fib_nexthops: Wait before checking reported idle time
Date:   Mon,  8 Nov 2021 12:44:54 -0500
Message-Id: <20211108174644.1187889-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit b69c99463d414cc263411462d52f25205657e9af ]

The purpose of this test is to verify that after a short activity passes,
the reported time is reasonable: not zero (which could be reported by
mistake), and not something outrageous (which would be indicative of an
issue in used units).

However, the idle time is reported in units of clock_t, or hundredths of
second. If the initial sequence of commands is very quick, it is possible
that the idle time is reported as just flat-out zero. When this test was
recently enabled in our nightly regression, we started seeing spurious
failures for exactly this reason.

Therefore buffer the delay leading up to the test with a sleep, to make
sure there is no legitimate way of reporting 0.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 0d293391e9a44..b5a69ad191b07 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -2078,6 +2078,7 @@ basic_res()
 		"id 101 index 0 nhid 2 id 101 index 1 nhid 2 id 101 index 2 nhid 1 id 101 index 3 nhid 1"
 	log_test $? 0 "Dump all nexthop buckets in a group"
 
+	sleep 0.1
 	(( $($IP -j nexthop bucket list id 101 |
 	     jq '[.[] | select(.bucket.idle_time > 0 and
 	                       .bucket.idle_time < 2)] | length') == 4 ))
-- 
2.33.0

