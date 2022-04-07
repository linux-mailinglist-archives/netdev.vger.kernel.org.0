Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B014F72BE
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 05:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiDGDQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 23:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239821AbiDGDQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 23:16:30 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A09433A4
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 20:14:31 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id o62so7417768ybo.2
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 20:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eyP+RccwmIDSP7TYhhVEn4mD7lxVyq/B4jZG854998I=;
        b=jgK6XP3Qtr/7e4JJOHYqyMJvf4DXiejCFQechuXmYuV4EuwrfIAozTTQz5Yxe44IcL
         wFYFFb7w/v28smQa39W3NMcprczSTijgrpDnlfOTUtwyHkMpPpdHVV/77iqhP3AjhdGI
         ySNNKjPnxj5Xz5E3tcu/w4a3GmbkUpIZytjNHtYm959e32xHeDYrvjKSbNa9LdmJrJpq
         c4afZ/e4VOIiOuKmm52FzXh68rxMd9+pA+xmVK40t2aUaRXlBTFztCHxEiRfVA2vMTZa
         llnndti5KmGaUf0V3qJHSB6wHTxjV+ntJWNWua68RtMpxCXDwLQa6e8ieb6LmUvN7xwl
         5qzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eyP+RccwmIDSP7TYhhVEn4mD7lxVyq/B4jZG854998I=;
        b=ZQhqIqo3Nky8vkK4i1EJiO/uIE5tNCQ27rZHzU2g/ANwbTvI1h5sOnjtCwx4W8cNB/
         k1MTFNGLPx5R7P5wlIyE0VZg2djdH3VmGfEzN/b1EgigCFEQ5NYc1n1tK9CbbWIetOu8
         sjS/tCWHVa/I6GpUbrOgIz20FzObCM2MgwtriHdZUMClwFUBbLOxXFxQ6ZnciKP2ilkm
         Jhya673N7LBMW+jdZ2x19bx1kDh76arPRwDHe4AoGir4Hc9WZlKx0F72Ay10lnHDMrlA
         SQ2iCr1ImFHDCNaJqq3GL75bLwuDKMvFLpUFIi9EvHSvyQ+B0ph3kxpaPHFQtDXRdFHW
         XMAQ==
X-Gm-Message-State: AOAM530jQ129YA1/ISrv2LahEabuuVcXjn7dU0LHIFYpltWM2uciFUJo
        53WtktRgOZ/xUMk/0sI1bkJT/rIqu37PpiQTHBrnL5gWtdEEHw7M
X-Google-Smtp-Source: ABdhPJw9KesE+jVwTKHtF1QPgOLo2KiaW3kvRm6pHcJ4zj8CA1r3iwpGcMD5xSVKlaL+7BXiFHA4CCW/wrutIWrXeFY=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr8771646ybe.598.1649301270716; Wed, 06
 Apr 2022 20:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220406114807.1803-1-lianglixue@greatwall.com.cn>
 <CANn89iK+GSrShunMPA5g12O36CofeUso1C9Ce3daFowkntScPg@mail.gmail.com> <6BE2E6E4-F6D0-4CB4-96ED-F1D1931D62CE@gmail.com>
In-Reply-To: <6BE2E6E4-F6D0-4CB4-96ED-F1D1931D62CE@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Apr 2022 20:14:19 -0700
Message-ID: <CANn89iLzm3UhzXP+R5cwVnwvSYic2EzKQui9tgJyji-SQh+MPQ@mail.gmail.com>
Subject: Re: [PATCH] af_packet: fix efficiency issues in packet_read_pending
To:     lixue liang <lixue.liang5086@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, rsanger@wand.net.nz,
        Yajun Deng <yajun.deng@linux.dev>,
        jiapeng.chong@linux.alibaba.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 8:02 PM lixue liang <lixue.liang5086@gmail.com> wrot=
e:
>
> Hi, Eric Dumazet.The pending_refcnt will indeed increase and decrease on =
different cpus,
> but the caller of packet_read_pending in af_packet.c only needs to determ=
ine whether there is
> a pending packet, not the sum of pending packets on each cpu .
>
> In the numa of 128 cpus, if the maximum distance of node is 100 (numactl =
-H, the result is as shown below),
> even if the first cpu has a pending packet, the packet_read_pending of tp=
acket_destruct_skb still needs to
> additionally traverse the remaining 127 cpus the pending packet, which le=
ads to additional consumption
> of more cpu time, and the return refcnt of packet_read_pending is the sum=
 of the pending packets that the
> caller does not need.
>
> please correct me, thanks.

Please do not send HTML messages, they won't be delivered to the list.

No, the intent of the code is to sum all cpu variables.

Your change basically will break many cases, as I explained.

If for some reason CPU 0 did a single packet_inc_pending() but the
corresponding packet_dec_pending() happened on CPU 1,
we do not want  packet_read_pending() to return 1, but 0.


If having per-cpu variable is too costly, we need to revisit the whole thin=
g.

(ie possibly revert b013840810c221f2b0cf641d01531526052dc1fb packet:
use percpu mmap tx frame pending refcount)

>
>
>
> 2022=E5=B9=B44=E6=9C=886=E6=97=A5 23:20=EF=BC=8CEric Dumazet <edumazet@go=
ogle.com> =E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Apr 6, 2022 at 4:49 AM lianglixue <lixue.liang5086@gmail.com> wro=
te:
>
>
> In packet_read_pengding, even if the pending_refcnt of the first CPU
> is not 0, the pending_refcnt of all CPUs will be traversed,
> and the long delay of cross-cpu access in NUMA significantly reduces
> the performance of packet sending; especially in tpacket_destruct_skb.
>
> When pending_refcnt is not 0, it returns without counting the number of
> all pending packets, which significantly reduces the traversal time.
>
>
> Can you describe the use case ?
>
> You are changing the slow path.
>
> Perhaps you do not use the interface in the most efficient way.
>
> Your patch is wrong, pending_refcnt increments and decrements can
> happen on different cpus.
>
>
>
> Signed-off-by: lianglixue <lianglixue@greatwall.com.cn>
> ---
> net/packet/af_packet.c | 9 +++++----
> 1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index c39c09899fd0..c04f49e44a33 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1210,17 +1210,18 @@ static void packet_dec_pending(struct packet_ring=
_buffer *rb)
>
> static unsigned int packet_read_pending(const struct packet_ring_buffer *=
rb)
> {
> -       unsigned int refcnt =3D 0;
>        int cpu;
>
>        /* We don't use pending refcount in rx_ring. */
>        if (rb->pending_refcnt =3D=3D NULL)
>                return 0;
>
> -       for_each_possible_cpu(cpu)
> -               refcnt +=3D *per_cpu_ptr(rb->pending_refcnt, cpu);
> +       for_each_possible_cpu(cpu) {
> +               if (*per_cpu_ptr(rb->pending_refcnt, cpu) !=3D 0)
> +                       return 1;
> +       }
>
> -       return refcnt;
> +       return 0;
> }
>
> static int packet_alloc_pending(struct packet_sock *po)
> --
> 2.27.0
>
>
