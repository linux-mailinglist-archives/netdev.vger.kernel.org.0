Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B68E5F3468
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiJCRZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiJCRZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:25:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D751262C
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664817910; x=1696353910;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=T2AFLdZjpp4ui9w1zEg5V8vO9Uf4YOZQw6CGnSSrxkw=;
  b=S+wfSnzFo0T8znoH4PwL4T7FQ/nH+Kjbs6uH5wdZFEC1MR7Bfuo83mzR
   ERToIlr/hzHAJMXp21TlB4X8G+FvR3C/784ARPjdmO/O2GYVoDvo0nklg
   tZ9CI+NwkgCYLrLZHVin9N6Dv9uEWSupUnUn6jZUapx9TnYvMKoWNlc/Y
   H3+XgbxKR866OGyBTuKtsNxkfQ1FnRxisk/sBJSYFbgOp/jKQDw/sj3fI
   tGlCPKQrmLk1U6V2MJ2wxXgwQXNBwK42CVdgaGpxaiemD227K6QlzxWUm
   kRDebMn57VDYAszMW5VEfzfsfv0HWM9aPjuMYuLEtoJt+eZBcYIzy26nj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="388991410"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="388991410"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 10:25:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="654444343"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="654444343"
Received: from kancharl-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.48.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 10:25:09 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yannick.vignon@nxp.com" <yannick.vignon@nxp.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net v1] net/sched: taprio: Fix crash when adding child
 qdisc
In-Reply-To: <20220930225639.q4hr4vcqhy7zyomk@skbuf>
References: <20220930223042.351022-1-vinicius.gomes@intel.com>
 <20220930225639.q4hr4vcqhy7zyomk@skbuf>
