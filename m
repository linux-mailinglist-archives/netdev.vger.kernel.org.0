Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B6E649527
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 18:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiLKRFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 12:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLKRFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 12:05:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D652BD3
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 09:04:59 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gt4so7976407pjb.1
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 09:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiPM/BRwebzkgBF18G5ZPRXMBq5fC3tN6A1lbz1/cvs=;
        b=r9NfusOGXcoeuDHYRxnkdlbWANyiTpT3vvKTAjLPUi8ZdSVGGwhnVJ8lweaB4pQp0o
         rbPGNKBAuZmLKt6cj+sUZPnoYu8eSNC5mqD2GVjGp1iy9/K3qrDGqqCFxsevQmt6wy3y
         3iGGX7/PrpiPmGTFx/IQZk8A8opFwf+CaJiyhR5itr04qV6If188cKxu5STAjqVeTORl
         Yx9t3qLS2tP94/z8VezlE79EVRMwtxayoJxDlsaru91WL2NUoKQB8GyzmjzeF6V+5EhX
         tzPcj8CgCnZQ0O8YhY7pD2MLBqJZ6P6sf7n1+qmcFwLhvWcSTmGK8+N4rk6RtByM20qy
         uYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiPM/BRwebzkgBF18G5ZPRXMBq5fC3tN6A1lbz1/cvs=;
        b=fsoOtRnjlLvWFXWSGDpOlwkmYSA0AWW7EzXfPvNqg9Oo9JuCTEOE881FBnD8zWUd9d
         G1/K3wB59AzG2IhDAdvcgowxRBxyHCM9QVclJB2GrbVGOAssbFB3zsI+OKeFY1d+kIzw
         QjkXNKTSrp9+wjX2/TJvhVDB4p9eanir6um4ZtadF2XwuXHQqomSbH4MkC0+nSDraZM2
         adgLMiAemoEUMT2/tpYxupF0SG0MT6zs6q71bwC9E9v3+PzxdoB7FCO3jLPHjeD5+u99
         +1l4LgTC/VM1arygFnXEjqDc2bkEksfNTZVNFBY0KwYj5LuhOT2/1tbo1Y+gdehvOc4/
         IXlQ==
X-Gm-Message-State: ANoB5pnjd7qCLgprYk/AoeX8aPi1yXCEfajHl75Ej1qNybxVCAz9JnAf
        /F2dbsbu0bSYeV8XCrgGHwjb+g==
X-Google-Smtp-Source: AA0mqf7J/9d6SEJapvnozyDK8hY6/HCM/PXMmiA2iZizk4Mh12UIRlMPW3QmoMk6HpfDDe/XrF8/oQ==
X-Received: by 2002:a05:6a20:3d06:b0:9d:efbe:52c3 with SMTP id y6-20020a056a203d0600b0009defbe52c3mr23416500pzi.51.1670778299173;
        Sun, 11 Dec 2022 09:04:59 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x8-20020aa79ac8000000b0056da63c8515sm4320660pfp.91.2022.12.11.09.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 09:04:58 -0800 (PST)
Date:   Sun, 11 Dec 2022 09:04:56 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Neal Cardwell <ncardwell@google.com>,
        Weiping Zhang <zhangweiping@didiglobal.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        zwp10758@gmail.com
Subject: Re: [RFC PATCH] tcp: correct srtt and mdev_us calculation
Message-ID: <20221211090456.652eda22@hermes.local>
In-Reply-To: <CANn89i+nT61qvE3iChGc-bYiTCzR=x2ZhvddRD0qDUTF6JuK+g@mail.gmail.com>
References: <Y44xdN3zH4f+BZCD@zwp-5820-Tower>
        <CADVnQykvAWHFOec_=DyU9GMLppK6mpeK-GqUVbktJffj1XA5rQ@mail.gmail.com>
        <87mt805181.fsf@cloudflare.com>
        <CANn89i+nT61qvE3iChGc-bYiTCzR=x2ZhvddRD0qDUTF6JuK+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Dec 2022 18:45:56 +0100
Eric Dumazet <edumazet@google.com> wrote:

> On Tue, Dec 6, 2022 at 10:29 AM Jakub Sitnicki <jakub@cloudflare.com> wro=
te:
>=20
>=20
> > Nifty. And it's documented.
> >
> > struct tcp_sock {
> >         =E2=80=A6
> >         u32     srtt_us;        /* smoothed round trip time << 3 in use=
cs */
> >
> > Thanks for the hint. =20
>=20
> The >> 3 is all over the place... So even without a formal comment,
> anyone familiar with TCP stack would spot this...

And it should be in every text book already and is in BSD as well.
Maybe a link to the SIGCOMM paper would be good for those
google deprived people?

