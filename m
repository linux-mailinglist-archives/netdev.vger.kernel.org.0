Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3247584379
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiG1Pru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiG1Prt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:47:49 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8926A9FD
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:47:48 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-31bf3656517so23558137b3.12
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eIW+Gt62BFoUQ5JzgAMQpOCY6T9OYOeQnOKq/wLHShY=;
        b=jtFR45QjXBLWZztW8Z4ZXEX+t08zPSlpQRpXg/KS40AWmAukZIClsNGhu+HLxQGbsO
         dDbCwq0Psw+a5cWOEFr6AGfsN5OddCxVt4VH58y8Na1OvExUL58wC8AosENIdm/h8TTs
         RUwNc46PlJ+bwJa4qI2UwaMLnUahkpRxOVpSEuQb0Jq5HRSqVRVbtgBrfdwdWQ/7Aixs
         BAT3HU0+E3QDoF8ZAwoFOKOSuictnDiaWbHOTVpRjXmkVxJY4K7IQk+aLjwY7MlWSCkR
         ovxsneuri0SrilohwCI7dnpWIT88ciHqOtgQayKTlPgWsdB7MnCg4BWDQRgQYqj331BT
         0aVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eIW+Gt62BFoUQ5JzgAMQpOCY6T9OYOeQnOKq/wLHShY=;
        b=H7zfZ9Hx/kZjnWurcQpNiqvvxIfHlxFw8Fa/YMY6nfPYzyzH/lmbCCXhBV+DAAp5os
         VSEPMQ2e3zQ8TU/HGb0tDO3aC/aUjEJuvIzIkR31TghqTcGoSjQOzYO8PVxxb7Iw6D58
         BljDiF5R+kg761OsFI2jfnxinJHkxJh4uqUg8HsmQNFbRowMrgEUP3Fl0jXNDRgMSaYe
         7FGCoBRTY6eM/kwTHy65ruxpLxEyRfZbRSgt9uI+y68nSlDWjC9xwSBUaJhKgtBRzM/v
         qnOw9S1WuM7JR9KOf2kBvsKmkvtfoPwxTeEOtopFIuCE33alitSvYMynIJLHTqHtriNl
         X6dg==
X-Gm-Message-State: AJIora9h73ucES0TB+MeqWqLJlujuDgDYzUaMcE9h2iQ8Qvbxc82J2jK
        HW3YUblbT6xCAmBIG0GSTgk5gPnD/ohrbCQhobHitw==
X-Google-Smtp-Source: AGRyM1uFld3Lpoxqx+i2tBdAsxUKElPnTMVrF+spMW6jRFQCukNK8QIyE1bTYhvMu/7fv2Q9tYWh8DSy9Puf2pqz47M=
X-Received: by 2002:a05:690c:831:b0:322:1402:d950 with SMTP id
 by17-20020a05690c083100b003221402d950mr4622827ywb.255.1659023267363; Thu, 28
 Jul 2022 08:47:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220727031524.358216-1-kuba@kernel.org> <20220727031524.358216-3-kuba@kernel.org>
 <e70b924a0a2ef69c4744a23862258ebb23b60907.camel@redhat.com> <20220728084244.7c654a6e@kernel.org>
In-Reply-To: <20220728084244.7c654a6e@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Jul 2022 17:47:36 +0200
Message-ID: <CANn89i+vOXgKw+2ahJuhtu3-1MDSK4uDdCrK5CQ432QOhVn-PQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] tls: rx: don't consider sock_rcvtimeo() cumulative
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, vfedorenko@novek.ru
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

On Thu, Jul 28, 2022 at 5:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 28 Jul 2022 15:50:03 +0200 Paolo Abeni wrote:
> > I have a possibly dumb question: this patch seems to introduce a change
> > of behavior (timeo re-arming after every progress vs a comulative one),
> > while re-reading the thread linked above it I (mis?)understand that the
> > timeo re-arming is the current behavior?
> >
> > Could you please clarify/help me understand this better?
>
> There're two places we use timeo - waiting for the exclusive reader
> lock and waiting for data. Currently (net-next as of now) we behave
> cumulatively in the former and re-arm in the latter.
>
> That's to say if we have a timeo of 50ms, and spend 10ms on the lock,
> the wait for each new data record must be shorter than 40ms.

s/must/could/    because timers can expire later than expected.

>
> Does that make more sense?
