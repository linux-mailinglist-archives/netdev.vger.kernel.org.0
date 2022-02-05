Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770814AA4DC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378410AbiBEADw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:46978 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378638AbiBEADt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019429; x=1675555429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=99lJdKNYiu9KvqIPYUt13bHys3gSixFKEb2XApcOOCI=;
  b=hAxgsugHzTZkbTRq1oWGZFQWwQ46RpGmcuepGZp2/r8phGvEhBLyIqOT
   yFO/r7E1ndLJM+kgCDFsc/CaNRjcuoKGq6NPX2PCjHZhaj4JiI+Q2ZbVq
   WBET0W4KylCXUtsI0CDrxh5VbAIO5zYljshxePUhoNCLSKPQ24Rv2fam7
   c5HuXuLCWeBJrUvLYYvOZ4Vk+VSfJSZle3nbZboK4d3SlNHayeIVxKvOR
   +3g1MCLHRDQvy4Cip12e8gwV5gPbsH3nU+ZbcT5lUUVt+Fhrn7X1WlsRg
   Y8/MB/G9HPxi0V0KvJefqv1dD4uJ74UntplqdwEhsfwgTW2TRK2d8yMAc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115098"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115098"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097529"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:45 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 8/9] selftests: mptcp: add set_flags tests in pm_netlink.sh
Date:   Fri,  4 Feb 2022 16:03:36 -0800
Message-Id: <20220205000337.187292-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the setting flags test cases, using both addr-based and
id-based lookups for the setting address.

The output looks like this:

 set flags (backup)                                 [ OK ]
           (nobackup)                               [ OK ]
           (fullmesh)                               [ OK ]
           (nofullmesh)                             [ OK ]
           (backup,fullmesh)                        [ OK ]

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/pm_netlink.sh  | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index cbacf9f6538b..89839d1ff9d8 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -164,4 +164,22 @@ id 253 flags  10.0.0.5
 id 254 flags  10.0.0.2
 id 255 flags  10.0.0.3" "wrap-around ids"
 
+ip netns exec $ns1 ./pm_nl_ctl flush
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1 flags subflow
+ip netns exec $ns1 ./pm_nl_ctl set 10.0.1.1 flags backup
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+subflow,backup 10.0.1.1" "set flags (backup)"
+ip netns exec $ns1 ./pm_nl_ctl set 10.0.1.1 flags nobackup
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+subflow 10.0.1.1" "          (nobackup)"
+ip netns exec $ns1 ./pm_nl_ctl set id 1 flags fullmesh
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+subflow,fullmesh 10.0.1.1" "          (fullmesh)"
+ip netns exec $ns1 ./pm_nl_ctl set id 1 flags nofullmesh
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+subflow 10.0.1.1" "          (nofullmesh)"
+ip netns exec $ns1 ./pm_nl_ctl set id 1 flags backup,fullmesh
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+subflow,backup,fullmesh 10.0.1.1" "          (backup,fullmesh)"
+
 exit $ret
-- 
2.35.1

