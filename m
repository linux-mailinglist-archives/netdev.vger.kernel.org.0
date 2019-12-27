Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D79E12B883
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfL0RmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbfL0Rl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC2A218AC;
        Fri, 27 Dec 2019 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468518;
        bh=BS+mAXFvlqflThf7F1mV4aixoBzjq1S/IWPEOHRCS/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkeqlLy+MhHMm5bCSGAtzRveE9gc8FAQUL0+xG0Nh/OdVQwyKWzDE+hEFvioPslsI
         tVs4sjb8Ggna4F66rJoyy+tutCD/Geb4hrzl7ci+AdJDwyWzsPeZ+1R2PRvgs6tBaa
         zQBmYugWt3sQa35j0k+pmhLhyAwGqJZ8C3/9DAWQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 050/187] selftests: forwarding: Delete IPv6 address at the end
Date:   Fri, 27 Dec 2019 12:38:38 -0500
Message-Id: <20191227174055.4923-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 65cb13986229cec02635a1ecbcd1e2dd18353201 ]

When creating the second host in h2_create(), two addresses are assigned
to the interface, but only one is deleted. When running the test twice
in a row the following error is observed:

$ ./router_bridge_vlan.sh
TEST: ping                                                          [ OK ]
TEST: ping6                                                         [ OK ]
TEST: vlan                                                          [ OK ]
$ ./router_bridge_vlan.sh
RTNETLINK answers: File exists
TEST: ping                                                          [ OK ]
TEST: ping6                                                         [ OK ]
TEST: vlan                                                          [ OK ]

Fix this by deleting the address during cleanup.

Fixes: 5b1e7f9ebd56 ("selftests: forwarding: Test routed bridge interface")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/router_bridge_vlan.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
index fef88eb4b873..fa6a88c50750 100755
--- a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
@@ -36,7 +36,7 @@ h2_destroy()
 {
 	ip -6 route del 2001:db8:1::/64 vrf v$h2
 	ip -4 route del 192.0.2.0/28 vrf v$h2
-	simple_if_fini $h2 192.0.2.130/28
+	simple_if_fini $h2 192.0.2.130/28 2001:db8:2::2/64
 }
 
 router_create()
-- 
2.20.1

