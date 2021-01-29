Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BC830832A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhA2BVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:21:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:6819 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229885AbhA2BVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:21:03 -0500
IronPort-SDR: Wvb/oWe3s4djEEw+zO20kvuw03Ryh17IVd7hdJ8yCqA+zlipFsUu/z6tPcgrc2iRLbuM2sO1V/
 g1BI/87xmONw==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430185"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430185"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:24 -0800
IronPort-SDR: 5TF6RV6bJm1eQ/xGYQmHWcDMbtPYx/U+c5nP3cccpU4+zJXKB0I5HoBEo30MK3dj0uP4qIhQS3
 fL9VutYJ4JfQ==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538343"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:24 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 16/16] selftests: mptcp: add command line arguments for mptcp_join.sh
Date:   Thu, 28 Jan 2021 17:11:15 -0800
Message-Id: <20210129011115.133953-17-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Since the mptcp_join script is becoming too big, this patch splits it
into several smaller chunks, each of them has been defined in a function
as a individual test group for several related testcases.

Using bash getopts function to parse command line arguments, and invoke
each function to do the individual test group.

Here are all the arguments:
  -f subflows_tests
  -s signal_address_tests
  -l link_failure_tests
  -t add_addr_timeout_tests
  -r remove_tests
  -a add_tests
  -6 ipv6_tests
  -4 v4mapped_tests
  -b backup_tests
  -p add_addr_ports_tests
  -c syncookies_tests
  -h help

Run mptcp_join.sh with no argument will execute all testcases.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 1068 +++++++++--------
 1 file changed, 590 insertions(+), 478 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index b8fd924033b1..964db9ed544f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -680,6 +680,551 @@ chk_prio_nr()
 	fi
 }
 
