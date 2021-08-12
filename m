Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2887F3EA9CE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbhHLRxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 13:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhHLRxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 13:53:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C726023D;
        Thu, 12 Aug 2021 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628790802;
        bh=+DBNYMHW9C8tmDuzsVD2IYotEdpsRD+WdJebzOTS63s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jegYsXtcbMNzdIvbEX3MZpK2NVdUzHdJu+ngI7qnFJKyEpRaB/KrJiYn5rm390eRn
         01SmHrk+QiH51VQDxIilpnkWJS8HDLDOadV4cBADDuGfMVc1daizdGdawOQmg6J8Vj
         yXHPlBLP4y+6FvTkBFUKWYUscaUsZ2j50K0dIeEP2sHpmR79NAIpYE9SbXsR/g8gd5
         MluWNMM381PicRbSvkXOrwwDi+5WL0o5ztKSt7KYUtmvdLjneI0IIZhJQ8Pu0Ox2Ia
         AF5IRvRjJlnEzTkhv2w7jE/BvKXt4DnzBRUMI68oVV23nliy+VXfUAVk5ouJBE9qgA
         xc8JbWMD6FZ6Q==
Date:   Thu, 12 Aug 2021 10:53:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     tcs.kernel@gmail.com, vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        Haimin Zhang <tcs_kernel@tencent.com>
Subject: Re: [PATCH] net:sched fix array-index-out-of-bounds in
 taprio_change
Message-ID: <20210812105321.0de11e3e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
References: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 13:10:09 +0800 tcs.kernel@gmail.com wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> syzbot report an array-index-out-of-bounds in taprio_change
> index 16 is out of range for type '__u16 [16]'
> that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
> the return value of netdev_set_num_tc.
> 
> Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> ---
>  net/sched/sch_taprio.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 9c79374..1ab2fc9 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	taprio_set_picos_per_byte(dev, q);
>  
>  	if (mqprio) {
> -		netdev_set_num_tc(dev, mqprio->num_tc);
> +		err = netdev_set_num_tc(dev, mqprio->num_tc);
> +		if (err)
> +			goto free_sched;

taprio_set_picos_per_byte() already got called and applied some of the
changes. It seems like the early return from taprio_parse_mqprio_opt()
if dev->num_tc is non-zero is incorrect. That function is supposed to
validate that mqprio_opt() is correct AFAIU. That would mean:

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")

Vinicius - WDYT?

>  		for (i = 0; i < mqprio->num_tc; i++)
>  			netdev_set_tc_queue(dev, i,
>  					    mqprio->count[i],

