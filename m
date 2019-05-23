Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3DD28C76
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388394AbfEWVgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:36:15 -0400
Received: from mail.us.es ([193.147.175.20]:46972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388276AbfEWVf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 17:35:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AD502C1A70
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DC82DA70A
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 93814DA705; Thu, 23 May 2019 23:35:57 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5ECB8DA705;
        Thu, 23 May 2019 23:35:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2DF144265A32;
        Thu, 23 May 2019 23:35:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/11] selftests: netfilter: missing error check when setting up veth interface
Date:   Thu, 23 May 2019 23:35:41 +0200
Message-Id: <20190523213547.15523-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

A test for the basic NAT functionality uses ip command which needs veth
device. There is a condition where the kernel support for veth is not
compiled into the kernel and the test script breaks. This patch contains
code for reasonable error display and correct code exit.

Signed-off-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 21159f5f3362..f102a65aa8b7 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -24,7 +24,11 @@ ip netns add ns0
 ip netns add ns1
 ip netns add ns2
 
-ip link add veth0 netns ns0 type veth peer name eth0 netns ns1
+ip link add veth0 netns ns0 type veth peer name eth0 netns ns1 > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
 ip link add veth1 netns ns0 type veth peer name eth0 netns ns2
 
 ip -net ns0 link set lo up
-- 
2.11.0

