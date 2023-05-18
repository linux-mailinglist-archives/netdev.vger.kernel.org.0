Return-Path: <netdev+bounces-3747-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CA477087B0
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B3441C210EF
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DAA3A315;
	Thu, 18 May 2023 18:07:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B50D3A2E3;
	Thu, 18 May 2023 18:07:02 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58F28F;
	Thu, 18 May 2023 11:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433220; x=1715969220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=btMEqfPJdz24ajU0aJZF0IeGeFF/1NrmUw/U4+YuNPo=;
  b=QCUre7+j6TmljQLGX+HY0kXcvw6etSqLKndw5GuJPNk8KxUI0u1Yi/mg
   ZKaVWIZoDeagYWnxRinpYrYIdniENy3nmWeMAFkXRV31/+o8fdeyZu0fN
   YucIx3o3W2ar1X7MFwMYAqgX7837bzNCPX4pevW+Wy7P0xXTlsKcrRusY
   DZ7l4V37cKFHrqUhxNc/8knnjMZFnE2u0C1tr6CNtLlkb+m8krry4hEvF
   qonUXqGxdoieKHFjQ53HP9m5UpBQ22wL06tKlONBCkqHNkK0uari+/nIR
   GvdODAd7vZqWQ8Df1iAd8a9mqmd0Bkb9xkZE0ta0fPFK7ADjFktV0wwTc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350985094"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350985094"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780640"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780640"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:43 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	bjorn@kernel.org
Subject: [PATCH bpf-next 21/21] selftests/xsk: reset NIC settings to default after running test suite
Date: Thu, 18 May 2023 20:05:45 +0200
Message-Id: <20230518180545.159100-22-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, when running ZC test suite, after finishing first run of test
suite and then switching to busy-poll tests within xskxceiver, such
errors are observed:

libbpf: Kernel error message: ice: MTU is too large for linear frames and XDP prog does not support frags
1..26
libbpf: Kernel error message: Native and generic XDP can't be active at the same time
Error attaching XDP program
not ok 1 [xskxceiver.c:xsk_reattach_xdp:1568]: ERROR: 17/"File exists"

this is because test suite ends with 9k MTU and native xdp program being
loaded. Busy-poll tests start non-multi-buffer tests for generic mode.
To fix this, let us introduce bash function that will reset NIC settings
to default (e.g. 1500 MTU and no xdp progs loaded) so that test suite
can continue without interrupts. It also means that after busy-poll
tests NIC will have those default settings, whereas right now it is left
with 9k MTU and xdp prog loaded in native mode.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 5 +++++
 tools/testing/selftests/bpf/xsk_prereqs.sh | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index c2ad50f26b63..2aa5a3445056 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -171,7 +171,10 @@ exec_xskxceiver
 
 if [ -z $ETH ]; then
 	cleanup_exit ${VETH0} ${VETH1}
+else
+	cleanup_iface ${ETH} ${MTU}
 fi
+
 TEST_NAME="XSK_SELFTESTS_${VETH0}_BUSY_POLL"
 busy_poll=1
 
@@ -184,6 +187,8 @@ exec_xskxceiver
 
 if [ -z $ETH ]; then
 	cleanup_exit ${VETH0} ${VETH1}
+else
+	cleanup_iface ${ETH} ${MTU}
 fi
 
 failures=0
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index ae697a10a056..29175682c44d 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -53,6 +53,13 @@ test_exit()
 	exit 1
 }
 
+cleanup_iface()
+{
+	ip link set $1 mtu $2
+	ip link set $1 xdp off
+	ip link set $1 xdpgeneric off
+}
+
 clear_configs()
 {
 	[ $(ip link show $1 &>/dev/null; echo $?;) == 0 ] &&
-- 
2.34.1


