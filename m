Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216BA14FFD4
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 23:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgBBWhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 17:37:31 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56252 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726971AbgBBWhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 17:37:31 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iyNrs-0007uX-NL; Sun, 02 Feb 2020 23:37:28 +0100
Date:   Sun, 2 Feb 2020 23:37:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch nf 3/3] xt_hashlimit: limit the max size of hashtable
Message-ID: <20200202223728.GO795@breakpoint.cc>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-4-xiyou.wangcong@gmail.com>
 <20200131220807.GJ795@breakpoint.cc>
 <CAM_iQpVVgkP8u_9ez-2fmrJDdKoFwAxGcbE3Mmk3=7cv4W_QJQ@mail.gmail.com>
 <20200131233659.GM795@breakpoint.cc>
 <CAM_iQpWbejoFPbFDSfUtvhFbU3DjhV6NAkPQ+-mirY_QEMHxkA@mail.gmail.com>
 <20200202061611.GN795@breakpoint.cc>
 <CAM_iQpXC9FnisZwLwWHQEbi-She3HywO5SJAxSS1cf_Pntn-6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXC9FnisZwLwWHQEbi-She3HywO5SJAxSS1cf_Pntn-6Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> Ok, so here is what I have now:
> 
> 
> +#define HASHLIMIT_MAX_SIZE 1048576
> +
>  static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
>                                      struct xt_hashlimit_htable **hinfo,
>                                      struct hashlimit_cfg3 *cfg,
> @@ -847,6 +849,14 @@ static int hashlimit_mt_check_common(const struct
> xt_mtchk_param *par,
> 
>         if (cfg->gc_interval == 0 || cfg->expire == 0)
>                 return -EINVAL;
> +       if (cfg->size > HASHLIMIT_MAX_SIZE) {
> +               cfg->size = HASHLIMIT_MAX_SIZE;
> +               pr_info_ratelimited("size too large, truncated to
> %u\n", cfg->size);
> +       }
> +       if (cfg->max > HASHLIMIT_MAX_SIZE) {
> +               cfg->max = HASHLIMIT_MAX_SIZE;
> +               pr_info_ratelimited("max too large, truncated to
> %u\n", cfg->max);
> +       }
> 
> Please let me know if it is still different with your suggestion.

I am fine with this.
