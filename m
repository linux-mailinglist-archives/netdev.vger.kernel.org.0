Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A604A9155
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 00:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356076AbiBCX5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 18:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBCX53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 18:57:29 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534AEC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 15:57:29 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id w81so13799612ybg.12
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 15:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MhizQeomtdW18uugxSCu+0xIa+evezXN+l6ZZnCYm18=;
        b=phOxpv7e0qp22eNXAtMD6xQLtYuEhUHnmLDOOGS7N9mQMhYZMyD8wKCGzuWTscL2mW
         cUNbNran9B92k1troNy/asPx4RbVE7A4DyKcuj2CgFdnHDFj2VWbQP7Lt5aYVEjJwSOn
         jaS+oil5IW2pkc37CkkbPVqYVJ8P8l9LOt+6b6VDuEOIzf2YEacF8AFb/lKOux50Pa5o
         pTbyxa3MNV+1EpgG3GngxV7UasedWjJhqcJ3htwDxSi1lYb3lY4HBMnhQXP6GjeQnL04
         ILgvP3/JRMdFTUemeOX85gnQCBZKD4tnWTBYERbdcOyyFS6ps/XUWqJX4Hou+gXBYhKc
         Aw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MhizQeomtdW18uugxSCu+0xIa+evezXN+l6ZZnCYm18=;
        b=F0MQbnOj/QWBJfZqraL+D+9tf7v3wc4dSOqMSaqjIntlY/zA5k+YPcrpf2KHFe2Bcf
         HQe5v1WkBEAYhbAq72MBgf81KgWwAKL2dNjyAdgX60Isj+Bvn/ytr58zMzn0daRvV8rw
         gRaxy+9nMFU6fOAzY8e/LZno8BO6uN+sfmeQDzh0ykTmJlOo3c2jzfioty2CBxxtB5sV
         EZNEA0/8+Pu+jtBrD9ovpYZsnnpB62itMWpmEvzyr62SdG1J0/Bu7MXUi7oRDAU779ev
         k7thfhVfrQ5r+MQpZp7xwtV5jsQiDyWt3ZaBuuGGWxHm69EVmOku3hLAF4S1LcefA7GG
         VXaw==
X-Gm-Message-State: AOAM531cDBWYyH/sDUnxg+Moyg+CqQx7Gz2LO9seVSbTOEwMXbBoabYO
        hE4yFpd1j88Bx55x+IYuOhSox7gevNVd/g/OzJh9lg==
X-Google-Smtp-Source: ABdhPJwr4fghLXiMwmHCsBspQXUsA5vQ4PsjqzQ7x/jF7iMxfbY6ICK20ZnpUwXpPZ/LRt8S0TNcOwOqDvxwMxbGFLQ=
X-Received: by 2002:a25:d9c2:: with SMTP id q185mr549467ybg.293.1643932648169;
 Thu, 03 Feb 2022 15:57:28 -0800 (PST)
MIME-Version: 1.0
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
 <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com> <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
In-Reply-To: <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 15:57:17 -0800
Message-ID: <CANn89i+4afh3A-5ynOQ4aQf5-G1qJFkbkPPFJnh2BdS3qZ+nyQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed after
 scheduling NAPI
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 3:40 PM Yannick Vignon
<yannick.vignon@oss.nxp.com> wrote:
>
> On 2/3/2022 8:08 PM, Eric Dumazet wrote:
> > On Thu, Feb 3, 2022 at 11:06 AM Yannick Vignon
> > <yannick.vignon@oss.nxp.com> wrote:
> >>
> >> From: Yannick Vignon <yannick.vignon@nxp.com>
> >>
> >> If NAPI was not scheduled from interrupt or softirq,
> >> __raise_softirq_irqoff would mark the softirq pending, but not
> >> wake up ksoftirqd. With force threaded IRQs, this is
> >> compensated by the fact that the interrupt handlers are
> >> protected inside a local_bh_disable()/local_bh_enable()
> >> section, and bh_enable will call do_softirq if needed. With
> >> normal threaded IRQs however, this is no longer the case
> >> (unless the interrupt handler itself calls local_bh_enable()),
> >> whic results in a pending softirq not being handled, and the
> >> following message being printed out from tick-sched.c:
> >> "NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #%02x!!!\n"
> >>
> >> Call raise_softirq_irqoff instead to make sure ksoftirqd is
> >> woken up in such a case, ensuring __napi_schedule, etc behave
> >> normally in more situations than just from an interrupt,
> >> softirq or from within a bh_disable/bh_enable section.
> >>
> >
> > This is buggy. NAPI is called from the right context.
> >
> > Can you provide a stack trace or something, so that the buggy driver
> > can be fixed ?
> >
>
> Maybe some background on how I came to this would be helpful. I have
> been chasing down sources of latencies in processing rx packets on a
> PREEMPT_RT kernel and the stmmac driver. I observed that the main ones
> were bh_dis/en sections, preventing even my high-prio, (force-)threaded
> rx irq from being handled in a timely manner. Given that explicitly
> threaded irq handlers were not enclosed in a bh_dis/en section, and that
> from what I saw the stmmac interrupt handler didn't need such a
> protection anyway, I modified the stmmac driver to request threaded
> interrupts. This worked, safe for that "NOHZ" message: because
> __napi_schedule was now called from a kernel thread context, the softirq
> was no longer triggered.
> (note that the problem solves itself when enabling threaded NAPI)
>
> Is there a rule saying we shouldn't call __napi_schedule from a regular
> kernel thread, and in particular a threaded interrupt handler?

The rule is that you need to be in a safe context before calling
__napi_schedule()

This has been the case for more than a decade.

We are not going to slow down the stack just in case a process context
does not care about BH.

Please check:

commit ec13ee80145ccb95b00e6e610044bbd94a170051
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Wed May 16 10:57:12 2012 +0300

    virtio_net: invoke softirqs after __napi_schedule


>
> >> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
> >> ---
> >>   net/core/dev.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index 1baab07820f6..f93b3173454c 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -4239,7 +4239,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
> >>          }
> >>
> >>          list_add_tail(&napi->poll_list, &sd->poll_list);
> >> -       __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >> +       raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >>   }
> >>
> >>   #ifdef CONFIG_RPS
> >> --
> >> 2.25.1
> >>
>
