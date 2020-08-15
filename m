Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286B7245442
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgHOWS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:18:59 -0400
Received: from correo.us.es ([193.147.175.20]:38938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgHOWSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00598DA8A1
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E473BDA72F
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9A55DA840; Sat, 15 Aug 2020 12:32:23 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B88D4DA72F;
        Sat, 15 Aug 2020 12:32:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CBE9E42EF4E0;
        Sat, 15 Aug 2020 12:32:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/8] selftests: netfilter: add MTU arguments to flowtables
Date:   Sat, 15 Aug 2020 12:31:59 +0200
Message-Id: <20200815103201.1768-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Add some documentation, default values defined in original
script and Originator/Link/Responder arguments
using getopts like in tools/power/cpupower/bench/cpufreq-bench_plot.sh

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_flowtable.sh      | 30 +++++++++++++++----
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 68a183753c6c..e98cac6f8bfd 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -2,13 +2,18 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # This tests basic flowtable functionality.
-# Creates following topology:
+# Creates following default topology:
 #
 # Originator (MTU 9000) <-Router1-> MTU 1500 <-Router2-> Responder (MTU 2000)
 # Router1 is the one doing flow offloading, Router2 has no special
 # purpose other than having a link that is smaller than either Originator
 # and responder, i.e. TCPMSS announced values are too large and will still
 # result in fragmentation and/or PMTU discovery.
+#
+# You can check with different Orgininator/Link/Responder MTU eg:
+# sh nft_flowtable.sh -o1000 -l500 -r100
+#
+
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -78,11 +83,24 @@ ip -net nsr2 addr add dead:2::1/64 dev veth1
 # ns2 is going via nsr2 with a smaller mtu, so that TCPMSS announced by both peers
 # is NOT the lowest link mtu.
 
-ip -net nsr1 link set veth0 mtu 9000
-ip -net ns1 link set eth0 mtu 9000
+omtu=9000
+lmtu=1500
+rmtu=2000
+
+while getopts "o:l:r:" o
+do
+	case $o in
+		o) omtu=$OPTARG;;
+		l) lmtu=$OPTARG;;
+		r) rmtu=$OPTARG;;
+	esac
+done
+
+ip -net nsr1 link set veth0 mtu $omtu
+ip -net ns1 link set eth0 mtu $omtu
 
-ip -net nsr2 link set veth1 mtu 2000
-ip -net ns2 link set eth0 mtu 2000
+ip -net nsr2 link set veth1 mtu $rmtu
+ip -net ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
 # these addresses are not used for connections.
@@ -136,7 +154,7 @@ table inet filter {
       # as PMTUd is off.
       # This rule is deleted for the last test, when we expect PMTUd
       # to kick in and ensure all packets meet mtu requirements.
-      meta length gt 1500 accept comment something-to-grep-for
+      meta length gt $lmtu accept comment something-to-grep-for
 
       # next line blocks connection w.o. working offload.
       # we only do this for reverse dir, because we expect packets to
-- 
2.20.1

