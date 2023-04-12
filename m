Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672E06E0291
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjDLXaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDLXaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:30:11 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144544490
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 16:30:10 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54c12009c30so356921817b3.9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 16:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681342209; x=1683934209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIliBBbuDjDtY2jBrQxfWgWxrKW0lVsS0G4Zt1WCvPc=;
        b=irWUc0FM+eEdV+2UosDLuaprwm9JdRgmCAaNpKEa1rlbCG/OPHdmLlFF1rn9St08tt
         s9XsPZYggeXpGrw25EnOdf4QgrOSXxkD5o046Kyg6TivP3yJZYCPOfHAM57Da+FLxuAE
         fV8TXGom9Yuv3C1CQmahnpdi4CSspjalw5zqdEOLGHYvpM8p/eT9pAQ0wDK2Z4vrf7A7
         nyMkqq/gods+STUoA9SVZhAFbwvty648AlPBlzWNgOePCv4OVn6QS0rmgC2pdHQNXc5D
         eD3tGTvk9KbTWGSs1OmNZiwzUgGCP5uCq+UO9Yr9l7iMDqyKeGPy1DcdhQSsFhSLPrGq
         j0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681342209; x=1683934209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIliBBbuDjDtY2jBrQxfWgWxrKW0lVsS0G4Zt1WCvPc=;
        b=QqJMqWYJlOKKcjC8iFUJQxAvAjSYbo6wAceYXa6NwA6rSb+s8v4onalpuqX6R4koZw
         zd6z4vTeBIjQEzCMEPRHhy9xJI9OkrG+prYidfqOLzQmeXcAiHohTa8BJKlOITuUtgXP
         CnUq/0w1TayMqfNPwzmG0qx4/MXtEz613yCCPGnL/v18DM2NYzgiGR09yt38KEljmcL8
         MJ3qUO/3EUrSStGkXrVgkOqb89JPPsDDOZQ0Kzfv1xwQ5xTpMAkeuuPyTj0ZaYOWq2nt
         iy4gvqFcOl6Ff1oSMBgAfkHnezhdwoKuvBiZMfeFqIqFNnQt1p6WZfO+ykr2XWkYD1me
         eSpA==
X-Gm-Message-State: AAQBX9ez82phVbMEjJtvbKEMeXZQLLB19qUB81k30f5YaotQsBuQkn/Q
        qm3tdFaz7Dr9VtWFw51XGflOqTrcKty+7nvYbV0=
X-Google-Smtp-Source: AKy350bVpkZBR5HmtWoKcLSweLy3fDzH6t5m0nUBRL8Y943+Qlgil6FHNblnP7Xg+AX3qIfjkM9aFrfkmcU7YcyyuqA=
X-Received: by 2002:a81:ad0e:0:b0:544:cd0e:2f80 with SMTP id
 l14-20020a81ad0e000000b00544cd0e2f80mr143490ywh.8.1681342209154; Wed, 12 Apr
 2023 16:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230325172828.24923-1-witu@nvidia.com> <1ef142e0-43dc-8f18-e67b-2020af37fd17@intel.com>
In-Reply-To: <1ef142e0-43dc-8f18-e67b-2020af37fd17@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 12 Apr 2023 16:29:32 -0700
Message-ID: <CALDO+Sac1_QnZgBo6SoyCrEY5-VG-rGXuutVY5GJrgxXRSsHkA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v19] vmxnet3: Add XDP support.
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        alexandr.lobakin@intel.com, bang@vmware.com,
        maciej.fijalkowski@intel.com, witu@nvidia.com,
        horatiu.vultur@microchip.com, error27@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Sorry for my late reply and thanks for taking another round of review!

