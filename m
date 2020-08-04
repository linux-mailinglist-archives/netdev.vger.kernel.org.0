Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11923C069
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgHDUCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:02:51 -0400
Received: from correo.us.es ([193.147.175.20]:49432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbgHDUCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 16:02:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E32EDA7F7
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63C65DA858
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5BB8CDA852; Tue,  4 Aug 2020 22:02:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0645DDA722;
        Tue,  4 Aug 2020 22:02:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 22:02:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 37D024265A32;
        Tue,  4 Aug 2020 22:02:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/5] selftests: netfilter: add meta iif/oif match test
Date:   Tue,  4 Aug 2020 22:02:06 +0200
Message-Id: <20200804200208.18620-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804200208.18620-1-pablo@netfilter.org>
References: <20200804200208.18620-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

simple test case, but would have caught this:

FAIL: iifgroupcount, want "packets 2", got
table inet filter {
        counter iifgroupcount {
                packets 0 bytes 0
        }
}

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 tools/testing/selftests/netfilter/nft_meta.sh | 124 ++++++++++++++++++
 2 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_meta.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index a179f0dca8ce..a374e10ef506 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -4,7 +4,7 @@
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
-	nft_queue.sh
+	nft_queue.sh nft_meta.sh
 
 LDLIBS = -lmnl
 TEST_GEN_FILES =  nf-queue
diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
new file mode 100755
index 000000000000..d250b84dd5bc
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -0,0 +1,124 @@
+#!/bin/bash
+
+# check iif/iifname/oifgroup/iiftype match.
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+sfx=$(mktemp -u "XXXXXXXX")
+ns0="ns0-$sfx"
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+cleanup()
+{
+	ip netns del "$ns0"
+}
+
+ip netns add "$ns0"
+ip -net "$ns0" link set lo up
+ip -net "$ns0" addr add 127.0.0.1 dev lo
+
+trap cleanup EXIT
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table inet filter {
+	counter iifcount {}
+	counter iifnamecount {}
+	counter iifgroupcount {}
+	counter iiftypecount {}
+	counter infproto4count {}
+	counter il4protocounter {}
+	counter imarkcounter {}
+
+	counter oifcount {}
+	counter oifnamecount {}
+	counter oifgroupcount {}
+	counter oiftypecount {}
+	counter onfproto4count {}
+	counter ol4protocounter {}
+	counter oskuidcounter {}
+	counter oskgidcounter {}
+	counter omarkcounter {}
+
+	chain input {
+		type filter hook input priority 0; policy accept;
+
+		meta iif lo counter name "iifcount"
+		meta iifname "lo" counter name "iifnamecount"
+		meta iifgroup "default" counter name "iifgroupcount"
+		meta iiftype "loopback" counter name "iiftypecount"
+		meta nfproto ipv4 counter name "infproto4count"
+		meta l4proto icmp counter name "il4protocounter"
+		meta mark 42 counter name "imarkcounter"
+	}
+
+	chain output {
+		type filter hook output priority 0; policy accept;
+		meta oif lo counter name "oifcount" counter
+		meta oifname "lo" counter name "oifnamecount"
+		meta oifgroup "default" counter name "oifgroupcount"
+		meta oiftype "loopback" counter name "oiftypecount"
+		meta nfproto ipv4 counter name "onfproto4count"
+		meta l4proto icmp counter name "ol4protocounter"
+		meta skuid 0 counter name "oskuidcounter"
+		meta skgid 0 counter name "oskgidcounter"
+		meta mark 42 counter name "omarkcounter"
+	}
+}
+EOF
+
+if [ $? -ne 0 ]; then
+	echo "SKIP: Could not add test ruleset"
+	exit $ksft_skip
+fi
+
+ret=0
+
+check_one_counter()
+{
+	local cname="$1"
+	local want="packets $2"
+	local verbose="$3"
+
+	cnt=$(ip netns exec "$ns0" nft list counter inet filter $cname | grep -q "$want")
+	if [ $? -ne 0 ];then
+		echo "FAIL: $cname, want \"$want\", got"
+		ret=1
+		ip netns exec "$ns0" nft list counter inet filter $counter
+	fi
+}
+
+check_lo_counters()
+{
+	local want="$1"
+	local verbose="$2"
+	local counter
+
+	for counter in iifcount iifnamecount iifgroupcount iiftypecount infproto4count \
+		       oifcount oifnamecount oifgroupcount oiftypecount onfproto4count \
+		       il4protocounter \
+		       ol4protocounter \
+	     ; do
+		check_one_counter "$counter" "$want" "$verbose"
+	done
+}
+
+check_lo_counters "0" false
+ip netns exec "$ns0" ping -q -c 1 127.0.0.1 -m 42 > /dev/null
+
+check_lo_counters "2" true
+
+check_one_counter oskuidcounter "1" true
+check_one_counter oskgidcounter "1" true
+check_one_counter imarkcounter "1" true
+check_one_counter omarkcounter "1" true
+
+if [ $ret -eq 0 ];then
+	echo "OK: nftables meta iif/oif counters at expected values"
+fi
+
+exit $ret
-- 
2.20.1

