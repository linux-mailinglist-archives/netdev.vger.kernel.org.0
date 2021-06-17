Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221E3ABFBD
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhFQXtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:49:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:13490 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233219AbhFQXsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:53 -0400
IronPort-SDR: 3b48dZ9yPshcc8VCwS17HicLSLE03BIC/k31WBDjnbm490pTZW6P3EVF+bss7bWHh/hyOdT70G
 hHU3bO/6PSgA==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506668"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506668"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:34 -0700
IronPort-SDR: LtOCCzk1jOrbgtelPEF9n6auB9W55FrpvOYBCsp/52QVpnoLadL89GtwgDuMnbXPrd3cHVDidC
 lohedL6X+cXg==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943926"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 15/16] selftests: mptcp: enable checksum in mptcp_connect.sh
Date:   Thu, 17 Jun 2021 16:46:21 -0700
Message-Id: <20210617234622.472030-16-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new argument "-C" for the mptcp_connect.sh script to
set the sysctl checksum_enabled to 1 in ns1, ns2, ns3 and ns4 to enable
the data checksum.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 9ca5f1ba461e..69351c3eb68c 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -3,7 +3,7 @@
 
 time_start=$(date +%s)
 
-optstring="S:R:d:e:l:r:h4cm:f:t"
+optstring="S:R:d:e:l:r:h4cm:f:tC"
 ret=0
 sin=""
 sout=""
@@ -22,6 +22,7 @@ sndbuf=0
 rcvbuf=0
 options_log=true
 do_tcp=0
+checksum=false
 filesize=0
 
 if [ $tc_loss -eq 100 ];then
@@ -47,6 +48,7 @@ usage() {
 	echo -e "\t-R: set rcvbuf value (default: use kernel default)"
 	echo -e "\t-m: test mode (poll, sendfile; default: poll)"
 	echo -e "\t-t: also run tests with TCP (use twice to non-fallback tcp)"
+	echo -e "\t-C: enable the MPTCP data checksum"
 }
 
 while getopts "$optstring" option;do
@@ -104,6 +106,9 @@ while getopts "$optstring" option;do
 	"t")
 		do_tcp=$((do_tcp+1))
 		;;
+	"C")
+		checksum=true
+		;;
 	"?")
 		usage $0
 		exit 1
@@ -200,6 +205,12 @@ ip -net "$ns4" route add default via dead:beef:3::2
 # use TCP syn cookies, even if no flooding was detected.
 ip netns exec "$ns2" sysctl -q net.ipv4.tcp_syncookies=2
 
+if $checksum; then
+	for i in "$ns1" "$ns2" "$ns3" "$ns4";do
+		ip netns exec $i sysctl -q net.mptcp.checksum_enabled=1
+	done
+fi
+
 set_ethtool_flags() {
 	local ns="$1"
 	local dev="$2"
-- 
2.32.0

