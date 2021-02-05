Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C8C310132
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhBEAAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhBEAAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 19:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E838164FB1;
        Fri,  5 Feb 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612483208;
        bh=6y7bv715PH1oL4pQr0YSXZSZ/aHTrBXnXi4uHWlihc4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=byObGgNODnFGVcoi72CwdYsiD49mzorqO3nrcyldlF2ALddhCWf1SLc6lQ9OCFYrW
         wNjqzkADA0Qg23lwpEAFiSwA9JkWGUsQnOb3smLzo0VxMDLZ3qgn8PrkDkkfBu8sui
         hlLuz7ZxneH7zt3GDI5oVpbCzrQeH/D9kcjOur5U9tgEaPpWyO/9UYxV6S5dqZDw3R
         AqZynorpnXGkyCN/wCoXRbKg0bQjE/1chdrIbVq0HhlCgI2CzLQe5Qgp+4h6KKjIG/
         AaevBVZ4zT18MLj0ew+yE0/3ym6SwF4ySnqfjCByn2gHUsuzyf02it13lf3u2NqltD
         CKQR3vF7Gfllg==
Date:   Thu, 4 Feb 2021 16:00:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy@google.com>
Cc:     Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@gmail.com>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for
 receive zerocopy.
Message-ID: <20210204160006.439ce566@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOFY-A0_MU3LP2HNY_5a1XZLZHDr3_9tDq6v-YB-FSJJb7508g@mail.gmail.com>
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
        <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
        <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com>
        <20210125061508.GC579511@unreal>
        <ad3d4a29-b6c1-c6d2-3c0f-fff212f23311@gmail.com>
        <CAOFY-A2y20N9mUDgknbqM=tR0SA6aS6aTjyybggWNa8uY2=U_Q@mail.gmail.com>
        <20210202065221.GB1945456@unreal>
        <CAOFY-A0_MU3LP2HNY_5a1XZLZHDr3_9tDq6v-YB-FSJJb7508g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 15:03:40 -0800 Arjun Roy wrote:
> But, if it's an IN or IN-OUT field, it seems like mandating that the
> application set it to 0 could break the case where a future
> application sets it to some non-zero value and runs on an older
> kernel.

That usually works fine in practice, 0 means "do what old kernels did /
feature not requested", then if newer userspace sets the field to non-0
that means it requires a feature the kernel doesn't support. So -EINVAL
/ -EOPNOTSUPP is right. BPF syscall has been successfully doing this
since day 1, I'm not aware of any major snags.

> And allowing it to be non-zero can maybe yield an unexpected
> outcome if an old application that did not zero it runs on a newer
> kernel.

Could you refresh our memory as to why we can't require the application
to pass zero-ed memory to TCP ZC? In practice is there are max
reasonable length of the argument that such legacy application may pass
so that we can start checking at a certain offset?

> So: maybe the right move is to mark it as reserved, not care what the
> input value is, always set it to 0 before returning to the user, and
> explicitly mandate that any future use of the field must be as an
> OUT-only parameter?

