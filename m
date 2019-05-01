Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E73C10B2B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfEAQQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 12:16:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62569 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfEAQQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 12:16:47 -0400
Received: from fsav304.sakura.ne.jp (fsav304.sakura.ne.jp [153.120.85.135])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x41GGjWe089982;
        Thu, 2 May 2019 01:16:45 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav304.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav304.sakura.ne.jp);
 Thu, 02 May 2019 01:16:45 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav304.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x41GGi4I089976
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Thu, 2 May 2019 01:16:44 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Julian Anastasov <ja@ssi.bg>, Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
 <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
 <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <40199494-8eb7-d861-2e3b-6e20fcebc0dc@i-love.sakura.ne.jp>
Date:   Thu, 2 May 2019 01:16:42 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/05/01 23:52, David Ahern wrote:
> On 5/1/19 7:38 AM, Tetsuo Handa wrote:
>> On 2019/04/30 3:43, David Ahern wrote:
>>>> The attached patch adds a tracepoint to notifier_call_chain. If you have
>>>> KALLSYMS enabled it will show the order of the function handlers:
>>>>
>>>> perf record -e notifier:* -a -g &
>>>>
>>>> ip netns del <NAME>
>>>> <wait a few seconds>
>>>>
>>>> fg
>>>> <ctrl-c on perf-record>
>>>>
>>>> perf script
>>>>
>>>
>>> with the header file this time.
>>>
>>
>> What is the intent of your patch? I can see that many notifiers are called. But
>> how does this help identify which event is responsible for dropping the refcount?
>>
> 
> In a previous response you stated: "Since I'm not a netdev person, I
> appreciate if you can explain that shutdown sequence using a flow chart."

Yes, I said. But

> 
> The notifier sequence tells you the order of cleanup handlers and what
> happens when a namespace is destroyed.
> 
> The dev_hold / dev_put tracepoint helps find the refcnt leak but
> requires some time analyzing the output to match up hold / put stack traces.
> 

I already observed that fib_netdev_event() calls rt_flush_dev() which becomes a no-op
after the refcount of a dev is moved to the loopback device in that namespace.
I think that there is no event which can drop the loopback device in that namespace.

