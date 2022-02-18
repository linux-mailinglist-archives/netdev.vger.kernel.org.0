Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37384BAFFC
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiBRDDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiBRDDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F5459A4B
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153400; x=1676689400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WbGXLDoYtJJu27wCa1qwhlZvWNzqWHDcYOCMw2OmxPg=;
  b=T5zKQvtnHwvwgg3B37Ubfidxk1AZMszdMmCZe3Weo1F5+87GtF+4YQb4
   KZQJmWynSnuaDZMYmSB9kEjlLrSq3n+Ac/eYdNkz7talaUnVQW3JXmffS
   vcpVt5zwPHqlDcfHtOr3XQsnWqrwsBaoQYliVEUyVYhuhKu3+PQqG+ZET
   L9Y7wNgysCb6/wqiop/18gyMG4UgGZ0PZH3rR0jC9ouyPHem49ZG+8jhJ
   t3M67Q6EJxkp9hTLed/aJl7tQ7TmvDCJYjsWAjrfu9DTLwyPI5DRn3wx6
   vj1wz5y9Q23P85QoOaTMpobxf5QssR2MjWmkPR/RoVkShGi/GLipKMJ1N
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794594"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794594"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431898"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/7] selftests: mptcp: simplify pm_nl_change_endpoint
Date:   Thu, 17 Feb 2022 19:03:06 -0800
Message-Id: <20220218030311.367536-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
References: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch simplified pm_nl_change_endpoint(), using id-based address
lookups only. And dropped the fragile way of parsing 'addr' and 'id'
from the output of pm_nl_show_endpoints().

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 37 ++++---------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 18bb0d0cf4bd..bbcacaaf81ce 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -240,16 +240,6 @@ is_v6()
 	[ -z "${1##*:*}" ]
 }
 
-is_addr()
-{
-	[ -z "${1##*[.:]*}" ]
-}
-
-is_number()
-{
-	[[ $1 == ?(-)+([0-9]) ]]
-}
-
 # $1: ns, $2: port
 wait_local_port_listen()
 {
@@ -379,16 +369,13 @@ pm_nl_show_endpoints()
 pm_nl_change_endpoint()
 {
 	local ns=$1
-	local flags=$2
-	local id=$3
-	local addr=$4
-	local port=""
+	local id=$2
+	local flags=$3
 
 	if [ $ip_mptcp -eq 1 ]; then
 		ip -n $ns mptcp endpoint change id $id ${flags//","/" "}
 	else
-		if [ $5 -ne 0 ]; then port="port $5"; fi
-		ip netns exec $ns ./pm_nl_ctl set $addr flags $flags $port
+		ip netns exec $ns ./pm_nl_ctl set id $id flags $flags
 	fi
 }
 
@@ -591,24 +578,16 @@ do_transfer()
 		for netns in "$ns1" "$ns2"; do
 			pm_nl_show_endpoints $netns | while read line; do
 				local arr=($line)
-				local addr
-				local port=0
+				local nr=0
 				local id
 
 				for i in ${arr[@]}; do
-					if is_addr $i; then
-						addr=$i
-					elif is_number $i; then
-						# The minimum expected port number is 10000
-						if [ $i -gt 10000 ]; then
-							port=$i
-						# The maximum id number is 255
-						elif [ $i -lt 255 ]; then
-							id=$i
-						fi
+					if [ $i = "id" ]; then
+						id=${arr[$nr+1]}
 					fi
+					let nr+=1
 				done
-				pm_nl_change_endpoint $netns $sflags $id $addr $port
+				pm_nl_change_endpoint $netns $id $sflags
 			done
 		done
 	fi
-- 
2.35.1

