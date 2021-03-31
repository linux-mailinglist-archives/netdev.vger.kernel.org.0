Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDD034F553
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhCaAJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:09:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:35604 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhCaAJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:09:04 -0400
IronPort-SDR: m+wTydnebTx5ea7HbASO+XRnalwV/K/VNh30kgLAi30VnS2VBtnZmD8OU/hlLhVkNRVc4NnBlf
 nJiadj/gZU7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="212108120"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="212108120"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:03 -0700
IronPort-SDR: H4mVB+kLrMkhdwb5I5Z5wK1ERDZrH8nwzMHbr2OAUpZLSMi0u4rknrn9ZBPWqos10rqVTNL7Sx
 rlj7bE7ED21A==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="378682562"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.25.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/6] selftests: mptcp: remove id 0 address testcases
Date:   Tue, 30 Mar 2021 17:08:56 -0700
Message-Id: <20210331000856.117636-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
References: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the testcases for removing the id 0 subflow and the id 0
address.

In do_transfer, use the removing addresses number '9' for deleting the id
0 address.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 35 +++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 679de3abaf34..d2273b88e72c 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -294,9 +294,12 @@ do_transfer()
 					let id+=1
 				done
 			fi
-		else
+		elif [ $rm_nr_ns1 -eq 8 ]; then
 			sleep 1
 			ip netns exec ${listener_ns} ./pm_nl_ctl flush
+		elif [ $rm_nr_ns1 -eq 9 ]; then
+			sleep 1
+			ip netns exec ${listener_ns} ./pm_nl_ctl del 0 ${connect_addr}
 		fi
 	fi
 
@@ -333,9 +336,18 @@ do_transfer()
 					let id+=1
 				done
 			fi
-		else
+		elif [ $rm_nr_ns2 -eq 8 ]; then
 			sleep 1
 			ip netns exec ${connector_ns} ./pm_nl_ctl flush
+		elif [ $rm_nr_ns2 -eq 9 ]; then
+			local addr
+			if is_v6 "${connect_addr}"; then
+				addr="dead:beef:1::2"
+			else
+				addr="10.0.1.2"
+			fi
+			sleep 1
+			ip netns exec ${connector_ns} ./pm_nl_ctl del 0 $addr
 		fi
 	fi
 
@@ -988,6 +1000,25 @@ remove_tests()
 	chk_join_nr "flush invalid addresses" 1 1 1
 	chk_add_nr 3 3
 	chk_rm_nr 3 1 invert
+
+	# remove id 0 subflow
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1 0 0 -9 slow
+	chk_join_nr "remove id 0 subflow" 1 1 1
+	chk_rm_nr 1 1
+
+	# remove id 0 address
+	reset
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+	run_tests $ns1 $ns2 10.0.1.1 0 -9 0 slow
+	chk_join_nr "remove id 0 address" 1 1 1
+	chk_add_nr 1 1
+	chk_rm_nr 1 1 invert
 }
 
 add_tests()
-- 
2.31.1

