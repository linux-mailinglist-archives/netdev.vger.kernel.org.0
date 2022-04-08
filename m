Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193124F9DC0
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbiDHTs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiDHTsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:48:17 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3084A389E
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649447173; x=1680983173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NABinCF0LHq/aOKg0y7Mwz+78G28IHxmsB6Mx1C7my4=;
  b=V4DajmRrmUl5o7t17p/WL8YW5fjWoIR5kMGDsTe4eUsv3f4SXjIaihgL
   nuQSKVK1HVHnyk8I5K69ZtCPx7yamC/Z2kczklANdkFZ7Y32+bBKNX2si
   WMIFAdYGsX31S+OUtlpTgt5gXysPxrH6U5HVdD+0UvV4vUQucJmUi8VHR
   o8AU6cD6os6AVUYeOX4wzYxhhwXWN8PlhZ8hdFCnU59xrwtcjzC/ufNSn
   kQ09Vq3IoQ56LO04oAtSt4cTQtsUs9xpKOzX78aEPfB9WXuzMEoJ65xZJ
   c0JY473JVjTg9c1XnC3+VdwMP4RQNBGyuIoagpixg8RTXbb9NZbBk3fLD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="322365316"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="322365316"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="659602181"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.134.75.99])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:11 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/8] selftests/mptcp: add diag listen tests
Date:   Fri,  8 Apr 2022 12:46:01 -0700
Message-Id: <20220408194601.305969-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
References: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Check dumping of mptcp listener sockets:
1. filter by dport should not return any results
2. filter by sport should return listen sk
3. filter by saddr+sport should return listen sk
4. no filter should return listen sk

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/diag.sh | 38 +++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index ff821025d309..9dd43d7d957b 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -71,6 +71,43 @@ chk_msk_remote_key_nr()
 		__chk_nr "grep -c remote_key" $*
 }
 
+__chk_listen()
+{
+	local filter="$1"
+	local expected=$2
+
+	shift 2
+	msg=$*
+
+	nr=$(ss -N $ns -Ml "$filter" | grep -c LISTEN)
+	printf "%-50s" "$msg"
+
+	if [ $nr != $expected ]; then
+		echo "[ fail ] expected $expected found $nr"
+		ret=$test_cnt
+	else
+		echo "[  ok  ]"
+	fi
+}
+
+chk_msk_listen()
+{
+	lport=$1
+	local msg="check for listen socket"
+
+	# destination port search should always return empty list
+	__chk_listen "dport $lport" 0 "listen match for dport $lport"
+
+	# should return 'our' mptcp listen socket
+	__chk_listen "sport $lport" 1 "listen match for sport $lport"
+
+	__chk_listen "src inet:0.0.0.0:$lport" 1 "listen match for saddr and sport"
+
+	__chk_listen "" 1 "all listen sockets"
+
+	nr=$(ss -Ml $filter | wc -l)
+}
+
 # $1: ns, $2: port
 wait_local_port_listen()
 {
@@ -113,6 +150,7 @@ echo "a" | \
 				0.0.0.0 >/dev/null &
 wait_local_port_listen $ns 10000
 chk_msk_nr 0 "no msk on netns creation"
+chk_msk_listen 10000
 
 echo "b" | \
 	timeout ${timeout_test} \
-- 
2.35.1

