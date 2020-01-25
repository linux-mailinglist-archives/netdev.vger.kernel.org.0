Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450A81496B3
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAYQpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:45:08 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44518 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAYQpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 11:45:08 -0500
Received: by mail-ed1-f66.google.com with SMTP id g19so1947930eds.11
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 08:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jkwYGM7i5sRo08DxnBQ8JZRzp8XVfFrgEr/AwZ14lIU=;
        b=hXOY9pRbX3kcqAYe/oTcGj6ApsJd0yw8jzhi6lHi/qqtKZxPzuPivW5GVpI0sIhPL7
         wan1fu9knT5y7euuumrOwdk8nGzg/qFA3nXu7ZP042BPBOjFWn2LY9yFfIh2PAwpfBC/
         JVlfdURA5gXw0xymLwII+JSN43GCoOSUcUhzcmmKBKylUi5FmlGyX243Fsa9hVDIN7Bh
         86CRJmKPOIOfqq8dco/7W25+Ab27Xy0HlDoGom8I73JPDJWaCB3injwD4xv6Upjw7fky
         VcWkCD8btxO+fXRuNRD3TE0zdsVOdltHf/3jlG2HOyQ+6jBdxGuDD6Zeck5kZy5o3+vs
         6yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jkwYGM7i5sRo08DxnBQ8JZRzp8XVfFrgEr/AwZ14lIU=;
        b=oo85Iv9knqHnrceopjrGkA2hUjZ+ONmrODa0zw2j5iUtnGcMPX6ZSbkJgBFvV/YdQB
         ske3mzN57A+GmeYxRK8z70Ic//1aJNLI8eL/zCmI2IuDC0fLYWU1WIGY+ggZRdXmRfOf
         86O0w8CIaQBGfnkx4AAILvW8nbif7A4HrAfA+QskYfiJ1+cnv5bXjMb2XVsnaXL3aA4V
         mF+m4lsE3NdeX6ONIX+RrKZfPHxqLJrYkEmDIPT2gWy8sozbYQZTKhxngR93qcKjhlVw
         PdVvkOm2vyYjLB6e0L1SeG0z4uZcp6wXM+iPPt8Y7Fj5UHyE6S6JSV+fRPYWPJvIboVX
         3gNQ==
X-Gm-Message-State: APjAAAUzlOKNxvlxlEVTT0bx8ArbnDic+jgxbbIWgv+Hld9vIASsZHfg
        gX7RVAUruAkOSsAOZSZ7QDV2DCHeeTNagv8XiFI=
X-Google-Smtp-Source: APXvYqxHfsW81+7fXV69gly1BqJ4+UIa7E+lxOBROcvqiVBaqi0d+1/7bzXFRzyM6n5hiFCWWEWLSNdl/bF57br3cbU=
X-Received: by 2002:a17:906:a406:: with SMTP id l6mr7044959ejz.293.1579970705978;
 Sat, 25 Jan 2020 08:45:05 -0800 (PST)
