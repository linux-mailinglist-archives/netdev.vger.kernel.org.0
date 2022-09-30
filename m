Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E525F1628
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiI3Wa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiI3Wax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:30:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ACD13C86A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664577051; x=1696113051;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XehaOn6JbMRTwgphtM8IDOJl35m49Jh+wkmovNEQ90U=;
  b=KDgwR7NoVHKENoQQbssSfnaxnPcJl4yDzrMbupx19lGHdHlqv1PFbt+T
   dbdwP5/5T5byNZ5Wb4pmVvBQI2JyJb2StDn5rU1kCHOCVIiCVKSmJu075
   BWX1hhAZprhAOeWusAdQ0/u4Ec9ZmaIHLoyIIzfFWTTj+RWW0EOHXHImJ
   iKqOUW9ALuiQM770RBPVViQG6jfQ1juI81CLxeBjzoRQi+A8RYwLp3RZr
   XAFp8ECqL8EaVQYESWdM3HIgNV0PirZbPXKxehxjMcqmZRPF5x6/SaNbP
   8c9+7iPXlyGOqbJce5zlGGNnJZC1iXsltIAFseVjiVbDEjCNF792f0qCS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="301021086"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="301021086"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 15:30:50 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="622926112"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="622926112"
Received: from lmesseng-mobl2.amr.corp.intel.com (HELO vcostago-mobl3.intel.com) ([10.209.83.29])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 15:30:50 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vladimir.oltean@nxp.com, yannick.vignon@nxp.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kuba@kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH net v1] net/sched: taprio: Fix crash when adding child qdisc
Date:   Fri, 30 Sep 2022 15:30:42 -0700
Message-Id: <20220930223042.351022-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported by Husaini that since commit 1461d212ab27 ("net/sched:
taprio: make qdisc_leaf() see the per-netdev-queue pfifo child
qdiscs"), there was a NULL dereference when adding a child qdisc (ETF
in this case) when using taprio full offload.

