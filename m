Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14EA64D635
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 06:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiLOFec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 00:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiLOFe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 00:34:29 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171F42A951
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 21:34:29 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id i7so1914662wrv.8
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 21:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OARgK+lR2WR6xLpz3QQ41iQnjNZd3aWvd3w0biZLmyM=;
        b=DscrijyUqHQY+GZ/KDCoRGhOwEs68XRfQ0A8R4xgBUEI0P6RZfcB7VyGMNjQBWr7Tp
         Hyv4sCyAPAxM/59i8vqTBaeXmaJN5mtCzvRh1PYVP0oUPva782JXvVd9t+m5Lfer42XZ
         XOS+m+MThXZElSV/0Tk9zxXuPjsdJOWo8vcFY65tW40+bEj0O14pS+QvdBhuwc2vkRh1
         x01Tzz9m2L0iH9BLqNSTcMVGzJhlAg77H74OdN1cpHAz5p2VkXC81G3zZUcAGkS5AouG
         P0Ya0bmrajy+8uW8/f+00kkNXZGofgPjJzk9zn3m7YujN7Qg12jQQ/i70ThpFCcZJ/uB
         o4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OARgK+lR2WR6xLpz3QQ41iQnjNZd3aWvd3w0biZLmyM=;
        b=mnyK1vK2nMMbf1z10U4A+o4teUvnm/MUrqmTnItKzMZbVTEP+VaXY8atARIyH+V82P
         Qz2nMCI4QFMbct2XdS2UKfXFgH/pQUfw+HCXZQlTVH0a/mtLXAwv+JDf/8uFdlYGU5cC
         3okq4dWTu1q/tJyXULu91O7gaz8DKx3b/1/XR1xqTBL69Zs1iXtzcskNml5jwFuVekrD
         XCbKhClwAi0uWzdronF2a4EVS2CQxLNIfOdHDMavnIuGSbW0Jqv2kMGavYCqe4GXpXAi
         5nsDY8nI8igtDwRICy/itAg8QzllEaAEFBvCZppdeA2s/o3Qewg/B9ocn1smYqFGc/6T
         K8Ew==
X-Gm-Message-State: ANoB5pk9vqGpd00KiB1DyGaUXGnCkTTwh6aoaCL/Td6cQB7EYFs6yPwj
        gAH09z/Fo3iSrUdDTPTkhhpySqYTjNt2qqf/WO3GOA==
X-Google-Smtp-Source: AA0mqf4lWhUq3jXe7+FJk+DB8Z8oDLjxIjSkc1HRXKKHLoYkemJrucKQrwGt+HUO1Drj6MerLmuBP3kn0gEx8+grmkg=
X-Received: by 2002:adf:ed83:0:b0:242:1379:9ccd with SMTP id
 c3-20020adfed83000000b0024213799ccdmr29706623wro.424.1671082467307; Wed, 14
 Dec 2022 21:34:27 -0800 (PST)
MIME-Version: 1.0
References: <20221213073801.361500-1-decot+git@google.com> <20221214204851.2102ba31@kernel.org>
In-Reply-To: <20221214204851.2102ba31@kernel.org>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 14 Dec 2022 21:34:00 -0800
Message-ID: <CAF2d9jh_O0-uceNq=AP5rqPm9xcn=9y8bVxMD-2EiJ3bD_mZsQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] net: neigh: persist proxy config across link flaps
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
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

On Wed, Dec 14, 2022 at 8:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 12 Dec 2022 23:38:01 -0800 David Decotigny wrote:
> > From: David Decotigny <ddecotig@google.com>
> >
> > Without this patch, the 'ip neigh add proxy' config is lost when the
> > cable or peer disappear, ie. when the link goes down while staying
> > admin up. When the link comes back, the config is never recovered.
> >
> > This patch makes sure that such an nd proxy config survives a switch
> > or cable issue.
>
> Hm, how does this square with the spirit of 859bd2ef1fc11 ?
>
Devid's (Decotigny) patch is adding the distinction between admin-down
from carrier-off which could be transient. So in my belief, it's
correcting / enhancing the behavior that David (Ahern) introduced but
we can hear from David himself :)

> Would be great to hear from David, IDK if he's around or off until
> next year.
