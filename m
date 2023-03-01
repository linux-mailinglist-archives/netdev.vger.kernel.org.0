Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B446A6D06
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 14:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCAN2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 08:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCAN2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 08:28:21 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50F9BBAC
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 05:28:19 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cw28so4620955edb.5
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 05:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lmqqQlgYZYOHqJWu/VnESxyYWak0lPlw9Q2NBrFdhdo=;
        b=DVQ9VMrdCQ7kuR5yVnPGPP0n8n5sx2X8eraab1SMf9KgJ1qJSf6msxMoCxm8eKH4Jw
         woCpDR0zyTpE7Nu10xQIy/svK77phk1Y7SlW+Dz3jyFnNm04Y91uqUR6VPjkLQzEJqIC
         sQPuTC/44D6f5JAU/3LK+RpiHljkcJWK9XBi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmqqQlgYZYOHqJWu/VnESxyYWak0lPlw9Q2NBrFdhdo=;
        b=0Djg5Oy44yVkwaCU+JzoPHP/zsqGcyCdzrqRDCcTjBJoqBtG6y+5LHS/VaZMtyE8Ma
         PtL/Lh+tViBkQXg5yudxkuPPzhcXplsCPi2+lfZw4GqcbXgvwLbeDZdPwGEWjWM4vLO1
         AWYUE0eAsn4e9KmpuuQwwkMNWFyLGA4dloXewcSNUiyupqYO0ONvS6lBaSNInYL8urSo
         Cc6AT+uAXm8G4QAih2DMLrwvmyJh+TnB8hM/JWPeRszAN/W3G6He/fsxBKn1bAaju3GX
         BUOCXYaTNXOZMvg51MYngdlwG4uD/LeUe2DvstdazsjG3ofOCMUlmXn5OyXYDm/L8Ytb
         PIpw==
X-Gm-Message-State: AO0yUKUyLsB3giRB/xYyUnC6g3r3PthWadSpf3QPJyhftEXLjzEINdcx
        JFre4Y3aDelr0t38Ho8atOMvzv1xdHTMYRWC1kF/sw==
X-Google-Smtp-Source: AK7set/Lhi4kDhOjni1GIs/lVYMerkY1xu1uJSSgpY7mTTqN0GGKIdjPVK7wZOd4XmeZEeOlAmP9EeFcfhCP5h7Vb1c=
X-Received: by 2002:a17:906:3586:b0:8ab:b606:9728 with SMTP id
 o6-20020a170906358600b008abb6069728mr3299480ejb.5.1677677298193; Wed, 01 Mar
 2023 05:28:18 -0800 (PST)
MIME-Version: 1.0
References: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
 <68b14b11-d0c7-65c9-4eeb-0487c95e395d@leemhuis.info> <675161ac-35c5-ee5d-e96b-8e70d9d11d98@leemhuis.info>
 <CAK8fFZ6jbCYK7FFoYGJpq5oH195t+dBF0sbOr_V6k4Q8pPb_ow@mail.gmail.com> <f7ab5942-eee2-88e4-ffac-007de0ed06ba@intel.com>
In-Reply-To: <f7ab5942-eee2-88e4-ffac-007de0ed06ba@intel.com>
From:   Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date:   Wed, 1 Mar 2023 14:27:51 +0100
Message-ID: <CAK8fFZ4-kDdB_RkQG5xx2WuELe-TprD-Vfd_XJAB_4h54eR=sw@mail.gmail.com>
Subject: Re: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        kamalheib1@gmail.com, shiraz.saleem@intel.com, leon@kernel.org,
        sashal@kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Igor Raits <igor.raits@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On 2/28/2023 4:33 AM, Jaroslav Pulchart wrote:
