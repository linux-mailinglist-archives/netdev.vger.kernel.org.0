Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401D0C9500
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbfJBXiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:16472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfJBXhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862642"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:25 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 45/45] selftests: mptcp: random ethtool tweaking
Date:   Wed,  2 Oct 2019 16:36:55 -0700
Message-Id: <20191002233655.24323-46-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Instead of unconditionally disabling TSO in ns3, turn off any of
gso/tso/gro in ns3 and/or ns4.

This gets us various combinations of GRO/GSO/TSO without a large
impact on test time.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 615691434a34..40cce8d1772e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -92,7 +92,6 @@ $ipv6 && ip -net ns3 addr add dead:beef:3::2/64 dev ns3eth4
 ip -net ns3 link set ns3eth4 up
 ip -net ns3 route add default via 10.0.2.1
 $ipv6 && ip -net ns3 route add default via dead:beef:2::1
-ip netns exec ns3 ethtool -K ns3eth2 tso off 2>/dev/null
 ip netns exec ns3 sysctl -q net.ipv4.ip_forward=1
 $ipv6 && ip netns exec ns3 sysctl -q net.ipv6.conf.all.forwarding=1
 
@@ -102,6 +101,34 @@ ip -net ns4 link set ns4eth3 up
 ip -net ns4 route add default via 10.0.3.2
 $ipv6 && ip -net ns4 route add default via dead:beef:3::2
 
+set_ethtool_flags() {
+	ns=$1
+	dev=$2
+
+	r=$RANDOM
+
+	pick1=$((r & 1))
+	r=$((r>>1))
+	pick2=$((r & 1))
+	r=$((r>>1))
+	pick3=$((r & 1))
+
+	comma=""
+	flags=""
+	[ $pick1 -ne 0 ] && flags="tso"
+	[ $pick1 -ne 0 ] && comma=","
+	[ $pick2 -ne 0 ] && flags=${flags}${comma}"gso"
+	[ $pick3 -ne 0 ] && flags=${flags}${comma}"gro"
+
+	[ -z $flags ] && return
+
+	ip netns exec $ns ethtool -K $dev $flags off 2>/dev/null
+	[ $? -eq 0 ] && echo "INFO: set $ns dev $dev: ethtool -K $flags off"
+}
+
+set_ethtool_flags ns3 ns3eth2
+set_ethtool_flags ns4 ns4eth3
+
 print_file_err()
 {
 	ls -l "$1" 1>&2
-- 
2.23.0

