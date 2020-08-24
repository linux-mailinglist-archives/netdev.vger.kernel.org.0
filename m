Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4B9250A12
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHXUfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:35:39 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57707 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:35:39 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c583cc22
        for <netdev@vger.kernel.org>;
        Mon, 24 Aug 2020 20:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zmBVELd6Z/LZj3XKmllIQFy00Fg=; b=fuQY13
        xMhLh0wPQ6Kf34wKghOac8O8aab927uNkQ0/kYh5AalS2DyDRZ/EdQuI4ijgrNSV
        c73YFfFEXRVOuADU2s0NfPyfDqkfnU8fas2pXvErop8KmLnNP1eLnNr7hTSQvynt
        fr2+4ZYc9UxttxfEANhEtU4cBt6JDW4swpghWKxSGMmP1Sx5dVCcvh7NypTFoiGV
        6HACtULM/oczJCQ3ZMENpQ7CLJOYGCIGW6hGqRXO49XnozH+Tt8x12PtZMSmb6n4
        KiYMiygcdmgBXzRwjgKlqoIHUL4Fx2cUrgBfhjI/3YCsxI1XQEL5IV0vcTLZLmXC
        O06ywuxQP6Fz7SUQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e1a2010e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 24 Aug 2020 20:08:36 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id t13so8465209ile.9
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:35:35 -0700 (PDT)
X-Gm-Message-State: AOAM530Gkj7Lra82bPsCu9S6gqFEnKmfCfezmrM39Z9HGDsN6hXcdSl0
        l09xU2sCuMTJmSGpvPRqQ+uDCT+oFNpKR5Gg1L0=
X-Google-Smtp-Source: ABdhPJzP2JqYwYHTQhb2/JlF9/1FjEpn/jRxZqgXwpBceoA8zXQz1/F6TXOYWhDa/PwrSHI0i28gxbj8wK/nQ+B5f6w=
X-Received: by 2002:a92:cf09:: with SMTP id c9mr6788853ilo.38.1598301335140;
 Mon, 24 Aug 2020 13:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200824141519.GA223008@mwanda> <20200824200650.21982-1-Jason@zx2c4.com>
In-Reply-To: <20200824200650.21982-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 24 Aug 2020 22:35:24 +0200
X-Gmail-Original-Message-ID: <CAHmME9q_5Vv8La7RR2XU48LFafEsGa1VWC1tZ+SWjcww_uyJZw@mail.gmail.com>
Message-ID: <CAHmME9q_5Vv8La7RR2XU48LFafEsGa1VWC1tZ+SWjcww_uyJZw@mail.gmail.com>
Subject: Re: [PATCH net] net: read dev->needs_free_netdev before potentially
 freeing dev
To:     Netdev <netdev@vger.kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 10:07 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> I believe that the bug Dan reported would easily be fixed as well by
> just setting dev->needs_free_netdev=true and removing the call to
> free_netdev(dev) in wg_destruct, in wireguard. If you think that this is
> the more proper fix -- and that the problem actually isn't this flow in
> dev.c and any code that might hit this UaF is wrong -- let me know and
> I'll send in a patch for wireguard instead.

I think ppp might be hit by the same bug, actually.
netdev_run_todo->ppp_dev_priv_destructor()->ppp_destroy_interface()->free_netdev(dev),
followed by "if (dev->needs_free_netdev)".
