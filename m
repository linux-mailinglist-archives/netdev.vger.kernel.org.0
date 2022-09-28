Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8275ED41B
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 07:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiI1FHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 01:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiI1FHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 01:07:21 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B56112FF9
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 22:07:20 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id e187so14595637ybh.10
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 22:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=+isc1sLxHn3DwFKgayxlXL4ZG4XpUmiYqAwUDzUSG0A=;
        b=JDQ6gUKOp503dK4yUfHcAjcdTbw09t4QzjWm24DYX+C0lGhoI9I8HoVft70vSU7ze+
         2cUMrDS1diFB+162AtS29Ycg0I6RJ9FlGEYjPF2pr1xO1HFepH4oj+LZpM/BxoKLVA2E
         WbY2hBn4gYtB9rT/X4y/ItlIJJvC/4CGQHUTDaluscr2oIW2b1TBIc+EfTGVEuK//ynU
         BgUh95NZPhbpiTzx8+o5LyEns2aDewVLntrafEFv+cwQymhQfDnpLPYZTdhLo6vOtn/a
         sapuZ4s1219C7C1loXqijnsXEOIzl755wmA0WdvPIFVQmoFw1++PDnyYHGjHuft2o/ZN
         4hUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+isc1sLxHn3DwFKgayxlXL4ZG4XpUmiYqAwUDzUSG0A=;
        b=JTiFQpARz1j+o/bkuSXXB3v1vJYJMy3X67rrIoFxEA+9XX1m3OMVFbVM00LM09IC6i
         fr3+ksbo780STxgxEwpBNIypRLr0EIQ/Vc34F970ajcx9lQIwCPaBGEr9Bshm/J+Bp+1
         ppi6ttGZaoZqqy2fX5Adk1/9D3dmMNJQkBM9jIAf7YRLnh9QQUvNUHbCY3FUbvz3G78m
         lHslgY+kpAPKJbQxS/ErwR2OQL4BusZUG60h8ixUd2pKcdxCx/bLZfHHxpXlNj3IaG3e
         JaUwRjIZPoQwcBIsBCwtyCCNOb6q9TChpEIdr6QyzPRXDzpUv5R6WkeH2CfrS7ZchWL6
         NRPA==
X-Gm-Message-State: ACrzQf2LSrtVVtqz8C/Zo+Yp/gB5gbJXdGqIwXLLJJRSAcnC9vDqp5+N
        Ey4G3DfcmhvTBlKavSK82RM2LZLZ6pltXn3xDJ0TUg==
X-Google-Smtp-Source: AMsMyM76V3KaxS7oP7gQxDmSLZDwxll/+ccNcTCgTDePtZYgUUT6L3jxJPHy7PPhRJ9+6dfUeQe/JvBpVn7F4n+2hWU=
X-Received: by 2002:a25:3bcd:0:b0:6b3:bb2d:8497 with SMTP id
 i196-20020a253bcd000000b006b3bb2d8497mr29670938yba.598.1664341639460; Tue, 27
 Sep 2022 22:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220927002544.3381205-1-kafai@fb.com> <CANn89iLdDbkFWWPh8tPp71-PNf-FY=DqODhqqQ+iUN+o2=GwYw@mail.gmail.com>
 <6afbe4af-ada1-68df-4561-ca4fb45debaf@linux.dev>
In-Reply-To: <6afbe4af-ada1-68df-4561-ca4fb45debaf@linux.dev>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 27 Sep 2022 22:07:08 -0700
Message-ID: <CANn89iJt4JjfmauHGrxeKGjY84Z1Gt1Feao6NwU9AFfSQRW9eg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Fix incorrect address comparison when
 searching for a bind2 bucket
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
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

On Tue, Sep 27, 2022 at 9:46 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/27/22 8:49 PM, Eric Dumazet wrote:
> > On Mon, Sep 26, 2022 at 5:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >>
> >> From: Martin KaFai Lau <martin.lau@kernel.org>
> >>
> >> The v6_rcv_saddr and rcv_saddr are inside a union in the
> >> 'struct inet_bind2_bucket'.  When searching a bucket by following the
> >> bhash2 hashtable chain, eg. inet_bind2_bucket_match, it is only using
> >> the sk->sk_family and there is no way to check if the inet_bind2_bucket
> >> has a v6 or v4 address in the union.  This leads to an uninit-value
> >> KMSAN report in [0] and also potentially incorrect matches.
> >
> > I do not see the KMSAN report, is it missing from this changelog ?
>
> My bad. Forgot to paste the link in the commit message.  It is here:
>
> https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/

I see, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
