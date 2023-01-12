Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A90667C2A
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 18:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbjALRCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 12:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240815AbjALRBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 12:01:49 -0500
X-Greylist: delayed 679 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Jan 2023 08:43:48 PST
Received: from sosiego.soundray.org (sosiego.soundray.org [116.203.207.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90007630C
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 08:43:48 -0800 (PST)
From:   Linus Heckemann <git@sphalerite.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sphalerite.org;
        s=sosiego; t=1673540741;
        bh=aTm8Gy+Ad82CG0A9W9jeHcexMIM4LX6ZnYQ4+jo6SBo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date;
        b=pA2SbFJYWwz222hxEWJYbiOP+DDox8vYshD901PSYuAKgrg3w0iOIAl9s7EZYrsws
         Jrs5hEtfjAb4PLrd7ELsOAFb9A9zpN6yzQme1rsiMFYFxg0w4/ouukWpDEmlKH29+k
         aCxKS8TeZ1Tlt8+a4IjsAMCeQVCT2Nh3Cl8KMPTA=
To:     Zhu Yanjun <yanjun.zhu@linux.dev>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Wesierski, DawidX" <dawidx.wesierski@intel.com>
Cc:     "kamalheib1@gmail.com" <kamalheib1@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Raits <igor.raits@gooddata.com>
Subject: Re: RE: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
In-Reply-To: <276971e8-7eac-6b0c-06a7-30d415fb86c0@linux.dev>
References: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
 <Y7hJJ5hIxDolYIAV@ziepe.ca>
 <MWHPR11MB00299035ECB2E34F60BC2C74E9FE9@MWHPR11MB0029.namprd11.prod.outlook.com>
 <276971e8-7eac-6b0c-06a7-30d415fb86c0@linux.dev>
Date:   Thu, 12 Jan 2023 17:25:39 +0100
Message-ID: <ygar0vzpvng.fsf@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Zhu Yanjun <yanjun.zhu@linux.dev> writes:

> =E5=9C=A8 2023/1/10 3:36, Saleem, Shiraz =E5=86=99=E9=81=93:
>>> Subject: Re: Network do not works with linux >=3D 6.1.2. Issue bisected=
 to
>>> "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the
>>> correct link speed)
>>>
>>> On Fri, Jan 06, 2023 at 08:55:29AM +0100, Jaroslav Pulchart wrote:
>>>> [  257.967099] task:NetworkManager  state:D stack:0     pid:3387
>>>> ppid:1      flags:0x00004002
>>>> [  257.975446] Call Trace:
>>>> [  257.977901]  <TASK>
>>>> [  257.980004]  __schedule+0x1eb/0x630 [  257.983498]
>>>> schedule+0x5a/0xd0 [  257.986641]  schedule_timeout+0x11d/0x160 [
>>>> 257.990654]  __wait_for_common+0x90/0x1e0 [  257.994666]  ?
>>>> usleep_range_state+0x90/0x90 [  257.998854]
>>>> __flush_workqueue+0x13a/0x3f0 [  258.002955]  ?
>>>> __kernfs_remove.part.0+0x11e/0x1e0
>>>> [  258.007661]  ib_cache_cleanup_one+0x1c/0xe0 [ib_core] [
>>>> 258.012721]  __ib_unregister_device+0x62/0xa0 [ib_core] [  258.017959]
>>>> ib_unregister_device+0x22/0x30 [ib_core] [  258.023024]
>>>> irdma_remove+0x1a/0x60 [irdma] [  258.027223]
>>>> auxiliary_bus_remove+0x18/0x30 [  258.031414]
>>>> device_release_driver_internal+0x1aa/0x230
>>>> [  258.036643]  bus_remove_device+0xd8/0x150 [  258.040654]
>>>> device_del+0x18b/0x3f0 [  258.044149]  ice_unplug_aux_dev+0x42/0x60
>>>> [ice]
>>>
>>> We talked about this already - wasn't it on this series?
>>=20
>> This is yet another path (when ice ports are added to a bond) I believe =
where the RDMA aux device
>> is removed holding the RTNL lock. It's being exposed now with this recen=
t irdma patch - 425c9bd06b7a,
>> causing a deadlock.
>>=20
>> ice_lag_event_handler [rtnl_lock]
>>   ->ice_lag_changeupper_event
>>       ->ice_unplug_aux_dev
>>          ->irdma_remove
>>              ->ib_unregister_device
>>                 ->ib_cache_cleanup_one
>>                    ->flush_workqueue(ib)
>>                       ->irdma_query_port
>>                           -> ib_get_eth_speed [rtnl_lock]
>
> Agree with the above analysis.
> Maybe a quick and direct fix is like this.
>
> @@ -74,6 +74,7 @@ static int irdma_query_port(struct ib_device *ibdev,=20
> u32 port,
>   {
>          struct irdma_device *iwdev =3D to_iwdev(ibdev);
>          struct net_device *netdev =3D iwdev->netdev;
> +       bool unlock_rtnl =3D false;
>
>          /* no need to zero out pros here. done by caller */
>
> @@ -91,9 +92,16 @@ static int irdma_query_port(struct ib_device *ibdev,=20
> u32 port,
>                  props->phys_state =3D IB_PORT_PHYS_STATE_DISABLED;
>          }
>
> +       if (rtnl_is_locked()) {
> +               rtnl_unlock();
> +               unlock_rtnl =3D true;
> +       }

Does this not introduce a window where something else could acquire
the lock, when something further up in the call chain could be holding
the lock for a good reason?

>          ib_get_eth_speed(ibdev, port, &props->active_speed,
>                           &props->active_width);
>
> +       if (unlock_rtnl) {
> +               rtnl_lock();
> +       }
>          if (rdma_protocol_roce(ibdev, 1)) {
>                  props->gid_tbl_len =3D 32;
>                  props->ip_gids =3D true;
>

That said, I've tested this anyway and it does appear to solve the
reported deadlock, but seems to introduce other hangs (this is rarer --
I've encountered the issue on 3 boots out of 30). Maybe this is the
race condition which I suspect? Here are the hung-task traces from one
such occurrence.

[  247.237227] INFO: task kworker/10:1:415 blocked for more than 122 second=
s.
[  247.244183]       Not tainted 5.15.86 #1-NixOS
[  247.248626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  247.256453] task:kworker/10:1    state:D stack:    0 pid:  415 ppid:    =
 2 flags:0x00004000
[  247.256457] Workqueue: ipv6_addrconf addrconf_dad_work
[  247.256462] Call Trace:
[  247.256463]  <TASK>
[  247.256466]  __schedule+0x2e6/0x13a0
[  247.256471]  ? ip6_finish_output2+0x1f5/0x6d0
[  247.256473]  schedule+0x5b/0xd0
[  247.256475]  schedule_preempt_disabled+0xa/0x10
[  247.256477]  __mutex_lock.constprop.0+0x216/0x400
[  247.256479]  addrconf_dad_work+0x3e/0x570
[  247.256481]  ? mld_ifc_work+0x1b2/0x450
[  247.256482]  process_one_work+0x1f1/0x390
[  247.256485]  worker_thread+0x53/0x3e0
[  247.256486]  ? process_one_work+0x390/0x390
[  247.256487]  kthread+0x127/0x150
[  247.256489]  ? set_kthread_struct+0x50/0x50
[  247.256491]  ret_from_fork+0x22/0x30
[  247.256494]  </TASK>
[  247.256499] INFO: task kworker/34:1:460 blocked for more than 122 second=
s.
[  247.263367]       Not tainted 5.15.86 #1-NixOS
[  247.267813] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  247.275640] task:kworker/34:1    state:D stack:    0 pid:  460 ppid:    =
 2 flags:0x00004000
[  247.275643] Workqueue: events_power_efficient reg_check_chans_work [cfg8=
0211]
[  247.275661] Call Trace:
[  247.275662]  <TASK>
[  247.275663]  __schedule+0x2e6/0x13a0
[  247.275665]  ? select_task_rq_fair+0x1010/0x1090
[  247.275668]  schedule+0x5b/0xd0
[  247.275669]  schedule_preempt_disabled+0xa/0x10
[  247.275671]  __mutex_lock.constprop.0+0x216/0x400
[  247.275673]  reg_check_chans_work+0x2d/0x390 [cfg80211]
[  247.275687]  process_one_work+0x1f1/0x390
[  247.275688]  worker_thread+0x53/0x3e0
[  247.275689]  ? process_one_work+0x390/0x390
[  247.275690]  kthread+0x127/0x150
[  247.275692]  ? set_kthread_struct+0x50/0x50
[  247.275693]  ret_from_fork+0x22/0x30
[  247.275695]  </TASK>
[  247.275698] INFO: task kworker/46:1:484 blocked for more than 122 second=
s.
[  247.282572]       Not tainted 5.15.86 #1-NixOS
[  247.287017] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  247.294842] task:kworker/46:1    state:D stack:    0 pid:  484 ppid:    =
 2 flags:0x00004000
[  247.294844] Workqueue: ipv6_addrconf addrconf_verify_work
[  247.294846] Call Trace:
[  247.294847]  <TASK>
[  247.294847]  __schedule+0x2e6/0x13a0
[  247.294849]  ? raw_spin_rq_lock_nested+0x12/0x70
[  247.294851]  ? newidle_balance+0x2ee/0x400
[  247.294852]  schedule+0x5b/0xd0
[  247.294854]  schedule_preempt_disabled+0xa/0x10
[  247.294856]  __mutex_lock.constprop.0+0x216/0x400
[  247.294857]  addrconf_verify_work+0xa/0x20
[  247.294858]  process_one_work+0x1f1/0x390
[  247.294859]  worker_thread+0x53/0x3e0
[  247.294860]  ? process_one_work+0x390/0x390
[  247.294861]  kthread+0x127/0x150
[  247.294862]  ? set_kthread_struct+0x50/0x50
[  247.294864]  ret_from_fork+0x22/0x30
[  247.294866]  </TASK>
[  247.294888] INFO: task systemd-udevd:1658 blocked for more than 122 seco=
nds.
[  247.301934]       Not tainted 5.15.86 #1-NixOS
[  247.306379] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  247.314206] task:systemd-udevd   state:D stack:    0 pid: 1658 ppid:  15=
06 flags:0x00004226
[  247.314208] Call Trace:
[  247.314209]  <TASK>
[  247.314209]  __schedule+0x2e6/0x13a0
[  247.314212]  schedule+0x5b/0xd0
[  247.314214]  schedule_preempt_disabled+0xa/0x10
[  247.314216]  __mutex_lock.constprop.0+0x216/0x400
[  247.314217]  ? kobject_uevent_env+0x11f/0x680
[  247.314220]  ? bus_add_driver+0x1a8/0x200
[  247.314225]  register_netdevice_notifier+0x21/0x110
[  247.314228]  ? 0xffffffffc181f000
[  247.314247]  irdma_init_module+0xa6/0x1000 [irdma]
[  247.314258]  do_one_initcall+0x44/0x1d0
[  247.314260]  ? __cond_resched+0x16/0x50
[  247.314262]  ? kmem_cache_alloc_trace+0x44/0x3d0
[  247.314265]  do_init_module+0x4c/0x250
[  247.314268]  __do_sys_init_module+0x12e/0x1b0
[  247.314271]  do_syscall_64+0x3b/0x90
[  247.314274]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[  247.314276] RIP: 0033:0x7f7a2089a0fe
[  247.314279] RSP: 002b:00007ffd449a33e8 EFLAGS: 00000246 ORIG_RAX: 000000=
00000000af
[  247.314281] RAX: ffffffffffffffda RBX: 0000556ce7b5f6c0 RCX: 00007f7a208=
9a0fe
[  247.314282] RDX: 00007f7a209feb1d RSI: 00000000000cef90 RDI: 0000556ce7f=
21430
[  247.314283] RBP: 0000556ce7f21430 R08: 0000000000000007 R09: 0000556ce7b=
607e0
[  247.314283] R10: 0000000000000005 R11: 0000000000000246 R12: 00007f7a209=
feb1d
[  247.314284] R13: 0000556ce7b5f6c0 R14: 0000556ce7b472b0 R15: 0000556ce7b=
5f6c0
[  247.314285]  </TASK>

Thanks for looking into this!

Linus Heckemann
