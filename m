Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE84150E9F
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgBCRaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:30:06 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:40151 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbgBCRaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:30:06 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4b6bfc2f
        for <netdev@vger.kernel.org>;
        Mon, 3 Feb 2020 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=28t6sotqJukaFxRw171I3Cn6DxE=; b=WvadvR
        awCQFfOXiFBAGpb31NVzMFCrXb+RoX72vuoryKggzxx1QcQpFUnNLrAbcsf2t2lN
        74iVHgdLpQqKJAMesGaoqwYmVaicQ1OKg+ATPNsM7OF0zFtBr7hlZ+U5zptJdmfJ
        SD2NuAnoIfTY/8ydEGDfj2mUp8dfVCVuOa3rUK8MVBw2bDk7+WIeZ/9Hpx30IFX7
        TF0niHnMDQx+jsn4JltcqETWqsgryDOG0Vg/jSsXdRMcDOjbaSTj9+WDikDs7qQS
        vAYcCwoxvg7mlQ5DSWNv8hQaIiKgqGrBM5yFqTNFw6UbNR/qPOuR5pUlBgcG3LIX
        TGYiwMQjAyxeDkaQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1438a7de (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 3 Feb 2020 17:29:22 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id b18so15557753oie.2
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 09:30:04 -0800 (PST)
X-Gm-Message-State: APjAAAVHlHOTTL4FtoqbMF3bnz9oOapIGZleLaslaxgNmQq/+oNv1LfX
        cgXJvVmCPoeZx7BTAD5Il/gjYnct00ZYxKfA8D0=
X-Google-Smtp-Source: APXvYqzIoRHqNoLv7FbvVlnzWCsh7Adxxc5E2xveI4Q5n+MliMNd+hhEYP6mEFieDEAx6R0WAg1mk5zzcMJjebtbYe4=
X-Received: by 2002:aca:2109:: with SMTP id 9mr77511oiz.119.1580751003175;
 Mon, 03 Feb 2020 09:30:03 -0800 (PST)
MIME-Version: 1.0
References: <20200203171951.222257-1-edumazet@google.com>
In-Reply-To: <20200203171951.222257-1-edumazet@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 3 Feb 2020 18:29:52 +0100
X-Gmail-Original-Message-ID: <CAHmME9r3bROD=jAH-598_DU_RUxQECiqC6sw=spdQvHQiiwf=g@mail.gmail.com>
Message-ID: <CAHmME9r3bROD=jAH-598_DU_RUxQECiqC6sw=spdQvHQiiwf=g@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: fix use-after-free in root_remove_peer_lists
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Mon, Feb 3, 2020 at 6:19 PM Eric Dumazet <edumazet@google.com> wrote:
> diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> index 121d9ea0f13584f801ab895753e936c0a12f0028..3725e9cd85f4f2797afd59f42af454acc107aa9a 100644
> --- a/drivers/net/wireguard/allowedips.c
> +++ b/drivers/net/wireguard/allowedips.c
> @@ -263,6 +263,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
>         } else {
>                 node = kzalloc(sizeof(*node), GFP_KERNEL);
>                 if (unlikely(!node)) {
> +                       list_del(&newnode->peer_list);
>                         kfree(newnode);
>                         return -ENOMEM;
>                 }
> --
> 2.25.0.341.g760bfbb309-goog

Thanks, nice catch. I remember switching that code over to using the
peer_list somewhat recently and embarrassed I missed this. Glad to see
WireGuard is hooked up to syzkaller.

I've queued this up in my stable tree, and I'll send this back out in
a few days:
https://git.zx2c4.com/wireguard-linux/commit/?h=stable&id=3492daa8815770038c9da36382dc66cea76ad4fc

Jason
