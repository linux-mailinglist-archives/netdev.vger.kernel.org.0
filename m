Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7062331A840
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBLXWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:22:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:29010 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhBLXWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 18:22:30 -0500
IronPort-SDR: v4i3Eg1AiiWZbpBLbBNemuwQU3BAC4oDT2BlVIvTpR+kl8pO9Qg4AIvheiXrgQfssbezFJHFDg
 RCwcQOfTaXuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179934362"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179934362"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:36 -0800
IronPort-SDR: trdKtaFNZ0tu1VB0LnA+UJlyT90pMMTJKp/JvdZk9gJxwhabdclkFeesBLWcL7c5waqiAtfDQD
 9R9zpkGFWyjw==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="360595935"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:35 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/4] selftests: mptcp: dump more info on errors
Date:   Fri, 12 Feb 2021 15:20:27 -0800
Message-Id: <20210212232030.377261-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
References: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Even if that may sound completely unlikely, the mptcp implementation
is not perfect, yet.

When the self-tests report an error we usually need more information
of what the scripts currently report. iproute allow provides
some additional goodies since a few releases, let's dump them.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_connect.sh  | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 2cfd87d94db8..0c6b9d3c03c0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -128,6 +128,7 @@ cleanup()
 	local netns
 	for netns in "$ns1" "$ns2" "$ns3" "$ns4";do
 		ip netns del $netns
+		rm -f /tmp/$netns.{nstat,out}
 	done
 }
 
@@ -438,16 +439,24 @@ do_transfer()
 		kill ${cappid_connector}
 	fi
 
+	NSTAT_HISTORY=/tmp/${listener_ns}.nstat ip netns exec ${listener_ns} \
+		nstat | grep Tcp > /tmp/${listener_ns}.out
+	if [ ${listener_ns} != ${connector_ns} ]; then
+		NSTAT_HISTORY=/tmp/${connector_ns}.nstat ip netns exec ${connector_ns} \
+			nstat | grep Tcp > /tmp/${connector_ns}.out
+	fi
+
 	local duration
 	duration=$((stop-start))
 	duration=$(printf "(duration %05sms)" $duration)
 	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
 		echo "$duration [ FAIL ] client exit code $retc, server $rets" 1>&2
 		echo -e "\nnetns ${listener_ns} socket stat for ${port}:" 1>&2
-		ip netns exec ${listener_ns} ss -nita 1>&2 -o "sport = :$port"
+		ip netns exec ${listener_ns} ss -Menita 1>&2 -o "sport = :$port"
+		cat /tmp/${listener_ns}.out
 		echo -e "\nnetns ${connector_ns} socket stat for ${port}:" 1>&2
-		ip netns exec ${connector_ns} ss -nita 1>&2 -o "dport = :$port"
-
+		ip netns exec ${connector_ns} ss -Menita 1>&2 -o "dport = :$port"
+		[ ${listener_ns} != ${connector_ns} ] && cat /tmp/${connector_ns}.out
 		cat "$capout"
 		return 1
 	fi
-- 
2.30.1

