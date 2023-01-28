Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5760967F569
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 08:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjA1HQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 02:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjA1HQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 02:16:03 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9794ED25
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 23:16:02 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-50660e2d2ffso95919937b3.1
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 23:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kZmZuT84cAULJ/LY40DGBxYFR04P706QHnRE/xzs2H8=;
        b=Qr6CoftSYRBDdaBYNF27PMg7qt18/TkVDIGpVWi5/eQUgfi5NgiAgtfnxj+rQ4RcSB
         5mVysS14tJ+rUYz+iutP+Bl2lsFKs8Yq/YheQ0REvM2BRSPwYzJ68bSy49k1zg0O5xYX
         xtzv1mfFJ7sE+bjUZwSMgkULPL1dHVxpoZhmaswKKGpOnvWswqiTLZz/DNTmI+HSZ2xo
         rPFLBKx4wHBEGrbP1z7u54EWK3afAKs7PSxumrQR8lHoq6XZC+ukbkWrKQzQY7Jm76Q5
         GYDlWjRTQaZALr1mcu2Gw6FaIBlBank9/RefW6H8XMy7OjjOwUwgGeZQAzsF41zeWjB9
         HyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZmZuT84cAULJ/LY40DGBxYFR04P706QHnRE/xzs2H8=;
        b=hfaDqfkEbQe6/sBf4W3RWG/Kjg9dMObu8Hcqqu6dEN4+a7OpyS70PU7ZggeC2KxR2t
         D2rkOxdgyHo0C2UyyehWoNC+R0rXw3j5+RlolhrHQKZyMab3H0jQDSo5Abi58Mmy3Tmc
         oWzi6/pK+QfuRu0Yku28lWcfOCpMKm5dN/vjV4gV3kuwG2pEK8cAPEmF/zhtRaMQpBMb
         UsGG00mTvMpmrrPFrhy5Epp/REwAP/jxKyhNq+GI/5zC9z/grYYasO6LvoNGL+hQY6DS
         6FpMRulftRg1aTdQIEDPdc/P7AMtww+/VYsuA54vgfcUA3qGUA9X52khgfC41xXzUmnL
         B4fw==
X-Gm-Message-State: AO0yUKWwQ6MTphpbIAmOH3us79YjeR+aSZ7Mu/Z+EIErOP0wOfX93ygY
        RU3L5pwcXV0uOSUQv5qEZPxrxlBz1DH2OI1u1ZVnQw==
X-Google-Smtp-Source: AK7set9QzkXyPWFxKmXXH18EUv90h+vPUMHxWM4QMabwdPEWq73FHUWvPoohxRDbaTKKduR4eAU2yZtt171lDSWDKpo=
X-Received: by 2002:a81:5757:0:b0:50e:d390:d554 with SMTP id
 l84-20020a815757000000b0050ed390d554mr246646ywb.55.1674890161656; Fri, 27 Jan
 2023 23:16:01 -0800 (PST)
MIME-Version: 1.0
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
 <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com> <20230127212646.4cfeb475@kernel.org>
In-Reply-To: <20230127212646.4cfeb475@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 28 Jan 2023 08:15:50 +0100
Message-ID: <CANn89iL1x=Wis4xDRF=SJ-8_7FebY9y7hvG71gsvUPGXf6xwHA@mail.gmail.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>, nbd@nbd.name,
        davem@davemloft.net, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 28 Jan 2023 10:37:47 +0800 Yunsheng Lin wrote:
> > If we are not allowing gro for the above case, setting NAPI_GRO_CB(p)->flush
> > to 1 in gro_list_prepare() seems to be making more sense so that the above
> > case has the same handling as skb_has_frag_list() handling?
> > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/core/gro.c#L503
> >
> > As it seems to avoid some unnecessary operation according to comment
> > in tcp4_gro_receive():
> > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/ipv4/tcp_offload.c#L322
>
> The frag_list case can be determined with just the input skb.
> For pp_recycle we need to compare input skb's pp_recycle with
> the pp_recycle of the skb already held by GRO.
>
> I'll hold off with applying a bit longer tho, in case Eric
> wants to chime in with an ack or opinion.

Doing the test only if the final step (once all headers have been
verified) seems less costly
for the vast majority of the cases the driver cooks skbs with a
consistent pp_recycle bit ?

So Alex patch seems less expensive to me than adding the check very early.
