Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E7F242AE2
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 16:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgHLODf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 10:03:35 -0400
Received: from foss.arm.com ([217.140.110.172]:45598 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgHLODc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 10:03:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89B3FD6E;
        Wed, 12 Aug 2020 07:03:31 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6F9DF3F70D;
        Wed, 12 Aug 2020 07:03:28 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, Song.Zhu@arm.com,
        Jianlin.Lv@arm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next] bpf: fix load XDP program error in test_xdp_vlan
Date:   Wed, 12 Aug 2020 22:03:22 +0800
Message-Id: <20200812140322.132844-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_xdp_vlan.sh reports the error as below:

$ sudo ./test_xdp_vlan_mode_native.sh
+ '[' -z xdp_vlan_mode_native ']'
+ XDP_MODE=xdpgeneric
……
+ export XDP_PROG=xdp_vlan_remove_outer2
+ XDP_PROG=xdp_vlan_remove_outer2
+ ip netns exec ns1 ip link set veth1 xdpdrv off
Error: XDP program already attached.

ip will throw an error in case a XDP program is already attached to the
networking interface, to prevent it from being overridden by accident.
In order to replace the currently running XDP program with a new one,
the -force option must be used.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 tools/testing/selftests/bpf/test_xdp_vlan.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_vlan.sh b/tools/testing/selftests/bpf/test_xdp_vlan.sh
index bb8b0da91686..034e603aeb50 100755
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -220,7 +220,7 @@ ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
 # ETH_P_8021Q indication, and this cause overwriting of our changes.
 #
 export XDP_PROG=xdp_vlan_remove_outer2
-ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE off
+ip netns exec ns1 ip -force link set $DEVNS1 $XDP_MODE off
 ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # Now the namespaces should still be able reach each-other, test with ping:
-- 
2.17.1

