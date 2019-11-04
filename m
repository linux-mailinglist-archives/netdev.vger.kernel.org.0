Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E6EEEAF0
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbfKDVTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:19:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:62737 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfKDVTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:19:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:19:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="403110404"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 04 Nov 2019 13:19:11 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] taprio: fix panic while hw offload sched list swap
In-Reply-To: <20191101232828.17023-1-ivan.khoronzhuk@linaro.org>
References: <20191101232828.17023-1-ivan.khoronzhuk@linaro.org>
Date:   Mon, 04 Nov 2019 13:20:37 -0800
Message-ID: <87tv7juymy.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> writes:

> Don't swap oper and admin schedules too early, it's not correct and
> causes crash.
>
> Steps to reproduce:
>
> 1)
> tc qdisc replace dev eth0 parent root handle 100 taprio \
>     num_tc 3 \
>     map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>     queues 1@0 1@1 1@2 \
>     base-time $SOME_BASE_TIME \
>     sched-entry S 01 80000 \
>     sched-entry S 02 15000 \
>     sched-entry S 04 40000 \
>     flags 2
>
> 2)
> tc qdisc replace dev eth0 parent root handle 100 taprio \
>     base-time $SOME_BASE_TIME \
>     sched-entry S 01 90000 \
>     sched-entry S 02 20000 \
>     sched-entry S 04 40000 \
>     flags 2
>
> 3)
> tc qdisc replace dev eth0 parent root handle 100 taprio \
>     base-time $SOME_BASE_TIME \
>     sched-entry S 01 150000 \
>     sched-entry S 02 200000 \
>     sched-entry S 04 40000 \
>     flags 2
>
> Do 2 3 2 .. steps  more times if not happens and observe:
>
> [  305.832319] Unable to handle kernel write to read-only memory at
> virtual address ffff0000087ce7f0
> [  305.910887] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> [  305.919306] Hardware name: Texas Instruments AM654 Base Board (DT)
>
> [...]
>
> [  306.017119] x1 : ffff800848031d88 x0 : ffff800848031d80
> [  306.022422] Call trace:
> [  306.024866]  taprio_free_sched_cb+0x4c/0x98
> [  306.029040]  rcu_process_callbacks+0x25c/0x410
> [  306.033476]  __do_softirq+0x10c/0x208
> [  306.037132]  irq_exit+0xb8/0xc8
> [  306.040267]  __handle_domain_irq+0x64/0xb8
> [  306.044352]  gic_handle_irq+0x7c/0x178
> [  306.048092]  el1_irq+0xb0/0x128
> [  306.051227]  arch_cpu_idle+0x10/0x18
> [  306.054795]  do_idle+0x120/0x138
> [  306.058015]  cpu_startup_entry+0x20/0x28
> [  306.061931]  rest_init+0xcc/0xd8
> [  306.065154]  start_kernel+0x3bc/0x3e4
> [  306.068810] Code: f2fbd5b7 f2fbd5b6 d503201f f9400422 (f9000662)
> [  306.074900] ---[ end trace 96c8e2284a9d9d6e ]---
> [  306.079507] Kernel panic - not syncing: Fatal exception in interrupt
> [  306.085847] SMP: stopping secondary CPUs
> [  306.089765] Kernel Offset: disabled
>
> Try to explain one of the possible crash cases:
>
> The "real" admin list is assigned when admin_sched is set to
> new_admin, it happens after "swap", that assigns to oper_sched NULL.
> Thus if call qdisc show it can crash.
>
> Farther, next second time, when sched list is updated, the admin_sched
> is not NULL and becomes the oper_sched, previous oper_sched was NULL so
> just skipped. But then admin_sched is assigned new_admin, but schedules
> to free previous assigned admin_sched (that already became oper_sched).
>
> Farther, next third time, when sched list is updated,
> while one more swap, oper_sched is not null, but it was happy to be
> freed already (while prev. admin update), so while try to free
> oper_sched the kernel panic happens at taprio_free_sched_cb().
>
> So, move the "swap emulation" where it should be according to function
> comment from code.
>
> Fixes: 9c66d15646760e ("taprio: Add support for hardware offloading")
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

As it solves a crash, and I have no problems with this fix:

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

But reading the code, I got the feeling that upstream "swap emulation"
part of the code is not working as it should, perhaps it was lost during
upstreaming of the patch? Vladimir, can you confirm that this works for
you? (yeah, this can be solved later)


Cheers,
--
Vinicius

