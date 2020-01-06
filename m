Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D80130CA5
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 04:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgAFD6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 22:58:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbgAFD6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 22:58:37 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC582072C;
        Mon,  6 Jan 2020 03:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578283117;
        bh=tsfrQPHF5XQUnu02djwuXvwded7g5GMWHeNgUyZ9ymE=;
        h=From:To:Cc:Subject:Date:From;
        b=YSisyL9hdDGX2pUrN1xRDATrCnik+XAvzBD8qEQaOVLbveZKve2jmPLTjVENH7VVk
         6LV/wK8MdxDnK85wXEIuO1VUljUXkrhJSwvnN1m3xfw7muYDyyJEgJfvJkrqxNdojW
         te7IaZnNpq3ToKLpWGRPQ5zOVfAKSMUjxAKjOBhk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] fcnal-test: Fix vrf argument in local tcp tests
Date:   Sun,  5 Jan 2020 20:02:05 -0800
Message-Id: <20200106040205.29291-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The recent MD5 tests added duplicate configuration in the default VRF.
This change exposed a bug in existing tests designed to verify no
connection when client and server are not in the same domain. The
server should be running bound to the vrf device with the client run
in the default VRF (the -2 option is meant for validating connection
data). Fix the option for both tests.

While technically this is a bug in previous releases, the tests are
properly failing since the default VRF does not have any routing
configuration so there really is no need to backport to prior releases.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 15cb8ab68c7c..fb5c55dd6df8 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1165,8 +1165,8 @@ ipv4_tcp_vrf()
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		show_hint "Should fail 'No route to host' since client is not bound to VRF"
-		run_cmd nettest -s -2 ${VRF} &
+		show_hint "Should fail 'Connection refused' since client is not bound to VRF"
+		run_cmd nettest -s -d ${VRF} &
 		sleep 1
 		run_cmd nettest -r ${a}
 		log_test_addr ${a} $? 1 "Global server, local connection"
@@ -2663,8 +2663,8 @@ ipv6_tcp_vrf()
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		show_hint "Fails 'No route to host' since client is not in VRF"
-		run_cmd nettest -6 -s -2 ${VRF} &
+		show_hint "Fails 'Connection refused' since client is not in VRF"
+		run_cmd nettest -6 -s -d ${VRF} &
 		sleep 1
 		run_cmd nettest -6 -r ${a}
 		log_test_addr ${a} $? 1 "Global server, local connection"
-- 
2.11.0

