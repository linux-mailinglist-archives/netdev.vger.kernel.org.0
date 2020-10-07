Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332AD28553D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 02:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgJGALF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 20:11:05 -0400
Received: from correo.us.es ([193.147.175.20]:47000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgJGAKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 20:10:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 685131F0CE5
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:10:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59877DA73F
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:10:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F3B6DA72F; Wed,  7 Oct 2020 02:10:39 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E86FDA722;
        Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Oct 2020 02:10:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1598D42EF42A;
        Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/4] selftests: netfilter: add time counter check
Date:   Wed,  7 Oct 2020 02:10:27 +0200
Message-Id: <20201007001027.2530-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201007001027.2530-1-pablo@netfilter.org>
References: <20201007001027.2530-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Check packets are correctly placed in current year.
Also do a NULL check for another one.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 18a1abca3262..087f0e6e71ce 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -23,6 +23,8 @@ ip -net "$ns0" addr add 127.0.0.1 dev lo
 
 trap cleanup EXIT
 
+currentyear=$(date +%G)
+lastyear=$((currentyear-1))
 ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table inet filter {
 	counter iifcount {}
@@ -33,6 +35,8 @@ table inet filter {
 	counter il4protocounter {}
 	counter imarkcounter {}
 	counter icpu0counter {}
+	counter ilastyearcounter {}
+	counter icurrentyearcounter {}
 
 	counter oifcount {}
 	counter oifnamecount {}
@@ -55,6 +59,8 @@ table inet filter {
 		meta l4proto icmp counter name "il4protocounter"
 		meta mark 42 counter name "imarkcounter"
 		meta cpu 0 counter name "icpu0counter"
+		meta time "$lastyear-01-01" - "$lastyear-12-31" counter name ilastyearcounter
+		meta time "$currentyear-01-01" - "$currentyear-12-31" counter name icurrentyearcounter
 	}
 
 	chain output {
@@ -100,8 +106,7 @@ check_lo_counters()
 
 	for counter in iifcount iifnamecount iifgroupcount iiftypecount infproto4count \
 		       oifcount oifnamecount oifgroupcount oiftypecount onfproto4count \
-		       il4protocounter \
-		       ol4protocounter \
+		       il4protocounter icurrentyearcounter ol4protocounter \
 	     ; do
 		check_one_counter "$counter" "$want" "$verbose"
 	done
@@ -116,6 +121,7 @@ check_one_counter oskuidcounter "1" true
 check_one_counter oskgidcounter "1" true
 check_one_counter imarkcounter "1" true
 check_one_counter omarkcounter "1" true
+check_one_counter ilastyearcounter "0" true
 
 if [ $ret -eq 0 ];then
 	echo "OK: nftables meta iif/oif counters at expected values"
-- 
2.20.1

