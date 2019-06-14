Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CD2469F5
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfFNUgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbfFNU3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:44 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61A7621841;
        Fri, 14 Jun 2019 20:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544183;
        bh=CW+R9mtmL5tZ4dqbeQ7eWnMNZOmFSCvy9csAYnyIzSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZx57lLMhvnOy8MnYeVfSPsD/O1jjhyPJfLOskhr9sjeoAGIA4re0+aZpmV74HtG1
         EpQNJXS6+MVE7Oc+Tj6UUzHTKUHUa//CYeQ/y8UMzc3hwY7nSIJHWaWaIH0TkUEowt
         VvGNMnQzEp3iVQVFF6E5rP1Nudtl8ncJXSphF+DU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 40/59] selftests: set sysctl bc_forwarding properly in router_broadcast.sh
Date:   Fri, 14 Jun 2019 16:28:24 -0400
Message-Id: <20190614202843.26941-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 67c0aaa1eaec60e9dab301012bdebe6726ae04bd ]

sysctl setting bc_forwarding for $rp2 is needed when ping_test_from h2,
otherwise the bc packets from $rp2 won't be forwarded. This patch is to
add this setting for $rp2.

Also, as ping_test_from does grep "$from" only, which could match some
unexpected output, some test case doesn't really work, like:

  # ping_test_from $h2 198.51.200.255 198.51.200.2
    PING 198.51.200.255 from 198.51.100.2 veth3: 56(84) bytes of data.
    64 bytes from 198.51.100.1: icmp_seq=1 ttl=64 time=0.336 ms

When doing grep $form (198.51.200.2), the output could still match.
So change to grep "bytes from $from" instead.

Fixes: 40f98b9af943 ("selftests: add a selftest for directed broadcast forwarding")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/router_broadcast.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_broadcast.sh b/tools/testing/selftests/net/forwarding/router_broadcast.sh
index 9a678ece32b4..4eac0a06f451 100755
--- a/tools/testing/selftests/net/forwarding/router_broadcast.sh
+++ b/tools/testing/selftests/net/forwarding/router_broadcast.sh
@@ -145,16 +145,19 @@ bc_forwarding_disable()
 {
 	sysctl_set net.ipv4.conf.all.bc_forwarding 0
 	sysctl_set net.ipv4.conf.$rp1.bc_forwarding 0
+	sysctl_set net.ipv4.conf.$rp2.bc_forwarding 0
 }
 
 bc_forwarding_enable()
 {
 	sysctl_set net.ipv4.conf.all.bc_forwarding 1
 	sysctl_set net.ipv4.conf.$rp1.bc_forwarding 1
+	sysctl_set net.ipv4.conf.$rp2.bc_forwarding 1
 }
 
 bc_forwarding_restore()
 {
+	sysctl_restore net.ipv4.conf.$rp2.bc_forwarding
 	sysctl_restore net.ipv4.conf.$rp1.bc_forwarding
 	sysctl_restore net.ipv4.conf.all.bc_forwarding
 }
@@ -171,7 +174,7 @@ ping_test_from()
 	log_info "ping $dip, expected reply from $from"
 	ip vrf exec $(master_name_get $oif) \
 		$PING -I $oif $dip -c 10 -i 0.1 -w $PING_TIMEOUT -b 2>&1 \
-		| grep $from &> /dev/null
+		| grep "bytes from $from" > /dev/null
 	check_err_fail $fail $?
 }
 
-- 
2.20.1

