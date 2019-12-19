Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759E4125EA9
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfLSKM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:12:27 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39056 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfLSKM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:12:26 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so6591239oty.6;
        Thu, 19 Dec 2019 02:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7gVsavI/JT3S/B4hCPb68cU8nhyV5pL21wFcvH1mp4E=;
        b=oHhTEgeNOr4aEuORnmTe/e4mLY8BQRzVBBQIGfPl1jlyPRubu0SXQudSynf+l18T9u
         TVaObZZJflZee3w8mu7OVwGf8nkR6TfZFdcxXl3AnDmvMgNn4pp0DEu+R0YOjbcxFnsL
         iuYe3FquV9NECADz0L4EwsblOVKSI1ip9Hzf6d308VEmhrgtHL1d94oVZG56nBOoR5UV
         OyBbXT5Jd+6jy+oTKaJKDb6IElbMUN4eLSedUNdMUwWeHCvvOqmRFdTcyuVVijAYSqxE
         WcWWcC/Q9kJEjwLlQAhjYZyDJad84W0FgHautPJWhdv+75ONimxm1JlfVxuEYFjDhLtL
         /EIA==
X-Gm-Message-State: APjAAAXz8PFjZGGRqwvzcTkB1CtYqqjss/1ExlgMRcWKOW2h6VltoSKX
        ohomfYS2565f/MvTKg8sAS/TUV9scIaSrHSF2vc=
X-Google-Smtp-Source: APXvYqzL4QPPo84YZ/GFL90PvSpMdwHUiM5jspEumQc5V+iVkrg1mIXqszRvm+fHeYjzejWdR21UlKMtjcO5l+BSoMM=
X-Received: by 2002:a9d:7984:: with SMTP id h4mr8153285otm.297.1576750345417;
 Thu, 19 Dec 2019 02:12:25 -0800 (PST)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-8ffb055beae58574d3e77b4bf9d4d15eace1ca27@kernel.org>
In-Reply-To: <git-mailbomb-linux-master-8ffb055beae58574d3e77b4bf9d4d15eace1ca27@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 19 Dec 2019 11:12:14 +0100
Message-ID: <CAMuHMdVgF0PVmqXbaWqkrcML0O-hhWB3akj8UAn8Q_hN2evm+A@mail.gmail.com>
Subject: refcount_warn_saturate WARNING (was: Re: cls_flower: Fix the behavior
 using port ranges with hw-offload)
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Komachi-san,