+subflows_tests()
+{
+	reset
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "no JOIN" "0" "0" "0"
+
+	# subflow limited by client
+	reset
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow, limited by client" 0 0 0
+
+	# subflow limited by server
+	reset
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow, limited by server" 1 1 0
+
+	# subflow
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow" 1 1 1
+
+	# multiple subflows
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "multiple subflows" 2 2 2
+
+	# multiple subflows limited by serverf
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "multiple subflows, limited by server" 2 2 1
+}
+
+signal_address_tests()
+{
+	# add_address, unused
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "unused signal address" 0 0 0
+	chk_add_nr 1 1
+
+	# accept and use add_addr
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal address" 1 1 1
+	chk_add_nr 1 1
+
+	# accept and use add_addr with an additional subflow
+	# note: signal address in server ns and local addresses in client ns must
+	# belong to different subnets or one of the listed local address could be
+	# used for 'add_addr' subflow
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "subflow and signal" 2 2 2
+	chk_add_nr 1 1
+
+	# accept and use add_addr with additional subflows
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "multiple subflows and signal" 3 3 3
+	chk_add_nr 1 1
+}
+
+link_failure_tests()
+{
+	# accept and use add_addr with additional subflows and link loss
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 1
+	chk_join_nr "multiple flows, signal, link failure" 3 3 3
+	chk_add_nr 1 1
+}
+
+add_addr_timeout_tests()
+{
+	# add_addr timeout
+	reset_with_add_addr_timeout
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
+	chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
+	chk_add_nr 4 0
+
+	# add_addr timeout IPv6
+	reset_with_add_addr_timeout 6
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+	chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
+	chk_add_nr 4 0
+}
+
+remove_tests()
+{
+	# single subflow, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
+	chk_join_nr "remove single subflow" 1 1 1
+	chk_rm_nr 1 1
+
+	# multiple subflows, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
+	chk_join_nr "remove multiple subflows" 2 2 2
+	chk_rm_nr 2 2
+
+	# single address, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
+	chk_join_nr "remove single address" 1 1 1
+	chk_add_nr 1 1
+	chk_rm_nr 0 0
+
+	# subflow and signal, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
+	chk_join_nr "remove subflow and signal" 2 2 2
+	chk_add_nr 1 1
+	chk_rm_nr 1 1
+
+	# subflows and signal, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
+	chk_join_nr "remove subflows and signal" 3 3 3
+	chk_add_nr 1 1
+	chk_rm_nr 2 2
+
+	# subflows and signal, flush
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+	chk_join_nr "flush subflows and signal" 3 3 3
+	chk_add_nr 1 1
+	chk_rm_nr 2 2
+}
+
+add_tests()
+{
+	# add single subflow
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
+	chk_join_nr "add single subflow" 1 1 1
+
+	# add signal address
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
+	chk_join_nr "add signal address" 1 1 1
+	chk_add_nr 1 1
+
+	# add multiple subflows
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
+	chk_join_nr "add multiple subflows" 2 2 2
+
+	# add multiple subflows IPv6
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	run_tests $ns1 $ns2 dead:beef:1::1 0 0 2 slow
+	chk_join_nr "add multiple subflows IPv6" 2 2 2
+
+	# add multiple addresses IPv6
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	run_tests $ns1 $ns2 dead:beef:1::1 0 2 0 slow
+	chk_join_nr "add multiple addresses IPv6" 2 2 2
+	chk_add_nr 2 2
+}
+
+ipv6_tests()
+{
+	# subflow IPv6
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+	chk_join_nr "single subflow IPv6" 1 1 1
+
+	# add_address, unused IPv6
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+	chk_join_nr "unused signal address IPv6" 0 0 0
+	chk_add_nr 1 1
+
+	# signal address IPv6
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
+	chk_join_nr "single address IPv6" 1 1 1
+	chk_add_nr 1 1
+
+	# single address IPv6, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
+	chk_join_nr "remove single address IPv6" 1 1 1
+	chk_add_nr 1 1
+	chk_rm_nr 0 0
+
+	# subflow and signal IPv6, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
+	run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
+	chk_join_nr "remove subflow and signal IPv6" 2 2 2
+	chk_add_nr 1 1
+	chk_rm_nr 1 1
+}
+
+v4mapped_tests()
+{
+	# subflow IPv4-mapped to IPv4-mapped
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
+	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+	chk_join_nr "single subflow IPv4-mapped" 1 1 1
+
+	# signal address IPv4-mapped with IPv4-mapped sk
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
+	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+	chk_join_nr "signal address IPv4-mapped" 1 1 1
+	chk_add_nr 1 1
+
+	# subflow v4-map-v6
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+	chk_join_nr "single subflow v4-map-v6" 1 1 1
+
+	# signal address v4-map-v6
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 "::ffff:10.0.1.1"
+	chk_join_nr "signal address v4-map-v6" 1 1 1
+	chk_add_nr 1 1
+
+	# subflow v6-map-v4
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow v6-map-v4" 1 1 1
+
+	# signal address v6-map-v4
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal address v6-map-v4" 1 1 1
+	chk_add_nr 1 1
+
+	# no subflow IPv6 to v4 address
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "no JOIN with diff families v4-v6" 0 0 0
+
+	# no subflow IPv6 to v4 address even if v6 has a valid v4 at the end
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "no JOIN with diff families v4-v6-2" 0 0 0
+
+	# no subflow IPv4 to v6 address, no need to slow down too then
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 dead:beef:1::1
+	chk_join_nr "no JOIN with diff families v6-v4" 0 0 0
+}
+
+backup_tests()
+{
+	# single subflow, backup
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
+	chk_join_nr "single subflow, backup" 1 1 1
+	chk_prio_nr 0 1
+
+	# single address, backup
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+	chk_join_nr "single address, backup" 1 1 1
+	chk_add_nr 1 1
+	chk_prio_nr 1 0
+}
+
+add_addr_ports_tests()
+{
+	# signal address with port
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal address with port" 1 1 1
+	chk_add_nr 1 1 1
+
+	# subflow and signal with port
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "subflow and signal with port" 2 2 2
+	chk_add_nr 1 1 1
+
+	# single address with port, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
+	chk_join_nr "remove single address with port" 1 1 1
+	chk_add_nr 1 1 1
+	chk_rm_nr 0 0
+
+	# subflow and signal with port, remove
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
+	chk_join_nr "remove subflow and signal with port" 2 2 2
+	chk_add_nr 1 1 1
+	chk_rm_nr 1 1
+
+	# subflows and signal with port, flush
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
+	chk_join_nr "flush subflows and signal with port" 3 3 3
+	chk_add_nr 1 1
+	chk_rm_nr 2 2
+
+	# multiple addresses with port
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10100
+	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "multiple addresses with port" 2 2 2
+	chk_add_nr 2 2 2
+
+	# multiple addresses with ports
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 2 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10101
+	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "multiple addresses with ports" 2 2 2
+	chk_add_nr 2 2 2
+}
+
+syncookies_tests()
+{
+	# single subflow, syncookies
+	reset_with_cookies
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "single subflow with syn cookies" 1 1 1
+
+	# multiple subflows with syn cookies
+	reset_with_cookies
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "multiple subflows with syn cookies" 2 2 2
+
+	# multiple subflows limited by server
+	reset_with_cookies
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "subflows limited by server w cookies" 2 2 1
+
+	# test signal address with cookies
+	reset_with_cookies
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal address with syn cookies" 1 1 1
+	chk_add_nr 1 1
+
+	# test cookie with subflow and signal
+	reset_with_cookies
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "subflow and signal w cookies" 2 2 2
+	chk_add_nr 1 1
+
+	# accept and use add_addr with additional subflows
+	reset_with_cookies
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "subflows and signal w. cookies" 3 3 3
+	chk_add_nr 1 1
+}
+
+all_tests()
+{
+	subflows_tests
+	signal_address_tests
+	link_failure_tests
+	add_addr_timeout_tests
+	remove_tests
+	add_tests
+	ipv6_tests
+	v4mapped_tests
+	backup_tests
+	add_addr_ports_tests
+	syncookies_tests
+}
+
+usage()
+{
+	echo "mptcp_join usage:"
+	echo "  -f subflows_tests"
+	echo "  -s signal_address_tests"
+	echo "  -l link_failure_tests"
+	echo "  -t add_addr_timeout_tests"
+	echo "  -r remove_tests"
+	echo "  -a add_tests"
+	echo "  -6 ipv6_tests"
+	echo "  -4 v4mapped_tests"
+	echo "  -b backup_tests"
+	echo "  -p add_addr_ports_tests"
+	echo "  -c syncookies_tests"
+	echo "  -h help"
+}
+
 sin=$(mktemp)
 sout=$(mktemp)
 cin=$(mktemp)
