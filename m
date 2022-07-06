Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E577E568AD9
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiGFOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiGFOFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:05:04 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7714DB9A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 07:05:03 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i14so7755917yba.1
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 07:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kVoGDHkmg2bV3dEPVfOyFVTv4T1dp99x9dXZ6++KkGc=;
        b=cdo6+uYBatnadqEjI5guS0rIxTahsAQIeUq45tTSVhz23zrCM96eQ4BT4Jo3qowS7F
         zwvrozvhVd7zFWB+PxqeU2qtg3dLEK9pYxuInFXgEWHWATikP5H272k78mRw/8A2M0bP
         nuS5TSe8/G+NX0Q1E3IBiBi2M8aETzG8enil6Gos7nWggMBDe/5UumGenZ+aCC/PUIAg
         oy8uzghMOZYCWOuUt85ssn1mfDPfKJehj5ZzD0krTTlBqrGaeuNEA0ldGcDqE6N7E6y7
         CiMY6S/riZB+qlTjX3boa4jcJthwzSNM53w/Ph5/4rCOauSDEp0U3mAINbQ0DJHvSC7f
         7/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kVoGDHkmg2bV3dEPVfOyFVTv4T1dp99x9dXZ6++KkGc=;
        b=H+xVs1y5DXYKvZkXmH1Bhu0VNbiRXYllZo6BcasZ1BQCDdfp7oFbcrviQUe2xamATC
         WpmT9wE+dT3uDOnAQ1+xjEj3Wkw5vqmAb8UcMIQ/ASsVMcmRj7LmKxOe/QqNFwCUwsm5
         iifGc4aWJ6MqZWTGtTYGd57tuHkxOqUlKWPCjF2I0BLbTwHbaKkfafEgfZINiVoGrI+2
         dT7M9/6eA7cxLnqxS+49wAET8VX6b64jTJwzLvuWJFecH2dQA1wfheUCEjqWFaprwLYG
         kiTucnkDVzeOJUmLCQnwEhqBmXFnag2tZIGvokVvQad+uMT95jiAMNJAv548VwzXs/E+
         n1gw==
X-Gm-Message-State: AJIora/S+MiOglZCy4QtceCFczOCQ5aI3m6J9pd8ZuIp1f7b7sDZJ6ae
        gDXeJMoo0jjc2PSytD+u+uBj5Z7wTYGweJJWJoUIDg==
X-Google-Smtp-Source: AGRyM1vvPdKHgBPAPQoHPnplrll3WuBZpno3rPELKLbCaPm8kAqegFo2BdOcqTQ6rLOzjsy/LVP7pS1Hssh6NJY/3EY=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr45625905ybh.36.1657116302422; Wed, 06
 Jul 2022 07:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
In-Reply-To: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Jul 2022 16:04:51 +0200
Message-ID: <CANn89iKxoSDOO3gx2qVXPaQ2g+6rJi8Q0CN2GAW-nf4WTo1GBw@mail.gmail.com>
Subject: Re: [PATCH] net: Shrink sock.sk_err sk_err_soft to u16 from int
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Sun, Jul 3, 2022 at 10:07 PM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> These fields hold positive errno values which are limited by
> ERRNO_MAX=4095 so 16 bits is more than enough.
>
> They are also always positive; setting them to a negative errno value
> can result in falsely reporting a successful read/write of incorrect
> size.
>
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---

We can not do this safely.

sk->sk_err_soft can be written without lock, this needs to be a full integer,
otherwise this might pollute adjacent bytes.

>  include/net/sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> I ran some relatively complex tests without noticing issues but some corner
> case where this breaks might exist.
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 0dd43c3df49b..acd85d1702d9 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -480,11 +480,11 @@ struct sock {
>         u16                     sk_protocol;
>         u16                     sk_gso_max_segs;
>         unsigned long           sk_lingertime;
>         struct proto            *sk_prot_creator;
>         rwlock_t                sk_callback_lock;
> -       int                     sk_err,
> +       u16                     sk_err,
>                                 sk_err_soft;
>         u32                     sk_ack_backlog;
>         u32                     sk_max_ack_backlog;
>         kuid_t                  sk_uid;
>         u8                      sk_txrehash;
> --
> 2.25.1
>