> >>
> >> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> >> to make this easily accessible to everyone.
> >>
> >> On 06.01.23 12:11, Linux kernel regression tracking (#adding) wrote:
> >>> On 06.01.23 08:55, Jaroslav Pulchart wrote:
> >>>> Hello,
> >>>>
> >>>> I would like to report a >= 6.1.2 some network regression (looks like
> >>>> NIC us not UP) on our Dell R7525 servers with E810 NICs. The issue was
> >>>> observed after I updated 6.1.0 to 6.1.2 or newer (tested up to newest
> >>>> 6.1.4-rc1). The system is not accesible and all services are in D
> >>>> state after each reboot.
> >>
> >> Can anyone please provide a status on this? It seems to take quite a
> >> while to get this regression fixed, which is unfortunate. Or was
> >> progress made somewhere and I just missed it?
> >>
> >> I noticed Tony tried to address this in mainline, but the last thing I'm
> >> aware of is "Please ignore/drop this. Just saw that this change doesn't
> >> solve the issue." here:
> >>
> >
> > FYI: We are building 6.1.y with the provided patch to fix the
> > regression in our environment.
>
> Thanks for the input Jaroslav; just to be clear, are you using the v1
> [1] or v2 [2] of the patch?

We are using v1 [1] of the patch.


>
> We're doing more testing on v2, but I was going to reach out to you
> afterwards to see if you would mind testing the v2 as we haven't heard
> from the other reporter who said v2 didn't work for him.
>
> Thanks,
> Tony
>
> [1]
> https://lore.kernel.org/netdev/20230131213703.1347761-2-anthony.l.nguyen@intel.com/
> [2]
> https://lore.kernel.org/netdev/20230217004201.2895321-1-anthony.l.nguyen@intel.com/
>
> >> https://lore.kernel.org/all/b944d1d4-7f90-dcef-231c-91bb031a4275@intel.com/#t
> >>
> >> Should the backport to 6.1.y (425c9bd06b7a ) maybe be dropped to at
> >> least resolve the issue there until this is fixed in mainline? Or would
> >> that cause a regression as well?
> >>
> >> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> >> --
> >> Everything you wanna know about Linux kernel regression tracking:
> >> https://linux-regtracking.leemhuis.info/about/#tldr
> >> If I did something stupid, please tell me, as explained on that page.
> >>
> >> #regzbot poke
> >>
> >>>> [  257.625207]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
> >>>> [  257.631911] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>>> disables this message.
> >>>> [  257.639740] task:kworker/u192:1  state:D stack:0     pid:11
> >>>> ppid:2      flags:0x00004000
> >>>> [  257.648095] Workqueue: netns cleanup_net
> >>>> [  257.652029] Call Trace:
> >>>> [  257.654481]  <TASK>
> >>>> [  257.656589]  __schedule+0x1eb/0x630
> >>>> [  257.660087]  schedule+0x5a/0xd0
> >>>> [  257.663233]  schedule_preempt_disabled+0x11/0x20
> >>>> [  257.667851]  __mutex_lock.constprop.0+0x372/0x6c0
> >>>> [  257.672561]  rdma_dev_change_netns+0x25/0x120 [ib_core]
> >>>> [  257.677821]  rdma_dev_exit_net+0x139/0x1e0 [ib_core]
> >>>> [  257.682804]  ops_exit_list+0x30/0x70
> >>>> [  257.686382]  cleanup_net+0x213/0x3b0
> >>>> [  257.689964]  process_one_work+0x1e2/0x3b0
> >>>> [  257.693984]  ? rescuer_thread+0x390/0x390
> >>>> [  257.697995]  worker_thread+0x50/0x3a0
> >>>> [  257.701661]  ? rescuer_thread+0x390/0x390
> >>>> [  257.705674]  kthread+0xd6/0x100
> >>>> [  257.708819]  ? kthread_complete_and_exit+0x20/0x20
> >>>> [  257.713613]  ret_from_fork+0x1f/0x30
> >>>> [  257.717192]  </TASK>
> >>>> [  257.719496] INFO: task kworker/87:0:470 blocked for more than 122 seconds.
> >>>> [  257.726423]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
> >>>> [  257.733123] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>>> disables this message.
> >>>> [  257.740949] task:kworker/87:0    state:D stack:0     pid:470
> >>>> ppid:2      flags:0x00004000
> >>>> [  257.749307] Workqueue: events linkwatch_event
> >>>> [  257.753672] Call Trace:
> >>>> [  257.756124]  <TASK>
> >>>> [  257.758228]  __schedule+0x1eb/0x630
> >>>> [  257.761723]  schedule+0x5a/0xd0
> >>>> [  257.764867]  schedule_preempt_disabled+0x11/0x20
> >>>> [  257.769487]  __mutex_lock.constprop.0+0x372/0x6c0
> >>>> [  257.774196]  ? pick_next_task+0x57/0x9b0
> >>>> [  257.778127]  ? finish_task_switch.isra.0+0x8f/0x2a0
> >>>> [  257.783007]  linkwatch_event+0xa/0x30
> >>>> [  257.786674]  process_one_work+0x1e2/0x3b0
> >>>> [  257.790687]  worker_thread+0x50/0x3a0
> >>>> [  257.794352]  ? rescuer_thread+0x390/0x390
> >>>> [  257.798365]  kthread+0xd6/0x100
> >>>> [  257.801513]  ? kthread_complete_and_exit+0x20/0x20
> >>>> [  257.806303]  ret_from_fork+0x1f/0x30
> >>>> [  257.809885]  </TASK>
> >>>> [  257.812109] INFO: task kworker/39:1:614 blocked for more than 123 seconds.
> >>>> [  257.818984]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
> >>>> [  257.825686] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>>> disables this message.
> >>>> [  257.833519] task:kworker/39:1    state:D stack:0     pid:614
> >>>> ppid:2      flags:0x00004000
> >>>> [  257.841869] Workqueue: infiniband ib_cache_event_task [ib_core]
> >>>> [  257.847802] Call Trace:
> >>>> [  257.850252]  <TASK>
> >>>> [  257.852360]  __schedule+0x1eb/0x630
> >>>> [  257.855851]  schedule+0x5a/0xd0
> >>>> [  257.858998]  schedule_preempt_disabled+0x11/0x20
> >>>> [  257.863617]  __mutex_lock.constprop.0+0x372/0x6c0
> >>>> [  257.868325]  ib_get_eth_speed+0x65/0x190 [ib_core]
> >>>> [  257.873127]  ? ib_cache_update.part.0+0x4b/0x2b0 [ib_core]
> >>>> [  257.878619]  ? __kmem_cache_alloc_node+0x18c/0x2b0
> >>>> [  257.883417]  irdma_query_port+0xb3/0x110 [irdma]
> >>>> [  257.888051]  ib_query_port+0xaa/0x100 [ib_core]
> >>>> [  257.892601]  ib_cache_update.part.0+0x65/0x2b0 [ib_core]
> >>>> [  257.897924]  ? pick_next_task+0x57/0x9b0
> >>>> [  257.901855]  ? dequeue_task_fair+0xb6/0x3c0
> >>>> [  257.906043]  ? finish_task_switch.isra.0+0x8f/0x2a0
> >>>> [  257.910920]  ib_cache_event_task+0x58/0x80 [ib_core]
> >>>> [  257.915906]  process_one_work+0x1e2/0x3b0
> >>>> [  257.919918]  ? rescuer_thread+0x390/0x390
> >>>> [  257.923931]  worker_thread+0x50/0x3a0
> >>>> [  257.927595]  ? rescuer_thread+0x390/0x390
> >>>> [  257.931609]  kthread+0xd6/0x100
> >>>> [  257.934755]  ? kthread_complete_and_exit+0x20/0x20
> >>>> [  257.939549]  ret_from_fork+0x1f/0x30
> >>>> [  257.943128]  </TASK>
> >>>> [  257.945438] INFO: task NetworkManager:3387 blocked for more than 123 seconds.
> >>>> [  257.952577]       Tainted: G            E      6.1.4-0.gdc.el9.x86_64 #1
> >>>> [  257.959274] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>>> disables this message.
> >>>> [  257.967099] task:NetworkManager  state:D stack:0     pid:3387
> >>>> ppid:1      flags:0x00004002
> >>>> [  257.975446] Call Trace:
> >>>> [  257.977901]  <TASK>
> >>>> [  257.980004]  __schedule+0x1eb/0x630
> >>>> [  257.983498]  schedule+0x5a/0xd0
> >>>> [  257.986641]  schedule_timeout+0x11d/0x160
> >>>> [  257.990654]  __wait_for_common+0x90/0x1e0
> >>>> [  257.994666]  ? usleep_range_state+0x90/0x90
> >>>> [  257.998854]  __flush_workqueue+0x13a/0x3f0
> >>>> [  258.002955]  ? __kernfs_remove.part.0+0x11e/0x1e0
> >>>> [  258.007661]  ib_cache_cleanup_one+0x1c/0xe0 [ib_core]
> >>>> [  258.012721]  __ib_unregister_device+0x62/0xa0 [ib_core]
> >>>> [  258.017959]  ib_unregister_device+0x22/0x30 [ib_core]
> >>>> [  258.023024]  irdma_remove+0x1a/0x60 [irdma]
> >>>> [  258.027223]  auxiliary_bus_remove+0x18/0x30
> >>>> [  258.031414]  device_release_driver_internal+0x1aa/0x230
> >>>> [  258.036643]  bus_remove_device+0xd8/0x150
> >>>> [  258.040654]  device_del+0x18b/0x3f0
> >>>> [  258.044149]  ice_unplug_aux_dev+0x42/0x60 [ice]
> >>>> [  258.048707]  ice_lag_changeupper_event+0x287/0x2a0 [ice]
> >>>> [  258.054038]  ice_lag_event_handler+0x51/0x130 [ice]
> >>>> [  258.058930]  raw_notifier_call_chain+0x41/0x60
> >>>> [  258.063381]  __netdev_upper_dev_link+0x1a0/0x370
> >>>> [  258.068008]  netdev_master_upper_dev_link+0x3d/0x60
> >>>> [  258.072886]  bond_enslave+0xd16/0x16f0 [bonding]
> >>>> [  258.077517]  ? nla_put+0x28/0x40
> >>>> [  258.080756]  do_setlink+0x26c/0xc10
> >>>> [  258.084249]  ? avc_alloc_node+0x27/0x180
> >>>> [  258.088173]  ? __nla_validate_parse+0x141/0x190
> >>>> [  258.092708]  __rtnl_newlink+0x53a/0x620
> >>>> [  258.096549]  rtnl_newlink+0x44/0x70
> >>>> [  258.100040]  rtnetlink_rcv_msg+0x159/0x3d0
> >>>> [  258.104140]  ? rtnl_calcit.isra.0+0x140/0x140
> >>>> [  258.108496]  netlink_rcv_skb+0x4e/0x100
> >>>> [  258.112338]  netlink_unicast+0x23b/0x360
> >>>> [  258.116264]  netlink_sendmsg+0x24e/0x4b0
> >>>> [  258.120191]  sock_sendmsg+0x5f/0x70
> >>>> [  258.123684]  ____sys_sendmsg+0x241/0x2c0
> >>>> [  258.127609]  ? copy_msghdr_from_user+0x6d/0xa0
> >>>> [  258.132054]  ___sys_sendmsg+0x88/0xd0
> >>>> [  258.135722]  ? ___sys_recvmsg+0x88/0xd0
> >>>> [  258.139559]  ? wake_up_q+0x4a/0x90
> >>>> [  258.142967]  ? rseq_get_rseq_cs.isra.0+0x16/0x220
> >>>> [  258.147673]  ? __fget_light+0xa4/0x130
> >>>> [  258.151434]  __sys_sendmsg+0x59/0xa0
> >>>> [  258.155012]  do_syscall_64+0x38/0x90
> >>>> [  258.158591]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >>>> [  258.163645] RIP: 0033:0x7ff23714fa7d
> >>>> [  258.167226] RSP: 002b:00007ffdddfc8c70 EFLAGS: 00000293 ORIG_RAX:
> >>>> 000000000000002e
> >>>> [  258.174798] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff23714fa7d
> >>>> [  258.181933] RDX: 0000000000000000 RSI: 00007ffdddfc8cb0 RDI: 000000000000000d
> >>>> [  258.189063] RBP: 00005572f5d77040 R08: 0000000000000000 R09: 0000000000000000
> >>>> [  258.196197] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffdddfc8e1c
> >>>> [  258.203332] R13: 00007ffdddfc8e20 R14: 0000000000000000 R15: 00007ffdddfc8e28
> >>>> [  258.210464]  </TASK>
> >>>> ...
> >>>>
> >>>> I bisected the issue to a commit
> >>>> "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the
> >>>> correct link speed). Reverting this commit in my kernel build "fix"
> >>>> the issue and the server has a working network again.
> >>>
> >>> Thanks for the report. To be sure the issue doesn't fall through the
> >>> cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
> >>> tracking bot:
> >>>
> >>> #regzbot ^introduced 425c9bd06b7a7079
> >>> #regzbot title RDMA/irdma: network stopped working
> >>> #regzbot ignore-activity
> >>>
> >>> This isn't a regression? This issue or a fix for it are already
> >>> discussed somewhere else? It was fixed already? You want to clarify when
> >>> the regression started to happen? Or point out I got the title or
> >>> something else totally wrong? Then just reply and tell me -- ideally
> >>> while also telling regzbot about it, as explained by the page listed in
> >>> the footer of this mail.
> >>>
> >>> Reminder for developers: When fixing the issue, add 'Link:' tags
> >>> pointing to the report (see page linked in footer for details).
> >>>
> >>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> >>> --
> >>> Everything you wanna know about Linux kernel regression tracking:
> >>> https://linux-regtracking.leemhuis.info/about/#tldr
> >>> That page also explains what to do if mails like this annoy you.
> >>>
> >>>
