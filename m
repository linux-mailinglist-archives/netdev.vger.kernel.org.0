Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90908D51F6
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 21:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfJLTOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 15:14:22 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42590 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbfJLTOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 15:14:22 -0400
Received: by mail-lf1-f66.google.com with SMTP id c195so9201427lfg.9
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 12:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KUGTurWlShM/Pg1VeuI9jhdTqsInLXd4qSQf6ODKVnw=;
        b=mp43YZqkwt7hlye6iMOy9MUbkW1cOVi58mwFTOgGi1dbH42yxnHB7b4eYKsQFzDoxd
         tMKa/1ar1offKcAPfuO+ZjTCU0NJsClEN9RylnUUE+9bk9M2rd73j8+0v8yGB8/Gki1+
         kOxQgmn2YyBCoP0hrBWQLoByHwWxdwyncEpTMbonzbLd0xgoZ7zfT8A1uRYPhxSlALWZ
         2MT2+1xJPBuA9OufcgTi5lVDE95Wrg0rSPQgiOHEucqfkoKr2lVno3CQUAYaXwGaYIUM
         N7gsU8DvcMEnwrV5nICAHWb0U/fEKzO3S1GVdQk8+454FuICrs9ycLE02UdwNkHTfYBE
         q+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KUGTurWlShM/Pg1VeuI9jhdTqsInLXd4qSQf6ODKVnw=;
        b=JPea4OAkc3qmHk/Rcj4Dm4PMejNWI/4VSqQNezpkZYD3VYBhzNUtBp0y2zpEKJny0M
         OInJukUoBeoQ3HVyViO+QZgk7DuaTL5RnKzj/Cr9uS9OU44qBXLfNe3A1dzD1dAI/+eN
         Z1trhemYY5jJKj0epiUXJrltrc+MTQIBIlStIu0LVCaASwpZl0TDgiMa/2VNYR+EaxEs
         cdimRhb9y78rd4ay1Qrdph/GRQRfWhy2N/gDBkrv5GUtb4GLvdJbLIaCrXRJ5ceyTi6V
         2t9gJip4DlX8i5lI5YCiQ8eJUQ/Gv4HVeVQ/KIRaQA5sz+iCIXzxE9VMaesACmKMmoIk
         shyg==
X-Gm-Message-State: APjAAAWb5jmyt7KLxBylXpI4TMU3snUJoKR647Q8UeSINcHfgeY/5Jcq
        HEpUimtJinMDWkBT1e95dz+RQg==
X-Google-Smtp-Source: APXvYqzz/RCVgIEpRFWXgpM9uWYP5GRcFJdXio/dX7ET+g6mVk4gkHgqktjlqK7nIqA7VNbdhqvNkw==
X-Received: by 2002:ac2:4c83:: with SMTP id d3mr12176485lfl.102.1570907660260;
        Sat, 12 Oct 2019 12:14:20 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:42ce:cb54:d810:b267:5380:ba01])
        by smtp.gmail.com with ESMTPSA id j5sm2930146lfj.77.2019.10.12.12.14.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Oct 2019 12:14:19 -0700 (PDT)
Subject: Re: [PATCH net-next] net: sched: Avoid using yield() in a busy
 waiting loop
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>, tglx@linutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <8c3fad79-369a-403d-89fd-e54ab1b03643@cogentembedded.com>
Date:   Sat, 12 Oct 2019 22:14:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10/11/2019 08:15 PM, Sebastian Andrzej Siewior wrote:

> From: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> With threaded interrupts enabled, the interrupt thread runs as SCHED_RR
> with priority 50. If a user application with a higher priority preempts
> the interrupt thread and tries to shutdown the network interface then it
> will loop forever. The kernel will spin in the loop waiting for the
> device to become idle and the scheduler will never consider the
> interrupt thread because its priority is lower.
> 
> Avoid the problem by using by sleeping for a jiffy giving other tasks,

   So "using" or "sleeping"? :-)

> including the interrupt thread, a chance to run and make progress.
> 
> In the original thread it has been suggested to use wait_event() and
> properly waiting for the state to occur. DaveM explained that this would
> require to add expensive checks in the fast paths of packet processing.
> 
> Link: https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [bigeasy: Rewrite commit message, add comment, use
>           schedule_timeout_uninterruptible()]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> The old thread also pointed anoth yield() loop which was resolved by
> commit
>    845704a535e9b ("tcp: avoid looping in tcp_send_fin()")
> 
>  net/sched/sch_generic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 17bd8f539bc7f..b27574f2c6b47 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1217,8 +1217,13 @@ void dev_deactivate_many(struct list_head *head)
>  
>  	/* Wait for outstanding qdisc_run calls. */
>  	list_for_each_entry(dev, head, close_list) {
> -		while (some_qdisc_is_busy(dev))
> -			yield();
> +		while (some_qdisc_is_busy(dev)) {
> +			/* wait_event() would avoid this sleep-loop but would
> +			 * require expesive checks in the fast paths of packet

   Expensive?

> +			 * processing which isn't worth it.
> +			 */
> +			schedule_timeout_uninterruptible(1);
> +		}
>  		/* The new qdisc is assigned at this point so we can safely
>  		 * unwind stale skb lists and qdisc statistics
>  		 */

MBR, Sergei