[   71.388104][ T7620] rt_flush_dev(00000000cd35e96a)->(00000000d9f4ea20)
[   71.391757][ T7620] dev_hold(00000000d9f4ea20): 7->8
[   71.394725][ T7620] CPU: 4 PID: 7620 Comm: a.out Not tainted 5.1.0-rc5+ #177
[   71.398094][ T7620] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
[   71.403711][ T7620] Call Trace:
[   71.405912][ T7620]  dump_stack+0xaa/0xd8
[   71.408252][ T7620]  rt_flush_dev+0x177/0x1b0
[   71.410802][ T7620]  fib_netdev_event+0x150/0x1b0
[   71.413270][ T7620]  notifier_call_chain+0x47/0xd0
[   71.415849][ T7620]  raw_notifier_call_chain+0x2d/0x40
[   71.418491][ T7620]  ? tun_show_group+0x90/0x90
[   71.421108][ T7620]  call_netdevice_notifiers_info+0x32/0x70
[   71.423854][ T7620]  rollback_registered_many+0x421/0x680
[   71.426583][ T7620]  rollback_registered+0x68/0xb0
[   71.429244][ T7620]  unregister_netdevice_queue+0xa5/0x100
[   71.432191][ T7620]  __tun_detach+0x576/0x590
[   71.435533][ T7620]  tun_chr_close+0x41/0x80
[   71.437957][ T7620]  ? __tun_detach+0x590/0x590
[   71.440500][ T7620]  __fput+0xeb/0x2d0
[   71.442816][ T7620]  ____fput+0x15/0x20
[   71.445090][ T7620]  task_work_run+0xa9/0xd0
[   71.447467][ T7620]  do_exit+0x37a/0xf40
[   71.449623][ T7620]  do_group_exit+0x57/0xe0
[   71.451826][ T7620]  get_signal+0x114/0x950
[   71.453989][ T7620]  do_signal+0x2f/0x700
[   71.456126][ T7620]  ? handle_mm_fault+0x1a8/0x360
[   71.458323][ T7620]  ? __x64_sys_futex+0x179/0x210
[   71.460620][ T7620]  exit_to_usermode_loop+0x159/0x180
[   71.462956][ T7620]  do_syscall_64+0x15d/0x180
[   71.465110][ T7620]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[   89.873350][ T4478] rt_flush_dev(00000000d9f4ea20)->(00000000d9f4ea20)
[   89.876311][ T4478] dev_hold(00000000d9f4ea20): 34->35
[   89.878712][ T4478] CPU: 2 PID: 4478 Comm: kworker/u128:28 Not tainted 5.1.0-rc5+ #177
[   89.881981][ T4478] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
[   89.887273][ T4478] Workqueue: netns cleanup_net
[   89.889712][ T4478] Call Trace:
[   89.891737][ T4478]  dump_stack+0xaa/0xd8
[   89.894127][ T4478]  rt_flush_dev+0x177/0x1b0
[   89.896477][ T4478]  fib_netdev_event+0x150/0x1b0
[   89.898810][ T4478]  notifier_call_chain+0x47/0xd0
[   89.901348][ T4478]  raw_notifier_call_chain+0x2d/0x40
[   89.903974][ T4478]  call_netdevice_notifiers_info+0x32/0x70
[   89.906450][ T4478]  rollback_registered_many+0x421/0x680
[   89.909125][ T4478]  unregister_netdevice_many.part.119+0x17/0x90
[   89.911833][ T4478]  default_device_exit_batch+0x1a1/0x1d0
[   89.914287][ T4478]  ? do_wait_intr_irq+0xb0/0xb0
[   89.916720][ T4478]  ? unregister_netdevice_many+0x30/0x30
[   89.919258][ T4478]  ? dev_change_net_namespace+0x4e0/0x4e0
[   89.921759][ T4478]  ops_exit_list.isra.6+0x75/0x90
[   89.924396][ T4478]  cleanup_net+0x20d/0x380
[   89.926632][ T4478]  process_one_work+0x202/0x4f0
[   89.929045][ T4478]  worker_thread+0x3c/0x4b0
[   89.931398][ T4478]  kthread+0x139/0x160
[   89.933448][ T4478]  ? process_one_work+0x4f0/0x4f0
[   89.935887][ T4478]  ? kthread_destroy_worker+0x70/0x70
[   89.938243][ T4478]  ret_from_fork+0x35/0x40
[   89.940530][ T4478] dev_put(00000000d9f4ea20): 35->34
[   89.943031][ T4478] CPU: 2 PID: 4478 Comm: kworker/u128:28 Not tainted 5.1.0-rc5+ #177
[   89.946064][ T4478] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
[   89.951324][ T4478] Workqueue: netns cleanup_net
[   89.953646][ T4478] Call Trace:
[   89.955652][ T4478]  dump_stack+0xaa/0xd8
[   89.957857][ T4478]  rt_flush_dev+0x19f/0x1b0
[   89.960187][ T4478]  fib_netdev_event+0x150/0x1b0
[   89.962706][ T4478]  notifier_call_chain+0x47/0xd0
[   89.965044][ T4478]  raw_notifier_call_chain+0x2d/0x40
[   89.967503][ T4478]  call_netdevice_notifiers_info+0x32/0x70
[   89.970139][ T4478]  rollback_registered_many+0x421/0x680
[   89.972618][ T4478]  unregister_netdevice_many.part.119+0x17/0x90
[   89.975364][ T4478]  default_device_exit_batch+0x1a1/0x1d0
[   89.977827][ T4478]  ? do_wait_intr_irq+0xb0/0xb0
[   89.980066][ T4478]  ? unregister_netdevice_many+0x30/0x30
[   89.982761][ T4478]  ? dev_change_net_namespace+0x4e0/0x4e0
[   89.985231][ T4478]  ops_exit_list.isra.6+0x75/0x90
[   89.987756][ T4478]  cleanup_net+0x20d/0x380
[   89.990090][ T4478]  process_one_work+0x202/0x4f0
[   89.992384][ T4478]  worker_thread+0x3c/0x4b0
[   89.994702][ T4478]  kthread+0x139/0x160
[   89.996749][ T4478]  ? process_one_work+0x4f0/0x4f0
[   89.999116][ T4478]  ? kthread_destroy_worker+0x70/0x70
[   90.001580][ T4478]  ret_from_fork+0x35/0x40
