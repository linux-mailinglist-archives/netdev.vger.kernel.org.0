Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B70963D28F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiK3JzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiK3JzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:55:08 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB6428E1E;
        Wed, 30 Nov 2022 01:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669802107; x=1701338107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pNLXsxeNGGkHQ/txi5YKruCJGisFk3qEwRDZxwc6iG0=;
  b=Rp5qP5Nh4tJgUpOfH6wkd+W7S5ImgGBTqPC+okV7eHQ/rmrlQS5wE2jO
   r4bT7LQ37YeUHuxCe7wNzRKgY/xzbBSIEyLN9EvCeVq4KuqRZgwd4LlIA
   379WqxLmLxyDtfiIYXgF86NYLelKco7nAjCN2f43VT3SVFBgwyTrclRVG
   zAUQJYSwBpask3ept7/gYxRZmCm3qFqiUerWphwv2+7n3ZoS0O0WSY1Z5
   f7rDZInIY/XIJsfeUSYK3Jl4EapZtpp4ycR1TFzY9ZkquqoBjzM7KZjHU
   IsLdZQOGMLP3dgvBO/6y8x6V1EBinIZjTON2ICuPsP3VNboTKTa02CYZd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="314047836"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="314047836"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 01:55:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="621823959"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="621823959"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 01:55:06 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] selftests: xsk: changes for setting up NICs to run xsk self-tests
Date:   Wed, 30 Nov 2022 15:11:42 +0530
Message-Id: <20221130094142.545051-1-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETH devies need to be set up for running xsk self-tests, like enable
loopback, set promiscuous mode, MTU etc. This patch adds those settings
before running xsk self-tests and reverts them back once done.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh | 27 ++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index d821fd098504..e7a5c5fc4f71 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -106,7 +106,11 @@ MTU=1500
 trap ctrl_c INT
 
 function ctrl_c() {
-        cleanup_exit ${VETH0} ${VETH1} ${NS1}
+	if [ ! -z $ETH ]; then
+		cleanup_exit ${VETH0} ${VETH1} ${NS1}
+	else
+		cleanup_eth
+	fi
 	exit 1
 }
 
@@ -138,9 +142,28 @@ setup_vethPairs() {
 	ip link set ${VETH0} up
 }
 
+setup_eth() {
+       sudo ethtool -L ${ETH} combined 1
+       sudo ethtool -K ${ETH} loopback on
+       sudo ip link set ${ETH} promisc on
+       sudo ip link set ${ETH} mtu ${MTU}
+       sudo ip link set ${ETH} up
+       IPV6_DISABLE_CMD="sudo sysctl -n net.ipv6.conf.${ETH}.disable_ipv6"
+       IPV6_DISABLE=`$IPV6_DISABLE_CMD 2> /dev/null`
+       [[ $IPV6_DISABLE == "0" ]] && $IPV6_DISABLE_CMD=1
+       sleep 1
+}
+
+cleanup_eth() {
+       [[ $IPV6_DISABLE == "0" ]] && $IPV6_DISABLE_CMD=0
+       sudo ethtool -K ${ETH} loopback off
+       sudo ip link set ${ETH} promisc off
+}
+
 if [ ! -z $ETH ]; then
 	VETH0=${ETH}
 	VETH1=${ETH}
+	setup_eth
 	NS1=""
 else
 	validate_root_exec
@@ -191,6 +214,8 @@ exec_xskxceiver
 
 if [ -z $ETH ]; then
 	cleanup_exit ${VETH0} ${VETH1} ${NS1}
+else
+	cleanup_eth
 fi
 
 failures=0
-- 
2.34.1

