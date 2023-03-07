Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF7B6AED58
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjCGSDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjCGSC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:02:58 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F967AA277
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 09:56:13 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id k10so31867021edk.13
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 09:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678211771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpbwD5A+nT3p8meze/QbtH3VFkABogGoDoeoO8g0g+8=;
        b=GYEZjQyFR0uDSo/6obGk52hmnrkvkX/aOV+lQp6jP9HYYzznFirIN/GJoNFU1AGTn3
         VtKvQ0U2EOj9bfIycG9jNIdZ1bTbcxWniVUxTlMik7QFPDzLAUBjGCox1E4/2JHALhbq
         2x/N2l9l5kF5eeWDQRle0rU1Pq7MxbBV937Yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kpbwD5A+nT3p8meze/QbtH3VFkABogGoDoeoO8g0g+8=;
        b=GoCQS+qGIYTZeoaATH3ZdCLmsum+VzRcdMnHosGm5E2d/staiAWu+zTKmFXmabJ08u
         nPO/ny9c/NYAMlaOgkDsdW4IjEMVO5Hta7zMaeGgrmShBLLqge9yvY3Rge6NPl42Irjj
         IkX7lAlTvhgeKHVraIJYp7FfUDRx/9GYujj65Y6tZVWl+OGI4SQv1hnLPqGyxQKtQgzm
         c1edF6R1Kcd/cPxAAE1KdvYKNdrdAJ3AiBHy+4w1UsewEdi4pmjCwI78embiPzZNA3LO
         pPphO08tX7GxeivGRh8oaEttTFFS8UbxVWmmkX/To5TBqbmWqaeNBRDU//5xVynT/KiM
         dPCg==
X-Gm-Message-State: AO0yUKUOXVP4vSg62Is7xHfNaE/T/i5T3qQMYV0ITFr/dyjJ+e5TFIYz
        zHydTxXkMsui9KQxdGE04b8SOtTar19APqD7d077QYq/
X-Google-Smtp-Source: AK7set8JjCfQpZmpsQgJe3FcrgqzW2wzHbKAlKMHzcfVJ/Gs7Pp2x+42fFXWZ4+KNmFOItsfuS9YjQ==
X-Received: by 2002:a17:906:4997:b0:8b1:800b:9fbf with SMTP id p23-20020a170906499700b008b1800b9fbfmr14402659eju.13.1678211771375;
        Tue, 07 Mar 2023 09:56:11 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id f14-20020a1709067f8e00b008c16025b318sm6360534ejr.155.2023.03.07.09.56.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 09:56:10 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id s11so55768214edy.8
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 09:56:10 -0800 (PST)
X-Received: by 2002:a17:906:b10d:b0:878:561c:6665 with SMTP id
 u13-20020a170906b10d00b00878561c6665mr7662618ejy.0.1678211770178; Tue, 07 Mar
 2023 09:56:10 -0800 (PST)
MIME-Version: 1.0
References: <20230307125358.772287565@linutronix.de> <20230307125538.989175656@linutronix.de>
In-Reply-To: <20230307125538.989175656@linutronix.de>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Tue, 7 Mar 2023 09:55:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjO15WdfF2Y=pROf2pid0zW5xfHnfJt3bH2QWQp6oWyGw@mail.gmail.com>
Message-ID: <CAHk-=wjO15WdfF2Y=pROf2pid0zW5xfHnfJt3bH2QWQp6oWyGw@mail.gmail.com>
Subject: Re: [patch V2 4/4] net: dst: Switch to rcuref_t reference counting
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 4:57=E2=80=AFAM Thomas Gleixner <tglx@linutronix.de>=
 wrote:
>
> -       atomic_t                __refcnt;       /* 64-bit offset 64 */
> +       rcuref_t                __refcnt;       /* 64-bit offset 64 */

> -       atomic_t                __refcnt;       /* 32-bit offset 64 */
> +       rcuref_t                __refcnt;       /* 32-bit offset 64 */

I assume any mis-use is caught by typechecking, but I'd be even
happier if you changed the name of the member when you fundamentally
change the use model for it (eg "__refcnt" -> "__rcuref" or
something).

Or was there some reason for not doing that?

          Linus
