Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84211A5ECD
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 03:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfICBUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 21:20:21 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45175 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfICBUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 21:20:20 -0400
Received: by mail-ed1-f67.google.com with SMTP id f19so2996792eds.12;
        Mon, 02 Sep 2019 18:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r8YPUUF0d88Im2MSWVp9Z/JOWe6kwDxp6YPzU+SjyHg=;
        b=FMvvFFMKS1ZonpEVgVVCgnhfhzSmho1H03hppgHDZ5V9kA+PcZhPyRl7WWIC0ZJwqi
         8fe9MU6N65UYdMEj3vP1UO277huHHf/uKFV1TVqCcNPBrCU172UI3Rtd2PmnYWgVtLuc
         e/Pi7CRiCxbC07HHOp9p/IEXdjIU1LV0KcUdNLjy2fGQ82Hr9z+M3ovWZpITZeLbRhBf
         +dl+cuge5vW06Ujtph9TIBcvMuPVnudvxPhtQXxtQPtQ5MsSt5kMXG2HpXItZFyBmkG9
         Zy7MEO+Qc1vKiK9QxQl0BPrrthcrL1tv6SebQQ6iKHnFaUoqIhmsObfUHBDy6BXwNe77
         9iLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r8YPUUF0d88Im2MSWVp9Z/JOWe6kwDxp6YPzU+SjyHg=;
        b=lo5D1KJjMZXjDHIkDeex36TRLsfQ4x9mV8s3CLPIrKeRYtK1eR8ZNESZkuYJwOxIBL
         lqUNjfo4sonyKuJwhU1vRmckYjwkZvaREPleRSO1Dproav/Rzd69PYg8MfKcgR0tA2AL
         IAk3v5tKWiXOO6G8eHPQC9ynCkIGgVdA1weuDzqkmLZlBtwmaufVsnpFYPjahH24M/Dr
         ytNiZrY06gEKy6l6DgistDoGEEn0GTKTuwM3khsqcRp9BV6EmWmanYeo8vT3ssu4h517
         mRUtnNtGre/NUhW+yYBTtY1PCA4p1AC3ubcFZbZy73L4OumGar2NMkhPiKB6zdekRpvJ
         oPQQ==
X-Gm-Message-State: APjAAAX/dBccMc5hbEGY6Ubi3V9Z+CHkf0zBZ6aSl1vTKrz96tN0sken
        A3dPR0JN/JT7Ga5LnNqOFLiPtbuWXBMm/5vsF4Q=
X-Google-Smtp-Source: APXvYqzdOYk/6sBbZdasEPv/swpy5p4AYKghObh6210BGAUiLYwGONE3rEOLDAXS08KqkU9da4DtDlD5GOIptw1b8+0=
X-Received: by 2002:a17:906:b34a:: with SMTP id cd10mr5454993ejb.300.1567473618872;
 Mon, 02 Sep 2019 18:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190903010817.GA13595@embeddedor>
In-Reply-To: <20190903010817.GA13595@embeddedor>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 3 Sep 2019 04:20:08 +0300
Message-ID: <CA+h21ho16BiOn=kRm-LkDwQR=myff+tJhM5cBR=tW3nzWJZceQ@mail.gmail.com>
Subject: Re: [PATCH] net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Sep 2019 at 04:08, Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
>
> Add suffix LL to constant 1000 in order to avoid a potential integer
> overflow and give the compiler complete information about the proper
> arithmetic to use. Notice that this constant is being used in a context
> that expects an expression of type s64, but it's currently evaluated
> using 32-bit arithmetic.
>
> Addresses-Coverity-ID: 1453459 ("Unintentional integer overflow")
> Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  net/sched/sch_taprio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8d8bc2ec5cd6..956f837436ea 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -966,7 +966,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
>
>  skip:
>         picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
> -                                  speed * 1000 * 1000);
> +                                  speed * 1000LL * 1000);
>
>         atomic64_set(&q->picos_per_byte, picos_per_byte);
>         netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",
> --
> 2.23.0
>
