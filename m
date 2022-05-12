Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CE6525290
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352914AbiELQaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343801AbiELQ37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:29:59 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1502267C0B
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:29:58 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i38so10695760ybj.13
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bvAMmsqUql9MGmQ3k9fwC4TcKC8cDBLoJc8vmz5rS/M=;
        b=SuwyQH2endya0WpJ2CrdYphwTF6WtrbAAD2IRoqr2uCQFWc415hD7b4RFQNHc0OUUu
         hVAzOfbotZ1eHuq39U8XFUVx87D2mRc4hYU2Yt3auBDzsZXBNYMT195baiVhRr5OQ2c9
         5bc0Q7U/Lj0CSVKaqe/TNcgKfYbgd2HsilsQmql05hotP+QAhUceOd6nEGdjHakRhPVc
         wk0EsTW61iuo3Ak/wkPEguN3LTifR5AVL1IEQELQhvU0RnLP0BHOZkeDLnGhUOdBVN+Q
         W3kw/aTiwBMmNtxHLT10Zu+EUAlrxDvVHXuGLwJFKEJjUrMsHcxl945Que8rogE2PfAc
         VAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bvAMmsqUql9MGmQ3k9fwC4TcKC8cDBLoJc8vmz5rS/M=;
        b=alkQ1NGrLu0IHEdiQkNzrIi1aMg50IlAn2Pk1bnyoGmPMYiw4TlZdDPqx4JoJACDCi
         mqWMmGND0Zohk2jS54Ju5b7FoDPGOJScnRTwTmYlMsovXT4CoaEqhwRpxzm4NPm4mA/F
         xUgIHO+h0QXy/uJGXuqROQDSCD4RXrcfG8BVnIxMTgZm+Gz+V5YnBYEzcmOZbKkqflLG
         C3vkVDSnAYkIsEGStzz5CMdJLWOtsKmHnqFeuHkkSd97OXSZSRg13nj/tCir9bkqK77Q
         32Eg5L9YONLAQ3hBMRT1WpLmjgbD6opKgfrEaQM5O9mJER9GDeL5cfIxn2P6i+UeQMhn
         MFfw==
X-Gm-Message-State: AOAM530VlmSRaVJC1bD1J0gDN09gLWwzWDAbJNioG/xyiBdQdGQ8Da8J
        NglPsgqyTnEPlJlDfXRdpKZLjRM4KABKfBT2tcU=
X-Google-Smtp-Source: ABdhPJwxMFWmYg5CXx9cbLUUE/E/a65DRiMnRGoJyGVD7Oe64HojKq0hfjiQCeZW/idepXrrpM81+swuS7Vdv1lIdWM=
X-Received: by 2002:a5b:18d:0:b0:64a:73c1:5225 with SMTP id
 r13-20020a5b018d000000b0064a73c15225mr650793ybl.547.1652372998048; Thu, 12
 May 2022 09:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220512104831.976553-1-eyal.birger@gmail.com> <dca644d9-aee1-9eae-19fb-b134b19827ec@6wind.com>
In-Reply-To: <dca644d9-aee1-9eae-19fb-b134b19827ec@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 12 May 2022 19:29:48 +0300
Message-ID: <CAHsH6GtFfam4j9T0oBOkEjZqOjQu7j1SrGsjb40mrd1pVF0-ag@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: fix "disable_policy" flag use when arriving
 from different devices
To:     nicolas.dichtel@6wind.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 7:09 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
>
> Le 12/05/2022 =C3=A0 12:48, Eyal Birger a =C3=A9crit :
> > In IPv4 setting the "disable_policy" flag on a device means no policy
> > should be enforced for traffic originating from the device. This was
> > implemented by seting the DST_NOPOLICY flag in the dst based on the
> > originating device.
> >
> > However, dsts are cached in nexthops regardless of the originating
> > devices, in which case, the DST_NOPOLICY flag value may be incorrect.
> >
> > Consider the following setup:
> >
> >                      +------------------------------+
> >                      | ROUTER                       |
> >   +-------------+    | +-----------------+          |
> >   | ipsec src   |----|-|ipsec0           |          |
> >   +-------------+    | |disable_policy=3D0 |   +----+ |
> >                      | +-----------------+   |eth1|-|-----
> >   +-------------+    | +-----------------+   +----+ |
> >   | noipsec src |----|-|eth0             |          |
> >   +-------------+    | |disable_policy=3D1 |          |
> >                      | +-----------------+          |
> >                      +------------------------------+
> >
> > Where ROUTER has a default route towards eth1.
> >
> > dst entries for traffic arriving from eth0 would have DST_NOPOLICY
> > and would be cached and therefore can be reused by traffic originating
> > from ipsec0, skipping policy check.
> >
> > Fix by setting a IPSKB_NOPOLICY flag in IPCB and observing it instead
> > of the DST in IN/FWD IPv4 policy checks.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > ---
>
> [snip]
>
> > @@ -1852,8 +1856,7 @@ static int __mkroute_input(struct sk_buff *skb,
> >               }
> >       }
> >
> > -     rth =3D rt_dst_alloc(out_dev->dev, 0, res->type,
> > -                        IN_DEV_ORCONF(in_dev, NOPOLICY),
> > +     rth =3D rt_dst_alloc(out_dev->dev, 0, res->type, no_policy,>     =
                    IN_DEV_ORCONF(out_dev, NOXFRM));
> no_policy / DST_NOPOLICY is still needed in the dst entry after this patc=
h?

I see it's being set in the outbound direction in IPv4 - though I don't see
where it's actually used in that direction.

Maybe it could be cleaned up as a follow up, but I wanted to scope this
patch to the bugfix.

Eyal.
