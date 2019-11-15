Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8994FE678
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfKOUiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:38:52 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44684 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOUiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:38:52 -0500
Received: by mail-ed1-f68.google.com with SMTP id a67so8458664edf.11;
        Fri, 15 Nov 2019 12:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTcLhwvIMhlqP/s/7QCSwHIRuZ9rOIYUpZfr1zzirzY=;
        b=cvgK/nC3KBowcn7VWNctBq67Zjhrogzf+pKX091gF8wMMklXrkKkxC/qh+L8sjxbkb
         jlzFGtSrgPj4RqO7s2+vYId1X3oV7PbtcRJRsTFxRCN5QpKsxcHGD020t8u3/myjhD6v
         TeNKrw3p8HMXimZkoIZLpkO57Pg0vUvHr7WuVBuk3EjLezIettb6kLUV//ogvqPdHogn
         fcAOW7iyOyPIMtfMA2zIpjqaiGFXAlvPy6etcoeXR9FhZFjk/YlG5oG9rFC5OQEwr0HM
         46yNdS4wj2C9y8Xd2V38RaGcY26nCEsDIdpPok0hiMH2631bTfp+4iN3h9VPKcnGviG0
         X0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTcLhwvIMhlqP/s/7QCSwHIRuZ9rOIYUpZfr1zzirzY=;
        b=EGDlK4Bi5zcoiYmzzaQAI5lPVI8bfBaDQSMzPeS81ETKqnXCJIHtDLxVc97NsVVZ8m
         uiepHI2c9YMGbLSCmaCJcnCLRAjTJFbZ5k1a5iXZGBmmgllLrYxibaQ08e6FZI3UFcMe
         GDIuam2KS9QtOP7ybDz/hfe51/2iSoaSNx39H4I+Ek7DMf1MC8k5Zw4kyzQBxp7yBEbF
         Sl0OtZ53l+uW4Al2H6ZxhhwKU9SRVru4wuN1XON13HH21wCYix1OxrXg47DO0wocN+OY
         XsYWugIHwuTt3L/W/a/9jOxrOWaN6xSXrFxkGdUoaanjfisr3MFIC86MDKpeiNsHV7y8
         Q+BA==
X-Gm-Message-State: APjAAAVcE1zOeQysSdDJrOp4uPpoPR3wAn+ELl9f/wBGTh4uMpPdFgXR
        ux7gCJ3BR++wwGKxTtl855eHVsn6hXI59qF5sKg=
X-Google-Smtp-Source: APXvYqwuAPBsZ0YGDKdBX9FyeN/gNpDmSQGu5aWDAyMALQe7sM9Uq0EyDUVp8RGHG6+jBF6lAntMd8tkd1Xk35ywnQs=
X-Received: by 2002:a17:906:d210:: with SMTP id w16mr3708950ejz.86.1573850328320;
 Fri, 15 Nov 2019 12:38:48 -0800 (PST)
MIME-Version: 1.0
References: <20191115015607.11291-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20191115015607.11291-1-ivan.khoronzhuk@linaro.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 15 Nov 2019 22:38:37 +0200
Message-ID: <CA+h21hq+DfUQOeH30z0r_dhKp6EOwtbgRCAYBRGUmaZOo1BBwQ@mail.gmail.com>
Subject: Re: [net-next PATCH] taprio: don't reject same mqprio settings
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 at 03:58, Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> The taprio qdisc allows to set mqprio setting but only once. In case
> if mqprio settings are provided next time the error is returned as
> it's not allowed to change traffic class mapping in-flignt and that
> is normal. But if configuration is absolutely the same - no need to
> return error. It allows to provide same command couple times,
> changing only base time for instance, or changing only scheds maps,
> but leaving mqprio setting w/o modification. It more corresponds the
> message: "Changing the traffic mapping of a running schedule is not
> supported", so reject mqprio if it's really changed.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>

I would even kindly suggest a tag:
Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")

since the patch is doing nothing but making the tc-taprio command
idempotent, aka running it 10 times in a row produces the same result.
Previously, it would have worked the first time but failed the rest of
9 times, which is catastrophic for any sort of scripted environments.
It should have behaved like this from the beginning.

The problem is that it conflicts trivially with 9c66d1564676 ("taprio:
Add support for hardware offloading"), which made its appearance in
5.4. It's up to you if you want to rebase this on top of 5.4 as well,
for the stable trees.

>  net/sched/sch_taprio.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 7cd68628c637..bd844f2cbf7a 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1347,6 +1347,26 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
>         return err;
>  }
>
> +static int taprio_mqprio_cmp(struct net_device *dev,
> +                            struct tc_mqprio_qopt *mqprio)
> +{
> +       int i;
> +
> +       if (mqprio->num_tc != dev->num_tc)
> +               return -1;
> +
> +       for (i = 0; i < mqprio->num_tc; i++)
> +               if (dev->tc_to_txq[i].count != mqprio->count[i] ||
> +                   dev->tc_to_txq[i].offset != mqprio->offset[i])
> +                       return -1;
> +
> +       for (i = 0; i < TC_BITMASK + 1; i++)

Huh, odd, I wonder what's wrong with <= these days. I do see it's
being used like that in 2 more places in the code, so let's opt for
consistency.

> +               if (dev->prio_tc_map[i] != mqprio->prio_tc_map[i])
> +                       return -1;
> +
> +       return 0;
> +}
> +
>  static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>                          struct netlink_ext_ack *extack)
>  {
> @@ -1398,6 +1418,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>         admin = rcu_dereference(q->admin_sched);
>         rcu_read_unlock();
>
> +       /* no changes - no new mqprio settings */
> +       if (mqprio && !taprio_mqprio_cmp(dev, mqprio))
> +               mqprio = NULL;
> +
>         if (mqprio && (oper || admin)) {
>                 NL_SET_ERR_MSG(extack, "Changing the traffic mapping of a running schedule is not supported");
>                 err = -ENOTSUPP;
> --
> 2.20.1
>
