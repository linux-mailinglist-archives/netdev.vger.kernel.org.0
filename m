Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE710DCB8
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 06:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfK3FpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 00:45:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35098 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfK3FpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 00:45:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id s10so13788061plp.2
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 21:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bo8UTbn2I0UhAnxGVUhq9aeLyZDq0y88qPx178xvBoA=;
        b=FiKhLU694hR+C38VZslnVaEs7xDacSWiUZOYm3i3f8OYUPyI0vV2zWLGzjpO7kIuvV
         voh7CyMRadAxn707kzsw40fErId1IEzUUq+aephyL+fWqEIYGp3/IYJfMkd4TaJSgg9w
         NxBYxSqKct6/AHY5EewS09y4Lpma58dpNEi+/xIf27HK30UQ0lTi9RMwSAT618pCyRZP
         HBRjdEim7BEJclkbCDG4y+lrbGs18uSzSAEBdtU9w6geoj34LRyERL1s1+rIwRlGgz5I
         c5jqeJ63C6Q+56F9WNcWc18xPYsPA77yiHwaHPztN7pFpIkYccaDvZGM9TL22wgpwV8d
         viBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bo8UTbn2I0UhAnxGVUhq9aeLyZDq0y88qPx178xvBoA=;
        b=KovYEgRGLKJ5Ncjcs6fZ3VxRnFc37GotaOPly4LgTFelnth/zRmzkrBvitEzd7mduN
         s25EutvhoV3h/6iP75DivD5CYphdbniykJUFc2n3a8GzAZVOMJA1EkOpOc7qnHsBM4kB
         8z5Z71K8mDnkNqfqq2yHjgdlccVVNK5DzKHnsj8PFEILMOi9kQSW4mntB7WMvC8XJcb9
         y54PeQp4TUrGyHvU53Mc9EnP8x411xuuyNmbhoxRdlZZXCK0Dlo7MpWn9QNPF2pZMsED
         YEFgiRxSITdhFCI9BOk4CdtqLxy2UKHKiH0DqaPBTwCRPRVsPxnc69DdeI5bB31OEVdK
         RU4g==
X-Gm-Message-State: APjAAAVc9oZzwGBBXlzAImrqV3QHiVM3HMYOjC/iPktowOP6ha6LzQ1c
        FwQjC6dK6p0pazMHQejgdwDfWoBzQV8Tl38qgJM=
X-Google-Smtp-Source: APXvYqzLTsF//a0DqjjxuIBNj9BGi2jiqnfZ6FzeziiRNochujHyw3xna0IyXMifW6ok0rJqDPwT4AFxf6dZfu6X60s=
X-Received: by 2002:a17:90a:77c9:: with SMTP id e9mr23503128pjs.70.1575092703539;
 Fri, 29 Nov 2019 21:45:03 -0800 (PST)
MIME-Version: 1.0
References: <20191128063048.90282-1-dust.li@linux.alibaba.com>
In-Reply-To: <20191128063048.90282-1-dust.li@linux.alibaba.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Nov 2019 21:44:52 -0800
Message-ID: <CAM_iQpVYS9Am6G46iiNhg_OAft_=CLd5ziAFsMKt8sLmhuMCnQ@mail.gmail.com>
Subject: Re: [PATCH] net: sched: keep __gnet_stats_copy_xxx() same semantics
 for percpu stats
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 10:31 PM Dust Li <dust.li@linux.alibaba.com> wrote:
>
> __gnet_stats_copy_basic/queue() support both percpu stat and
> non-percpu stat, but they are handle in a different manner:
> 1. For percpu stat, percpu stats are added to the return value;
> 2. For non-percpu stat, non-percpu stats will overwrite the
>    return value;
> We should keep the same semantics for both type.
>
> This patch makes percpu stats follow non-percpu's manner by
> reset the return bstats before add the percpu bstats to it.
> Also changes the caller in sch_mq.c/sch_mqprio.c to make sure
> they dump the right statistics for percpu qdisc.
>
> One more thing, the sch->q.qlen is not set with nonlock child
> qdisc in mq_dump()/mqprio_dump(), add that.
>
> Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>  net/core/gen_stats.c   |  2 ++
>  net/sched/sch_mq.c     | 34 ++++++++++++++++------------------
>  net/sched/sch_mqprio.c | 35 +++++++++++++++++------------------
>  3 files changed, 35 insertions(+), 36 deletions(-)
>
> diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
> index 1d653fbfcf52..d71af69196c9 100644
> --- a/net/core/gen_stats.c
> +++ b/net/core/gen_stats.c
> @@ -120,6 +120,7 @@ __gnet_stats_copy_basic_cpu(struct gnet_stats_basic_packed *bstats,
>  {
>         int i;
>
> +       memset(bstats, 0, sizeof(*bstats));
>         for_each_possible_cpu(i) {
>                 struct gnet_stats_basic_cpu *bcpu = per_cpu_ptr(cpu, i);
>                 unsigned int start;
> @@ -288,6 +289,7 @@ __gnet_stats_copy_queue_cpu(struct gnet_stats_queue *qstats,
>  {
>         int i;
>
> +       memset(qstats, 0, sizeof(*qstats));


I think its caller is responsible to clear the stats, so you don't need to
clear them here? It looks like you do memset() twice.

Does this patch fix any bug? It looks more like a clean up to me, if so
please mark it for net-next.

Thanks.
