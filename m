Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D865252698F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383318AbiEMSsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383212AbiEMSsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:48:38 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0B765427
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:48:37 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2ef5380669cso99310897b3.9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mn7skLwP7ZLpWdqZiY5K4MCwW03heSSoaB+2qDqtvZc=;
        b=GkHOUdcJaMMiSvBrV6HXiWubsr/aXtMJxdRvnEcFE3gAlKCaAdJfdbGyOLxrrK4Wpj
         kdtA9wQD+8YekW4U3mRp0pcJGaZBgafljmu/VukUiR0GnHnWvSv5UfNKJwVBZkoImy8L
         b9OM3kL/frc/61+HjPVnvi0uOHhD80q+PK1RAMAIDDRI0yybdBNEWeKNdwyCDwN0RHk/
         S1+aPO9j6EJBUlNmpw25Eyns/j/O15hL3uSKeI5ILOMYdcP5LYmQn2bUO7M4u4romWrv
         x9I5qzloweC26Btz+Chw437T1Ti0KXbbIrrNoioyOGApxLzcOBxpwOXwVNirDcX3+lkb
         QD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mn7skLwP7ZLpWdqZiY5K4MCwW03heSSoaB+2qDqtvZc=;
        b=y+z724OdkIxUXLCT7DLa1RyAKdhxDF6wRrTIn3/LJN3EGYHOFJujucsN8SGsgY3N5Z
         4iMga7Hme93KSq4O7gtyPKixI2IIDOdN7qD8ESzXZ+Vn9Cmg2NK5QA3d7qhnV56GfLjP
         1dc4zkX7dLoVQXoCNbOnkV6WHJy9+YhrqvE2d7z7i6fnrKNJSfCJ4TD9Ml8lwnq2MQdb
         1h95kgXY7p9tmi4jZopcNwPXsp9B30//rWhL3Ul60W2zP0N12iafWsAzRJ16J/I3VeUv
         bSiokc5xBvwJJMt8gS8xowu38UENguLkzay16EjMNKaSdRWtlrpERXsSO1vSkjwog1Kd
         bfuQ==
X-Gm-Message-State: AOAM5308WmritBY/lZtrwSXhQ729aHv5P4EIZKezSn+ofM6sHfhNx1QQ
        ZHaUdkEovS29507nDT8CfdTVql0G5FbqcJfsU0b6hA==
X-Google-Smtp-Source: ABdhPJyuxsgUIU/Kn2VRLIaCWs3ZCA78mxditrMPScq/hJeattAeSz7WeRuBNofImCVAqbmArdRPNhFfjT9rPHGPVT8=
X-Received: by 2002:a0d:d80b:0:b0:2f7:c74f:7ca5 with SMTP id
 a11-20020a0dd80b000000b002f7c74f7ca5mr7253015ywe.489.1652467715964; Fri, 13
 May 2022 11:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220512165601.2326659-1-eric.dumazet@gmail.com>
 <09dae83a-b716-3a0c-cc18-39e6e9afa6cc@hartkopp.net> <CANn89i+V+ZW3qjb=OycX5vsEdcymdsn9-HF379QFqL3T2_a0Ag@mail.gmail.com>
 <20220513101817.3f001a85@kernel.org>
In-Reply-To: <20220513101817.3f001a85@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 13 May 2022 11:48:24 -0700
Message-ID: <CANn89i+8=JizjV-Ss=kY8yALQdTThC5aTNHpXk9BO2WW9D7ULQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, May 13, 2022 at 10:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 12 May 2022 10:14:23 -0700 Eric Dumazet wrote:
> > On Thu, May 12, 2022 at 10:02 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> >
> > > When you convert the #define into an inline function, wouldn't it be
> > > more natural to name it lower caps?
> > >
> > > static inline bool inet_match(struct net *net, ... )
> >
> > Sure, it is only a matter for us to remember all the past/present
> > names, based on implementation details, especially at backport times.
>
> We can apply as is if you prefer, but I'm not sure I follow TBH.
> The prototype (arguments) of the function/macro have changed so there
> is nothing to be gained from not changing the name AFAICT, no?

This was applied by David, I will send the v2 of the series, and a
patch renaming INET_MATCH().

Thanks.
