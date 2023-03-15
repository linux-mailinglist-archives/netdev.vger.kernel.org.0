Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35716BBE1E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjCOUsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCOUsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:48:02 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702A69DE32
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:47:51 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-54195ef155aso212865887b3.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JhlMApgTkitNvhVZeol6qqWUUqpGhh2PDZC8Nh6/Mug=;
        b=VV3hKgAQja7csYJ8TaNaV2aACeZQvbra4oYAC1TSN6JM/EYDDCLWO2bNMIxsfXCz0A
         U7AvsFYxYZF4Zn8DcE1Lc+icG9tBzpUqiEvuC7HTASd91OI5rTGCPgkZ5FG4xQIhoR38
         I8mPLvoErXarwbOj3UOm6emXcmryQi6XFydl1NZNhodaITyC6KizWOEDYCwfMdvAduzZ
         EawFiZud2Ix3jGwAoCDDdQ/REW3NUzuazPGIT95UUnVbFcuIEyMSAnyaXdHBIy5cpCK3
         ZMXmYHt+oXUWaqU9dmn5HxSjUdK8bBZL/4/q0Ey3gJD+I+i4xZTGr1uhnK1M/rp73/6d
         vl1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JhlMApgTkitNvhVZeol6qqWUUqpGhh2PDZC8Nh6/Mug=;
        b=oX/wUUJ53G4ryGJGFgExaCuJgJAKaRGig+himo4W6TJIvrZLGU5fDCE0M5lDSsHSFd
         LG+Fer1ap51RHuO9uAK5y3cigzBwt1oLXLfp3Lv66/S5a/zbS56GPV5jKV22otOLWn73
         re8VYAX0CSfKjYNcnuo5AzxYGwWupLEvz73Ic0IyaykkzCsVgsJoUfOjaageur/Fpt8p
         zhzA78uYLXncTlHn2kE4cVwABl5AM2u5mk9tR5I4z+3WVBaYfTLK1jJBih2eajQAk4F2
         8T9ulXMfeEU9nEOhQkx5PAe1D0g+a0/euAlu9G2CbocQgO2ytpWas8spQP3eqTtjp9CU
         CPBQ==
X-Gm-Message-State: AO0yUKVNuNwGmZZbcSFQtZDBgSTxIDWfeHYA23BCx5G9YpSg+u8ryywB
        RdZ7qBYO4zZl4mSW8b9kes+T3u4soPjmTBrm79IenQ==
X-Google-Smtp-Source: AK7set/+BVzEQhyfNAWDw+Yt/scbHKbQXxV7zoD7fpm0EVWlhDGDkVwWyIuF3qk54qHrrqgJ37/c234vk98FoR5N2Ho=
X-Received: by 2002:a81:b184:0:b0:53c:6fda:835f with SMTP id
 p126-20020a81b184000000b0053c6fda835fmr778513ywh.0.1678913270335; Wed, 15 Mar
 2023 13:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230307125358.772287565@linutronix.de> <20230307125538.818862491@linutronix.de>
 <20230315133659.4d608eb0@kernel.org>
In-Reply-To: <20230315133659.4d608eb0@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 13:47:39 -0700
Message-ID: <CANn89iJUE3De9t3Vf-H6K+DAscEM98VZU4FaVCEOhE0ULUz9hQ@mail.gmail.com>
Subject: Re: [patch V2 1/4] net: dst: Prevent false sharing vs. dst_entry::__refcnt
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Mar 15, 2023 at 1:37=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue,  7 Mar 2023 13:57:42 +0100 (CET) Thomas Gleixner wrote:
> > Move the rt[6i]_uncached[_list] members out of struct rtable and struct
> > rt6_info into struct dst_entry to provide padding and move the lwtstate
> > member after that so it ends up in the same cache line.
>
> Eric, David, looks reasonable?

Yes indeed, thanks for the heads up

Reviewed-by: Eric Dumazet <edumazet@google.com>
