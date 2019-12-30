Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DC112D4EB
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 00:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfL3XCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 18:02:23 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45990 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727695AbfL3XCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 18:02:22 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1im43E-0003J1-Sx; Tue, 31 Dec 2019 00:02:16 +0100
Date:   Tue, 31 Dec 2019 00:02:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Subject: Re: INFO: rcu detected stall in br_handle_frame (2)
Message-ID: <20191230230216.GK795@breakpoint.cc>
References: <000000000000f9f9a8059a737d7e@google.com>
 <20191228111548.GI795@breakpoint.cc>
 <30e6a8c6-b857-00b8-24d8-076b92409636@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30e6a8c6-b857-00b8-24d8-076b92409636@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 12/28/19 3:15 AM, Florian Westphal wrote:
> > If you don't have a better idea/suggestion for an upperlimit INT_MAX
> > would be enough to prevent perpetual <= 0 condition.
> 
> Thanks Florian for the analysis.
> 
> I guess we could use a conservative upper bound value of (1 << 20)
> ( about 16 64KB packets )
>
> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> index ff4c5e9d0d7778d86f20f4bd67cc627eed0713d9..12f1d1c6044fac9db987f7ce3a50a7e2c711358b 100644
> --- a/net/sched/sch_fq.c
> +++ b/net/sched/sch_fq.c
> @@ -786,15 +786,20 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
>         if (tb[TCA_FQ_QUANTUM]) {
>                 u32 quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
>  
> -               if (quantum > 0)
> +               if (quantum > 0 && quantum <= (1 << 20))
>                         q->quantum = quantum;
>                 else
>                         err = -EINVAL;
>         }
>  
> -       if (tb[TCA_FQ_INITIAL_QUANTUM])
> -               q->initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
> +       if (tb[TCA_FQ_INITIAL_QUANTUM]) {
> +               u32 quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
>  
> +               if (quantum > 0 && quantum <= (1 << 20))
> +                       q->initial_quantum = quantum;
> +               else
> +                       err = -EINVAL;
> +       }
>         if (tb[TCA_FQ_FLOW_DEFAULT_RATE])
>                 pr_warn_ratelimited("sch_fq: defrate %u ignored.\n",
>                                     nla_get_u32(tb[TCA_FQ_FLOW_DEFAULT_RATE]));
> 

Perhaps it would make sense to add an #ifdef for the 1 << 20 and
a small comment as to what this is / where this comes from.

But other than that nit, this looks good to me, thanks Eric!
