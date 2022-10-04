Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37B45F4C10
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 00:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiJDWle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 18:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJDWld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 18:41:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B603DF22
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 15:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664923291; x=1696459291;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=8Sk+Zg8RCYNw5DOKMCM1SwxjTZKJUX59I077/waU158=;
  b=DRKxyrmbCIVYVolNxrSX+Y3HZRF8cZ/o0zWV8MIzfYWUstcf5j67Hdy4
   dlFuTP08ATPScQZErGgqQKS7c0AKyaMmeujQY6FSVe166MHvJwroGGE0K
   jccaH3yHyS/NWdI74WdMwNj3ztV4ItynAAG4hU5SsqKb+7XCknTKwp8yd
   tGukdP/AY1qA03xMTnLfAdWJ7c3wR4kHaetzDxyRP9YJSFVaNKYj/HWBe
   cOoAcbBh5AGUkoi5pS4WCmQCcAtUaokxETH//WemCZ+HuDHPMcSDyorrJ
   Q3GCjzlQ8l2OG/776O9iRIUXKIiVDgxUvqxB2vIh7GMqvVvkgO47bdO2w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="364965598"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="364965598"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 15:41:31 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="575221196"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="575221196"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 15:41:31 -0700
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
In-Reply-To: <20221004213617.7qodtbsr37wkyavj@skbuf>
References: <20220930223042.351022-1-vinicius.gomes@intel.com>
 <20220930225639.q4hr4vcqhy7zyomk@skbuf> <87v8p04y6o.fsf@intel.com>
 <20221004213617.7qodtbsr37wkyavj@skbuf>
Date:   Tue, 04 Oct 2022 15:41:30 -0700
Message-ID: <87pmf7p5yd.fsf@intel.com>
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

