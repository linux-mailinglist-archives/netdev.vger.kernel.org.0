Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57B54B3D6F
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 21:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiBMUcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 15:32:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbiBMUb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 15:31:59 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3A853700
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 12:31:50 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id r144so17645708iod.9
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 12:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3rdhrGsB6cka+Ef4Pbq9BbguW4PKC4/Ny/Dc/UgVg9I=;
        b=MgetSyyfZYVU8EdQAtQ9EEk5/SnlzABkFcm79j3fvcLWmIlv4dELeia897T/vXhsuy
         ccM8qTg8WfTtmB8XlH6L+d4cZyj3NBXABqGP2pPpY6EeyJ9pkE2lYGhydWx4R91HKbk9
         83f2H+AsDDamhGiZ/LipYRXzSRHLOXxfq+T0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3rdhrGsB6cka+Ef4Pbq9BbguW4PKC4/Ny/Dc/UgVg9I=;
        b=puIxw6Dsfgf9pK3/pteFhRj3V6o0qgendRRIf4FE4suIPTaTln9x1vWQJ99i/mgRAb
         /136W+HEGUoBsGDeI83JZ7SLqmJfz9jcxtKdwnsM18+EYWzJIvaBX9Pv/W/pOBgGuELo
         LZuaHceLioa/5+sUxSlOZ+it0E48ZaaxoNXvCPBWDypyQ1KzRsmqJzQYl5FHQBN4U0Yi
         lD1c6e1clAgzJ1fiTNFjfu5uiJJzUV+MXCLxIBEM0L15//H0hlB5Z70aVccbjZzh6pW6
         qPZ35gr8dkTgIWuK8MmjrrcfMC0+b8PHb54lLFrmYiSBi3tij+snYSWslbrLcJ4M8Lmr
         D5qg==
X-Gm-Message-State: AOAM531rRLkoP9hElZre4vShEkgdzyWKNY28+Eeo4H/gSTnWzrfc+qaA
        dEnI6zBOpJ+EFtMyQGtwW9nsR6ghOGFFUL0CH0cAVg==
X-Google-Smtp-Source: ABdhPJzMUZurqwHSvnaBe+vDkWCw9aovyzgqIxE11CVXZHJufQuj6eebPymwiXB10YP2WUGRyaazQqk/hjpog64xJTw=
X-Received: by 2002:a02:824e:: with SMTP id q14mr6457263jag.0.1644784309865;
 Sun, 13 Feb 2022 12:31:49 -0800 (PST)
MIME-Version: 1.0
References: <20220211173042.112852-1-ignat@cloudflare.com> <717c68c0-f139-b6e5-aff1-3a4264344eeb@gmail.com>
In-Reply-To: <717c68c0-f139-b6e5-aff1-3a4264344eeb@gmail.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Sun, 13 Feb 2022 20:31:39 +0000
Message-ID: <CALrw=nFLGyGsZ_DmaJ_Cwk0o2QqwokSD+WrEHY3o9TGfiC48MQ@mail.gmail.com>
Subject: Re: [PATCH] ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        David Pinilla Caparros <dpini@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stupid me - forgot to reply to all and a discussion between me and
David happend off list. Below, is the transcript for posterity:

On Sun, Feb 13, 2022 at 5:53 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/13/22 8:43 AM, Ignat Korchagin wrote:
> > On Sun, Feb 13, 2022 at 4:17 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 2/12/22 1:46 PM, Ignat Korchagin wrote:
> >>> In 8965779d2c0e ("ipv6,mcast: always hold idev->lock before mca_lock")
> >>> mld_newpack() was actually migrated from "dev" to "idev' just for this
> >>> use case. It seems the most reasonable approach would be to revert
> >>> mld_newpack() back to dev and use the original code.
> >>
> >>
> >> pmc already has the reference on idev and idev->dev is the source of dev
> >> passed to mld_newpack. There is no reason to go back to the idev -> dev
> >> -> idev dance.
> >
> > I don't know. Three things which make it more reasonable in my opinion:
> >   * we're already using idev->dev in mld_newpack() - that is we're not
> > adding an extra variable here in mld_newpack() - we need it anyway, so
> > can use in multiple places
> >   * it makes the code more consistent with the same code for the same
> > reason in igmp6_send() in the same file, which uses "dev" and
> > ipv6_get_lladdr()
> >   * we're making __ipv6_get_lladdr() static again and everything in
> > the kernel is now using the public version of ipv6_get_lladdr() - I
> > think the extra indirection of idev->dev-idev is a reasonable price to
> > pay to avoid customized locking code in the caller, which may backfire
> > later again in the same way it backfired this time
>
> which is why I later said move the locking to __ipv6_get_lladdr.
> ipv6_get_lladdr takes a net_dev, looks up the idev and calls
> __ipv6_get_lladdr. __ipv6_get_lladdr handles the idev locking needs.
>
> Users of the get_lladdr API that already have the idev reference use
> __ipv6_get_lladdr. That is a common paradigm in the stack.

Ah. I see now. This does make sense as well to me.

> igmp6 code can use some modernization - but that is a net-next change.
> This is a -net change.