The issue seems to be that since commit 13511704f8d7 ("net: taprio
offload: enforce qdisc to netdev queue mapping"), the array of child
qdiscs (q->qdiscs[]) was not used, and even free'd when full offload
mode is used, in attach().

The current implementation since 1461d212ab27 (which I feel is a
sensible change) requires that the q->qdiscs[] array is always valid.
The fix is to not deallocate it, and keep it having references to each
child qdisc.

Log:

[ 2295.318620] IPv6: ADDRCONF(NETDEV_CHANGE): enp170s0: link becomes ready
[ 2371.758745] BUG: kernel NULL pointer dereference, address: 0000000000000008
[ 2371.765697] #PF: supervisor read access in kernel mode
[ 2371.770825] #PF: error_code(0x0000) - not-present page
[ 2371.775952] PGD 0 P4D 0
[ 2371.778494] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 2371.782844] CPU: 0 PID: 17964 Comm: tc Tainted: G     U  W          6.0.0-rc6-intel-ese-standard-lts+ #95
[ 2371.792374] Hardware name: Intel Corporation Tiger Lake Client Platform/TigerLake U DDR4 SODIMM RVP, BIOS TGLIFUI1.R00.4204.A00.2105270302 05/27/2021
[ 2371.805701] RIP: 0010:taprio_leaf+0x1e/0x30 [sch_taprio]
[ 2371.811011] Code: Unable to access opcode bytes at RIP 0xffffffffc1112ff4.
[ 2371.817867] RSP: 0018:ffffae7f82263a28 EFLAGS: 00010206
[ 2371.823078] RAX: 0000000000000000 RBX: 0000000001000002 RCX: ffff8a704ff38000
[ 2371.830190] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a7043f29000
[ 2371.837307] RBP: ffff8a7043f29000 R08: 0000000000000000 R09: ffffae7f82263b98
[ 2371.844420] R10: 0000000000000002 R11: ffff8a7045df0000 R12: ffff8a70519cc400
[ 2371.851534] R13: ffffae7f82263b98 R14: ffffffff9a04fb00 R15: ffff8a704ff38000
[ 2371.858646] FS:  00007fd2fc262740(0000) GS:ffff8a7790a00000(0000) knlGS:0000000000000000
[ 2371.866707] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2371.872435] CR2: ffffffffc1112ff4 CR3: 00000001053ac003 CR4: 0000000000770ef0
[ 2371.879546] PKRU: 55555554
[ 2371.882261] Call Trace:
[ 2371.884719]  <TASK>
[ 2371.886831]  tc_modify_qdisc+0x75/0x7c0
[ 2371.890667]  rtnetlink_rcv_msg+0x141/0x3c0
[ 2371.894764]  ? _copy_to_iter+0x1b0/0x5a0
[ 2371.898685]  ? rtnl_calcit.isra.0+0x140/0x140
[ 2371.903040]  netlink_rcv_skb+0x4e/0x100
[ 2371.906878]  netlink_unicast+0x197/0x240
[ 2371.910797]  netlink_sendmsg+0x246/0x4a0
[ 2371.914718]  sock_sendmsg+0x5f/0x70
[ 2371.918207]  ____sys_sendmsg+0x20f/0x280
[ 2371.922130]  ? copy_msghdr_from_user+0x72/0xb0
[ 2371.926570]  ___sys_sendmsg+0x7c/0xc0
[ 2371.930233]  ? ___sys_recvmsg+0x89/0xc0
[ 2371.934070]  __sys_sendmsg+0x59/0xa0
[ 2371.937647]  do_syscall_64+0x40/0x90
[ 2371.941224]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 2371.946273] RIP: 0033:0x7fd2fc38e707
[ 2371.949847] Code: 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[ 2371.968521] RSP: 002b:00007fffafdf9ce8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[ 2371.976070] RAX: ffffffffffffffda RBX: 0000000063359bf0 RCX: 00007fd2fc38e707
[ 2371.983183] RDX: 0000000000000000 RSI: 00007fffafdf9d50 RDI: 0000000000000003
[ 2371.990293] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[ 2371.997406] R10: 00007fd2fc28d670 R11: 0000000000000246 R12: 0000000000000001
[ 2372.004520] R13: 00005583e730c476 R14: 00005583e730c48a R15: 00005583e7333280
[ 2372.011637]  </TASK>
[ 2372.013830] Modules linked in: sch_taprio bnep 8021q bluetooth ecdh_generic ecc ecryptfs nfsd sch_fq_codel uio uhid iwlwifi cfg80211 i915 x86_pkg_temp_thermal kvm_intel kvm hid_sensor_als hid_sensor_incl_3d hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_trigger hid_sensor_iio_common hid_sensor_custom hid_sensor_hub atkbd mei_hdcp intel_ishtp_hid libps2 mei_wdt vivaldi_fmap dwc3 dwmac_intel stmmac e1000e ax88179_178a usbnet mii mei_me igc thunderbolt udc_core mei pcs_xpcs wdat_wdt irqbypass spi_pxa2xx_platform phylink intel_ish_ipc i2c_i801 dw_dmac tpm_crb intel_rapl_msr pcspkr dw_dmac_core i2c_smbus intel_ishtp tpm_tis parport_pc intel_pmc_core igen6_edac tpm_tis_core thermal parport i8042 tpm edac_core dwc3_pci video drm_buddy ttm drm_display_helper fuse configfs snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd soundcore
[ 2372.092427] CR2: 0000000000000008
[ 2372.095744] ---[ end trace 0000000000000000 ]---
[ 2372.276814] RIP: 0010:taprio_leaf+0x1e/0x30 [sch_taprio]
[ 2372.282140] Code: Unable to access opcode bytes at RIP 0xffffffffc1112ff4.
[ 2372.288995] RSP: 0018:ffffae7f82263a28 EFLAGS: 00010206
[ 2372.294215] RAX: 0000000000000000 RBX: 0000000001000002 RCX: ffff8a704ff38000
[ 2372.301329] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a7043f29000
[ 2372.308442] RBP: ffff8a7043f29000 R08: 0000000000000000 R09: ffffae7f82263b98
[ 2372.315550] R10: 0000000000000002 R11: ffff8a7045df0000 R12: ffff8a70519cc400
[ 2372.322663] R13: ffffae7f82263b98 R14: ffffffff9a04fb00 R15: ffff8a704ff38000
[ 2372.329774] FS:  00007fd2fc262740(0000) GS:ffff8a7790a00000(0000) knlGS:0000000000000000
[ 2372.337840] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2372.343569] CR2: ffffffffc1112ff4 CR3: 00000001053ac003 CR4: 0000000000770ef0
[ 2372.350680] PKRU: 55555554

Fixes: 1461d212ab27 ("net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs")
Reported-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
This patch is more to make others aware of this issue and to explain
what I think is going on. Perhaps the correct solution is something
else. (and that explicit refcount seems wrong, but getting warnings
without it).

I am questioning my sanity, I have clear memories about testing the
commit above and it working fine.

Reverting commit 1461d212ab27 is another alternative, but I think it's
worth to keep that and fix the problem that it exposed.


 net/sched/sch_taprio.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 86675a79da1e..75aacfff2d5e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1763,12 +1763,6 @@ static void taprio_attach(struct Qdisc *sch)
 		if (old)
 			qdisc_put(old);
 	}
-
-	/* access to the child qdiscs is not needed in offload mode */
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
-		kfree(q->qdiscs);
-		q->qdiscs = NULL;
-	}
 }
 
 static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
@@ -1801,8 +1795,9 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
 		*old = dev_graft_qdisc(dev_queue, new);
 	} else {
 		*old = q->qdiscs[cl - 1];
-		q->qdiscs[cl - 1] = new;
 	}
+	q->qdiscs[cl - 1] = new;
+	qdisc_refcount_inc(new);
 
 	if (new)
 		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
-- 
2.37.3

