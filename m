Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635DA339AC6
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhCMBQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232439AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: NomKOBQKvsBclmloUlco3ox+qsA8ggqK/uReZBF3jwMQn5vwTVcO8mHfYT0LdW6FUY3wAId2Rb
 pzPa+UF0H9NA==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828250"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828250"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
IronPort-SDR: GRwBfXS7soACpvSWmAvamCSnoZ4K65niYAyWp05jfx/lz8cIqd4yzWC8HK5NADCOITu9PNNpzE
 o0idyYfsRqlw==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197379"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:27 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/11] selftests: mptcp: set addr id for removing testcases
Date:   Fri, 12 Mar 2021 17:16:20 -0800
Message-Id: <20210313011621.211661-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
References: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

The removing testcases can only delete the addresses from id 1, this
patch added the support for deleting the addresses from any id that user
set.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 38 ++++++++++++-------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 15b71ddee615..6782a891b3e7 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -284,14 +284,19 @@ do_transfer()
 		let rm_nr_ns1=-addr_nr_ns1
 		if [ $rm_nr_ns1 -lt 8 ]; then
 			counter=1
-			sleep 1
-
-			while [ $counter -le $rm_nr_ns1 ]
-			do
-				ip netns exec ${listener_ns} ./pm_nl_ctl del $counter
+			dump=(`ip netns exec ${listener_ns} ./pm_nl_ctl dump`)
+			if [ ${#dump[@]} -gt 0 ]; then
+				id=${dump[1]}
 				sleep 1
-				let counter+=1
-			done
+
+				while [ $counter -le $rm_nr_ns1 ]
+				do
+					ip netns exec ${listener_ns} ./pm_nl_ctl del $id
+					sleep 1
+					let counter+=1
+					let id+=1
+				done
+			fi
 		else
 			sleep 1
 			ip netns exec ${listener_ns} ./pm_nl_ctl flush
@@ -318,14 +323,19 @@ do_transfer()
 		let rm_nr_ns2=-addr_nr_ns2
 		if [ $rm_nr_ns2 -lt 8 ]; then
 			counter=1
-			sleep 1
-
-			while [ $counter -le $rm_nr_ns2 ]
-			do
-				ip netns exec ${connector_ns} ./pm_nl_ctl del $counter
+			dump=(`ip netns exec ${connector_ns} ./pm_nl_ctl dump`)
+			if [ ${#dump[@]} -gt 0 ]; then
+				id=${dump[1]}
 				sleep 1
-				let counter+=1
-			done
+
+				while [ $counter -le $rm_nr_ns2 ]
+				do
+					ip netns exec ${connector_ns} ./pm_nl_ctl del $id
+					sleep 1
+					let counter+=1
+					let id+=1
+				done
+			fi
 		else
 			sleep 1
 			ip netns exec ${connector_ns} ./pm_nl_ctl flush
-- 
2.30.2

