Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B042246DF38
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbhLIAMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:12:32 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41742 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241319AbhLIAMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:12:31 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id ABB54605BD;
        Thu,  9 Dec 2021 01:06:35 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/7] selftests: netfilter: Add correctness test for mac,net set type
Date:   Thu,  9 Dec 2021 01:08:44 +0100
Message-Id: <20211209000847.102598-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211209000847.102598-1-pablo@netfilter.org>
References: <20211209000847.102598-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

The existing net,mac test didn't cover the issue recently reported
by Nikita Yushchenko, where MAC addresses wouldn't match if given
as first field of a concatenated set with AVX2 and 8-bit groups,
because there's a different code path covering the lookup of six
8-bit groups (MAC addresses) if that's the first field.

Add a similar mac,net test, with MAC address and IPv4 address
swapped in the set specification.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_concat_range.sh   | 24 ++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index 5a4938d6dcf2..ed61f6cab60f 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -23,8 +23,8 @@ TESTS="reported_issues correctness concurrency timeout"
 
 # Set types, defined by TYPE_ variables below
 TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
-       net_port_net net_mac net_mac_icmp net6_mac_icmp net6_port_net6_port
-       net_port_mac_proto_net"
+       net_port_net net_mac mac_net net_mac_icmp net6_mac_icmp
+       net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
 BUGS="flush_remove_add"
@@ -277,6 +277,23 @@ perf_entries	1000
 perf_proto	ipv4
 "
 
+TYPE_mac_net="
+display		mac,net
+type_spec	ether_addr . ipv4_addr
+chain_spec	ether saddr . ip saddr
+dst		 
+src		mac addr4
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	0
+"
+
 TYPE_net_mac_icmp="
 display		net,mac - ICMP
 type_spec	ipv4_addr . ether_addr
@@ -984,7 +1001,8 @@ format() {
 		fi
 	done
 	for f in ${src}; do
-		__expr="${__expr} . "
+		[ "${__expr}" != "{ " ] && __expr="${__expr} . "
+
 		__start="$(eval format_"${f}" "${srcstart}")"
 		__end="$(eval format_"${f}" "${srcend}")"
 
-- 
2.30.2

