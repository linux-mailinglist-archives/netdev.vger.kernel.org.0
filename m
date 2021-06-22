Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7F33B0DA2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhFVT1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:27:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:32271 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhFVT1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:27:48 -0400
IronPort-SDR: BPb/rGqhJga2c26DfMeeBjobW1f31a4OTFg7vrpSWXt9IGrGiJJfkohb3xazCUDSiJufNf67Om
 TOMXjwLaf14A==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="186818204"
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="186818204"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:31 -0700
IronPort-SDR: l1N+9FkG1RS1IWpLAUTo6GL30l3+PJe8+GtTpNR5/C1YedhMmy9d11lZLKe/ZjI2i3gkCCvAqi
 Hi1JhwJ61JIQ==
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="480909728"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.237.182])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:30 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/6] selftests: mptcp: turn rp_filter off on each NIC
Date:   Tue, 22 Jun 2021 12:25:22 -0700
Message-Id: <20210622192523.90117-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
References: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

To turn rp_filter off we should:

  echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter

and

  echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter

before NIC created.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 3aeef3bcb101..fd63ebfe9a2b 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -60,6 +60,8 @@ setup()
 	for i in "$ns1" "$ns2" "$ns3";do
 		ip netns add $i || exit $ksft_skip
 		ip -net $i link set lo up
+		ip netns exec $i sysctl -q net.ipv4.conf.all.rp_filter=0
+		ip netns exec $i sysctl -q net.ipv4.conf.default.rp_filter=0
 	done
 
 	ip link add ns1eth1 netns "$ns1" type veth peer name ns2eth1 netns "$ns2"
@@ -80,7 +82,6 @@ setup()
 
 	ip netns exec "$ns1" ./pm_nl_ctl limits 1 1
 	ip netns exec "$ns1" ./pm_nl_ctl add 10.0.2.1 dev ns1eth2 flags subflow
-	ip netns exec "$ns1" sysctl -q net.ipv4.conf.all.rp_filter=0
 
 	ip -net "$ns2" addr add 10.0.1.2/24 dev ns2eth1
 	ip -net "$ns2" addr add dead:beef:1::2/64 dev ns2eth1 nodad
-- 
2.32.0

