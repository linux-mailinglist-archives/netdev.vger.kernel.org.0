Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A036606CE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbjAFS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbjAFS5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:57:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3387DE38
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031462; x=1704567462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a8gyns7Ko54rdIa1+HSNN/LKtDcgrXJkUF2mSLfWSHk=;
  b=WtQZO6U7Zw5IR6rg9HgdPY5DiG3Lw3I1NpGiwhIVaP7Xblm0zF0oYcqE
   Bj8CERtrSly2KuXrJdxzgACcfe4iQrq68a+M+ttroC53FtIqdZ4OTjvV2
   74iDcAh3K2m6QDT99/i0qfkOyEztOEfQea6qv32qHtq+lngM6z3d4TGh/
   cxaL7pKZrAqmt0aE3vyXFKiuRXKCLkpxR3jNNToCGNqtJDJk/Kr9bTbTJ
   vTitCvah4Vu7LxWuB7+xxp1r453Powdz3L+Ynlq9hgDXgkDCPQeJHvlEf
   gDk4NEsaUWO0NLESApXsDk9Lcv9s5kjyWsMatXTPeocOh1CPcDiy4F2YQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322611262"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="322611262"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688383436"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688383436"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:57:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Menglong Dong <imagedong@tencent.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 9/9] selftest: mptcp: add test for mptcp socket in use
Date:   Fri,  6 Jan 2023 10:57:25 -0800
Message-Id: <20230106185725.299977-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
References: <20230106185725.299977-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Add the function chk_msk_inuse() to diag.sh, which is used to check the
statistics of mptcp socket in use. As mptcp socket in listen state will
be closed randomly after 'accept', we need to get the count of listening
mptcp socket through 'ss' command.

All tests pass.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/diag.sh | 56 +++++++++++++++++++++--
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index 24bcd7b9bdb2..ef628b16fe9b 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -17,6 +17,11 @@ flush_pids()
 	sleep 1.1
 
 	ip netns pids "${ns}" | xargs --no-run-if-empty kill -SIGUSR1 &>/dev/null
+
+	for _ in $(seq 10); do
+		[ -z "$(ip netns pids "${ns}")" ] && break
+		sleep 0.1
+	done
 }
 
 cleanup()
@@ -37,15 +42,20 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
+get_msk_inuse()
+{
+	ip netns exec $ns cat /proc/net/protocols | awk '$1~/^MPTCP$/{print $3}'
+}
+
 __chk_nr()
 {
-	local condition="$1"
+	local command="$1"
 	local expected=$2
 	local msg nr
 
 	shift 2
 	msg=$*
-	nr=$(ss -inmHMN $ns | $condition)
+	nr=$(eval $command)
 
 	printf "%-50s" "$msg"
 	if [ $nr != $expected ]; then
@@ -57,9 +67,17 @@ __chk_nr()
 	test_cnt=$((test_cnt+1))
 }
 
+__chk_msk_nr()
+{
+	local condition=$1
+	shift 1
+
+	__chk_nr "ss -inmHMN $ns | $condition" $*
+}
+
 chk_msk_nr()
 {
-	__chk_nr "grep -c token:" $*
+	__chk_msk_nr "grep -c token:" $*
 }
 
 wait_msk_nr()
@@ -97,12 +115,12 @@ wait_msk_nr()
 
 chk_msk_fallback_nr()
 {
-		__chk_nr "grep -c fallback" $*
+		__chk_msk_nr "grep -c fallback" $*
 }
 
 chk_msk_remote_key_nr()
 {
-		__chk_nr "grep -c remote_key" $*
+		__chk_msk_nr "grep -c remote_key" $*
 }
 
 __chk_listen()
@@ -142,6 +160,26 @@ chk_msk_listen()
 	nr=$(ss -Ml $filter | wc -l)
 }
 
+chk_msk_inuse()
+{
+	local expected=$1
+	local listen_nr
+
+	shift 1
+
+	listen_nr=$(ss -N "${ns}" -Ml | grep -c LISTEN)
+	expected=$((expected + listen_nr))
+
+	for _ in $(seq 10); do
+		if [ $(get_msk_inuse) -eq $expected ];then
+			break
+		fi
+		sleep 0.1
+	done
+
+	__chk_nr get_msk_inuse $expected $*
+}
+
 # $1: ns, $2: port
 wait_local_port_listen()
 {
@@ -195,8 +233,10 @@ wait_connected $ns 10000
 chk_msk_nr 2 "after MPC handshake "
 chk_msk_remote_key_nr 2 "....chk remote_key"
 chk_msk_fallback_nr 0 "....chk no fallback"
+chk_msk_inuse 2 "....chk 2 msk in use"
 flush_pids
 
+chk_msk_inuse 0 "....chk 0 msk in use after flush"
 
 echo "a" | \
 	timeout ${timeout_test} \
@@ -211,8 +251,11 @@ echo "b" | \
 				127.0.0.1 >/dev/null &
 wait_connected $ns 10001
 chk_msk_fallback_nr 1 "check fallback"
+chk_msk_inuse 1 "....chk 1 msk in use"
 flush_pids
 
+chk_msk_inuse 0 "....chk 0 msk in use after flush"
+
 NR_CLIENTS=100
 for I in `seq 1 $NR_CLIENTS`; do
 	echo "a" | \
@@ -232,6 +275,9 @@ for I in `seq 1 $NR_CLIENTS`; do
 done
 
 wait_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
+chk_msk_inuse $((NR_CLIENTS*2)) "....chk many msk in use"
 flush_pids
 
+chk_msk_inuse 0 "....chk 0 msk in use after flush"
+
 exit $ret
-- 
2.39.0

