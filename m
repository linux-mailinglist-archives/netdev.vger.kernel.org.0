Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85D65BEC2F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiITRqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiITRqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:46:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4558061D6B
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663695962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AbliVbXlQly5RovkwZbu+/I1PgCumMG1ueGQNxm6Zdg=;
        b=dh6Ts2FxhxJRya6sJQz5e5hGSSb3wIBoe07lJUtPxbou0ZGlHQhFbIkuHmXBQEzBJyoJdy
        hV7sxXhgeZ8sGeQl3xFzuCqcg+QLIgYBGEqdMhvVbCkwMFg2dUrI901282fgr8JK3cuhS5
        EIVGakRR2FSQ1GruGANboP1aRWEdM78=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-sIzzLldSMOS3OXEjN9KK5w-1; Tue, 20 Sep 2022 13:45:58 -0400
X-MC-Unique: sIzzLldSMOS3OXEjN9KK5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48090833948;
        Tue, 20 Sep 2022 17:45:58 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.18.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECE12140EBF5;
        Tue, 20 Sep 2022 17:45:57 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Jussi Maki <joamaki@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 1/2] selftests: bonding: cause oops in bond_rr_gen_slave_id
Date:   Tue, 20 Sep 2022 13:45:51 -0400
Message-Id: <b4b1dddae380df6cf75a2fc92803d229761a2b25.1663694476.git.jtoppins@redhat.com>
In-Reply-To: <cover.1663694476.git.jtoppins@redhat.com>
References: <cover.1663694476.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bonding selftest causes the following kernel oops on aarch64 and
should be architectures agnostic.

[  329.805838] kselftest: Running tests in drivers/net/bonding
[  330.011028] eth0: renamed from link1_2
[  330.220846] eth0: renamed from link1_1
[  330.387755] bond0: (slave eth0): making interface the new active one
[  330.394165] bond0: (slave eth0): Enslaving as an active interface with an up link
[  330.401867] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  334.586619] bond0: (slave eth0): Releasing backup interface
[  334.671065] bond0: (slave eth0): Enslaving as an active interface with an up link
[  334.686773] Unable to handle kernel paging request at virtual address ffff2c91ac905000
[  334.694703] Mem abort info:
[  334.697486]   ESR = 0x0000000096000004
[  334.701234]   EC = 0x25: DABT (current EL), IL = 32 bits
[  334.706536]   SET = 0, FnV = 0
[  334.709579]   EA = 0, S1PTW = 0
[  334.712719]   FSC = 0x04: level 0 translation fault
[  334.717586] Data abort info:
[  334.720454]   ISV = 0, ISS = 0x00000004
[  334.724288]   CM = 0, WnR = 0
[  334.727244] swapper pgtable: 4k pages, 48-bit VAs, pgdp=000008044d662000
[  334.733944] [ffff2c91ac905000] pgd=0000000000000000, p4d=0000000000000000
[  334.740734] Internal error: Oops: 96000004 [#1] SMP
[  334.745602] Modules linked in: bonding tls veth rfkill sunrpc arm_spe_pmu vfat fat acpi_ipmi ipmi_ssif ixgbe igb i40e mdio ipmi_devintf ipmi_msghandler arm_cmn arm_dsu_pmu cppc_cpufreq acpi_tad fuse zram crct10dif_ce ast ghash_ce sbsa_gwdt nvme drm_vram_helper drm_ttm_helper nvme_core ttm xgene_hwmon
[  334.772217] CPU: 7 PID: 2214 Comm: ping Not tainted 6.0.0-rc4-00133-g64ae13ed4784 #4
[  334.779950] Hardware name: GIGABYTE R272-P31-00/MP32-AR1-00, BIOS F18v (SCP: 1.08.20211002) 12/01/2021
[  334.789244] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  334.796196] pc : bond_rr_gen_slave_id+0x40/0x124 [bonding]
[  334.801691] lr : bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
[  334.807962] sp : ffff8000221733e0
[  334.811265] x29: ffff8000221733e0 x28: ffffdbac8572d198 x27: ffff80002217357c
[  334.818392] x26: 000000000000002a x25: ffffdbacb33ee000 x24: ffff07ff980fa000
[  334.825519] x23: ffffdbacb2e398ba x22: ffff07ff98102000 x21: ffff07ff981029c0
[  334.832646] x20: 0000000000000001 x19: ffff07ff981029c0 x18: 0000000000000014
[  334.839773] x17: 0000000000000000 x16: ffffdbacb1004364 x15: 0000aaaabe2f5a62
[  334.846899] x14: ffff07ff8e55d968 x13: ffff07ff8e55db30 x12: 0000000000000000
[  334.854026] x11: ffffdbacb21532e8 x10: 0000000000000001 x9 : ffffdbac857178ec
[  334.861153] x8 : ffff07ff9f6e5a28 x7 : 0000000000000000 x6 : 000000007c2b3742
[  334.868279] x5 : ffff2c91ac905000 x4 : ffff2c91ac905000 x3 : ffff07ff9f554400
[  334.875406] x2 : ffff2c91ac905000 x1 : 0000000000000001 x0 : ffff07ff981029c0
[  334.882532] Call trace:
[  334.884967]  bond_rr_gen_slave_id+0x40/0x124 [bonding]
[  334.890109]  bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
[  334.896033]  __bond_start_xmit+0x128/0x3a0 [bonding]
[  334.901001]  bond_start_xmit+0x54/0xb0 [bonding]
[  334.905622]  dev_hard_start_xmit+0xb4/0x220
[  334.909798]  __dev_queue_xmit+0x1a0/0x720
[  334.913799]  arp_xmit+0x3c/0xbc
[  334.916932]  arp_send_dst+0x98/0xd0
[  334.920410]  arp_solicit+0xe8/0x230
[  334.923888]  neigh_probe+0x60/0xb0
[  334.927279]  __neigh_event_send+0x3b0/0x470
[  334.931453]  neigh_resolve_output+0x70/0x90
[  334.935626]  ip_finish_output2+0x158/0x514
[  334.939714]  __ip_finish_output+0xac/0x1a4
[  334.943800]  ip_finish_output+0x40/0xfc
[  334.947626]  ip_output+0xf8/0x1a4
[  334.950931]  ip_send_skb+0x5c/0x100
[  334.954410]  ip_push_pending_frames+0x3c/0x60
[  334.958758]  raw_sendmsg+0x458/0x6d0
[  334.962325]  inet_sendmsg+0x50/0x80
[  334.965805]  sock_sendmsg+0x60/0x6c
[  334.969286]  __sys_sendto+0xc8/0x134
[  334.972853]  __arm64_sys_sendto+0x34/0x4c
[  334.976854]  invoke_syscall+0x78/0x100
[  334.980594]  el0_svc_common.constprop.0+0x4c/0xf4
[  334.985287]  do_el0_svc+0x38/0x4c
[  334.988591]  el0_svc+0x34/0x10c
[  334.991724]  el0t_64_sync_handler+0x11c/0x150
[  334.996072]  el0t_64_sync+0x190/0x194
[  334.999726] Code: b9001062 f9403c02 d53cd044 8b040042 (b8210040)
[  335.005810] ---[ end trace 0000000000000000 ]---
[  335.010416] Kernel panic - not syncing: Oops: Fatal exception in interrupt
[  335.017279] SMP: stopping secondary CPUs
[  335.021374] Kernel Offset: 0x5baca8eb0000 from 0xffff800008000000
[  335.027456] PHYS_OFFSET: 0x80000000
[  335.030932] CPU features: 0x0000,0085c029,19805c82
[  335.035713] Memory Limit: none
[  335.038756] Rebooting in 180 seconds..

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---

