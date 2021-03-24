Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFB63481CF
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbhCXTVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbhCXTUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 15:20:39 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF71CC061763;
        Wed, 24 Mar 2021 12:20:38 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r17so15353145pgi.0;
        Wed, 24 Mar 2021 12:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BZVkLp1A4sxw0q9/qAve7LfdBGr1kHFGkqnNYCMOOvY=;
        b=IqJtHOh/7Wok2sdGsGQyexiCwo2LiPzH8njBJBvmOzEuJFkmtJfPoI1bXyuM9sjjDI
         j9H8FVxb52RnDc+nRNykq0KVAZveUuGVhcmNdUAzfkVSpAQbp7LuGpfJXhivhnb9bc4I
         FcJUiQ7/n62IsnEkR4eFwMHpqueZO5AWm9P2S3rScnGiOnoilAX+P3fh2bbp5UJnx8sl
         jp553cgCcdGREbdb767Htg6zaPJS2wzoHXF0XhKo6VgEQIjMRcj+kyiFGgdsvai2W/PA
         gA4r3V2rWIt0msFH6BvGLnISctZQK4aAUFln3FGPKglOfY6VMnOOv62htzWSgMS7UFuT
         wV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZVkLp1A4sxw0q9/qAve7LfdBGr1kHFGkqnNYCMOOvY=;
        b=FENA1OcrLLo6jPjzpkrJ4oaiuU/28KeA01owNPrOnd/Tk/vBHQUxb87jbhe2NEZqzr
         udBOQdJN6MitnGZ+Yd94dghy0H+q4dFprHUyHQ9JJLB4AUsMH40Em4Wq1sZrnGOz9eCa
         ZUgI/jZ/uJNh9Dl/IBSEZOU7RHft+brBrhAZlN2maxMxhIXcCfdkQ9gpoha6yrdV2F6J
         DvwVWzNpC/5ICG8zJ8dIfy+Il0aHJmPTXybNZPIXnlYCOg4UoVd29ZPxga+fsd1XJNz2
         YOoJR7f/ZclH5hM1zSxy6UEEJj1+eExFo4gHedPGsk3gWhEwXdXP7PUV8/Rdbx4HTcYU
         pDog==
X-Gm-Message-State: AOAM532PxWs8p30dFu7NQs/viDqV7KqUO+NdOcfZtcsTmp2L24L6Acqm
        dkT9qxUn1ZUfG7eCxdQaBEuYjHo1kYLtrSVPVck=
X-Google-Smtp-Source: ABdhPJzydEFxkIR8JwBYP+8K4cByS8+eH3m+v6+qcSZGQC6tzkKIj6dIANhuknpLazlZvg2yQf9Ay+lNpH5cyTLhRzg=
X-Received: by 2002:a63:db02:: with SMTP id e2mr4359862pgg.18.1616613638397;
 Wed, 24 Mar 2021 12:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <1616552677-39016-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1616552677-39016-1-git-send-email-linyunsheng@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 24 Mar 2021 12:20:27 -0700
Message-ID: <CAM_iQpXAedg31hPx674u4Q4fj0DweADPSn0n_KghgRBWDoOOfw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: sched: fix packet stuck problem for lockless qdisc
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
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 7:24 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> @@ -176,8 +207,23 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>  static inline void qdisc_run_end(struct Qdisc *qdisc)
>  {
>         write_seqcount_end(&qdisc->running);
> -       if (qdisc->flags & TCQ_F_NOLOCK)
> +       if (qdisc->flags & TCQ_F_NOLOCK) {
>                 spin_unlock(&qdisc->seqlock);
> +
> +               /* qdisc_run_end() is protected by RCU lock, and
> +                * qdisc reset will do a synchronize_net() after
> +                * setting __QDISC_STATE_DEACTIVATED, so testing
> +                * the below two bits separately should be fine.

Hmm, why synchronize_net() after setting this bit is fine? It could
still be flipped right after you test RESCHEDULE bit.


> +                * For qdisc_run() in net_tx_action() case, we
> +                * really should provide rcu protection explicitly
> +                * for document purposes or PREEMPT_RCU.
> +                */
> +               if (unlikely(test_bit(__QDISC_STATE_NEED_RESCHEDULE,
> +                                     &qdisc->state) &&
> +                            !test_bit(__QDISC_STATE_DEACTIVATED,
> +                                      &qdisc->state)))

Why do you want to test __QDISC_STATE_DEACTIVATED bit at all?
dev_deactivate_many() will wait for those scheduled but being
deactivated, so what's the problem of scheduling it even with this bit?

Thanks.
