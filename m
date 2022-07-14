Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED57574557
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiGNGyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiGNGyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:54:17 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6E62A977
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:54:16 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s27so710391pga.13
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L5qdFiUswjd3yEUQQv1O0GE2dsDntoUrAiEUDA8m4g0=;
        b=5H9jsmyT1l03GSfjDe2/QfiAPom0iNrUTKgHQd5uW7IoPr4ficdQycNGSuhbXtMlso
         ghNIa8bsCbPXPenSqibEUTizS31eqSosShb1n5nw6pMeNFo0N44Pmzfcaw7iX8vpTnB7
         0FJQyc5CEGq0hdHFddDhlQOv6xmRQvXmapTN5mntToxIntp9XZ7EWiQq9dMhaUXzptTu
         js8CPmzqIlKeMztp/YuOpeW5ZMaEAuNejYxvM+9eE4KzgYQngN9f2KdsVEkRCBYwof4W
         SxvTmxG8YaO/DecP0Zk7PfXIsAmHe/ecYV0zdv1h1BTQWezEOZiWUgdZBFImBu/6Cl/B
         02fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L5qdFiUswjd3yEUQQv1O0GE2dsDntoUrAiEUDA8m4g0=;
        b=Ch0Xx6k1/ktOsgbpV67p24aBUxtZ/xgmFohFTrwhr7N1JSAVhqK4TCc1W07zxwGbNO
         AClXTYW1citU0R/HbmTB92VjyGWaubYzU7XtFXUovjcOVOoeg4Bufc5w4MA7nbytYuRl
         A0WFBVMfb9lPuOAVdLvtTyxyRZRcENNeXsRuQHEINgRmEvDB9A3tZJgv38AhC5Nmo8T/
         0SilSjBHfkBee5z0FuK6T69MF/I3FrduE2W88qqrFYx/woIiCVeJymjOwVfS9bmnomvv
         2q8Cb7ajMiNfzCZCfLASIB6EhAMxOnUgORdyS9DrRVGmpmtNWst0UtQHxcJ5Z9XTOvnu
         1DVA==
X-Gm-Message-State: AJIora+5AFz8gTvk8gDRR0z3NUKf7HXNf2D7XTyVX6d3bvoFrX999S9F
        iRDhQyLt+vY+ahZFKvub/4Ce455SHDr++RNTti2xtQ==
X-Google-Smtp-Source: AGRyM1vQfjYX75PVQz/pxDek55+3w0WUtiI2YMI9LHHYb1IvF6cze/SK5USas0xq3x1osMTdjjm3AtWZmWm1U9WVYRc=
X-Received: by 2002:a05:6a00:a0c:b0:528:5233:f119 with SMTP id
 p12-20020a056a000a0c00b005285233f119mr7178398pfh.69.1657781656100; Wed, 13
 Jul 2022 23:54:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
 <20220713200203.4eb3a64e@kernel.org> <55c50d9a-1612-ed2c-55f4-58a5c545b662@redhat.com>
In-Reply-To: <55c50d9a-1612-ed2c-55f4-58a5c545b662@redhat.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Thu, 14 Jul 2022 09:53:40 +0300
Message-ID: <CAJs=3_BNvrJo9JCkMhL3G2TBescrLbgeD7eOx=cs+T9YOLTwLg@mail.gmail.com>
Subject: Re: [PATCH v2] net: virtio_net: notifications coalescing support
To:     Jason Wang <jasowang@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jakub and Jason.

> I think we need to return -EBUSY here regardless whether or not
> interrupt coalescing is negotiated.


The part you are referring to is relevant only if we are going to update NAPI.
Jakub suggested splitting the function into 2 cases.

If interrupt coalescing is negotiated:
 Send control commands to the device.
Otherwise:
 Update NAPI.

So this is not relevant if interrupt coalescing is negotiated.
You don't think that we should separate the function into 2 different cases?


Or maybe I misunderstood you, and you are not referring to the following part:
> +                             if (!notf_coal)
> +                                     return -EBUSY;
> +
> +                             goto exit;

But you are referring to the whole virtnet_set_coalesce function in general.


Alvaro.
