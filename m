Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EFA7E1D3
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387833AbfHASAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfHASAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:00:30 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B32D32FA3E2;
        Thu,  1 Aug 2019 18:00:30 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BA125D704;
        Thu,  1 Aug 2019 18:00:27 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id CB26B31256FD1;
        Thu,  1 Aug 2019 20:00:26 +0200 (CEST)
Subject: [net v1 PATCH 3/4] selftests/bpf: reduce time to execute
 test_xdp_vlan.sh
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     xdp-newbies@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        brandon.cazander@multapplied.net,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Thu, 01 Aug 2019 20:00:26 +0200
Message-ID: <156468242676.27559.5206877790597119575.stgit@firesoul>
In-Reply-To: <156468229108.27559.2443904494495785131.stgit@firesoul>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 01 Aug 2019 18:00:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the increasing number of BPF selftests, it makes sense to
reduce the time to execute these tests.  The ping parameters are
adjusted to reduce the time from measures 9 sec to approx 2.8 sec.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/test_xdp_vlan.sh |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_vlan.sh b/tools/testing/selftests/bpf/test_xdp_vlan.sh
index 7348661be815..bb8b0da91686 100755
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -188,7 +188,7 @@ ip netns exec ns2 ip link set lo up
 # At this point, the hosts cannot reach each-other,
 # because ns2 are using VLAN tags on the packets.
 
-ip netns exec ns2 sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Okay ping fails"'
+ip netns exec ns2 sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Success: First ping must fail"'
 
 
 # Now we can use the test_xdp_vlan.c program to pop/push these VLAN tags
@@ -210,8 +210,8 @@ ip netns exec ns1 tc filter add dev $DEVNS1 egress \
   prio 1 handle 1 bpf da obj $FILE sec tc_vlan_push
 
 # Now the namespaces can reach each-other, test with ping:
-ip netns exec ns2 ping -W 2 -c 3 $IPADDR1
-ip netns exec ns1 ping -W 2 -c 3 $IPADDR2
+ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
 
 # Second test: Replace xdp prog, that fully remove vlan header
 #
@@ -224,5 +224,5 @@ ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE off
 ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # Now the namespaces should still be able reach each-other, test with ping:
-ip netns exec ns2 ping -W 2 -c 3 $IPADDR1
-ip netns exec ns1 ping -W 2 -c 3 $IPADDR2
+ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2

