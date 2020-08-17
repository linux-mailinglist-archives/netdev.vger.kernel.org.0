Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58653245C5B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 08:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHQGSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 02:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHQGSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 02:18:06 -0400
Received: from coco.lan (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 777BC2072D;
        Mon, 17 Aug 2020 06:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597645085;
        bh=bCo9S69xJPTgREOBEaxrTqK2XsGl+pA07/LQTF8hF9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XBQbDlHh0KLndVf/A5G/HMzqZxMFRyA8lmLWJCSIAhrrGR3CwiIaMvtopKeG62OJW
         +8hZahNYhNaX695y02ylJe2fxG1Q8/OpXfqmq8PwtzQ4CTL+oU7yV/Wyu5S97a6lHG
         BEenRTTvzler/slfGt1SQ8Ug6Hbg0p9EBTCMZTpE=
Date:   Mon, 17 Aug 2020 08:17:51 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Michael Turquette <mturquette@baylibre.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] clk: clk-hi3670: Add CLK_IGNORE_UNUSED flag
Message-ID: <20200817081751.221ef469@coco.lan>
In-Reply-To: <159754521196.2423498.12327214866049224014@swboyd.mtv.corp.google.com>
References: <3d575cb4b8016d70efc219bc37e56017cf045c1d.1597414570.git.mchehab+huawei@kernel.org>
        <159754521196.2423498.12327214866049224014@swboyd.mtv.corp.google.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, 15 Aug 2020 19:33:31 -0700
Stephen Boyd <sboyd@kernel.org> escreveu:

> Please send patches To: somebody. Sending them to nobody causes my MUA
> pain.

Ok. Should I send it to you or to someone else?
> 
> Quoting Mauro Carvalho Chehab (2020-08-14 07:16:20)
> > There are several clocks that are required for Kirin 970 to
> > work. Without them, the system hangs. However, most of
> > the clocks defined at clk-hi3670 aren't specified on its
> > device tree, nor at Hikey 970 one.
> > 
> > A few of them are defined at the Linaro's official tree
> > for Hikey 970, but, even there, distros use
> > 
> >         clk_ignore_unused=true
> > 
> > as a boot option.
> > 
> > So, instead, let's modify the driver to use CLK_IGNORE_UNUSED
> > flags, removing the need for this boot parameter.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >  drivers/clk/hisilicon/clk-hi3670.c | 731 +++++++++++++++++------------
> >  1 file changed, 425 insertions(+), 306 deletions(-)  
> 
> This is very many. Are all of these clks actually enabled out of boot
> and are getting turned off at late init?

That's a very good question. Unfortunately, I don't know.

There are some documentation at:
	https://www.96boards.org/documentation/consumer/hikey/hikey970/hardware-docs/

Including schematics for HiKey 970, but it doesn't seem to show all
the clock lines, plus the clock names at the driver don't seem to match
what's there at the datasheet.

> Is there some set of clks that can be marked as CLK_IS_CRITICAL instead?

Maybe, but identifying those would require a huge amount of work. See,
this patch marks 306 clock lines with CLK_IGNORE_UNUSED:

	$ git grep CLK_IGNORE_UNUSED drivers/clk/hisilicon/clk-hi3670.c|wc -l
	306

At vanilla Kernel 5.8, there are 49 known clock lines:

	$ git grep -E 'HI\S+CLK' arch/arm64/boot/dts/hisilicon/*70*|wc -l
	49

As I'm porting several drivers in order to support DRM and hopefully USB,
this count should increase as drivers get merged.

At downstream 4.9 Kernel, there are 99 known clock lines:

	$ git grep -E 'KI\S+CLK' arch/arm64/boot/dts/hisilicon/*70*|wc -l
	99

In other words, there are still 207 lines that we have no clue about
them. What among those are critical or not is a very good question.


> The CLK_IGNORE_UNUSED flag shouldn't be used very much at all. Instead,
> drivers should be using the CLK_IS_CRITICAL flag. We have a lot of
> CLK_IGNORE_UNUSED in the kernel right now, but the hope is that we can
> get rid of this flag one day.

I see the point. Yet, I can't see any solution for that, except not letting 
PM to disable unused clocks on this chipset. See, the only way to use the
HiKey 970 board (which is the only one with DT bindings upstream for this
chipset) is to boot the Kernel with clk_ignore_unused=true.

Ok, if someone has enough time and some robot infrastructure that would
automatically be patching the driver, detect broken boots, and powering
down/up the device after each attempt, he could be disabling each one of 
the clock lines that are not specified at the DT, identifying the
critical ones.

Then, he may need to port more drivers, together with their DT bindings,
from the downstream tree.

That is a lot of work for, IMHO, not much gain.

Thanks,
Mauro
