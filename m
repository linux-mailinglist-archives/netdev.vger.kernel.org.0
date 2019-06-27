Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7FF58551
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfF0PMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:12:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48452 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfF0PMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:12:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hgW4j-0003u7-Fa; Thu, 27 Jun 2019 17:12:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net] selftests: rtnetlink: skip ipsec offload tests if netdevsim isn't present
Date:   Thu, 27 Jun 2019 17:12:42 +0200
Message-Id: <20190627151242.5150-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

running the script on systems without netdevsim now prints:

SKIP: ipsec_offload can't load netdevsim

instead of error message & failed status.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Feel free to apply to -next, its not a bug fix per se.

 tools/testing/selftests/net/rtnetlink.sh | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index b25c9fe019d2..a7a443bdbdd9 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -699,13 +699,17 @@ kci_test_ipsec_offload()
 	sysfsd=/sys/kernel/debug/netdevsim/netdevsim0/ports/0/
 	sysfsf=$sysfsd/ipsec
 	sysfsnet=/sys/bus/netdevsim/devices/netdevsim0/net/
+	probed=false
 
 	# setup netdevsim since dummydev doesn't have offload support
-	modprobe netdevsim
-	check_err $?
-	if [ $ret -ne 0 ]; then
-		echo "FAIL: ipsec_offload can't load netdevsim"
-		return 1
+	if [ ! -w /sys/bus/netdevsim/new_device ] ; then
+		modprobe -q netdevsim
+		check_err $?
+		if [ $ret -ne 0 ]; then
+			echo "SKIP: ipsec_offload can't load netdevsim"
+			return $ksft_skip
+		fi
+		probed=true
 	fi
 
 	echo "0" > /sys/bus/netdevsim/new_device
@@ -785,7 +789,7 @@ EOF
 	fi
 
 	# clean up any leftovers
-	rmmod netdevsim
+	$probed && rmmod netdevsim
 
 	if [ $ret -ne 0 ]; then
 		echo "FAIL: ipsec_offload"
-- 
2.21.0