@@ -690,483 +1235,50 @@ make_file "$cin" "client" 1
 make_file "$sin" "server" 1
 trap cleanup EXIT
 
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "no JOIN" "0" "0" "0"
-
-# subflow limted by client
-reset
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "single subflow, limited by client" 0 0 0
-
-# subflow limted by server
-reset
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "single subflow, limited by server" 1 1 0
-
-# subflow
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "single subflow" 1 1 1
-
-# multiple subflows
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "multiple subflows" 2 2 2
-
-# multiple subflows limited by serverf
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "multiple subflows, limited by server" 2 2 1
-
-# add_address, unused
-reset
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "unused signal address" 0 0 0
-chk_add_nr 1 1
-
-# accept and use add_addr
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "signal address" 1 1 1
-chk_add_nr 1 1
-
-# accept and use add_addr with an additional subflow
-# note: signal address in server ns and local addresses in client ns must
-# belong to different subnets or one of the listed local address could be
-# used for 'add_addr' subflow
-reset
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "subflow and signal" 2 2 2
-chk_add_nr 1 1
-
-# accept and use add_addr with additional subflows
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "multiple subflows and signal" 3 3 3
-chk_add_nr 1 1
-
-# accept and use add_addr with additional subflows and link loss
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 1
-chk_join_nr "multiple flows, signal, link failure" 3 3 3
-chk_add_nr 1 1
-
-# add_addr timeout
-reset_with_add_addr_timeout
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-chk_join_nr "signal address, ADD_ADDR timeout" 1 1 1
-chk_add_nr 4 0
-
-# single subflow, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
-chk_join_nr "remove single subflow" 1 1 1
-chk_rm_nr 1 1
-
-# multiple subflows, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
-chk_join_nr "remove multiple subflows" 2 2 2
-chk_rm_nr 2 2
-
-# single address, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
-chk_join_nr "remove single address" 1 1 1
-chk_add_nr 1 1
-chk_rm_nr 0 0
-
-# subflow and signal, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
-chk_join_nr "remove subflow and signal" 2 2 2
-chk_add_nr 1 1
-chk_rm_nr 1 1
-
-# subflows and signal, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
-chk_join_nr "remove subflows and signal" 3 3 3
-chk_add_nr 1 1
-chk_rm_nr 2 2
-
-# subflows and signal, flush
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-chk_join_nr "flush subflows and signal" 3 3 3
-chk_add_nr 1 1
-chk_rm_nr 2 2
-
-# add single subflow
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-run_tests $ns1 $ns2 10.0.1.1 0 0 1 slow
-chk_join_nr "add single subflow" 1 1 1
-
-# add signal address
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 10.0.1.1 0 1 0 slow
-chk_join_nr "add signal address" 1 1 1
-chk_add_nr 1 1
-
-# add multiple subflows
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-run_tests $ns1 $ns2 10.0.1.1 0 0 2 slow
-chk_join_nr "add multiple subflows" 2 2 2
-
-# add multiple subflows IPv6
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-run_tests $ns1 $ns2 dead:beef:1::1 0 0 2 slow
-chk_join_nr "add multiple subflows IPv6" 2 2 2
-
-# add multiple addresses IPv6
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 2 2
-run_tests $ns1 $ns2 dead:beef:1::1 0 2 0 slow
-chk_join_nr "add multiple addresses IPv6" 2 2 2
-chk_add_nr 2 2
-
-# subflow IPv6
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
-run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-chk_join_nr "single subflow IPv6" 1 1 1
-
-# add_address, unused IPv6
-reset
-ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-chk_join_nr "unused signal address IPv6" 0 0 0
-chk_add_nr 1 1
-
-# signal address IPv6
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-chk_join_nr "single address IPv6" 1 1 1
-chk_add_nr 1 1
-
-# add_addr timeout IPv6
-reset_with_add_addr_timeout 6
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-run_tests $ns1 $ns2 dead:beef:1::1 0 0 0 slow
-chk_join_nr "signal address, ADD_ADDR6 timeout" 1 1 1
-chk_add_nr 4 0
-
-# single address IPv6, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 dead:beef:1::1 0 -1 0 slow
-chk_join_nr "remove single address IPv6" 1 1 1
-chk_add_nr 1 1
-chk_rm_nr 0 0
-
-# subflow and signal IPv6, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns1 ./pm_nl_ctl add dead:beef:2::1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-ip netns exec $ns2 ./pm_nl_ctl add dead:beef:3::2 flags subflow
-run_tests $ns1 $ns2 dead:beef:1::1 0 -1 -1 slow
-chk_join_nr "remove subflow and signal IPv6" 2 2 2
-chk_add_nr 1 1
-chk_rm_nr 1 1
-
-# subflow IPv4-mapped to IPv4-mapped
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
-run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-chk_join_nr "single subflow IPv4-mapped" 1 1 1
-
-# signal address IPv4-mapped with IPv4-mapped sk
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
-run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-chk_join_nr "signal address IPv4-mapped" 1 1 1
-chk_add_nr 1 1
-
-# subflow v4-map-v6
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-chk_join_nr "single subflow v4-map-v6" 1 1 1
-
-# signal address v4-map-v6
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-run_tests $ns1 $ns2 "::ffff:10.0.1.1"
-chk_join_nr "signal address v4-map-v6" 1 1 1
-chk_add_nr 1 1
-
-# subflow v6-map-v4
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add "::ffff:10.0.3.2" flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "single subflow v6-map-v4" 1 1 1
-
-# signal address v6-map-v4
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add "::ffff:10.0.2.1" flags signal
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "signal address v6-map-v4" 1 1 1
-chk_add_nr 1 1
-
-# no subflow IPv6 to v4 address
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "no JOIN with diff families v4-v6" 0 0 0
-
-# no subflow IPv6 to v4 address even if v6 has a valid v4 at the end
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add dead:beef:2::10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "no JOIN with diff families v4-v6-2" 0 0 0
-
-# no subflow IPv4 to v6 address, no need to slow down too then
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 dead:beef:1::1
-chk_join_nr "no JOIN with diff families v6-v4" 0 0 0
-
-# single subflow, backup
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
-run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
-chk_join_nr "single subflow, backup" 1 1 1
-chk_prio_nr 0 1
-
-# single address, backup
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
-chk_join_nr "single address, backup" 1 1 1
-chk_add_nr 1 1
-chk_prio_nr 1 0
-
-# signal address with port
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "signal address with port" 1 1 1
-chk_add_nr 1 1 1
-
-# subflow and signal with port
-reset
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "subflow and signal with port" 2 2 2
-chk_add_nr 1 1 1
-
-# single address with port, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
-chk_join_nr "remove single address with port" 1 1 1
-chk_add_nr 1 1 1
-chk_rm_nr 0 0
-
-# subflow and signal with port, remove
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
-chk_join_nr "remove subflow and signal with port" 2 2 2
-chk_add_nr 1 1 1
-chk_rm_nr 1 1
-
-# subflows and signal with port, flush
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
-chk_join_nr "flush subflows and signal with port" 3 3 3
-chk_add_nr 1 1
-chk_rm_nr 2 2
-
-# multiple addresses with port
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10100
-ip netns exec $ns2 ./pm_nl_ctl limits 2 2
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "multiple addresses with port" 2 2 2
-chk_add_nr 2 2 2
-
-# multiple addresses with ports
-reset
-ip netns exec $ns1 ./pm_nl_ctl limits 2 2
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal port 10100
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal port 10101
-ip netns exec $ns2 ./pm_nl_ctl limits 2 2
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "multiple addresses with ports" 2 2 2
-chk_add_nr 2 2 2
-
-# single subflow, syncookies
-reset_with_cookies
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "single subflow with syn cookies" 1 1 1
-
-# multiple subflows with syn cookies
-reset_with_cookies
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "multiple subflows with syn cookies" 2 2 2
-
-# multiple subflows limited by server
-reset_with_cookies
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "subflows limited by server w cookies" 2 2 1
-
-# test signal address with cookies
-reset_with_cookies
-ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-ip netns exec $ns2 ./pm_nl_ctl limits 1 1
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "signal address with syn cookies" 1 1 1
-chk_add_nr 1 1
-
-# test cookie with subflow and signal
-reset_with_cookies
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "subflow and signal w cookies" 2 2 2
-chk_add_nr 1 1
-
-# accept and use add_addr with additional subflows
-reset_with_cookies
-ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
-ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
-run_tests $ns1 $ns2 10.0.1.1
-chk_join_nr "subflows and signal w. cookies" 3 3 3
-chk_add_nr 1 1
+if [ -z $1 ]; then
+	all_tests
+	exit $ret
+fi
+
+while getopts 'fsltra64bpch' opt; do
+	case $opt in
+		f)
+			subflows_tests
+			;;
+		s)
+			signal_address_tests
+			;;
+		l)
+			link_failure_tests
+			;;
+		t)
+			add_addr_timeout_tests
+			;;
+		r)
+			remove_tests
+			;;
+		a)
+			add_tests
+			;;
+		6)
+			ipv6_tests
+			;;
+		4)
+			v4mapped_tests
+			;;
+		b)
+			backup_tests
+			;;
+		p)
+			add_addr_ports_tests
+			;;
+		c)
+			syncookies_tests
+			;;
+		h | *)
+			usage
+			;;
+	esac
+done
 
 exit $ret
-- 
2.30.0