Date:   Mon, 03 Oct 2022 10:25:03 -0700
Message-ID: <87v8p04y6o.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Sep 30, 2022 at 03:30:42PM -0700, Vinicius Costa Gomes wrote:
>> It was reported by Husaini that since commit 1461d212ab27 ("net/sched:
>> taprio: make qdisc_leaf() see the per-netdev-queue pfifo child
>> qdiscs"), there was a NULL dereference when adding a child qdisc (ETF
>> in this case) when using taprio full offload.
>> 
>> The issue seems to be that since commit 13511704f8d7 ("net: taprio
>> offload: enforce qdisc to netdev queue mapping"), the array of child
>> qdiscs (q->qdiscs[]) was not used, and even free'd when full offload
>> mode is used, in attach().
>> 
>> The current implementation since 1461d212ab27 (which I feel is a
>> sensible change) requires that the q->qdiscs[] array is always valid.
>> The fix is to not deallocate it, and keep it having references to each
>> child qdisc.
>> 
>> Log:
>> 
>> [ 2295.318620] IPv6: ADDRCONF(NETDEV_CHANGE): enp170s0: link becomes ready
>> [ 2371.758745] BUG: kernel NULL pointer dereference, address: 0000000000000008
>> [ 2371.765697] #PF: supervisor read access in kernel mode
>> [ 2371.770825] #PF: error_code(0x0000) - not-present page
>> [ 2371.775952] PGD 0 P4D 0
>> [ 2371.778494] Oops: 0000 [#1] PREEMPT SMP NOPTI
>> [ 2371.782844] CPU: 0 PID: 17964 Comm: tc Tainted: G     U  W          6.0.0-rc6-intel-ese-standard-lts+ #95
>> [ 2371.792374] Hardware name: Intel Corporation Tiger Lake Client Platform/TigerLake U DDR4 SODIMM RVP, BIOS TGLIFUI1.R00.4204.A00.2105270302 05/27/2021
>> [ 2371.805701] RIP: 0010:taprio_leaf+0x1e/0x30 [sch_taprio]
>> [ 2371.811011] Code: Unable to access opcode bytes at RIP 0xffffffffc1112ff4.
>> [ 2371.817867] RSP: 0018:ffffae7f82263a28 EFLAGS: 00010206
>> [ 2371.823078] RAX: 0000000000000000 RBX: 0000000001000002 RCX: ffff8a704ff38000
>> [ 2371.830190] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a7043f29000
>> [ 2371.837307] RBP: ffff8a7043f29000 R08: 0000000000000000 R09: ffffae7f82263b98
>> [ 2371.844420] R10: 0000000000000002 R11: ffff8a7045df0000 R12: ffff8a70519cc400
>> [ 2371.851534] R13: ffffae7f82263b98 R14: ffffffff9a04fb00 R15: ffff8a704ff38000
>> [ 2371.858646] FS:  00007fd2fc262740(0000) GS:ffff8a7790a00000(0000) knlGS:0000000000000000
>> [ 2371.866707] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 2371.872435] CR2: ffffffffc1112ff4 CR3: 00000001053ac003 CR4: 0000000000770ef0
>> [ 2371.879546] PKRU: 55555554
>> [ 2371.882261] Call Trace:
>> [ 2371.884719]  <TASK>
>> [ 2371.886831]  tc_modify_qdisc+0x75/0x7c0
>> [ 2371.890667]  rtnetlink_rcv_msg+0x141/0x3c0
>> [ 2371.894764]  ? _copy_to_iter+0x1b0/0x5a0
>> [ 2371.898685]  ? rtnl_calcit.isra.0+0x140/0x140
>> [ 2371.903040]  netlink_rcv_skb+0x4e/0x100
>> [ 2371.906878]  netlink_unicast+0x197/0x240
>> [ 2371.910797]  netlink_sendmsg+0x246/0x4a0
>> [ 2371.914718]  sock_sendmsg+0x5f/0x70
>> [ 2371.918207]  ____sys_sendmsg+0x20f/0x280
>> [ 2371.922130]  ? copy_msghdr_from_user+0x72/0xb0
>> [ 2371.926570]  ___sys_sendmsg+0x7c/0xc0
>> [ 2371.930233]  ? ___sys_recvmsg+0x89/0xc0
>> [ 2371.934070]  __sys_sendmsg+0x59/0xa0
>> [ 2371.937647]  do_syscall_64+0x40/0x90
>> [ 2371.941224]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [ 2371.946273] RIP: 0033:0x7fd2fc38e707
>> [ 2371.949847] Code: 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
>> [ 2371.968521] RSP: 002b:00007fffafdf9ce8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> [ 2371.976070] RAX: ffffffffffffffda RBX: 0000000063359bf0 RCX: 00007fd2fc38e707
>> [ 2371.983183] RDX: 0000000000000000 RSI: 00007fffafdf9d50 RDI: 0000000000000003
>> [ 2371.990293] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
>> [ 2371.997406] R10: 00007fd2fc28d670 R11: 0000000000000246 R12: 0000000000000001
>> [ 2372.004520] R13: 00005583e730c476 R14: 00005583e730c48a R15: 00005583e7333280
>> [ 2372.011637]  </TASK>
>> [ 2372.013830] Modules linked in: sch_taprio bnep 8021q bluetooth ecdh_generic ecc ecryptfs nfsd sch_fq_codel uio uhid iwlwifi cfg80211 i915 x86_pkg_temp_thermal kvm_intel kvm hid_sensor_als hid_sensor_incl_3d hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_trigger hid_sensor_iio_common hid_sensor_custom hid_sensor_hub atkbd mei_hdcp intel_ishtp_hid libps2 mei_wdt vivaldi_fmap dwc3 dwmac_intel stmmac e1000e ax88179_178a usbnet mii mei_me igc thunderbolt udc_core mei pcs_xpcs wdat_wdt irqbypass spi_pxa2xx_platform phylink intel_ish_ipc i2c_i801 dw_dmac tpm_crb intel_rapl_msr pcspkr dw_dmac_core i2c_smbus intel_ishtp tpm_tis parport_pc intel_pmc_core igen6_edac tpm_tis_core thermal parport i8042 tpm edac_core dwc3_pci video drm_buddy ttm drm_display_helper fuse configfs snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd soundcore
>> [ 2372.092427] CR2: 0000000000000008
>> [ 2372.095744] ---[ end trace 0000000000000000 ]---
>> [ 2372.276814] RIP: 0010:taprio_leaf+0x1e/0x30 [sch_taprio]
>> [ 2372.282140] Code: Unable to access opcode bytes at RIP 0xffffffffc1112ff4.
>> [ 2372.288995] RSP: 0018:ffffae7f82263a28 EFLAGS: 00010206
>> [ 2372.294215] RAX: 0000000000000000 RBX: 0000000001000002 RCX: ffff8a704ff38000
>> [ 2372.301329] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8a7043f29000
>> [ 2372.308442] RBP: ffff8a7043f29000 R08: 0000000000000000 R09: ffffae7f82263b98
>> [ 2372.315550] R10: 0000000000000002 R11: ffff8a7045df0000 R12: ffff8a70519cc400
>> [ 2372.322663] R13: ffffae7f82263b98 R14: ffffffff9a04fb00 R15: ffff8a704ff38000
>> [ 2372.329774] FS:  00007fd2fc262740(0000) GS:ffff8a7790a00000(0000) knlGS:0000000000000000
>> [ 2372.337840] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 2372.343569] CR2: ffffffffc1112ff4 CR3: 00000001053ac003 CR4: 0000000000770ef0
>> [ 2372.350680] PKRU: 55555554
>> 
>> Fixes: 1461d212ab27 ("net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs")
>> Reported-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>> This patch is more to make others aware of this issue and to explain
>> what I think is going on. Perhaps the correct solution is something
>> else. (and that explicit refcount seems wrong, but getting warnings
>> without it).
>> 
>> I am questioning my sanity, I have clear memories about testing the
>> commit above and it working fine.
>> 
>> Reverting commit 1461d212ab27 is another alternative, but I think it's
>> worth to keep that and fix the problem that it exposed.
>> 
>> 
>>  net/sched/sch_taprio.c | 9 ++-------
>>  1 file changed, 2 insertions(+), 7 deletions(-)
>> 
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index 86675a79da1e..75aacfff2d5e 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -1763,12 +1763,6 @@ static void taprio_attach(struct Qdisc *sch)
>>  		if (old)
>>  			qdisc_put(old);
>>  	}
>> -
>> -	/* access to the child qdiscs is not needed in offload mode */
>> -	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
>> -		kfree(q->qdiscs);
>> -		q->qdiscs = NULL;
>> -	}
>>  }
>
> omfg, I didn't include this hunk in the patch? yikes, sorry.
>
>>  
>>  static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
>> @@ -1801,8 +1795,9 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
>>  		*old = dev_graft_qdisc(dev_queue, new);
>>  	} else {
>>  		*old = q->qdiscs[cl - 1];
>> -		q->qdiscs[cl - 1] = new;
>>  	}
>> +	q->qdiscs[cl - 1] = new;
>> +	qdisc_refcount_inc(new);
>
> What warning are you getting without this part of the change?

