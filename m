Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1C84AA4D9
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378619AbiBEADp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:45 -0500
Received: from mga17.intel.com ([192.55.52.151]:46958 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378410AbiBEADo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019424; x=1675555424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BIHDQ0cV+8FuNvzldY9/cMZQZYbfgj0qdBVLxCsVVjU=;
  b=cP4esqaKTvJRcLrh8lrSw8JpESw3NqiR/DGyRAp7wsGVtVeCyaIfkHRx
   +yzpkx24kWXlGHXUNhHrH93shupS88XIQzba8PNXE4iDmmj40MR/MQ2HK
   qFNkeVW+gpnDpiPmCmAGlXnUVBV4mh8Akic8U9CzPk+euPjHLJ1WaGbTK
   6iD2pQgHf/pF+36TU/FIz+Etv1ySgZ9h6KzjRQZIvtXhTXKaTqEVqLYSH
   7He0Lt4HGxDR29k+joJO+Z/iVPziyXQvZ7Y8fG/jJKzDd196FEE77JDOb
   fRnnZ8WpQ2IH8TFEqmWi6yGjcsrc0neEmL3qK2pF298tCwAwRJ46CJsve
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115087"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115087"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097518"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/9] selftests: mptcp: add backup with port testcase
Date:   Fri,  4 Feb 2022 16:03:31 -0800
Message-Id: <20220205000337.187292-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the backup testcase using an address with a port number.

The original backup tests only work for the output of 'pm_nl_ctl dump'
without the port number. It chooses the last item in the dump to parse
the address in it, and in this case, the address is showed at the end
of the item.

But it doesn't work for the dump with the port number, in this case, the
port number is showed at the end of the item, not the address.

So implemented a more flexible approach to get the address and the port
number from the dump to fit for the port number case.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 44 ++++++++++++++++---
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index bd106c7ec232..eb945cebbd6d 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -239,6 +239,16 @@ is_v6()
 	[ -z "${1##*:*}" ]
 }
 
+is_addr()
+{
+	[ -z "${1##*[.:]*}" ]
+}
+
+is_number()
+{
+	[[ $1 == ?(-)+([0-9]) ]]
+}
+
 # $1: ns, $2: port
 wait_local_port_listen()
 {
@@ -464,11 +474,25 @@ do_transfer()
 	if [ ! -z $sflags ]; then
 		sleep 1
 		for netns in "$ns1" "$ns2"; do
-			dump=(`ip netns exec $netns ./pm_nl_ctl dump`)
-			if [ ${#dump[@]} -gt 0 ]; then
-				addr=${dump[${#dump[@]} - 1]}
-				ip netns exec $netns ./pm_nl_ctl set $addr flags $sflags
-			fi
+			ip netns exec $netns ./pm_nl_ctl dump | while read line; do
+				local arr=($line)
+				local addr
+				local port=0
+				local _port=""
+
+				for i in ${arr[@]}; do
+					if is_addr $i; then
+						addr=$i
+					elif is_number $i; then
+						# The minimum expected port number is 10000
+						if [ $i -gt 10000 ]; then
+							port=$i
+						fi
+					fi
+				done
+				if [ $port -ne 0 ]; then _port="port $port"; fi
+				ip netns exec $netns ./pm_nl_ctl set $addr flags $sflags $_port
+			done
 		done
 	fi
 
@@ -1616,6 +1640,16 @@ backup_tests()
 	chk_join_nr "single address, backup" 1 1 1
 	chk_add_nr 1 1
 	chk_prio_nr 1 0
+
+	# single address with port, backup
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+	chk_join_nr "single address with port, backup" 1 1 1
+	chk_add_nr 1 1
+	chk_prio_nr 1 0
 }
 
 add_addr_ports_tests()
-- 
2.35.1