Notes:
    v2:
     * only delete used net namespaces

 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../bonding/bond-arp-interval-causes-panic.sh | 49 +++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index 0f9659407969..1d866658e541 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -2,7 +2,8 @@
 # Makefile for net selftests
 
 TEST_PROGS := bond-break-lacpdu-tx.sh \
-	      dev_addr_lists.sh
+	      dev_addr_lists.sh \
+	      bond-arp-interval-causes-panic.sh
 
 TEST_FILES := lag_lib.sh
 
diff --git a/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
new file mode 100755
index 000000000000..71c00bfafbc9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
@@ -0,0 +1,49 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# cause kernel oops in bond_rr_gen_slave_id
+DEBUG=${DEBUG:-0}
+
+set -e
+test ${DEBUG} -ne 0 && set -x
+
+finish()
+{
+	ip netns delete server || true
+	ip netns delete client || true
+	ip link del link1_1 || true
+}
+
+trap finish EXIT
+
+client_ip4=192.168.1.198
+server_ip4=192.168.1.254
+
+# setup kernel so it reboots after causing the panic
+echo 180 >/proc/sys/kernel/panic
+
+# build namespaces
+ip link add dev link1_1 type veth peer name link1_2
+
+ip netns add "server"
+ip link set dev link1_2 netns server up name eth0
+ip netns exec server ip addr add ${server_ip4}/24 dev eth0
+
+ip netns add "client"
+ip link set dev link1_1 netns client down name eth0
+ip netns exec client ip link add dev bond0 down type bond mode 1 \
+	miimon 100 all_slaves_active 1
+ip netns exec client ip link set dev eth0 down master bond0
+ip netns exec client ip link set dev bond0 up
+ip netns exec client ip addr add ${client_ip4}/24 dev bond0
+ip netns exec client ping -c 5 $server_ip4 >/dev/null
+
+ip netns exec client ip link set dev eth0 down nomaster
+ip netns exec client ip link set dev bond0 down
+ip netns exec client ip link set dev bond0 type bond mode 0 \
+	arp_interval 1000 arp_ip_target "+${server_ip4}"
+ip netns exec client ip link set dev eth0 down master bond0
+ip netns exec client ip link set dev bond0 up
+ip netns exec client ping -c 5 $server_ip4 >/dev/null
+
+exit 0
-- 
2.31.1