Something like this:

[   73.174189] refcount_t: underflow; use-after-free.
[   73.174197] WARNING: CPU: 10 PID: 878 at lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
[   73.174204] Modules linked in: sch_taprio(E) snd_hda_codec_hdmi(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_intel(E) snd_intel_dspcfg(E) snd_hda_codec(E) snd_hda_core(E) snd_pcm(E) igc(E) snd_timer(E) intel_pch_thermal(E) joydev(E) usbhid(E) efivarfs(E)
[   73.174226] CPU: 10 PID: 878 Comm: tc Tainted: G            E      6.0.0-rc7+ #13
[   73.174229] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS ULTRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
[   73.174232] RIP: 0010:refcount_warn_saturate+0xd8/0xe0
[   73.174246] Code: ff 48 c7 c7 58 4d 61 a4 c6 05 39 59 ac 01 01 e8 36 92 71 00 0f 0b c3 48 c7 c7 00 4d 61 a4 c6 05 25 59 ac 01 01 e8 20 92 71 00 <0f> 0b c3 0f 1f 44 00 00 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 13
[   73.174250] RSP: 0018:ffffa24c8336b9b8 EFLAGS: 00010296
[   73.174254] RAX: 0000000000000026 RBX: 0000000000000001 RCX: 0000000000000027
[   73.174257] RDX: ffff9ebfae49c868 RSI: 0000000000000001 RDI: ffff9ebfae49c860
[   73.174260] RBP: ffff9ebc0a4eb000 R08: 0000000000000000 R09: ffffffffa4e72f40
[   73.174262] R10: ffffa24c8336b870 R11: ffffffffa4ee2f88 R12: ffff9ebc10bfc000
[   73.174265] R13: 0000000000000000 R14: ffff9ebc0a4eb000 R15: 0000000000000000
[   73.174268] FS:  00007f4b546f5c40(0000) GS:ffff9ebfae480000(0000) knlGS:0000000000000000
[   73.174271] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.174273] CR2: 00005587d1ad02c1 CR3: 0000000128460005 CR4: 00000000003706e0
[   73.174276] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   73.174278] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   73.174281] Call Trace:
[   73.174284]  <TASK>
[   73.174287]  taprio_destroy+0xa4/0x110 [sch_taprio]
[   73.174295]  qdisc_destroy+0x48/0x180
[   73.174300]  qdisc_graft+0x573/0x6b0
[   73.174308]  tc_get_qdisc+0x157/0x3d0
[   73.174323]  rtnetlink_rcv_msg+0x155/0x520
[   73.174328]  ? netlink_deliver_tap+0x78/0x3f0
[   73.174334]  ? rtnl_getlink+0x3d0/0x3d0
[   73.174339]  netlink_rcv_skb+0x4e/0xf0
[   73.174348]  netlink_unicast+0x15e/0x230
[   73.174354]  netlink_sendmsg+0x234/0x490
[   73.174363]  sock_sendmsg+0x30/0x40
[   73.174368]  ____sys_sendmsg+0x214/0x230
[   73.174373]  ? import_iovec+0x17/0x20
[   73.174377]  ? copy_msghdr_from_user+0x5d/0x80
[   73.174384]  ___sys_sendmsg+0x86/0xd0
[   73.174400]  ? lock_is_held_type+0x9b/0x100
[   73.174405]  ? find_held_lock+0x2b/0x80
[   73.174413]  __sys_sendmsg+0x47/0x80
[   73.174423]  do_syscall_64+0x34/0x80
[   73.174428]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   73.174432] RIP: 0033:0x7f4b54817ab7
[   73.174435] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb ba 0f 1f 00 f3 0f 1e fa 80 3d 2d 9b 0d 00 00 74 13 b8 2e 00 00 00 c5 fc 77 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[   73.174438] RSP: 002b:00007fff996ecf18 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
[   73.174442] RAX: ffffffffffffffda RBX: 00005587d1af6f60 RCX: 00007f4b54817ab7
[   73.174444] RDX: 0000000000000000 RSI: 00007fff996ecf68 RDI: 0000000000000003
[   73.174447] RBP: 00000000633b1a29 R08: 0000000000000001 R09: 00007fff996ecc98
[   73.174450] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
[   73.174452] R13: 00007fff996ed060 R14: 0000000000000001 R15: 00005587d1ad219a
[   73.174464]  </TASK>
[   73.174466] irq event stamp: 7453
[   73.174468] hardirqs last  enabled at (7461): [<ffffffffa30fa962>] __up_console_sem+0x52/0x60
[   73.174473] hardirqs last disabled at (7468): [<ffffffffa30fa947>] __up_console_sem+0x37/0x60
[   73.174476] softirqs last  enabled at (7094): [<ffffffffa3079d3f>] __irq_exit_rcu+0xbf/0xf0
[   73.174481] softirqs last disabled at (7089): [<ffffffffa3079d3f>] __irq_exit_rcu+0xbf/0xf0
[   73.174484] ---[ end trace 0000000000000000 ]---

-- 
Vinicius