> On Mon, Oct 03, 2022 at 10:25:03AM -0700, Vinicius Costa Gomes wrote:
>> Something like this:
>> 
>> [   73.174189] refcount_t: underflow; use-after-free.
>> [   73.174197] WARNING: CPU: 10 PID: 878 at lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
>> [   73.174204] Modules linked in: sch_taprio(E) snd_hda_codec_hdmi(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_intel(E) snd_intel_dspcfg(E) snd_hda_codec(E) snd_hda_core(E) snd_pcm(E) igc(E) snd_timer(E) intel_pch_thermal(E) joydev(E) usbhid(E) efivarfs(E)
>> [   73.174226] CPU: 10 PID: 878 Comm: tc Tainted: G            E      6.0.0-rc7+ #13
>> [   73.174229] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS ULTRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
>> [   73.174232] RIP: 0010:refcount_warn_saturate+0xd8/0xe0
>> [   73.174246] Code: ff 48 c7 c7 58 4d 61 a4 c6 05 39 59 ac 01 01 e8 36 92 71 00 0f 0b c3 48 c7 c7 00 4d 61 a4 c6 05 25 59 ac 01 01 e8 20 92 71 00 <0f> 0b c3 0f 1f 44 00 00 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 13
>> [   73.174250] RSP: 0018:ffffa24c8336b9b8 EFLAGS: 00010296
>> [   73.174254] RAX: 0000000000000026 RBX: 0000000000000001 RCX: 0000000000000027
>> [   73.174257] RDX: ffff9ebfae49c868 RSI: 0000000000000001 RDI: ffff9ebfae49c860
>> [   73.174260] RBP: ffff9ebc0a4eb000 R08: 0000000000000000 R09: ffffffffa4e72f40
>> [   73.174262] R10: ffffa24c8336b870 R11: ffffffffa4ee2f88 R12: ffff9ebc10bfc000
>> [   73.174265] R13: 0000000000000000 R14: ffff9ebc0a4eb000 R15: 0000000000000000
>> [   73.174268] FS:  00007f4b546f5c40(0000) GS:ffff9ebfae480000(0000) knlGS:0000000000000000
>> [   73.174271] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   73.174273] CR2: 00005587d1ad02c1 CR3: 0000000128460005 CR4: 00000000003706e0
>> [   73.174276] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   73.174278] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [   73.174281] Call Trace:
>> [   73.174284]  <TASK>
>> [   73.174287]  taprio_destroy+0xa4/0x110 [sch_taprio]
>> [   73.174295]  qdisc_destroy+0x48/0x180
>> [   73.174300]  qdisc_graft+0x573/0x6b0
>> [   73.174308]  tc_get_qdisc+0x157/0x3d0
>> [   73.174323]  rtnetlink_rcv_msg+0x155/0x520
>> [   73.174328]  ? netlink_deliver_tap+0x78/0x3f0
>> [   73.174334]  ? rtnl_getlink+0x3d0/0x3d0
>> [   73.174339]  netlink_rcv_skb+0x4e/0xf0
>> [   73.174348]  netlink_unicast+0x15e/0x230
>> [   73.174354]  netlink_sendmsg+0x234/0x490
>> [   73.174363]  sock_sendmsg+0x30/0x40
>> [   73.174368]  ____sys_sendmsg+0x214/0x230
>> [   73.174373]  ? import_iovec+0x17/0x20
>> [   73.174377]  ? copy_msghdr_from_user+0x5d/0x80
>> [   73.174384]  ___sys_sendmsg+0x86/0xd0
>> [   73.174400]  ? lock_is_held_type+0x9b/0x100
>> [   73.174405]  ? find_held_lock+0x2b/0x80
>> [   73.174413]  __sys_sendmsg+0x47/0x80
>> [   73.174423]  do_syscall_64+0x34/0x80
>> [   73.174428]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [   73.174432] RIP: 0033:0x7f4b54817ab7
>> [   73.174435] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb ba 0f 1f 00 f3 0f 1e fa 80 3d 2d 9b 0d 00 00 74 13 b8 2e 00 00 00 c5 fc 77 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
>> [   73.174438] RSP: 002b:00007fff996ecf18 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
>> [   73.174442] RAX: ffffffffffffffda RBX: 00005587d1af6f60 RCX: 00007f4b54817ab7
>> [   73.174444] RDX: 0000000000000000 RSI: 00007fff996ecf68 RDI: 0000000000000003
>> [   73.174447] RBP: 00000000633b1a29 R08: 0000000000000001 R09: 00007fff996ecc98
>> [   73.174450] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
>> [   73.174452] R13: 00007fff996ed060 R14: 0000000000000001 R15: 00005587d1ad219a
>> [   73.174464]  </TASK>
>> [   73.174466] irq event stamp: 7453
>> [   73.174468] hardirqs last  enabled at (7461): [<ffffffffa30fa962>] __up_console_sem+0x52/0x60
>> [   73.174473] hardirqs last disabled at (7468): [<ffffffffa30fa947>] __up_console_sem+0x37/0x60
>> [   73.174476] softirqs last  enabled at (7094): [<ffffffffa3079d3f>] __irq_exit_rcu+0xbf/0xf0
>> [   73.174481] softirqs last disabled at (7089): [<ffffffffa3079d3f>] __irq_exit_rcu+0xbf/0xf0
>> [   73.174484] ---[ end trace 0000000000000000 ]---
>
> I studied the problem a bit and unfortunately your fix is not correct.
> It is not sufficient to call qdisc_refcount_inc() on the child qdiscs
> grafted in taprio_graft(), there are still other sources of use-after-free.
>

I was afraid that this this would happen. I need to stop, grab some tea
and think very carefully how to simplify the lifetime handling of the
children qdiscs. It has become complicated now that the
offloaded/not-offloaded modes are very different internally.

> I will send a revert of my patch soon, and explain there in more detail
> what the problem is. Sorry for the trouble and thanks for reporting the
> problem and proposing a solution.

Agreed. The revert is safer for net.

No worries. Been there, done that.


Cheers,
-- 
Vinicius
