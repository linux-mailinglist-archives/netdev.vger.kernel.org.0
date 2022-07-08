Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1356E56C0B2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbiGHROV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238128AbiGHROU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:14:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E48120BE2
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 10:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657300459; x=1688836459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dDFcKsL9kB1Uqm+n86u6isMH3J6Z2PbdfW1/uIBATOc=;
  b=lf9AfmYXeCw3h1Jwr/dypVUjEp4pxd99/G97KsoyxQKRAE7h9pOUXkb1
   WnawssX870cBIM+I7hHrn8kJfXOL6IBI5HdWAKXUw7FIpjx0hVAg6pNxY
   5G/iP7XZ6g5ITDsAq5cASDtHcXqgahqWlrgcaTm+2tezHFOYtITzEBgKb
   x5AsFz+sLolhXXJotCV9iW5zYwSOndpiv2iJjpcQ20esOiTYZV7GcO0lb
   duqGu0R+9xSfktPGr4+MuTT9F/8ofVY4bh3YZhdVxVfmt9u4l+9Kzg56F
   f17zo5omA3BuF/zBS03kXuQMr3KCTsjiYrXEeTErbR8M4pT52HVnKAsQN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="267364238"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="267364238"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="651641498"
Received: from aroras-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.1.203])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 10:14:18 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/6] selftests: mptcp: tweak simult_flows for debug kernels
Date:   Fri,  8 Jul 2022 10:14:09 -0700
Message-Id: <20220708171413.327112-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220708171413.327112-1-mathew.j.martineau@linux.intel.com>
References: <20220708171413.327112-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The mentioned test measures the transfer run-time to verify
that the user-space program is able to use the full aggregate B/W.

Even on (virtual) link-speed-bound tests, debug kernel can slow
down the transfer enough to cause sporadic test failures.

Instead of unconditionally raising the maximum allowed run-time,
tweak when the running kernel is a debug one, and use some simple/
rough heuristic to guess such scenarios.

Note: this intentionally avoids looking for /boot/config-<version> as
the latter file is not always available in our reference CI
environments.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index f441ff7904fc..ffa13a957a36 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -12,6 +12,7 @@ timeout_test=$((timeout_poll * 2 + 1))
 test_cnt=1
 ret=0
 bail=0
+slack=50
 
 usage() {
 	echo "Usage: $0 [ -b ] [ -c ] [ -d ]"
@@ -52,6 +53,7 @@ setup()
 	cout=$(mktemp)
 	capout=$(mktemp)
 	size=$((2 * 2048 * 4096))
+
 	dd if=/dev/zero of=$small bs=4096 count=20 >/dev/null 2>&1
 	dd if=/dev/zero of=$large bs=4096 count=$((size / 4096)) >/dev/null 2>&1
 
@@ -104,6 +106,16 @@ setup()
 	ip -net "$ns3" route add default via dead:beef:3::2
 
 	ip netns exec "$ns3" ./pm_nl_ctl limits 1 1
+
+	# debug build can slow down measurably the test program
+	# we use quite tight time limit on the run-time, to ensure
+	# maximum B/W usage.
+	# Use kmemleak/lockdep/kasan/prove_locking presence as a rough
+	# estimate for this being a debug kernel and increase the
+	# maximum run-time accordingly. Observed run times for CI builds
+	# running selftests, including kbuild, were used to determine the
+	# amount of time to add.
+	grep -q ' kmemleak_init$\| lockdep_init$\| kasan_init$\| prove_locking$' /proc/kallsyms && slack=$((slack+550))
 }
 
 # $1: ns, $2: port
@@ -241,7 +253,7 @@ run_test()
 
 	# mptcp_connect will do some sleeps to allow the mp_join handshake
 	# completion (see mptcp_connect): 200ms on each side, add some slack
-	time=$((time + 450))
+	time=$((time + 400 + slack))
 
 	printf "%-60s" "$msg"
 	do_transfer $small $large $time
-- 
2.37.0