MIME-Version: 1.0
References: <20200125005320.3353761-1-vinicius.gomes@intel.com> <20200125005320.3353761-3-vinicius.gomes@intel.com>
In-Reply-To: <20200125005320.3353761-3-vinicius.gomes@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 25 Jan 2020 18:44:55 +0200
Message-ID: <CA+h21hojJYDsb29Xc99hN52J2Vtxd0PbrUWWWGwfBVsKa-RJ=g@mail.gmail.com>
Subject: Re: [PATCH net v1 2/3] taprio: Fix still allowing changing the flags
 during runtime
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Sat, 25 Jan 2020 at 02:52, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> The check for 'q->flags' being zero allows that, if the taprio
> instance was created with no 'flags' specified, for 'flags' to be
> changed. By design this should not be permitted, as it might require
> changing the enqueue()/dequeue() functions of taprio, which might
> already be running, and if the hrtimer is enabled or not.
>
> The solution is to not support changing flags in any way during
> "runtime".
>
> As a result of this problem the following RCU stall can be observed:
>
> [ 1730.558249] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [ 1730.558258] rcu:       6-...0: (190 ticks this GP) idle=922/0/0x1 softirq=25580/25582 fqs=16250
> [ 1730.558264]            (detected by 2, t=65002 jiffies, g=33017, q=81)
> [ 1730.558269] Sending NMI from CPU 2 to CPUs 6:
> [ 1730.559277] NMI backtrace for cpu 6
> [ 1730.559277] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G            E     5.5.0-rc6+ #35
> [ 1730.559278] Hardware name: Gigabyte Technology Co., Ltd. Z390 AORUS ULTRA/Z390 AORUS ULTRA-CF, BIOS F7 03/14/2019
> [ 1730.559278] RIP: 0010:__hrtimer_run_queues+0xe2/0x440
> [ 1730.559278] Code: 48 8b 43 28 4c 89 ff 48 8b 75 c0 48 89 45 c8 e8 f4 bb 7c 00 0f 1f 44 00 00 65 8b 05 40 31 f0 68 89 c0 48 0f a3 05 3e 5c 25 01 <0f> 82 fc 01 00 00 48 8b 45 c8 48 89 df ff d0 89 45 c8 0f 1f 44 00
> [ 1730.559279] RSP: 0018:ffff9970802d8f10 EFLAGS: 00000083
> [ 1730.559279] RAX: 0000000000000006 RBX: ffff8b31645bff38 RCX: 0000000000000000
> [ 1730.559280] RDX: 0000000000000000 RSI: ffffffff9710f2ec RDI: ffffffff978daf0e
> [ 1730.559280] RBP: ffff9970802d8f68 R08: 0000000000000000 R09: 0000000000000000
> [ 1730.559280] R10: 0000018336d7944e R11: 0000000000000001 R12: ffff8b316e39f9c0
> [ 1730.559281] R13: ffff8b316e39f940 R14: ffff8b316e39f998 R15: ffff8b316e39f7c0
> [ 1730.559281] FS:  0000000000000000(0000) GS:ffff8b316e380000(0000) knlGS:0000000000000000
> [ 1730.559281] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1730.559281] CR2: 00007f1105303760 CR3: 0000000227210005 CR4: 00000000003606e0
> [ 1730.559282] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1730.559282] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1730.559282] Call Trace:
> [ 1730.559282]  <IRQ>
> [ 1730.559283]  ? taprio_dequeue_soft+0x2d0/0x2d0 [sch_taprio]
> [ 1730.559283]  hrtimer_interrupt+0x104/0x220
> [ 1730.559283]  ? irqtime_account_irq+0x34/0xa0
> [ 1730.559283]  smp_apic_timer_interrupt+0x6d/0x230
> [ 1730.559284]  apic_timer_interrupt+0xf/0x20
> [ 1730.559284]  </IRQ>
> [ 1730.559284] RIP: 0010:cpu_idle_poll+0x35/0x1a0
> [ 1730.559285] Code: 88 82 ff 65 44 8b 25 12 7d 73 68 0f 1f 44 00 00 e8 90 c3 89 ff fb 65 48 8b 1c 25 c0 7e 01 00 48 8b 03 a8 08 74 0b eb 1c f3 90 <48> 8b 03 a8 08 75 13 8b 05 be a8 a8 00 85 c0 75 ed e8 75 48 84 ff
> [ 1730.559285] RSP: 0018:ffff997080137ea8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
> [ 1730.559285] RAX: 0000000000000001 RBX: ffff8b316bc3c580 RCX: 0000000000000000
> [ 1730.559286] RDX: 0000000000000001 RSI: 000000002819aad9 RDI: ffffffff978da730
> [ 1730.559286] RBP: ffff997080137ec0 R08: 0000018324a6d387 R09: 0000000000000000
> [ 1730.559286] R10: 0000000000000400 R11: 0000000000000001 R12: 0000000000000006
> [ 1730.559286] R13: ffff8b316bc3c580 R14: 0000000000000000 R15: 0000000000000000
> [ 1730.559287]  ? cpu_idle_poll+0x20/0x1a0
> [ 1730.559287]  ? cpu_idle_poll+0x20/0x1a0
> [ 1730.559287]  do_idle+0x4d/0x1f0
> [ 1730.559287]  ? complete+0x44/0x50
> [ 1730.559288]  cpu_startup_entry+0x1b/0x20
> [ 1730.559288]  start_secondary+0x142/0x180
> [ 1730.559288]  secondary_startup_64+0xb6/0xc0
> [ 1776.686313] nvme nvme0: I/O 96 QID 1 timeout, completion polled
>
> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  net/sched/sch_taprio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index ad0dadcfcdba..dfbecb9ee2f4 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1391,7 +1391,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>         if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
>                 taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
>
> -               if (q->flags != 0 && q->flags != taprio_flags) {
> +               if (q->flags != taprio_flags) {

You can't quite do this, since it now breaks plain 'tc qdisc add'
behavior. Can you initialize q->flags to -1 in taprio_init, just below
q->clockid, and keep the "q->flags != -1" check here? You might also
need to validate the taprio_flags to be a positive value.

>                         NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
>                         return -EOPNOTSUPP;
>                 } else if (!taprio_flags_valid(taprio_flags)) {
> --
> 2.25.0
>

Regards,
-Vladimir
