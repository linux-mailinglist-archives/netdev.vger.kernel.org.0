Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73F3520850
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiEIXYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiEIXYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:24:46 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E46438791
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:20:49 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j14so15261585plx.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 16:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UnVJFBU8Of138vQ65R2bL0eo1K3/bVsgAZS6qku60tI=;
        b=AJtZZuGNWIeim9tYrydinTJcadnpuadrHvo3/jrvKul3ho4wIIbCCyQh8vjO6Zru0/
         NjKI3Uk3CBF7aLWJuAUy8e26QelVqXTCCsgTeRd2uOt9JSMcte7JNq5TFPlwerVibmJz
         8P7Li9Y0zqWWKvdAgI71xUxdRbxQ+6x7WsE9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UnVJFBU8Of138vQ65R2bL0eo1K3/bVsgAZS6qku60tI=;
        b=5mh3Hx6vdSih4ZERRln8XbK2ebaBkoXb54peEXm/qMAWXZnw9rQYrFLkcYPhQ210yZ
         FL8QCBhhMo+GuGaiWMviA0kUCCurdjID/bl2t/+9FymYi5isjSLg2x2wZ31df11467gW
         MLq2xIEcC7XXJt/mhnh0+Enbf9SwjglYYfGHfzlJYvvgNQgpN9pE87j3Z6MLI46R7giG
         j25QQX18LyDS06VVAEu79M3Y2EK8KdwX+S5kB/7QjFh4qRXCNcYZDnVYj7zaFbsI/wbF
         tzhmHyn5sMY52JZrzP9tmfovfpXISsj7PK+78bl2ma5rzlHB52Miuo1gB4jFpYLAL1z1
         mb0Q==
X-Gm-Message-State: AOAM531LSkPKvGUmVi8UtjHXOMIdqaBxrFKn4fbAr7xgJc2acBLVCf9Z
        F1w2IrRs4hkzDG3v0CfapVDVzQ==
X-Google-Smtp-Source: ABdhPJynMfb+tc93tdQLTMGm5Ixo9lciJ8d2aWW2d93+SLJsuOsKRBdJy9ZSE7MB5MIhet5n3h2thQ==
X-Received: by 2002:a17:90b:3649:b0:1db:a201:5373 with SMTP id nh9-20020a17090b364900b001dba2015373mr20213858pjb.175.1652138448589;
        Mon, 09 May 2022 16:20:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b24-20020a170902b61800b0015e8d4eb21fsm422736pls.105.2022.05.09.16.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 16:20:48 -0700 (PDT)
Date:   Mon, 9 May 2022 16:20:47 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <202205091614.C55B5D49F@keescook>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com>
 <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
 <20220506185405.527a79d4@kernel.org>
 <202205070026.11B94DF@keescook>
 <CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 07, 2022 at 04:19:06AM -0700, Eric Dumazet wrote:
> On Sat, May 7, 2022 at 12:46 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, May 06, 2022 at 06:54:05PM -0700, Jakub Kicinski wrote:
> > > On Fri, 6 May 2022 17:32:43 -0700 Eric Dumazet wrote:
> > > > On Fri, May 6, 2022 at 3:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > In function ‘fortify_memcpy_chk’,
> > > > >     inlined from ‘mlx5e_sq_xmit_wqe’ at ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:408:5:
> > > > > ../include/linux/fortify-string.h:328:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> > > > >   328 |                         __write_overflow_field(p_size_field, size);
> > > > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Ah, my old friend, inline_hdr.start. Looks a lot like another one I fixed
> > earlier in ad5185735f7d ("net/mlx5e: Avoid field-overflowing memcpy()"):
> >
> >         if (attr->ihs) {
> >                 if (skb_vlan_tag_present(skb)) {
> >                         eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs + VLAN_HLEN);
> >                         mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
> >                         stats->added_vlan_packets++;
> >                 } else {
> >                         eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
> >                         memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
> >                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >                 }
> >                 dseg += wqe_attr->ds_cnt_inl;
> >
> > This is actually two regions, 2 bytes in eseg and everything else in
> > dseg. Splitting the memcpy() will work:
> >
> >         memcpy(eseg->inline_hdr.start, skb->data, sizeof(eseg->inline_hdr.start));
> >         memcpy(dseg, skb->data + sizeof(eseg->inline_hdr.start), ihs - sizeof(eseg->inline_hdr.start));
> >
> > But this begs the question, what is validating that ihs -2 is equal to
> > wqe_attr->ds_cnt_inl * sizeof(*desg) ?
> >
> > And how is wqe bounds checked?
> 
> Look at the definition of struct mlx5i_tx_wqe
> 
> Then mlx5i_sq_calc_wqe_attr() computes the number of ds_cnt  (16 bytes
> granularity)
> units needed.
> 
> Then look at mlx5e_txqsq_get_next_pi()

Thanks! I'll study the paths.

> I doubt a compiler can infer that the driver is correct.

Agreed; this layering visibility is a bit strange to deal with. I'll see
if I can come up with a sane solution that doesn't split the memcpy but
establishes some way to do compile-time (or run-time) bounds checking.
If I can't, I suspect I'll have to create an "unsafe_memcpy" wrapper
that expressly ignores the structure layouts, etc. That's basically what
memcpy() currently is, so it's not a regression from that perspective.
I'd just prefer to find a way to refactor things so that the compiler
can actually help us do the bounds checking.

> Basically this is variable length structure, quite common in NIC
> world, given number of dma descriptor can vary from 1 to XX,
> and variable size of headers. (Typically, fast NIC want to get the
> headers inlined in TX descriptor)

Yup; most of the refactoring patches I've sent for the memcpy bounds
checking have been in networking. :) (But then, also, all the recent
security flaws with memcpy overflows have also been in networking,
so no real surprise, I guess.)

> NIC drivers send millions of packets per second.
> We can not really afford copying each component of a frame one byte at a time.
> 
> The memcpy() here can typically copy IPv6 header (40 bytes) + TCP
> header (up to 60 bytes), plus more headers if encapsulation is added.

Right; I need to make sure this gets fixed without wrecking performance.
:)

-- 
Kees Cook
