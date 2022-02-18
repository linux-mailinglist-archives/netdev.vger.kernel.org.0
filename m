Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72C54BC232
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbiBRVgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:36:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237535AbiBRVgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:36:09 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF2B108565
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 13:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645220152; x=1676756152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=25BcXDQQWkP0Aa2PBvrQgF9AqV4OGrfUZbGVafZBSaY=;
  b=jUHgCoGcHG69ABVk4sgVEJ5Cof48GxLNBMiefNKuhQwuqo0iKz9MmOg5
   oLULevu87TY3TMTR5QMrU4E1pok3Xf9bIkHCCZGQqOmD0tRxAJD82bjLc
   cPDJj0/qdYN5sD5+DEr0EXhbc1Mvs7v2+SOMhHzyyQ87Jz1nwWUzpUbpp
   79u+Fa7Bw+L/39ZW6wRHMI/k2+r84zSiARKxHSgWIa5f+Gn1OQgDxlwLP
   pyfX2ltup5ucO43A8uT6MqmbVeXlnuWNBsCgVH9cdSD7EBPEKmEP+gJ0h
   8MwETieXPoy3Lwyb+NU5VzDEoG7VxJLK75P+f1WnL9DJXoqx+ZPN5O4hp
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="251176192"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="251176192"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="605664068"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.65.242])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 13:35:50 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        geliang.tang@suse.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/7] selftests: mptcp: fix diag instability
Date:   Fri, 18 Feb 2022 13:35:38 -0800
Message-Id: <20220218213544.70285-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
References: <20220218213544.70285-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Instead of waiting for an arbitrary amount of time for the MPTCP
MP_CAPABLE handshake to complete, explicitly wait for the relevant
socket to enter into the established status.

Additionally let the data transfer application use the slowest
transfer mode available (-r), to cope with very slow host, or
high jitter caused by hosting VMs.

Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/258
Reported-and-tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/diag.sh | 44 +++++++++++++++++++----
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index 2674ba20d524..ff821025d309 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -71,6 +71,36 @@ chk_msk_remote_key_nr()
 		__chk_nr "grep -c remote_key" $*
 }
 
+# $1: ns, $2: port
+wait_local_port_listen()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+
+	local port_hex i
+
+	port_hex="$(printf "%04X" "${port}")"
+	for i in $(seq 10); do
+		ip netns exec "${listener_ns}" cat /proc/net/tcp | \
+			awk "BEGIN {rc=1} {if (\$2 ~ /:${port_hex}\$/ && \$4 ~ /0A/) {rc=0; exit}} END {exit rc}" &&
+			break
+		sleep 0.1
+	done
+}
+
+wait_connected()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+
+	local port_hex i
+
+	port_hex="$(printf "%04X" "${port}")"
+	for i in $(seq 10); do
+		ip netns exec ${listener_ns} grep -q " 0100007F:${port_hex} " /proc/net/tcp && break
+		sleep 0.1
+	done
+}
 
 trap cleanup EXIT
 ip netns add $ns
@@ -81,15 +111,15 @@ echo "a" | \
 		ip netns exec $ns \
 			./mptcp_connect -p 10000 -l -t ${timeout_poll} \
 				0.0.0.0 >/dev/null &
-sleep 0.1
+wait_local_port_listen $ns 10000
 chk_msk_nr 0 "no msk on netns creation"
 
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10000 -j -t ${timeout_poll} \
+			./mptcp_connect -p 10000 -r 0 -t ${timeout_poll} \
 				127.0.0.1 >/dev/null &
-sleep 0.1
+wait_connected $ns 10000
 chk_msk_nr 2 "after MPC handshake "
 chk_msk_remote_key_nr 2 "....chk remote_key"
 chk_msk_fallback_nr 0 "....chk no fallback"
@@ -101,13 +131,13 @@ echo "a" | \
 		ip netns exec $ns \
 			./mptcp_connect -p 10001 -l -s TCP -t ${timeout_poll} \
 				0.0.0.0 >/dev/null &
-sleep 0.1
+wait_local_port_listen $ns 10001
 echo "b" | \
 	timeout ${timeout_test} \
 		ip netns exec $ns \
-			./mptcp_connect -p 10001 -j -t ${timeout_poll} \
+			./mptcp_connect -p 10001 -r 0 -t ${timeout_poll} \
 				127.0.0.1 >/dev/null &
-sleep 0.1
+wait_connected $ns 10001
 chk_msk_fallback_nr 1 "check fallback"
 flush_pids
 
@@ -119,7 +149,7 @@ for I in `seq 1 $NR_CLIENTS`; do
 				./mptcp_connect -p $((I+10001)) -l -w 10 \
 					-t ${timeout_poll} 0.0.0.0 >/dev/null &
 done
-sleep 0.1
+wait_local_port_listen $ns $((NR_CLIENTS + 10001))
 
 for I in `seq 1 $NR_CLIENTS`; do
 	echo "b" | \
-- 
2.35.1

