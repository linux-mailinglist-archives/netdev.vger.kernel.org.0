Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D972F265202
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgIJVGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731146AbgIJOhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:37:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A18C0617B1
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:36:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so7290873ioj.7
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JgPkBBgj99p/Q87OQ6Mz7GbrZ2KsSxwOsslmD2SBkAA=;
        b=sS86pLShXGJO+u/7X+j/JSTVGvfxKiMkBn4sqcabHF/+P2aVAjxZY5mxgUH3NZxpQQ
         qIEc8Hu92WL7tL4k8MEw6YUoh05tayGb5Nmc9sZaAGOjjaq4+p1eDX1GMhy7U7dQY2hr
         zJ6hRsMDXaZ3URpCpT8edF8ojlPsEFxy0xloAPO6zYOvtaDVpeaSZtrNhFbyHx8tzXXX
         sJGR0jsLOabVO7L5Dp+eiNVLLuYdxAvtSApg251stxapjhJt+/OQ5Ai1mWfzlKeDrw1u
         oHq/iFDUVJU2hvfFjovlKatfIhCS/M9R6I1x/IkySKmV3BKg/jH+fJW+rknzlufUy8Vb
         zduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JgPkBBgj99p/Q87OQ6Mz7GbrZ2KsSxwOsslmD2SBkAA=;
        b=eVPyNKavRIT2x1ZvmvoShiiU0qXOu5KSd761FEYHfWozsoBYGYLBx32XD3Q/y1DMAM
         94q8/GWiUKNVZDb+XcbNzE61m4ejbHBNYvLsyUN060N1GWEN+A1X3eHOssY+COzSARZc
         Yv8zA1AuYz78b+Eq7yS+2I/W6faR0Y2mnNyJ6ylAFphcsYYcD3FaNVpaTjtTMTOuEZTV
         D7nIo623p+T8vOfMdgdRjAQ9BaxWDiALiqVlWMEjndxi4N1AKCjhBSPXc6HosebNLh9K
         4PYksrwBuKzMja0+Ow3R0bKh2yXz1GrYow80rElVF8ZQ4EiTJNsJpyQL/SpVSBqJPgpn
         92Dg==
X-Gm-Message-State: AOAM53369Q1c/Ojj38k9u9XJFYuIb1IKZ0srqCeourSXS+z3t8Eumob0
        eKIWEXuJNR90k4GL0es4TO43UafB6wlAh95n625YAdm+Hd6zHQ==
X-Google-Smtp-Source: ABdhPJyugBclama+vyjK7gkJTaECj8HvXDkjyf4eck4h3+1JrmOHFLl0SGxtvt/OnU/esstNQArSK4mhdRoGsArp71I=
X-Received: by 2002:a05:6638:1381:: with SMTP id w1mr9091751jad.34.1599748593207;
 Thu, 10 Sep 2020 07:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <0d64ac9b321104d58270822c204845ccb31368f8.1599747321.git.pabeni@redhat.com>
In-Reply-To: <0d64ac9b321104d58270822c204845ccb31368f8.1599747321.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Sep 2020 16:36:21 +0200
Message-ID: <CANn89iLOJVjsmrefxRvzyiEejhKAstXTWzqiftYH=_hn=irp+g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: try to avoid unneeded backlog flush
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 4:21 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> flush_all_backlogs() may cause deadlock on systems
> running processes with FIFO scheduling policy.
>
> The above is critical in -RT scenarios, where user-space
> specifically ensure no network activity is scheduled on
> the CPU running the mentioned FIFO process, but still get
> stuck.
>
> This commit tries to address the problem checking the
> backlog status on the remote CPUs before scheduling the
> flush operation. If the backlog is empty, we can skip it.

If it is not empty, the problem you want to fix is still there ?

>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/core/dev.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 46 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 152ad3b578de..fdef40bf4b88 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5621,17 +5621,59 @@ static void flush_backlog(struct work_struct *work)
>         local_bh_enable();
>  }
>
> +static bool flush_required(int cpu)
> +{
> +#if IS_ENABLED(CONFIG_RPS)
> +       struct softnet_data *sd = &per_cpu(softnet_data, cpu);
> +       bool do_flush;
> +
> +       local_irq_disable();
> +       rps_lock(sd);
> +
> +       /* as insertion into process_queue happens with the rps lock held,
> +        * process_queue access may race only with dequeue
> +        */
> +       do_flush = !skb_queue_empty(&sd->input_pkt_queue) ||
> +                  !skb_queue_empty_lockless(&sd->process_queue);
> +       rps_unlock(sd);
> +       local_irq_enable();
> +
> +       return do_flush;
> +#endif
> +       /* without RPS we can't safely check input_pkt_queue: during a
> +        * concurrent remote skb_queue_splice() we can detect as empty both
> +        * input_pkt_queue and process_queue even if the latter could end-up
> +        * containing a lot of packets.
> +        */
> +       return true;
> +}
> +
>  static void flush_all_backlogs(void)
>  {
> +       static cpumask_t flush_cpus  = { CPU_BITS_NONE };
>         unsigned int cpu;
>
> +       /* since we are under rtnl lock protection we can use static data
> +        * for the cpumask and avoid allocating on stack the possibly
> +        * large mask
> +        */
> +       ASSERT_RTNL();
> +

OK, but you only set bits in this bitmask.

You probably want to clear it here, not rely on one time CPU_BITS_NONE

>         get_online_cpus();
>
> -       for_each_online_cpu(cpu)
> -               queue_work_on(cpu, system_highpri_wq,
> -                             per_cpu_ptr(&flush_works, cpu));
> +       for_each_online_cpu(cpu) {
> +               if (flush_required(cpu)) {
> +                       queue_work_on(cpu, system_highpri_wq,
> +                                     per_cpu_ptr(&flush_works, cpu));
> +                       cpumask_set_cpu(cpu, &flush_cpus);
> +               }
> +       }
>
> -       for_each_online_cpu(cpu)
> +       /* we can have in flight packet[s] on the cpus we are not flushing,
> +        * synchronize_net() in rollback_registered_many() will take care of
> +        * them
> +        */
> +       for_each_cpu(cpu, &flush_cpus)
>                 flush_work(per_cpu_ptr(&flush_works, cpu));
>



>         put_online_cpus();
> --
> 2.26.2
>
