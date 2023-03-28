Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C106CC9BB
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjC1Ryd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjC1Ry2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:54:28 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070DC114
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 10:54:26 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s1so6737532ild.6
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 10:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680026065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mhvhLb7D4riffRSL6raFnIME1Z/M2laCEfNPlg61Ao=;
        b=Z2zkqwkq6Y2lOdMPTFGpEhKpmx7qA52CuqtQ6NeUpQRaEH5b1FDlVpdMTFBVkgXKJZ
         1MocbI2g6UFrQqLxjgT3Xj/qEcjtcX6hnWu0RY+N1hj/ht0+TiC4q9zOymBLfJYKN39T
         4yCI3/Aw76k79gv3g/nA6Pg42c0OrpG7CnUYkTgf3xaBvzDWhEaJI+OBphCkhuWmg6cm
         h0drTxHj7Pu+CMVA4PkrnL/42GtWWm02RYCE5mxWHI1FffKthEjdhh9kc44M76q1Jpwt
         kNB/z0Z3t7Ot7kZW4XJ/Hf97CA34jzbfgwqztrC1Gqkqp0rfSxNGnH5WegOyuZMvL2t7
         cnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680026065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mhvhLb7D4riffRSL6raFnIME1Z/M2laCEfNPlg61Ao=;
        b=KqsL9QfjB0AOedQ2DFP43VCX6p6DJUiPkbcLdsaoCshLm2+rP/475iZN687s8T5WqW
         gsnQG3l0626Q0RmxrBQYPUD9rNnNn6Q+FNi+u3SPElTLj/aQdro00mJoaPsHxB8Ht9Uc
         d/FeOj7NHEGeAr4NcykIOzlnjG0wq/vequB75rdmfl6vf4wx7bWfkCwfVYI/sBjz6Emh
         tH4iIeA8Mtm/A+3k0yHHW3EzJXc0pMOBkk0I9V+c0Tv1y40o3EQ5yeUMMLuxHPxuM8MP
         xVRmKcVoLxN4n2JFHq+tK/1api9VdAb8si19Us9i4H7+EoewFYccK1mLKZKMWi8zJ+Lr
         Y7lA==
X-Gm-Message-State: AAQBX9euAVLXAqievhvEAADIVy+8DxsfjSQZAhXldvt7frKHU12DFNLN
        irbetGiS+LJ06X6aoLv+GEGXwf0mSHmsWEVr6LXNig==
X-Google-Smtp-Source: AKy350Zb4mUt1zFrnZvoiL7x6WGFpRDkYSe7gQJMODodXCy9tySgTy5p7fzZnY1rbt5Bn0wTZqf/O/4JoWAqNMhwIn0=
X-Received: by 2002:a05:6e02:106d:b0:30f:543d:e52c with SMTP id
 q13-20020a056e02106d00b0030f543de52cmr7803189ilj.2.1680026064971; Tue, 28 Mar
 2023 10:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <b9182b02829b158d55acc53a0bcec1ed667b2668.1680000784.git.stefan@agner.ch>
In-Reply-To: <b9182b02829b158d55acc53a0bcec1ed667b2668.1680000784.git.stefan@agner.ch>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Mar 2023 19:54:13 +0200
Message-ID: <CANn89iKxcqDO3-LyuroUkFUfG2dtZOLE4n2UJQ3y-ft5BRm30g@mail.gmail.com>
Subject: Re: [RFC PATCH] ipv6: add option to explicitly enable reachability test
To:     Stefan Agner <stefan@agner.ch>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        john.carr@unrouted.co.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 5:39=E2=80=AFPM Stefan Agner <stefan@agner.ch> wrot=
e:
>
> Systems which act as host as well as router might prefer the host
> behavior. Currently the kernel does not allow to use IPv6 forwarding
> globally and at the same time use route reachability probing.
>
> Add a compile time flag to enable route reachability probe in any
> case.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> My use case is a OpenThread device which at the same time can also act as=
 a
> client communicating with Thread devices. Thread Border routers use the R=
oute
> Information mechanism to publish routes with a lifetime of up to 1800s. I=
f
> one of the Thread Border router goes offline, the lack of reachability pr=
obing
> currenlty leads to outages of up to 30 minutes.
>
> Not sure if the chosen method is acceptable. Maybe a runtime flag is pref=
erred?

I guess so. Because distros would have to choose a compile option.

Not a new sysfs, only an IFLA_INET6_REACHABILITY_PROBE ?

Thanks.