On Fri, Mar 31, 2023 at 8:43=E2=80=AFAM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: William Tu <u9012063@gmail.com>
> Date: Sat, 25 Mar 2023 10:28:28 -0700
>
> Sorry for the late reply, I've been busy :s
>
> > From: William Tu <u9012063@gmail.com>
> >
> > The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIREC=
T.
> >
> > Background:
>
> [...]
>
> > +static int
> > +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp,
> > +             struct bpf_prog *prog)
> > +{
> > +     struct xdp_frame *xdpf;
> > +     struct page *page;
> > +     int err;
> > +     u32 act;
> > +
> > +     act =3D bpf_prog_run_xdp(prog, xdp);
> > +     rq->stats.xdp_packets++;
>
> I think you can increment it *before* running the program, so that
> there'll be as tiny time gap as possible.

Good idea, will do it.

>
> > +     page =3D virt_to_page(xdp->data_hard_start);
>
> You don't need it for PASS and REDIRECT.
>
> > +
> > +     switch (act) {
> > +     case XDP_PASS:
> > +             return act;
> > +     case XDP_REDIRECT:
> > +             err =3D xdp_do_redirect(rq->adapter->netdev, xdp, prog);
> > +             if (!err)
> > +                     rq->stats.xdp_redirects++;
> > +             else
> > +                     rq->stats.xdp_drops++;
>
> BTW, if you get @err here, shouldn't you recycle the page, just like in
> TX case?

Yes, will fix it.

>
> > +             return act;
> > +     case XDP_TX:
> > +             xdpf =3D xdp_convert_buff_to_frame(xdp);
> > +             if (unlikely(!xdpf ||
> > +                          vmxnet3_xdp_xmit_back(rq->adapter, xdpf))) {
> > +                     rq->stats.xdp_drops++;
> > +                     page_pool_recycle_direct(rq->page_pool, page);
> > +             } else {
> > +                     rq->stats.xdp_tx++;
> > +             }
> > +             return act;
> > +     default:
> > +             bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, ac=
t);
> > +             fallthrough;
> > +     case XDP_ABORTED:
> > +             trace_xdp_exception(rq->adapter->netdev, prog, act);
> > +             rq->stats.xdp_aborted++;
> > +             break;
> > +     case XDP_DROP:
> > +             rq->stats.xdp_drops++;
> > +             break;
> > +     }
> > +
> > +     page_pool_recycle_direct(rq->page_pool, page);
> > +
> > +     return act;
> > +}
>
> [...]
>
> > +     xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&xdp, page_address(page), rq->page_pool->p.offse=
t,
> > +                      len, false);
> > +     xdp_buff_clear_frags_flag(&xdp);
> > +
> > +     /* Must copy the data because it's at dataring. */
> > +     memcpy(xdp.data, data, len);
> > +
> > +     rcu_read_lock();
>
> Where's the corresponding unlock?
I should remove this rcu_read_lock. A mistake in v16
    - remove using rcu_read_lock,unlock around XDP invocation
      https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/
>
> > +     xdp_prog =3D rcu_dereference(rq->adapter->xdp_bpf_prog);
> > +     if (!xdp_prog) {
> > +             act =3D XDP_PASS;
> > +             goto out_skb;
> > +     }
> > +     act =3D vmxnet3_run_xdp(rq, &xdp, xdp_prog);
> > +
> > +     if (act =3D=3D XDP_PASS) {
> > +out_skb:
> > +             *skb_xdp_pass =3D vmxnet3_build_skb(rq, page, &xdp);
> > +             if (!*skb_xdp_pass)
> > +                     return XDP_DROP;
> > +     }
> > +
> > +     /* No need to refill. */
> > +     return act;
>
> Maybe
>
>         act =3D vmxnet3_run_xdp(rq, &xdp, xdp_prog);
>         if (act !=3D XDP_PASS)
>                 return act;
>
> out_skb:
>         *skb_xdp_pass =3D vmxnet3_build_skb(rq, page, &xdp);
>
>         return likely(*skb_xdp_pass) ? act : XDP_DROP;

it does look simpler, will use this.

thanks
William
