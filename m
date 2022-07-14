Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63389574755
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiGNIlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbiGNIlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:41:00 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62E613FBE
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:40:59 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-31c89111f23so10359167b3.0
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1hQFYGSQnuRsXUn9gwi5D8VBslwORs4FgqetRjAlfVo=;
        b=B6jRIoNvbLoBuvD9HkMm9V1lnFRQgLusHu2IOTHm5hwgZnpyKpr1IbtCi8blZ5ElVF
         /0SM6xYPoZzeBRaJJaiDsuSCZkMMEsHkLI+kLSkbtblUOxU0Lp8ZqD9Q6VfZM9pG4t56
         wHaJZBeKU7hDKm+tew7J43APBeE1CRXfXRKAzvwdQFISp9jZfQ2r6XXsqUc7Xtk529GU
         M9rL8sPpLYmnIvi1RyHIJs/U8h8hYGr3iV68oZQ3/RHSUlEoonQ9/dGP4JvV82seJsul
         GKjdHJKb8eSu8skxyr4szwP7xunWsbCEyrLmhYYDyhLKrAaxZBjbpTI2uSnlhE4e+czv
         pa2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1hQFYGSQnuRsXUn9gwi5D8VBslwORs4FgqetRjAlfVo=;
        b=XnX8LGxdfGI04KyC6Lqd3Pe3KXKdkrlbq3/PBFG1e2TqaVVLjf8EsRaKenaPWDrruk
         Q/GIs3MbSmtsfXiStxkIEiUkNhjukU1AGgtB3NHSFXguSQ7dXX4TAoM3gNcfgnCh8yJG
         gHg0nhNAk7UAfrpftV9puvE81Ke3jbTpMFzD9Kls+rcE4rFC0r/yzW23VYxna6UJzT5l
         wH4NI/xXzaEitwLc+pWHCITFq6SgpY501gCe51ateMZcAhyhqRmFaJfRDp7FR/InFw3L
         /PzrD0us09B4kQqa0PnuK+ZIrApFAjgyFwkzZp9UFYbPhp0l3xhluVJ+dD+EGkyoofRV
         ePJQ==
X-Gm-Message-State: AJIora+ll/Ec4ge7Is+Q3PftgOms3haa3kvIy7uREP31zEES5+cykj17
        lZp67cfwi4RzcWW4jqcBV7bdpU8P6Th7Qv/ttw7HtQ==
X-Google-Smtp-Source: AGRyM1toQQM8k5+Gq5zniC3zjN3RNn5woYm3k7A3dguhYcXX5rJr7XdF9g11WOtcz8/ThotR3T9IXB9X940RoFVzkKs=
X-Received: by 2002:a0d:c884:0:b0:31c:c31c:87d9 with SMTP id
 k126-20020a0dc884000000b0031cc31c87d9mr8809371ywd.124.1657788059002; Thu, 14
 Jul 2022 01:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220704084354.3556326-1-jeongik@google.com> <CAE7E4g=BGzup31AD5zAuZpoR2gMswJhuo67B7cV8=wHOY=Y+qA@mail.gmail.com>
 <86d347821699bac79902608d32e2bfac569347a3.camel@sipsolutions.net>
In-Reply-To: <86d347821699bac79902608d32e2bfac569347a3.camel@sipsolutions.net>
From:   Jeongik Cha <jeongik@google.com>
Date:   Thu, 14 Jul 2022 17:40:48 +0900
Message-ID: <CAE7E4g=xjtcRXOVwdkzMJyP2fAFfz-Q6h_GPB6ysKbXamq5N7Q@mail.gmail.com>
Subject: Re: [PATCH v1] wifi: mac80211_hwsim: fix race condition in pending packet
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, adelva@google.com,
        kernel-team@android.com, jaeman@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 5:39 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2022-07-14 at 17:37 +0900, Jeongik Cha wrote:
> >
> > It fixes kernel panics during a long test which uses mac80211_hwsim
> > driver. So I think it would be beneficial if we could merge this into
> > LTS branches. Could you share your opinion?
> >
>
> It also introduced two build compiler warning issues so I have two more
> fixes ... I guess you can request that, but make sure you include the
> other fixes (one of which hasn't landed yet) :-)
>
> johannes

Will do! Thanks for letting me know.

Thanks,
Jeongik
