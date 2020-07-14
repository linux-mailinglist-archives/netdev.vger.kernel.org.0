Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9139421F1A9
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgGNMki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:40:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34397 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgGNMkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 08:40:37 -0400
Received: from 1.general.ppisati.uk.vpn ([10.172.193.134] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1jvKEb-0001KX-1E; Tue, 14 Jul 2020 12:40:33 +0000
From:   Paolo Pisati <paolo.pisati@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: net: ip_defrag: modprobe missing nf_defrag_ipv6 support
Date:   Tue, 14 Jul 2020 14:40:32 +0200
Message-Id: <20200714124032.49133-1-paolo.pisati@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix ip_defrag.sh when CONFIG_NF_DEFRAG_IPV6=m:

$ sudo ./ip_defrag.sh
+ set -e
+ mktemp -u XXXXXX
+ readonly NETNS=ns-rGlXcw
+ trap cleanup EXIT
+ setup
+ ip netns add ns-rGlXcw
+ ip -netns ns-rGlXcw link set lo up
+ ip netns exec ns-rGlXcw sysctl -w net.ipv4.ipfrag_high_thresh=9000000
+ ip netns exec ns-rGlXcw sysctl -w net.ipv4.ipfrag_low_thresh=7000000
+ ip netns exec ns-rGlXcw sysctl -w net.ipv4.ipfrag_time=1
+ ip netns exec ns-rGlXcw sysctl -w net.ipv6.ip6frag_high_thresh=9000000
+ ip netns exec ns-rGlXcw sysctl -w net.ipv6.ip6frag_low_thresh=7000000
+ ip netns exec ns-rGlXcw sysctl -w net.ipv6.ip6frag_time=1
+ ip netns exec ns-rGlXcw sysctl -w net.netfilter.nf_conntrack_frag6_high_thresh=9000000
+ cleanup
+ ip netns del ns-rGlXcw

$ ls -la /proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh
ls: cannot access '/proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh': No such file or directory

$ sudo modprobe nf_defrag_ipv6
$ ls -la /proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh
-rw-r--r-- 1 root root 0 Jul 14 12:34 /proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 tools/testing/selftests/net/ip_defrag.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/ip_defrag.sh b/tools/testing/selftests/net/ip_defrag.sh
index 15d3489ecd9c..6919afe47e0a 100755
--- a/tools/testing/selftests/net/ip_defrag.sh
+++ b/tools/testing/selftests/net/ip_defrag.sh
@@ -3,6 +3,8 @@
 #
 # Run a couple of IP defragmentation tests.
 
+modprobe -q nf_defrag_ipv6
+
 set +x
 set -e
 
-- 
2.25.1

