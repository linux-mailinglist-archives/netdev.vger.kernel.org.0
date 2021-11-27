Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D953745FC68
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 04:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352057AbhK0DoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 22:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhK0DmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 22:42:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0990EC08ECA9;
        Fri, 26 Nov 2021 18:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C300060B0C;
        Sat, 27 Nov 2021 02:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2850DC53FC9;
        Sat, 27 Nov 2021 02:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637980342;
        bh=k8LPEgdOrY1JwBzenXCurgiwoYPg9UZhK//hAysuHbY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QyUuswkQ+eRwMDpaAxk+9wHrqAQtw8Za8PaRwO8j5EQU2tilOgrI7TmGd/oYtQ0Tr
         6bhZcLjDpSAp8hyJQB+v/kjIelFjFgai9/LgZSrxuNs+4lwAuZzPh9bCQiX9tojwoZ
         gNIAKi1krvekP15uVvzSoSYgngMJRi3jVu5eO/pz9LcDcymCBj7HZeV0vqkM9+1PcC
         boiD+qRiOgCWDTO8vWi/QYP24t6/s1ecbPdro08wGYXPQUdw6guyKJcw77kXaY8BJR
         9wpxi4ySxl30aHZs0Dk0KpE4CIlJ+IQ/Q8hrF/d/hb8d7sYh+2KlCi1KugSfyv9dW/
         n+2jH4HDiFp4g==
Received: by mail-yb1-f176.google.com with SMTP id f186so24722168ybg.2;
        Fri, 26 Nov 2021 18:32:22 -0800 (PST)
X-Gm-Message-State: AOAM533dgzq9f6UkKEgFp8Q/PvBaURux/i3xUNHccl1ow0T6Zt5w69z1
        aQziXWIO6I5MKB/4DXtaNi/kRiEnnd4Hwh5NJx0=
X-Google-Smtp-Source: ABdhPJwWnYS34Lk4+MdywnVNl1ggmxTzMSgFmz1hcYDbfnrnw37rp1Dxgp2qjPYdfrN6sh5bYfHyYF9rlBIPcm1XVuM=
X-Received: by 2002:a25:324d:: with SMTP id y74mr20085550yby.526.1637980341173;
 Fri, 26 Nov 2021 18:32:21 -0800 (PST)
MIME-Version: 1.0
References: <20211123230632.1503854-1-zenczykowski@gmail.com>
In-Reply-To: <20211123230632.1503854-1-zenczykowski@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Nov 2021 18:32:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7AYkW5-5Labsj9ziFQzcEaqcZU0xCqTfhqJhNJf8kuxA@mail.gmail.com>
Message-ID: <CAPhsuW7AYkW5-5Labsj9ziFQzcEaqcZU0xCqTfhqJhNJf8kuxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net-bpf: bpf_skb_change_proto() - add support
 for ipv6 fragments
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Lorenzo Colitti <lorenzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 3:06 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> IPv4 fragments (20 byte IPv4 header) need to be translated to/from
> IPv6 fragments (40 byte IPv6 header with additional 8 byte IPv6
> fragmentation header).
>
> This allows this to be done by adding an extra flag BPF_F_IPV6_FRAGMENT
> to bpf_skb_change_proto().
>
> I think this is already technically achievable via the use of
> bpf_skb_adjust_room() which was added in v4.12 commit 2be7e212d541,
> but this is far easier to use and eliminates the need to call two
> helper functions, so it's also faster.
>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Please add a selftest to exercise the new flag.

Thanks,
Song
