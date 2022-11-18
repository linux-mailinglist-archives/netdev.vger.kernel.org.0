Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B7C630003
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiKRWZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiKRWYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:24:46 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57787286FC
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668810284; x=1700346284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dG1Tx+g9eK3xZ6BtFhOy7tg565+/z/blAfxvZrQui14=;
  b=nuElh7Gg4SVQJwQs8akJOTUVVJ5wdqpK0EkrSgEM7bn1/DcRUmqFkU4s
   N1SxvLIuZX/Pmr376QmZnvWUG2lu6HUp7wg/zycuPRSrOspf1UuDrGsN8
   lvjX1SvLCDMxP02UGOHsCkECnZMRIjps/eJOtRNIlt/JBmaADAoTvhT/L
   57o8XYcbNSH6kesMbLCEvPWhmFuCd0zrWosbct/rFw/NgWZouqto3EUeo
   1xvSOLaQKwzDx6IlxSwBjNystBYO+XeUgDhSoGv50K5A35nb3XJgBxeoi
   B+1uqx2RIGzQGkUrqExmw0D02jw45Hx8nanmNGMflQOeRBCfCPvnhS1tz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375394911"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="375394911"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 14:24:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="634580306"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="634580306"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 18 Nov 2022 14:24:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/4] iavf: Fix a crash during reset task
Date:   Fri, 18 Nov 2022 14:24:36 -0800
Message-Id: <20221118222439.1565245-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
References: <20221118222439.1565245-1-anthony.l.nguyen@intel.com>
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

From: Ivan Vecera <ivecera@redhat.com>

Recent commit aa626da947e9 ("iavf: Detach device during reset task")
removed netif_tx_stop_all_queues() with an assumption that Tx queues
are already stopped by netif_device_detach() in the beginning of
reset task. This assumption is incorrect because during reset
task a potential link event can start Tx queues again.
Revert this change to fix this issue.

Reproducer:
1. Run some Tx traffic (e.g. iperf3) over iavf interface
2. Switch MTU of this interface in a loop

[root@host ~]# cat repro.sh

IF=enp2s0f0v0

iperf3 -c 192.168.0.1 -t 600 --logfile /dev/null &
sleep 2

while :; do
        for i in 1280 1500 2000 900 ; do
                ip link set $IF mtu $i
                sleep 2
        done
done
[root@host ~]# ./repro.sh

Result:
[  306.199917] iavf 0000:02:02.0 enp2s0f0v0: NIC Link is Up Speed is 40 Gbps Full Duplex
[  308.205944] iavf 0000:02:02.0 enp2s0f0v0: NIC Link is Up Speed is 40 Gbps Full Duplex
[  310.103223] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  310.110179] #PF: supervisor write access in kernel mode
[  310.115396] #PF: error_code(0x0002) - not-present page
[  310.120526] PGD 0 P4D 0
[  310.123057] Oops: 0002 [#1] PREEMPT SMP NOPTI
[  310.127408] CPU: 24 PID: 183 Comm: kworker/u64:9 Kdump: loaded Not tainted 6.1.0-rc3+ #2
[  310.135485] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Super Server/H12SSW-iN, BIOS 2.4 04/13/2022
[  310.145728] Workqueue: iavf iavf_reset_task [iavf]
[  310.150520] RIP: 0010:iavf_xmit_frame_ring+0xd1/0xf70 [iavf]
[  310.156180] Code: d0 0f 86 da 00 00 00 83 e8 01 0f b7 fa 29 f8 01 c8 39 c6 0f 8f a0 08 00 00 48 8b 45 20 48 8d 14 92 bf 01 00 00 00 4c 8d 3c d0 <49> 89 5f 08 8b 43 70 66 41 89 7f 14 41 89 47 10 f6 83 82 00 00 00
[  310.174918] RSP: 0018:ffffbb5f0082caa0 EFLAGS: 00010293
[  310.180137] RAX: 0000000000000000 RBX: ffff92345471a6e8 RCX: 0000000000000200
[  310.187259] RDX: 0000000000000000 RSI: 000000000000000d RDI: 0000000000000001
[  310.194385] RBP: ffff92341d249000 R08: ffff92434987fcac R09: 0000000000000001
[  310.201509] R10: 0000000011f683b9 R11: 0000000011f50641 R12: 0000000000000008
[  310.208631] R13: ffff923447500000 R14: 0000000000000000 R15: 0000000000000000
[  310.215756] FS:  0000000000000000(0000) GS:ffff92434ee00000(0000) knlGS:0000000000000000
[  310.223835] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  310.229572] CR2: 0000000000000008 CR3: 0000000fbc210004 CR4: 0000000000770ee0
[  310.236696] PKRU: 55555554
[  310.239399] Call Trace:
[  310.241844]  <IRQ>
[  310.243855]  ? dst_alloc+0x5b/0xb0
[  310.247260]  dev_hard_start_xmit+0x9e/0x1f0
[  310.251439]  sch_direct_xmit+0xa0/0x370
[  310.255276]  __qdisc_run+0x13e/0x580
[  310.258848]  __dev_queue_xmit+0x431/0xd00
[  310.262851]  ? selinux_ip_postroute+0x147/0x3f0
[  310.267377]  ip_finish_output2+0x26c/0x540

Fixes: aa626da947e9 ("iavf: Detach device during reset task")
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
Cc: SlawomirX Laba <slawomirx.laba@intel.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Stefan reported seeing Tx timeouts with this patch[1], however,
that seems like a lesser issue than this crash.

[1] https://lore.kernel.org/netdev/20221108105343.vjczwdxcsxhfghk7@p1/

 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3fc572341781..5abcd66e7c7a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3033,6 +3033,7 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
+		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
-- 
2.35.1

