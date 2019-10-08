Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E412D0481
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfJHX6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:58:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46447 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfJHX6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:58:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id t3so337712edw.13
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kKkqUTadaQLfNfYS/8MksxMbHTI1S9pbhiAfbmChUJg=;
        b=PO/GCDrClP0vefiAAY6JBSDAqb2fLA7iTVJIFGsxzIvyDldtjzSadAd8VHocLEmFBr
         2yNj5mCryGmmWFKY3aCjNPBAUjc2E2fRInSWpirR3Q+xh4x3O0jg5Bx4AWShJuIdoD7i
         JcxpuiJd7m/hhPpm6BEkZnDr/oyGg0xrD4iZ3b3awTN0809QV8xgq0heJntZGuRTRF5O
         BRXZAcA0k1OFAlqAN8oj7wk1DOJoW6lFxT/KbGjvRsgFiWiknv6mmrjvG+TbnTaNsBbe
         2MF7KJ6Mf3E37DCC//vwgzG034QZrt0th24DT4d1SZReKg+JHuJPDiYM/SE+YgxJ9zoi
         VNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kKkqUTadaQLfNfYS/8MksxMbHTI1S9pbhiAfbmChUJg=;
        b=aQ0FKyC9nrA4wZ7M0j8Y1k2q37Ubm0w5HiGA6Ai1/FSiKWCQ6mW1tKjyu2uxIzP6dP
         b5gejJgzdE9GwB/gvClqtVIJOdN6MRnpXrfbYR9mUny+u4ro0CF6GcFVF0NqHJI6lmqc
         zRtERUKRhWq4rBz8lovmk6/znuIoBjWmjYJOxDE4dYcmtdcSXnnBwIHmWDO9pjUmEZ3z
         nNyBvXmwzX2tS2hTLWa1A2Q9XqEslqALeM9s9KGwOSu3yjhnJG3cUJMFgqBEDJzP8nxy
         RfkAs/g2lLlAHVasdUwsDRkat9n27ZSW8GIBTCrMDlbDRZKnL1VsvKC8ncEnlNeiCOFs
         5qdQ==
X-Gm-Message-State: APjAAAWvn7T9AnhcJujY9mUFt9jS5l/3nEpS2LEQsIOTXeAtsnld2p7G
        l4Yx6n/3RxHmqu9xSMkTkA8l5k3qHYvssID+O8c=
X-Google-Smtp-Source: APXvYqzOnGSzStCPzfWLscZktuhBCfcKxZmyUkyEJ+YvOGNRbpkyCB+0iPLwRo8GQvZ90JATYiWxg9YQq+Uk2SvZYlY=
X-Received: by 2002:aa7:d0d5:: with SMTP id u21mr600754edo.36.1570579131487;
 Tue, 08 Oct 2019 16:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191008232007.16083-1-vinicius.gomes@intel.com>
In-Reply-To: <20191008232007.16083-1-vinicius.gomes@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 9 Oct 2019 02:58:40 +0300
Message-ID: <CA+h21hoc=shDEHSN-SEyO3qS7sBW4GzswcVrHW-7Sud9aP7apA@mail.gmail.com>
Subject: Re: [PATCH net v1] net: taprio: Fix returning EINVAL when configuring
 without flags
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Wed, 9 Oct 2019 at 02:19, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> When configuring a taprio instance if "flags" is not specified (or
> it's zero), taprio currently replies with an "Invalid argument" error.
>
> So, set the return value to zero after we are done with all the
> checks.
>
> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

You mean clockid, not flags, right?
Otherwise the patch looks correct, sorry for the bug.
Once you fix the commit message:

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  net/sched/sch_taprio.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 68b543f85a96..6719a65169d4 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1341,6 +1341,10 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
>                 NL_SET_ERR_MSG(extack, "Specifying a 'clockid' is mandatory");
>                 goto out;
>         }
> +
> +       /* Everything went ok, return success. */
> +       err = 0;
> +
>  out:
>         return err;
>  }
> --
> 2.23.0
>
