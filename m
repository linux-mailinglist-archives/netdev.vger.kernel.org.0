Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AD9378D52
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348020AbhEJMjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 08:39:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:11545 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344955AbhEJMVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:21:01 -0400
IronPort-SDR: pJbtbx2JDmN4VcoGNb1fgN7z+GDt2tI4cnlTiPhgxx54UrkB9PEUY6F4YEV++hnF8oaqkjnOFS
 d8QtXukQqeGQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="197195432"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="197195432"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 05:19:38 -0700
IronPort-SDR: ao4yB93p+glGus/p+7LqlVOo/UzoL00iN6fQNdv79r/4ZwcIE5umGx34UpIlUVegZIcG2R+z+i
 pNhno4LPORtg==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="391900373"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 05:19:32 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1lg4sg-00BAFq-NY; Mon, 10 May 2021 15:19:26 +0300
Date:   Mon, 10 May 2021 15:19:26 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     "Rocco.Yue" <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Peter Enderborg <peter.enderborg@sony.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Di Zhu <zhudi21@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, wsd_upsream@mediatek.com
Subject: Re: [PATCH][v2] rtnetlink: add rtnl_lock debug log
Message-ID: <YJkkzlJQPWXjanxe@smile.fi.intel.com>
References: <20210508085738.6296-1-rocco.yue@mediatek.com>
 <CAHp75VftbW7pgkfrSB6teKZO4EfGH9UWkhy1SAtijCLvKz8HTQ@mail.gmail.com>
 <1620631421.29475.106.camel@mbjsdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620631421.29475.106.camel@mbjsdccf07>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 03:23:41PM +0800, Rocco.Yue wrote:
> On Sun, 2021-05-09 at 12:42 +0300, Andy Shevchenko wrote:
> > On Sat, May 8, 2021 at 12:11 PM Rocco Yue <rocco.yue@mediatek.com> wrote:
> > >
> > > We often encounter system hangs caused by certain process
> > > holding rtnl_lock for a long time. Even if there is a lock
> > > detection mechanism in Linux, it is a bit troublesome and
> > > affects the system performance. We hope to add a lightweight
> > > debugging mechanism for detecting rtnl_lock.
> > >
> > > Up to now, we have discovered and solved some potential bugs
> > > through this lightweight rtnl_lock debugging mechanism, which
> > > is helpful for us.
> > >
> > > When you say Y for RTNL_LOCK_DEBUG, then the kernel will detect
> > > if any function hold rtnl_lock too long and some key information
> > > will be printed out to help locate the problem.
> > >
> > > i.e: from the following logs, we can clearly know that the pid=2206
> > > RfxSender_4 process holds rtnl_lock for a long time, causing the
> > > system to hang. And we can also speculate that the delay operation
> > > may be performed in devinet_ioctl(), resulting in rtnl_lock was
> > > not released in time.
> > >
> > > <6>[   40.191481][    C6] rtnetlink: -- rtnl_print_btrace start --
> > 
> > You don't seem to get it. It's a quite long trace for the commit
> > message. Do you need all those lines below? Why?
> > 
> 
> The contents shown in all the lines below are the original printed after
> adding this patch, I pasted these lines into commit message to
> illustrate this patch as a case.
> 
> It now appears that some of following are indeed unnecessary, I am going
> to condense a lot of following contents as follows.
> 
> Could you please help to take a look at it again? many thanks :-)
> 
> [   40.191481] rtnetlink: -- rtnl_print_btrace start --
> [   40.191494] RfxSender_4[2206][R] hold rtnl_lock more than 2 sec,
> start time: 38181400013
> [   40.191571] Call trace:
> [   40.191586]  rtnl_print_btrace+0xf0/0x124
> [   40.191656]  __delay+0xc0/0x180
> [   40.191663]  devinet_ioctl+0x21c/0x75c
> [   40.191668]  inet_ioctl+0xb8/0x1f8
> [   40.191675]  sock_do_ioctl+0x70/0x2ac
> [   40.191682]  sock_ioctl+0x5dc/0xa74
> [   40.191715] rtnetlink: -- rtnl_print_btrace end --
> [   42.181879] rtnetlink: rtnl_lock is held by [2206] from
> [38181400013] to [42181875177]

Much better, thanks!

(You still need a real review on the contents of the change)

> > > <6>[   40.191494][    C6] rtnetlink: RfxSender_4[2206][R] hold rtnl_lock
> > > more than 2 sec, start time: 38181400013
> > > <4>[   40.191510][    C6]  devinet_ioctl+0x1fc/0x75c
> > > <4>[   40.191517][    C6]  inet_ioctl+0xb8/0x1f8
> > > <4>[   40.191527][    C6]  sock_do_ioctl+0x70/0x2ac
> > > <4>[   40.191533][    C6]  sock_ioctl+0x5dc/0xa74
> > > <4>[   40.191541][    C6]  __arm64_sys_ioctl+0x178/0x1fc
> > > <4>[   40.191548][    C6]  el0_svc_common+0xc0/0x24c
> > > <4>[   40.191555][    C6]  el0_svc+0x28/0x88
> > > <4>[   40.191560][    C6]  el0_sync_handler+0x8c/0xf0
> > > <4>[   40.191566][    C6]  el0_sync+0x198/0x1c0
> > > <6>[   40.191571][    C6] Call trace:
> > > <6>[   40.191586][    C6]  rtnl_print_btrace+0xf0/0x124
> > > <6>[   40.191595][    C6]  call_timer_fn+0x5c/0x3b4
> > > <6>[   40.191602][    C6]  expire_timers+0xe0/0x49c
> > > <6>[   40.191609][    C6]  __run_timers+0x34c/0x48c
> > > <6>[   40.191616][    C6]  run_timer_softirq+0x28/0x58
> > > <6>[   40.191621][    C6]  efi_header_end+0x168/0x690
> > > <6>[   40.191628][    C6]  __irq_exit_rcu+0x108/0x124
> > > <6>[   40.191635][    C6]  __handle_domain_irq+0x130/0x1b4
> > > <6>[   40.191643][    C6]  gic_handle_irq.29882+0x6c/0x2d8
> > > <6>[   40.191648][    C6]  el1_irq+0xdc/0x1c0
> > > <6>[   40.191656][    C6]  __delay+0xc0/0x180
> > > <6>[   40.191663][    C6]  devinet_ioctl+0x21c/0x75c
> > > <6>[   40.191668][    C6]  inet_ioctl+0xb8/0x1f8
> > > <6>[   40.191675][    C6]  sock_do_ioctl+0x70/0x2ac
> > > <6>[   40.191682][    C6]  sock_ioctl+0x5dc/0xa74
> > > <6>[   40.191688][    C6]  __arm64_sys_ioctl+0x178/0x1fc
> > > <6>[   40.191694][    C6]  el0_svc_common+0xc0/0x24c
> > > <6>[   40.191699][    C6]  el0_svc+0x28/0x88
> > > <6>[   40.191705][    C6]  el0_sync_handler+0x8c/0xf0
> > > <6>[   40.191710][    C6]  el0_sync+0x198/0x1c0
> > > <6>[   40.191715][    C6] rtnetlink: -- rtnl_print_btrace end --
> > >
> > > <6>[   42.181879][ T2206] rtnetlink: rtnl_lock is held by [2206] from
> > > [38181400013] to [42181875177]

-- 
With Best Regards,
Andy Shevchenko


