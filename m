Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8930AFA134
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfKMBzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbfKMBzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C19F122473;
        Wed, 13 Nov 2019 01:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610148;
        bh=Nbm+0sMkxlk6HRLaRQOFwTLW1an+JMQpxxCNSerK81o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVXUZWaE5NnLDtRveSoXvK0b6E6YR7GMvmQKCCpS6ObUIfVxEdm8SABdP/DacKF6y
         oWon788sJI32rtvCC8xqtHLhpsbfqF8JwL7fw/6T1jnc9PDUWKFM+QXbyk/t0TXdna
         mCqOF1+6UPyEw0G+uNFGXaUDosRPzYlvdfW+NGd8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 193/209] selftests: forwarding: Have lldpad_app_wait_set() wait for unknown, too
Date:   Tue, 12 Nov 2019 20:50:09 -0500
Message-Id: <20191113015025.9685-193-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 372809055f6c830ff978564e09f58bcb9e9b937c ]

Immediately after mlxsw module is probed and lldpad started, added APP
entries are briefly in "unknown" state before becoming "pending". That's
the state that lldpad_app_wait_set() typically sees, and since there are
no pending entries at that time, it bails out. However the entries have
not been pushed to the kernel yet at that point, and thus the test case
fails.

Fix by waiting for both unknown and pending entries to disappear before
proceeding.

Fixes: d159261f3662 ("selftests: mlxsw: Add test for trust-DSCP")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index ca53b539aa2d1..08bac6cf1bb3a 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -251,7 +251,7 @@ lldpad_app_wait_set()
 {
 	local dev=$1; shift
 
-	while lldptool -t -i $dev -V APP -c app | grep -q pending; do
+	while lldptool -t -i $dev -V APP -c app | grep -Eq "pending|unknown"; do
 		echo "$dev: waiting for lldpad to push pending APP updates"
 		sleep 5
 	done
-- 
2.20.1

