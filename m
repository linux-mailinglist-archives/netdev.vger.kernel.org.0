Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA0B38144D
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhENXhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbhENXhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:37:41 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0388C06174A;
        Fri, 14 May 2021 16:36:27 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t30so441726pgl.8;
        Fri, 14 May 2021 16:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZKWayuBzw1qIWpHAk6u5EzDhzn/qca25fe/NfXJXZwc=;
        b=Ai7pYejWps2Pwpju1ozEEbK4dsd3LgQO46Q74hhjEsJEqcLPcpyyE6LgUWvy3wfQW0
         Bn1PBtUvC6wQU8s/TPoB068oGGyYp063JjBy+9UUYwzVyxUOjRjoUJFP7NKrz7dnU/E8
         SQMI4MDAw/z2SK7yuq0D8qsP/pLdFKw56d9Sl4amjcqPiXbHMQgl10MwPRamERoD5hK4
         cO7nPFiK+vl5GEgle0AJa0iW+F22F8f9lTIlrzUwWrSNSbNT5eeIMUOJTPvI+PH9Aqkm
         iF4PxqN69arItmctopnr89QEO3vqjaroF7gnBGyXH/uuXgH337lGDSunxfYKhCvN0Pnq
         Cx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZKWayuBzw1qIWpHAk6u5EzDhzn/qca25fe/NfXJXZwc=;
        b=qrS9aoFnozgKQF2Kys3BDZztwHB0JOAGsfzKGb7WlE5U6fDzBn1dDW35fKKqVTUTjT
         W1nDqAnQINgwW4Ud/G51fcm7l+Wp8CdwbpvlJ+ipvBVdW2DFs9AJ/Z7DwmLXlhNoMWMA
         angtYtUUuxkhuQu9R13bV8sALrRNNVAGHqMViHp7q3GLm4wiTdA+Vpxa+MBbGyLQ5Drp
         0/xb0VuzkC3srDEMyIH/ZPJrz9YzKNpEYED6XEMk0I93luqrxDq96jgFodvazmSUMKbU
         xSUQ4knOgW3/M5t0Zf9GwNeC1sWuSfJNHc5jStuYziEGDi1+g0z6JIly9mHITLQ5waAT
         ladg==
X-Gm-Message-State: AOAM5332rQadVJFrCs2/qyMYJ+c5h1Be1jqmGWZeprxtbxEi/fUetWgG
        xTwhyl+6HtjzILVmJp9DYxF2e5qKiDw1vrxZhIGE2QHqh0k+LgrS
X-Google-Smtp-Source: ABdhPJyxAXTagrwioTz9FkzHOjPJ3eK5MWToIPqNtHCKDwkQW7VFCxXF2tY/hafOFfIKAqy9jJSB8XPiIdDUMrSxHZ4=
X-Received: by 2002:a63:d014:: with SMTP id z20mr48201219pgf.428.1621035387323;
 Fri, 14 May 2021 16:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com> <1620959218-17250-2-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1620959218-17250-2-git-send-email-linyunsheng@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 14 May 2021 16:36:16 -0700
Message-ID: <CAM_iQpXWgYQxf8Ba-D4JQJMPUaR9MBfQFTLFCHWJMVq9PcUWRg@mail.gmail.com>
Subject: Re: [PATCH net v8 1/3] net: sched: fix packet stuck problem for
 lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        bpf <bpf@vger.kernel.org>, Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>, Jike Song <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, atenart@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Hillf Danton <hdanton@sina.com>, jgross@suse.com,
        JKosina@suse.com, Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 7:27 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>  struct qdisc_size_table {
> @@ -159,8 +160,33 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  {
>         if (qdisc->flags & TCQ_F_NOLOCK) {
> +               if (spin_trylock(&qdisc->seqlock))
> +                       goto nolock_empty;
> +
> +               /* If the MISSED flag is set, it means other thread has
> +                * set the MISSED flag before second spin_trylock(), so
> +                * we can return false here to avoid multi cpus doing
> +                * the set_bit() and second spin_trylock() concurrently.
> +                */
> +               if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
> +                       return false;
> +
> +               /* Set the MISSED flag before the second spin_trylock(),
> +                * if the second spin_trylock() return false, it means
> +                * other cpu holding the lock will do dequeuing for us
> +                * or it will see the MISSED flag set after releasing
> +                * lock and reschedule the net_tx_action() to do the
> +                * dequeuing.
> +                */
> +               set_bit(__QDISC_STATE_MISSED, &qdisc->state);
> +
> +               /* Retry again in case other CPU may not see the new flag
> +                * after it releases the lock at the end of qdisc_run_end().
> +                */
>                 if (!spin_trylock(&qdisc->seqlock))
>                         return false;
> +
> +nolock_empty:
>                 WRITE_ONCE(qdisc->empty, false);
>         } else if (qdisc_is_running(qdisc)) {
>                 return false;
> @@ -176,8 +202,15 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>  {
>         write_seqcount_end(&qdisc->running);
> -       if (qdisc->flags & TCQ_F_NOLOCK)
> +       if (qdisc->flags & TCQ_F_NOLOCK) {
>                 spin_unlock(&qdisc->seqlock);
> +
> +               if (unlikely(test_bit(__QDISC_STATE_MISSED,
> +                                     &qdisc->state))) {
> +                       clear_bit(__QDISC_STATE_MISSED, &qdisc->state);


We have test_and_clear_bit() which is atomic, test_bit()+clear_bit()
is not.


> +                       __netif_schedule(qdisc);
> +               }
> +       }
>  }
>
>  static inline bool qdisc_may_bulk(const struct Qdisc *qdisc)
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 44991ea..795d986 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -640,8 +640,10 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>  {
>         struct pfifo_fast_priv *priv = qdisc_priv(qdisc);
>         struct sk_buff *skb = NULL;
> +       bool need_retry = true;
>         int band;
>
> +retry:
>         for (band = 0; band < PFIFO_FAST_BANDS && !skb; band++) {
>                 struct skb_array *q = band2list(priv, band);
>
> @@ -652,6 +654,23 @@ static struct sk_buff *pfifo_fast_dequeue(struct Qdisc *qdisc)
>         }
>         if (likely(skb)) {
>                 qdisc_update_stats_at_dequeue(qdisc, skb);
> +       } else if (need_retry &&
> +                  test_bit(__QDISC_STATE_MISSED, &qdisc->state)) {
> +               /* Delay clearing the STATE_MISSED here to reduce
> +                * the overhead of the second spin_trylock() in
> +                * qdisc_run_begin() and __netif_schedule() calling
> +                * in qdisc_run_end().
> +                */
> +               clear_bit(__QDISC_STATE_MISSED, &qdisc->state);

Ditto.

> +
> +               /* Make sure dequeuing happens after clearing
> +                * STATE_MISSED.
> +                */
> +               smp_mb__after_atomic();
> +
> +               need_retry = false;
> +
> +               goto retry;

Two concurrent pfifo_fast_dequeue() would possibly retry it at the
same time when they test __QDISC_STATE_MISSED at the same
time and get true. Is this a problem?

Also, any reason why you want pfifo_fast to handle a generic
Qdisc flag? IOW, why not handle this logic in, for example,
qdisc_restart()?

Thanks.
