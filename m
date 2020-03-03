Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D895176CAC
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgCCCsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:48:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgCCCsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B9B824681;
        Tue,  3 Mar 2020 02:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203685;
        bh=eoNayO3uiDva1CrJ3Fk5TV4cI6wo6Xy7e7/LDxK2Xuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9IvxhW1TINoo9CDjopJqBbi+AcGegK4JVRA/XcvnJ5MEWw5ZXj27PTDT7eLNmU6/
         5NC3dMvcMbENU7inOuPrGWZJWpunafK8ab8chcHzaGdewJNsnsWY1GW/YUfo5tut/I
         /47rMIWySkIpg37P5ILiYRKAY+agR9G3UjW96LYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/58] selftests: forwarding: vxlan_bridge_1d: fix tos value
Date:   Mon,  2 Mar 2020 21:47:02 -0500
Message-Id: <20200303024740.9511-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4e867c9a50ff1a07ed0b86c3b1c8bc773933d728 ]

After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
than 0x1E. With current value 0x40 the test will failed with "v1: Expected
to capture 10 packets, got 0". So let's choose a smaller tos value for
testing.

Fixes: d417ecf533fe ("selftests: forwarding: vxlan_bridge_1d: Add a TOS test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index bb10e33690b25..353613fc19475 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -516,9 +516,9 @@ test_tos()
 	RET=0
 
 	tc filter add dev v1 egress pref 77 prot ip \
-		flower ip_tos 0x40 action pass
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x40" v1 egress 77 10
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x30" v1 egress 77 0
+		flower ip_tos 0x11 action pass
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
 	tc filter del dev v1 egress pref 77 prot ip
 
 	log_test "VXLAN: envelope TOS inheritance"
-- 
2.20.1

