Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E3122FDD5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgG0XaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgG0XXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:23:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EDC220A8B;
        Mon, 27 Jul 2020 23:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892235;
        bh=I2dTzUq/9wZciNDjDhbRp5+H1zAaUup4cSjPwG9P8DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjcrjdePUCW5hCWkOxycGS8bv3eQjSzRJGTq+ylPD1i4vEPFARGVBwWAaFS34rpGR
         BDpVa1xJ2Nqbv9ksiVbOVjZIdz9t6l22Jl93L5CzljCSyRn1N/XZhy2koMAx/ELGXH
         CiHQqtInTlUMDRrjvTzqRTH8tj2r2YEObBVBfT3U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Pisati <paolo.pisati@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 06/25] selftests: net: ip_defrag: modprobe missing nf_defrag_ipv6 support
Date:   Mon, 27 Jul 2020 19:23:26 -0400
Message-Id: <20200727232345.717432-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232345.717432-1-sashal@kernel.org>
References: <20200727232345.717432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

[ Upstream commit aba69d49fb49c9166596dd78926514173b7f9ab5 ]

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
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ip_defrag.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/ip_defrag.sh b/tools/testing/selftests/net/ip_defrag.sh
index 15d3489ecd9ce..ceb7ad4dbd945 100755
--- a/tools/testing/selftests/net/ip_defrag.sh
+++ b/tools/testing/selftests/net/ip_defrag.sh
@@ -6,6 +6,8 @@
 set +x
 set -e
 
+modprobe -q nf_defrag_ipv6
+
 readonly NETNS="ns-$(mktemp -u XXXXXX)"
 
 setup() {
-- 
2.25.1

