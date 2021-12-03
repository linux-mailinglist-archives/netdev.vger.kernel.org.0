Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFE6467F72
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 22:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhLCVpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 16:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240809AbhLCVpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 16:45:01 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84905C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 13:41:37 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id d10so13201439ybe.3
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 13:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGrl28PGQQOFVt9QAnfNahuC7MuwJCnpLXKoGC19w58=;
        b=U/ZYP8UQ0/I4S3SZNzaVK9eSxmWjjdzKPuV5z2DvO0eA8jGCep9aZiT2D8y8Y6Gb3g
         E+FVjckxbHugpZyDb1v7estxKC5ZSHzhaAB8+08GenfJO/2eRlkkGFSdv0alYj6RSUJZ
         SSyP/QBU/esdL3h4/Whn+7ah2zJmDHkIjc2QljdXn0DQybNv8nseOPoj4l4/BmC/lZG+
         SP5zMp9LqH2nh7FNJhaHEssPTzBaYb5d0fNE+FxtdOgIhKUyOGD/Cz9izRB62NkLU5bR
         UqfKYcmKD26vnbyukbPtihAttuLv4DbybK2zLG4QrNcqN5LlsYdc6lNMlWJeF4ICfDKy
         BLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGrl28PGQQOFVt9QAnfNahuC7MuwJCnpLXKoGC19w58=;
        b=pYZlMjrZCLL+h1i9D6KYJ4ZQAWmhWvgISAlbpBXcU7uMYxV0v/GgIFyV64gNtp+uGF
         SAkWe0dzg6JQCRac5uCcQdgHtwORkSPWbSI+gMzXQrFUIdrCz+N8oNDz/mGrZkMb8bR/
         26yNT7J9ZR/4LWzoLjBUZHUjcv8g+kZKr2nunUtqs1Iv7MerAQpUSTi2vPbn3Wz1n0rH
         HVa6aXHKOfgWwIgsLvDtJtOmUQ//RLMtYXguG7GCkEdN/2L2nVdD/gofAgu9AcKeoByr
         wJQBp9ZcM2gFiewaQW25qw0y2TXnNgq0lF8pMoH1o+z7EqISfLgxM7+B8Fnnm5oXBTfh
         6tRw==
X-Gm-Message-State: AOAM533/fo/gTUzrhrM33alxys5cc6igFnlaEM3hC3pa8lJ9r0d46YPm
        DJ/DVhQPm1avY8p0akf2locybtCPwLN/AJh5dYT+AA==
X-Google-Smtp-Source: ABdhPJyRQ+olocHi10QM9S2WKEuLoBPBrvQ5+SmHSaB9x1jEOwknmj3EDVF8Zv7hioqFIcLlrHKIn06KBVRACEu2Jb4=
X-Received: by 2002:a05:6902:120e:: with SMTP id s14mr28129225ybu.277.1638567696477;
 Fri, 03 Dec 2021 13:41:36 -0800 (PST)
MIME-Version: 1.0
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
 <20211202024723.76257-3-xiangxia.m.yue@gmail.com> <518bd06a-490c-47f0-652a-756805496063@iogearbox.net>
In-Reply-To: <518bd06a-490c-47f0-652a-756805496063@iogearbox.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Dec 2021 13:41:25 -0800
Message-ID: <CANn89i+go9pqvdQVMLaHFdi6nj1jaHMazko6MpngmUMmPLAe9w@mail.gmail.com>
Subject: Re: [net v4 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, atenart@kernel.org,
        alexandr.lobakin@intel.com, weiwan@google.com, arnd@arndb.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 1:35 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/2/21 3:47 AM, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Try to resolve the issues as below:
> > * We look up and then check tc_skip_classify flag in net
> >    sched layer, even though skb don't want to be classified.
> >    That case may consume a lot of cpu cycles.
> >
> >    Install the rules as below:
> >    $ for id in $(seq 1 10000); do
> >    $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> >    $ done
> >
> >    netperf:
> >    $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> >    $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> >
> >    Before: 152.04 tps, 0.58 Mbit/s
> >    After:  303.07 tps, 1.51 Mbit/s
> >    For TCP_RR, there are 99.3% improvement, TCP_STREAM 160.3%.
>
> As it was pointed out earlier by Eric in v3, these numbers are moot since noone
> is realistically running such a setup in practice with 10k linear rules.

Yes, I am so sorry that I used a sarcastic comment.

I really should have asked if a real world case was using a lot of filters.
If so, maybe we can do something about that, for packets actually
going through these filters.

Thanks
