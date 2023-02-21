Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A81869E07E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbjBUMfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjBUMfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:35:50 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772CE2313C
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:35:49 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l7-20020a05600c1d0700b003dc4050c94aso3037128wms.4
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=boB3QImnWTxd1SIqg7wv/Cf6QMLg6EWt7kIgnReisA8=;
        b=DVivvD/m7YZayhczBWE6676/dMyJqp1+vNYIHHvo04Yagt83bWGSf4bD329CymKx50
         rn60E3hgYG2iv7AYVxitlrWJsP2Rmj3O+cG/kc22XuCQfMuY0jIt5YzbGs2E5ylYI8AT
         FYFju5Z/xI9LYZlcc0hgVd+Nc2mOtyGS0LGiuCV+YJMHO+J64HiEujm+YSHy6RGKGGJq
         /37cifVvgUcBnOHTNkPYYfSbJ5KgA/eg10fkioQ97/sHQYpQM+Yw7Q6WCKle4QlLdRkr
         oCr0yNFdnMtWl9QawT1zPx86o2R7F49BghGw+4LZiUv8Ta5V6oaORz/kVt3n5O392WHP
         aWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=boB3QImnWTxd1SIqg7wv/Cf6QMLg6EWt7kIgnReisA8=;
        b=qp1X6AgKz2hJlj6sOaous83+1gN1TWmB/uL4nAOCL3UjpTsYr3s8ejs3C9Hqq/R1Tq
         BFQHPbFol4Gh70FG1JQTBMNGpr/12sT0cSrg62gwhd2vvfcGbFbBxMBq08Agxd5jx1s0
         8tcTmBvvu5k1rdVYZQW+2rTc9F5/3gjvgZfj/bovXAjDAO52jyKnQBVMjmY0YHs1U2h2
         gfvxvm3qMoHPiGWj22gNdmLpfDVyk8SxcUFdzN2rcRsenQvdBD8jfftQ7YTs3T+U/xGT
         eaLr03R8MRB055gWivTDGnqrilr0IouRXCbdK88GSr6og4VaRf82kJxoGAeF62CdsI0m
         ajvA==
X-Gm-Message-State: AO0yUKXySdnmHGb9VDiQvaS86eR2ak55utG4raYrzGMdC+Kx29bqDOlk
        5xAXwtPEBmwX04oaWpKcv62QaHSL4s9o0GW65rseUw==
X-Google-Smtp-Source: AK7set9nV+EK0TLUdzmV7Dwu03/Rt6FDG/VqUsQnuEfbjE6nlw5NgOvcGE2UwfzJhi0VA0xR7FmDfYru30Rv2bm+cMQ=
X-Received: by 2002:a05:600c:4e44:b0:3df:f862:fe42 with SMTP id
 e4-20020a05600c4e4400b003dff862fe42mr1874542wmq.10.1676982947772; Tue, 21 Feb
 2023 04:35:47 -0800 (PST)
MIME-Version: 1.0
References: <20230221110344.82818-1-kerneljasonxing@gmail.com> <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com>
In-Reply-To: <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Feb 2023 13:35:35 +0100
Message-ID: <CANn89iJjCXfwUQ4XxtCrNFChdCHciBMuWcK=Az4X1acBeqVDiQ@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix memory schedule error
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jason Xing <kerneljasonxing@gmail.com>,
        willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 1:27 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2023-02-21 at 19:03 +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Quoting from the commit 7c80b038d23e ("net: fix sk_wmem_schedule()
> > and sk_rmem_schedule() errors"):
> >
> > "If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
> > we want to allocate 1 byte more (rounded up to one page),
> > instead of 150001"
>
> I'm wondering if this would cause measurable (even small) performance
> regression? Specifically under high packet rate, with BH and user-space
> processing happening on different CPUs.
>
> Could you please provide the relevant performance figures?
>
> Thanks!
>
> Paolo
>

Probably not a big deal.

TCP skb truesize can easily reach 180 KB, but for UDP it's 99% below
or close to a 4K page.

I doubt this change makes any difference for UDP.
