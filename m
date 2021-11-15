Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7770A450144
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhKOJ1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:27:46 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:37423 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhKOJ1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 04:27:36 -0500
Received: by mail-yb1-f171.google.com with SMTP id e136so45071744ybc.4;
        Mon, 15 Nov 2021 01:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tuFbvIjm50IuAszvEEIIi3rMMyoH/wSECdwpOBDhsFs=;
        b=b+NXBwNb1j5zBhjx8Zf7nOT0tCCnjRhytwHquZmpEZ4y8408nZJy0MdCTXwcEb26B8
         hFivEacjHLvn5iB0ncugxxxkhsuNPSJ2sJurVIa6Fp1AsSgihVRFhsJVCaaIjIJsMb1E
         kdIqxLPA86dspj4DCmvIdTF7kjSCvQ7ZsdR08GGGXFAdyRj62n1cr7Gahn8HL91tXN/A
         ALc/Z/n4IjfAEmi/Dd++l8LnuCea5dAYW/6weCaQDRWoQHDLmA88ITQdp+haLRdLcRtk
         zBl4H4mJr4R+XsrjTs2i9Zkl4WvfsWZJu8Zt72A/URlJpZvxeMDye4NYjA7fI45Cf+GC
         0xqQ==
X-Gm-Message-State: AOAM531XDcgEHXYTyZ9taf96xsuqD1QqxIRCF4CY29uUBFewwMJCXI6D
        6dk6riO/zgdzkZHCmlW1Jm5Xc1mdG/ytNwynO/k=
X-Google-Smtp-Source: ABdhPJxVqMz5cYhmIv7Icq3FORFX2T6IyCmv03iiLyKk9lNM2VFpzkKIu4dzHOdIq5jXugNBBFlGrdm/moKUQjK1Pb0=
X-Received: by 2002:a25:c792:: with SMTP id w140mr37372926ybe.131.1636968273133;
 Mon, 15 Nov 2021 01:24:33 -0800 (PST)
MIME-Version: 1.0
References: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
 <20211115075124.17713-1-paskripkin@gmail.com> <YZIWT9ATzN611n43@hovoldconsulting.com>
 <7a98b159-f9bf-c0dd-f244-aec6c9a7dcaa@gmail.com> <YZIXdnFQcDcC2QvE@hovoldconsulting.com>
 <e91eb5b1-295e-1a21-d153-5e0fa52b2ffe@gmail.com>
In-Reply-To: <e91eb5b1-295e-1a21-d153-5e0fa52b2ffe@gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 15 Nov 2021 18:24:22 +0900
Message-ID: <CAMZ6Rq+3uPE31q=HN-BdkXsMYZf53=VfNSn0OD6HcweLO0u-_Q@mail.gmail.com>
Subject: Re: [PATCH v2] can: etas_es58x: fix error handling
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Johan Hovold <johan@kernel.org>, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 15 Nov 2021 at 17:30, Pavel Skripkin <paskripkin@gmail.com> wrote:
> On 11/15/21 11:16, Johan Hovold wrote:
> > On Mon, Nov 15, 2021 at 11:15:07AM +0300, Pavel Skripkin wrote:
> >> On 11/15/21 11:11, Johan Hovold wrote:
> >> > Just a drive-by comment:
> >> >
> >> > Are you sure about this move of the netdev[channel_idx] initialisation?
> >> > What happens if the registered can device is opened before you
> >> > initialise the pointer? NULL-deref in es58x_send_msg()?
> >> >
> >> > You generally want the driver data fully initialised before you register
> >> > the device so this looks broken.
> >> >
> >> > And either way it is arguably an unrelated change that should go in a
> >> > separate patch explaining why it is needed and safe.
> >> >
> >>
> >>
> >> It was suggested by Vincent who is the maintainer of this driver [1].
> >
> > Yeah, I saw that, but that doesn't necessarily mean it is correct.
> >
> > You're still responsible for the changes you make and need to be able to
> > argue why they are correct.
> >
>
> Sure! I should have check it before sending v2 :( My bad, sorry. I see
> now, that there is possible calltrace which can hit NULL defer.

I should be the one apologizing here. Sorry for the confusion.

> One thing I am wondering about is why in some code parts there are
> validation checks for es58x_dev->netdev[i] and in others they are missing.

There is a validation when it is accessed in a for loop.
It is not guarded in es58x_send_msg() because this function
expects the channel_idx to be a valid index.

Does this answer your wonders?
