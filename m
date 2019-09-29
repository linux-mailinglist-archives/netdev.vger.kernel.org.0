Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C36C19C3
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 01:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbfI2X0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 19:26:34 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37606 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfI2X0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 19:26:33 -0400
Received: by mail-ed1-f65.google.com with SMTP id r4so6980612edy.4
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 16:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIDZn9qtY+/S9QGSvK1L7MekFL20rU/xE5sMwveQveI=;
        b=ZbdlkfUwgo5/AcJW6z0EA1wMWl4ZyxD87Nd0HjhWTiZ5W3LT/YcLMexVD6fMfUL03i
         8F5IQQLlEfpIEBsEbM6VOweRwKUQmAHM7ESbsD6UYu55BbvTNq+5AWUdsUgsXjCWGoMp
         dhdhwsu6UFKVa8KuPEPmvklQtuo2RynioTSWjx9PgzuXgApmprDIBuv45mcaz3UfVk6n
         jhhzcMsOpujpOkelCFS5EMOEi6VTL8odIY4p2ZO2Wi4J/+KRV4F5DP3k+Dr4j2FFtpqP
         t6NzbWrxihS5co9cx7W8R4MCIH3/3TXnG8mspljjegzcQgIzSA2/nWxrHG7nbJGLsamh
         U67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIDZn9qtY+/S9QGSvK1L7MekFL20rU/xE5sMwveQveI=;
        b=JI1ipg1GrKeVh2xmj9rXtmXvVoxdIi/nhads4bigz0bjzXDlgAOYqpmuyBQxJFU7Ha
         Da7E2iQG1hnWbaE+3PES/JGAR0Erj24zjvqEhcWKSh/hiug1QyfJJLVdMr6XLW+D/6Vq
         rD9HZjlWdbKw5VDLmHou/VS5wBXq0nnx5GmxXn5/XVhFJ6knqvNLSGPc8LybdxPLjtyQ
         93OwuzAMR4jXRq0Q5dkVnSRx4xmpFHcAKnzi6NA+5s6xj5CON2XyM30Fltd8XIUlHCsa
         1rk/i6ajiy2PiibKKGj1OIF5R34PKdyiEorebWlhEW0+PQelifHwSOw5V5vSgBQGT9Sz
         kKYg==
X-Gm-Message-State: APjAAAX9VxNq28PBjXeE8Mrovbl7rfLM0M+X7JyV9bnnRJG5AFqt7US+
        /gUB6046MDTIaqOuChyqHdGjvd9Hc3D087MCAXw=
X-Google-Smtp-Source: APXvYqyNYp17Aq1B8JkfaIEHZ38+1+6p511wuzyP82fpHCsy9Ycg6vw2YSdjwX9UZvv4p9NBf0eHoPzEq18Arb2Qcxg=
X-Received: by 2002:a17:906:1c03:: with SMTP id k3mr16714497ejg.32.1569799591962;
 Sun, 29 Sep 2019 16:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <71354431.m7NQiGp1Tu@minako>
In-Reply-To: <71354431.m7NQiGp1Tu@minako>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 30 Sep 2019 02:26:21 +0300
Message-ID: <CA+h21hqm9jaKu4PgzkgcgMyu5gEMLSVmL=9sti1X88EOWNakuQ@mail.gmail.com>
Subject: Re: Regression: Network link not coming up after suspend/resume cycle
To:     Jan Janssen <medhefgo@web.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Vedang Patel <vedang.patel@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jan,

On Sun, 29 Sep 2019 at 22:25, Jan Janssen <medhefgo@web.de> wrote:
>
> Hi,
>
> I've been noticing lately that my network link sometimes does not go up
> after a suspend resume cycle (roughly 1 or 2 out of 10 times). This also
> sometimes happens with a fresh boot too. Doing a manual
> "ip link set down/up" cycle resolves this issue.
>
> I was able to bisect it to the commit below (or hope so) and also CCed
> the maintainer for my driver too.
>
> This is happening on a up-to-date Arch Linux system with a Intel I219-V.
>
> Jan
>
>
>
> 7ede7b03484bbb035aa5be98c45a40cfabdc0738 is the first bad commit
> commit 7ede7b03484bbb035aa5be98c45a40cfabdc0738
> Author: Vedang Patel <vedang.patel@intel.com>
> Date:   Tue Jun 25 15:07:18 2019 -0700
>
> taprio: make clock reference conversions easier
>
> Later in this series we will need to transform from
> CLOCK_MONOTONIC (used in TCP) to the clock reference used in TAPRIO.
>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> net/sched/sch_taprio.c | 30 ++++++++++++++++++++++--------
> 1 file changed, 22 insertions(+), 8 deletions(-)
>
>
>

That is a mechanical patch that produces no behavior change.
Furthermore, even if distributions were to build with
CONFIG_NET_SCH_TAPRIO (which there aren't many reasons to), it is
extremely likely that this qdisc is not enabled by default on your
interface. Are you voluntarily using taprio?
You might need to bisect again.

Regards,
-Vladimir
