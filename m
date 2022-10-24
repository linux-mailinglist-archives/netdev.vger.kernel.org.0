Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589F860B348
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 19:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJXRBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 13:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiJXRAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 13:00:21 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4FA1C93E
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:37:51 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id n130so11408390yba.10
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Al1Yz3zV3klBXyN8hzYqwzw3aRUMACYNNTKdspj56I=;
        b=PUoI+jPf4kEVcKR6NmIcbTKe7drpKyXmk7dcgdHKZEIa9mZVbK6Gvrtsrh+kU/16eq
         OA9Ix8KVSNdrLi1GsxhxxVuIKHfD5le6jRLKpyJdoe/mVKgmifjDqI4n4q6ZmKAkkStD
         8/zFaJyrBCBe4bA9Z6TmHfBugiHZ+NZ3gVpEcuBqVLIap3LHrm4VF52HcBrxDLJ0RZjt
         VXk1n8QG6muZmmeFepiCoSS1vKYwyXmWt0vgZlGpGtnXCTgKZXTDXTzRKwg8ei026WJs
         vHkrbtUreyYm3R4dART7ppHvWafEkgr36FYdcmsVRgASBQwuZM5jJ52I9kxDLZMcue0y
         FItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Al1Yz3zV3klBXyN8hzYqwzw3aRUMACYNNTKdspj56I=;
        b=bvbiJRx9EEv3EiTcUldI47JHCdZpRfVpC4/dEWaIxCdZk32Mti/nv2SRGCNlQhep3q
         tWgxfjzP2dXqSSDSgWSUDXrm9nAzSwbub/IFGvTpmMk7IJ2Lq31h3cgH/Vf0IsvHYF4/
         YWebVzM8rRHHXf1d0a1HbzOmwJjnPEUoeLImtjyFxXUV2jQA8w8zuXe3OPCQBLJaZqgN
         edRqp8K9vBFz0NHGQyP9onwsTpUdmrWCumb1kGW8dNN1Xj3ONLqh9vrCr399V+Ms4SPF
         zipl7QYElz31RARuE8Tce8O6xduDqaEl/WWJevgPLr//ZD4j9HZ6NN92kKEnFOZibdYp
         N96Q==
X-Gm-Message-State: ACrzQf1p7gH69NELKzDhL1t8dMG+Xccw9aaxSGPqDbpQAvlBdbLtQgXS
        y2/KHHylzW8+v48GJg956QjqhYvgFny6r2jHJc8Y+A==
X-Google-Smtp-Source: AMsMyM6yZMmWPEhmV+OU5hfTZ2BqRaiYft7Om29+GECG3iDVT16diYRLDWCohn3DZ8zC5u1xyrhQplZAPV8kHI2446c=
X-Received: by 2002:a25:d914:0:b0:6cb:13e2:a8cb with SMTP id
 q20-20020a25d914000000b006cb13e2a8cbmr4849686ybg.231.1666625784889; Mon, 24
 Oct 2022 08:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221024144753.479152-1-windhl@126.com>
In-Reply-To: <20221024144753.479152-1-windhl@126.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 24 Oct 2022 08:36:13 -0700
Message-ID: <CANn89iL==crwYiOpcgx=zVG1porMpMt23RCp=_JGpQmxOwK04w@mail.gmail.com>
Subject: Re: [PATCH] appletalk: Fix potential refcount leak
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

On Mon, Oct 24, 2022 at 8:25 AM Liang He <windhl@126.com> wrote:
>
> In atrtr_create(), we have added a dev_hold for the new reference.
> However, based on the code, if the 'rt' is not NULL and its 'dev'
> is not NULL, we should use dev_put() for the replaced reference.
>
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  net/appletalk/ddp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
> index a06f4d4a6f47..7e317d6448d1 100644
> --- a/net/appletalk/ddp.c
> +++ b/net/appletalk/ddp.c
> @@ -564,6 +564,7 @@ static int atrtr_create(struct rtentry *r, struct net_device *devhint)
>         /* Fill in the routing entry */
>         rt->target  = ta->sat_addr;
>         dev_hold(devhint);
> +       dev_put(rt->dev);
>         rt->dev     = devhint;
>         rt->flags   = r->rt_flags;
>         rt->gateway = ga->sat_addr;
>

IMO appletalk is probably completely broken.

atalk_routes_lock is not held while other threads might use rt->dev
and would not expect rt->dev to be changed under them
(atalk_route_packet() )

I would vote to remove it completely, unless someone is willing to
test any change in it.