On Sun, Dec 8, 2019 at 10:40 PM Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Commit:     8ffb055beae58574d3e77b4bf9d4d15eace1ca27
> Parent:     2f23cd42e19c22c24ff0e221089b7b6123b117c5
> Refname:    refs/heads/master
> Web:        https://git.kernel.org/torvalds/c/8ffb055beae58574d3e77b4bf9d4d15eace1ca27
> Author:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
> AuthorDate: Tue Dec 3 19:40:12 2019 +0900
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Tue Dec 3 11:55:46 2019 -0800
>
>     cls_flower: Fix the behavior using port ranges with hw-offload
>
>     The recent commit 5c72299fba9d ("net: sched: cls_flower: Classify
>     packets using port ranges") had added filtering based on port ranges
>     to tc flower. However the commit missed necessary changes in hw-offload
>     code, so the feature gave rise to generating incorrect offloaded flow
>     keys in NIC.
>
>     One more detailed example is below:
>
>     $ tc qdisc add dev eth0 ingress
>     $ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
>       dst_port 100-200 action drop
>
>     With the setup above, an exact match filter with dst_port == 0 will be
>     installed in NIC by hw-offload. IOW, the NIC will have a rule which is
>     equivalent to the following one.
>
>     $ tc qdisc add dev eth0 ingress
>     $ tc filter add dev eth0 ingress protocol ip flower ip_proto tcp \
>       dst_port 0 action drop
>
>     The behavior was caused by the flow dissector which extracts packet
>     data into the flow key in the tc flower. More specifically, regardless
>     of exact match or specified port ranges, fl_init_dissector() set the
>     FLOW_DISSECTOR_KEY_PORTS flag in struct flow_dissector to extract port
>     numbers from skb in skb_flow_dissect() called by fl_classify(). Note
>     that device drivers received the same struct flow_dissector object as
>     used in skb_flow_dissect(). Thus, offloaded drivers could not identify
>     which of these is used because the FLOW_DISSECTOR_KEY_PORTS flag was
>     set to struct flow_dissector in either case.
>
>     This patch adds the new FLOW_DISSECTOR_KEY_PORTS_RANGE flag and the new
>     tp_range field in struct fl_flow_key to recognize which filters are applied
>     to offloaded drivers. At this point, when filters based on port ranges
>     passed to drivers, drivers return the EOPNOTSUPP error because they do
>     not support the feature (the newly created FLOW_DISSECTOR_KEY_PORTS_RANGE
>     flag).
>
>     Fixes: 5c72299fba9d ("net: sched: cls_flower: Classify packets using port ranges")
>     Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

I still see the below warning on m68k/ARAnyM during boot with v5.5-rc2
and next-20191219.
Reverting commit 8ffb055beae58574 ("cls_flower: Fix the behavior using
port ranges with hw-offload") fixes that.

As this is networking, perhaps this is seen on big-endian only?
Or !CONFIG_SMP?

Do you have a clue?
I'm especially worried as this commit is already being backported to stable.
Thanks!

EXT4-fs (sda1): re-mounted. Opts:
EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
ext3 filesystem being remounted at / supports timestamps until 2038 (0x7fffffff)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 7 at lib/refcount.c:28 refcount_warn_saturate+0x54/0x100
refcount_t: underflow; use-after-free.
Modules linked in:
CPU: 0 PID: 7 Comm: ksoftirqd/0 Not tainted 5.5.0-rc2-next-20191219-atari #246
Stack from 00c31e88:
        00c31e88 00387ebc 00023d96 0039b5b0 0000001c 00000009 00a6d680 00023dda
        0039b5b0 0000001c 001a9658 00000009 00000000 00c31ed0 00000001 00000000
        04208040 0000000a 0039b5eb 00c31ef0 00c30000 001a9658 0039b5b0 0000001c
        00000009 0039b5eb 0027071c 00326d1c 00000003 00326cd8 00271840 00000001
        00326d1c 00000000 00a6d680 0024339c 00a6d680 00000000 00000200 000ab5e6
        00048632 00a6d680 0000000a 00400d78 003fbc00 002f88a6 00400d78 002f8b5e
Call Trace: [<00023d96>] __warn+0xb2/0xb4
 [<00023dda>] warn_slowpath_fmt+0x42/0x64
 [<001a9658>] refcount_warn_saturate+0x54/0x100
 [<001a9658>] refcount_warn_saturate+0x54/0x100
 [<0027071c>] refcount_sub_and_test.constprop.77+0x38/0x3e
 [<00271840>] ipv4_dst_destroy+0x24/0x42
 [<0024339c>] dst_destroy+0x40/0xae
 [<000ab5e6>] kfree+0x0/0x3e
 [<00048632>] rcu_process_callbacks+0x9a/0x9c
 [<002f88a6>] __do_softirq+0x146/0x182
 [<002f8b5e>] schedule+0x0/0xb4
 [<00035f3e>] kthread_parkme+0x0/0x10
 [<00035a86>] __init_completion+0x0/0x20
 [<0003836c>] smpboot_thread_fn+0x0/0x100
 [<000360a2>] kthread_should_stop+0x0/0x12
 [<00036096>] kthread_should_park+0x0/0xc
 [<00025c28>] run_ksoftirqd+0x12/0x20
 [<00038466>] smpboot_thread_fn+0xfa/0x100
 [<00024914>] do_exit+0x0/0x6d4
 [<0003f620>] complete+0x0/0x34
 [<0003665c>] kthread+0xb2/0xbc
 [<00035a86>] __init_completion+0x0/0x20
 [<000365aa>] kthread+0x0/0xbc
 [<00002ab8>] ret_from_kernel_thread+0xc/0x14
---[ end trace cddc6a39eb5bb237 ]---

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
