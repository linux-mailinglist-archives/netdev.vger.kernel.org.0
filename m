Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9BF3BEC48
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhGGQde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhGGQdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:33:33 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582ADC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 09:30:53 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id x192so4070775ybe.6
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 09:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQNISUULFgbKrhLAqw4Nwehw3NiOOIQmnixsb+iws/I=;
        b=k8AG4+b4kEzHlqqMFY92SpLTa77GrdVMI08O8YYfP5dtrJnXzxV4emPApwRvn/mKSs
         Dc9GRDruoEtVxW3dWqUI//leT3DFqdvfAHVV+AT4QdYGx3Y0ioZ9MHZZZvpgxuLbKeIG
         xo8yG257z+Bj3gU+zt+7KmOIjsHnU2sCycnBiU7ZepC7anh93z5L12MKARZkelXRmB9P
         Xnu8NMqRlCeYOn0mG2U8ltJx01/6NXvFWIiX3uxKgrL022s2F//bwKSDQ3M0SuN75yHM
         OTWHEhAIuoskTn0ZWgvIBdsI3QiSKJANbNTUjErw3rwFS3O7+DKpzwJDjxdIkrvatyEu
         B/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQNISUULFgbKrhLAqw4Nwehw3NiOOIQmnixsb+iws/I=;
        b=TtCfkDnWqo0he5+wXSDuiSUy8aUoPHLFrUQf5p/WmtzuYVL+7rD2tmjj3MhCWNA52r
         LTDvsJ9K9wXX9z/6sqYVD2RRDyuViI9nobsrXm83/w7nr4DdUGS7T943NEj4DOf94qfP
         mjITD29s/He+FLyolEThR1P+aE4cfPC8f7ppPog68YX3588oC+gkTw4zyEMtCUWFboKr
         inwyZmjhHaGcR421myhBJQb4jgtOf7FLzE7ShDBVUcZMUfjtHpH1UuldM3Z0qtygys0q
         U/y7UZVuG8nGpcXzkmfbQX2SqdQRTMGFotxPNaFcvIZd550DV9uOGds55xM1eMoFMdq8
         ZcAA==
X-Gm-Message-State: AOAM533rbLZFP7JeO4Jnh7jgwoi6ae1oubxn1REY9in6dm/mfVmwjq22
        /4RpdqkUvNUnLe25ko0wtKb/4Z+BsYavTeafFtardg==
X-Google-Smtp-Source: ABdhPJws3XEKqn6IZWY8NVMLVuK4iYYckAXQetAQHY3BYRw7JDkNBBIgvAbSNdmDQsbpVQjP8+Ssey86HoHHMLSPGoA=
X-Received: by 2002:a25:f0b:: with SMTP id 11mr33824301ybp.518.1625675452228;
 Wed, 07 Jul 2021 09:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210707154630.583448-1-eric.dumazet@gmail.com>
 <20210707155930.GE1978@1wt.eu> <CANn89iKroJhPxiFJFNhopS6cS-Y6u1z_RLDTDCnmH8PMkJwEsA@mail.gmail.com>
 <20210707161535.GF1978@1wt.eu> <CANn89iJcEiYJa7dv+nwUw-EF4KpeNCCPHb1NBhn7M0Nhw9gVrg@mail.gmail.com>
 <20210707162736.GA2337@1wt.eu>
In-Reply-To: <20210707162736.GA2337@1wt.eu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Jul 2021 18:30:41 +0200
Message-ID: <CANn89iKmv+UUfi2ea9QeDCWvjVRr5tzmoEPeKfX7NrmNWZs5hg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Maciej Zenczykowski <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 6:27 PM Willy Tarreau <w@1wt.eu> wrote:
>
> On Wed, Jul 07, 2021 at 06:25:10PM +0200, Eric Dumazet wrote:
> > On Wed, Jul 7, 2021 at 6:15 PM Willy Tarreau <w@1wt.eu> wrote:
> >> One can hope that one day the issue will disappear.
>
> Aie. I thought you were speaking about million PPS. For sure if 10 pkt/s
> already cause harm, there's little to nothing that can be achieved with
> sampling!

Yes, these routes expire after 600 seconds, and the ipv6/max_size
default to 4096

After a few minutes, the route cache is full and bad things happen.
