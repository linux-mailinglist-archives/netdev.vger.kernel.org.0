Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08D6B2C00
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfINPno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:43:44 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36085 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfINPno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 11:43:44 -0400
Received: by mail-oi1-f195.google.com with SMTP id k20so5084916oih.3
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 08:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XVhjnFtmv+0TBKm5U0qSsCzRBFNq5CmxVWO5VgyaA5U=;
        b=fFDFeG1qNjCVAsfppnIWc0SVG+J395rR8Fy9DioGkLjNQlTVFKjJ2YawjnJTde8glw
         +dTj7uIYEA8mr+rpp7NHi7VKyvPKLALGALXrIp7mqVWBDBIfnmKjTD2nMv6XZFnN8ph0
         5Rhf1peQwSv/5V4jF/BDBwwplixFF4z7kIMfNKIrH6u9996IMqRnV4kYeGVUSGnIlxDr
         TNYat2cyr/uAWllVR0vL1ZPBBoZviQGfM4EPYwbdH5oqqAiPGD4Ytmpf7JgFeElJx2y2
         pluMov6wy40qU0c+C2xHaWQDElp7qg/pcV/0gT2n0tYDmwEDpUsQPRwumU2Yduy9H/8/
         l65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XVhjnFtmv+0TBKm5U0qSsCzRBFNq5CmxVWO5VgyaA5U=;
        b=hprqKQfeZHPEy6m049aSxR3y9ytqFfW+V1o0rBmEWkbGXov9a3LzBU+qK3GDiTw949
         clXrSpV6wgS/yadnH/jtYXOSFXxGlfbj6mXlldOOCy4b+fCA40iZf8XIanxuLLzNmbjN
         IbztI6vVFLEDwOhCVEVcabOotJUZMrAHZLCniYcUl9NFy9teqRwGcpu/CL6+ATsMzjCt
         HowhiCR1/6NLp6CGbbNRalQINg2nzZm6A4yappMebZ7DS2vTSnxBd38Z1nzPUlXfSOfS
         0i9ERn8lBkOk0EzoNWobsVWzI+R1KarA2PaKfw8v5dlV3H8FM3MoudEZJAxj3yYADqpe
         pV/g==
X-Gm-Message-State: APjAAAVpjijwpHCQB+uLGMhOREj5UuWkOYwHH4RgKNVRwDsK2Ts9zQMC
        rGVqbbXctdoLTzpaag2BYroJpfc5otD8bfgAgseapA==
X-Google-Smtp-Source: APXvYqw7zYcnzSYkbukW2ZDex7/nrVTVB5DUs1s8FP9oYFFVVZR1ohbjO1scPEpButGX0yinjRGjIHmgWZwGfKpWum4=
X-Received: by 2002:aca:c505:: with SMTP id v5mr7448535oif.79.1568475822866;
 Sat, 14 Sep 2019 08:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190913232332.44036-1-tph@fb.com>
In-Reply-To: <20190913232332.44036-1-tph@fb.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 14 Sep 2019 11:43:25 -0400
Message-ID: <CADVnQynfwJ8HWstz-HAa7AMOGRhDC7nqKwMCKpe2Fvm7kUQgkA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] tcp: Add TCP_INFO counter for packets received out-of-order
To:     Thomas Higdon <tph@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 7:23 PM Thomas Higdon <tph@fb.com> wrote:
>
> For receive-heavy cases on the server-side, we want to track the
> connection quality for individual client IPs. This counter, similar to
> the existing system-wide TCPOFOQueue counter in /proc/net/netstat,
> tracks out-of-order packet reception. By providing this counter in
> TCP_INFO, it will allow understanding to what degree receive-heavy
> sockets are experiencing out-of-order delivery and packet drops
> indicating congestion.
>
> Please note that this is similar to the counter in NetBSD TCP_INFO, and
> has the same name.
>
> Also note that we avoid increasing the size of the tcp_sock struct by
> taking advantage of a hole.
>
> Signed-off-by: Thomas Higdon <tph@fb.com>
> ---
> changes since v4:
>  - optimize placement of rcv_ooopack to avoid increasing tcp_sock struct
>    size


Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Thomas, for adding this!

After this is merged, would you mind sending a patch to add support to
the "ss" command line tool to print these 2 new fields?

My favorite recent example of such a patch to ss is Eric's change:
  https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/misc/ss.c?id=5eead6270a19f00464052d4084f32182cfe027ff

thanks,
neal
