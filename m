Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F42D9872
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389657AbfJPR2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:28:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42381 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbfJPR2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:28:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id f14so9569320pgi.9
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 10:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dSyiYDGxQ6l3IKcJPG7eJG7CyAEyKvpSWn4nv1Crkb8=;
        b=C7+/LpcorTCnfDEDsUpz+jRxp2TjQyHhUyGcfbPZ/oJJzOTb/4w9jp/l9vxhQ0LRyZ
         m2PIglyxq7Z1iwx6uZdIctt1dzWeLQ//IaHMxQB232WanSGszvozzpGaFxBlw7uA2kOH
         03o2NLaCrzPVWMMZLCftgZ2uquBX0+n0nuh7N319K1SI56nxY+zEBa/PkwPC+VaN8Apa
         1Mr8L7uir6KYHV67LQQpxVvghk9GG6LfS+7DGlKzzBGQzxY+eGtX3jJ4dEUnH3BvEDbh
         w9Tf8kaS9hWdzGlCOKNw1vv8NWc8MnVmF4C0QeaIyGVpHcvGA7QemXuOCE3Vte1ODD6T
         N1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dSyiYDGxQ6l3IKcJPG7eJG7CyAEyKvpSWn4nv1Crkb8=;
        b=QqDGzgyhw21v+sOBQ0YrX5xmz9WrYDDPAAyltpn1iCYucEvBtGwgbF0fZdHN6q5bMY
         kLw0J/VXzaIfc4K7QxHYoss3tlxoFm7swlv2UvvAY6/IkCTadKG+7HDNEZevXRNo/sIA
         jnx7npaRfB6hHgGitjlHhJ84UL8y47yCpF3XqJrIbK/sYXqer2qCaMpjhhOBFkw4Vxn9
         BdWMmVwJjhYxpw3hcEQ+F1DaNwY0ej9wBZqtL1twWL220RCQPi5x1B2EBYZQPmhnCL8n
         ecFybr1J/avonDMmcTkKtnBHlVT5mCDO7qMtxya6fpL5VywXOB+kkww+q2ajXz/6Fa6U
         +kUg==
X-Gm-Message-State: APjAAAUU2S6pqYcrfzgavBkeypcKZTBPvJg2C7g7NjSEgiGikLubBN1D
        O96qwsU3nZDzU73JE931nwWeLBcbHFzmaZxLOaQ=
X-Google-Smtp-Source: APXvYqy6zaPFJvMkboTlw8wYpmQKvuOrbZVGO/lId2PbN9i+V4xx2NuweD2ptZVFvGdZs8oKdTyEmC/X8B7MRmz1qUg=
X-Received: by 2002:a65:614e:: with SMTP id o14mr45744889pgv.237.1571246895163;
 Wed, 16 Oct 2019 10:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20191011171526.fon5npsxnarpn3qp@linutronix.de>
 <8c3fad79-369a-403d-89fd-e54ab1b03643@cogentembedded.com> <20191016082833.u4jxbiqg3oo6lyue@linutronix.de>
In-Reply-To: <20191016082833.u4jxbiqg3oo6lyue@linutronix.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 16 Oct 2019 10:28:04 -0700
Message-ID: <CAM_iQpXS5Dm-pCAu+7t+9RRauW=q64i6VCQ-Gz6j9_qFMPcOjA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: sched: Avoid using yield() in a busy
 waiting loop
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 1:28 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> From: Marc Kleine-Budde <mkl@pengutronix.de>
>
> With threaded interrupts enabled, the interrupt thread runs as SCHED_RR
> with priority 50. If a user application with a higher priority preempts
> the interrupt thread and tries to shutdown the network interface then it
> will loop forever. The kernel will spin in the loop waiting for the
> device to become idle and the scheduler will never consider the
> interrupt thread because its priority is lower.
>
> Avoid the problem by sleeping for a jiffy giving other tasks,
> including the interrupt thread, a chance to run and make progress.
>
> In the original thread it has been suggested to use wait_event() and
> properly waiting for the state to occur. DaveM explained that this would
> require to add expensive checks in the fast paths of packet processing.
>
> Link: https://lkml.kernel.org/r/1393976987-23555-1-git-send-email-mkl@pen=
gutronix.de

BTW, this link doesn't work, 404 is returned.


> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [bigeasy: Rewrite commit message, add comment, use
>           schedule_timeout_uninterruptible()]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v1=E2=80=A6v2: Typo fixes, noticed by Sergei Shtylyov.
>
>  net/sched/sch_generic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 17bd8f539bc7f..974731b86c20c 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1217,8 +1217,13 @@ void dev_deactivate_many(struct list_head *head)
>
>         /* Wait for outstanding qdisc_run calls. */
>         list_for_each_entry(dev, head, close_list) {
> -               while (some_qdisc_is_busy(dev))
> -                       yield();
> +               while (some_qdisc_is_busy(dev)) {
> +                       /* wait_event() would avoid this sleep-loop but w=
ould
> +                        * require expensive checks in the fast paths of =
packet
> +                        * processing which isn't worth it.
> +                        */
> +                       schedule_timeout_uninterruptible(1);

I am curious why this is uninterruptible?

Thanks.
