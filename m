Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6109758FEA4
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiHKO5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbiHKO5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:57:41 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C599B10FE8
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:57:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v3so21723978wrp.0
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Zr5E6fvnauAQyciWhD4CMUprKYdv8I+qwGdyCSBAivE=;
        b=DZMdemll/lVv0QElnLbSPPYCekgQ/oSECwCD07OXOZAMk7Sgji4BSmSNruRtm/fy0D
         wWYRc7/llc4wKT8o6OzhmckbwI8vmYVGM+21/fHER3ODq3yeqylnu1HUEBbitRIyo6vo
         gT+2wv/DZRBqZbemgEpmI0HqC27Trrra3Z504=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Zr5E6fvnauAQyciWhD4CMUprKYdv8I+qwGdyCSBAivE=;
        b=Gah9SUkYWOxqPIVkqos2gQPtrFOVfERcz7v+JVmCjCt52+DEe9fhaV5QIGJ14xgVBv
         Z0UXyWSq7UN8+y3g8DO+zqurnDdrpPp5mTCJpz3XtoZLioWQT+FmMq//qsS/AZgOAYuc
         GwIEAiee6rGt1DVdjKEamkE7S7UjiwDPuAp5AE5qs0Q3suFF8K5IOJgl0mCNmr8MPpW1
         t7oE/Yic082KlGIM0MSs6k1P68dK3P0taR8VMurg3h9IFj/HYObVrHbY4LyhXopU4VdF
         XhOI2sKAi2lm3mMfzkVbn6y3xSUxs7ArQmfEr65MXASw+/tN6MYyu1spKcT9Bmcxj8pS
         a+zg==
X-Gm-Message-State: ACgBeo3jY2kWawffvskPWqVPL90v/VrkDPylSwPSjjPmTAzUCReP3enQ
        zmlSqzXezcoj/dA+iW6ZjLFO5UebIBXW5Iu/yRHudA==
X-Google-Smtp-Source: AA6agR7m/T1XTLKV03TUj4ElBEpfH//odZR9nicoQVx2QYBW1FKK0u93hwRlJ693bh3XoGAO5Zhd50r9Vse9zNUWcNg=
X-Received: by 2002:a5d:6c6f:0:b0:222:cdb9:f002 with SMTP id
 r15-20020a5d6c6f000000b00222cdb9f002mr12165079wrz.198.1660229859300; Thu, 11
 Aug 2022 07:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
 <20220810160840.311628-1-alexander.mikhalitsyn@virtuozzo.com>
 <20220811074630.4784fe6e@kernel.org> <CAJqdLrq6D+w=H_9t8A7s0c96GyitHFTnY0a2QvUrVeuxaUdtAQ@mail.gmail.com>
 <20220811075346.22699ece@kernel.org>
In-Reply-To: <20220811075346.22699ece@kernel.org>
From:   Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date:   Thu, 11 Aug 2022 17:57:28 +0300
Message-ID: <CAJqdLrp1F2UNQoZbHLKVbm9QU5j=NXDCwJEan2TPJVk+-puwDw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] neighbour: fix possible DoS due to net iface
 start/stop loop
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kernel@openvz.org, devel@openvz.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Aug 2022 17:51:32 +0300 Alexander Mikhalitsyn wrote:
> > On Thu, Aug 11, 2022 at 5:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 10 Aug 2022 19:08:38 +0300 Alexander Mikhalitsyn wrote:
> > > >  include/net/neighbour.h |  1 +
> > > >  net/core/neighbour.c    | 46 +++++++++++++++++++++++++++++++++--------
> > > >  2 files changed, 38 insertions(+), 9 deletions(-)
> > >
> > > Which tree are these based on? They don't seem to apply cleanly
> >
> > It's based on 5.19 tree, but I can easily resent it based on net-next.
>
> netdev/net would be the most appropriate tree for a fix.
> Not that it differs much from net-next at this stage of
> the merge window.

Yes, thanks Jakub. I'm a newbie here ;) Sorry for the inconvenience.

Will rebase and send patches soon.
