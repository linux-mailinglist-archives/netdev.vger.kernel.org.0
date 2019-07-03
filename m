Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06EFF5E01E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfGCIpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:45:49 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41888 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfGCIps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 04:45:48 -0400
Received: by mail-oi1-f196.google.com with SMTP id g7so1396178oia.8;
        Wed, 03 Jul 2019 01:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LyVZBS5jn++4pkEk1/rurUCjm6Iwr/LV+UH79/IW+aA=;
        b=EZ0zq+K66Xo7xswhkc90jMaA/VuZbkdyoFNeqR1KjSJhnRij4beJ7R04ieCoVqlWE9
         jiMkLSXL9AcOcN4ZDpjCGEWVg4rJQ7JtZAJzRdUHWBcxPLNJlHEJCcnjJaM6IgNyTDhZ
         y4e6Mgh2YeAjTvZA5D8JM6+jYezKa7QP1PBOm0Nps8YbLj4zwS4DHLnuoRnCKPxajBwF
         8GC2AcVMEfdxWax1Xj5x8vzdngzSYhr/rs7cEuO87pobq0GIg1nh/6RDVmpamV80lzQy
         fR7qSxkD2pol4hNhEM4Pb+0+anQigQB/Elhie8NYMXpxm7Wbb2Kd6o3PLCMQA04TREkL
         +riA==
X-Gm-Message-State: APjAAAVQkKHj9X4WbNxt+4AM5dfYzKCw8n6wW3XMFSXPXSQkeGu+rP9K
        TCgBFtQifSM2P8j075ujrB1DsoxR+mh17bX7I6A=
X-Google-Smtp-Source: APXvYqy6FsG08oXqoozMwxCegLkHJZaZKbf5DvRU1354+sTZCS91CFl1SbUhZ/GPT/+v4ndewHhmHHLsF7dBTBQ4gRU=
X-Received: by 2002:aca:c4d5:: with SMTP id u204mr5856840oif.131.1562143547995;
 Wed, 03 Jul 2019 01:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190703061631.84485-1-maheshb@google.com>
In-Reply-To: <20190703061631.84485-1-maheshb@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 3 Jul 2019 10:45:36 +0200
Message-ID: <CAMuHMdUSz7cA7+TSDLjb9Bwp6H5=G-q0O9uZk+EwMRKpNrrCBw@mail.gmail.com>
Subject: Re: [PATCH next] loopback: fix lockdep splat
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mahesh,

s/lockdep/rcu/ in the subject.

On Wed, Jul 3, 2019 at 8:16 AM Mahesh Bandewar <maheshb@google.com> wrote:
> dev_init_scheduler() and dev_activate() expect the caller to
> hold RTNL. Since we don't want blackhole device to be initialized
> per ns, we are initializing at init.
>
> [    3.855027] Call Trace:
> [    3.855034]  dump_stack+0x67/0x95
> [    3.855037]  lockdep_rcu_suspicious+0xd5/0x110
> [    3.855044]  dev_init_scheduler+0xe3/0x120
> [    3.855048]  ? net_olddevs_init+0x60/0x60
> [    3.855050]  blackhole_netdev_init+0x45/0x6e
> [    3.855052]  do_one_initcall+0x6c/0x2fa
> [    3.855058]  ? rcu_read_lock_sched_held+0x8c/0xa0
> [    3.855066]  kernel_init_freeable+0x1e5/0x288
> [    3.855071]  ? rest_init+0x260/0x260
> [    3.855074]  kernel_init+0xf/0x180
> [    3.855076]  ? rest_init+0x260/0x260
> [    3.855078]  ret_from_fork+0x24/0x30
>
> Fixes: 4de83b88c66 ("loopback: create blackhole net device similar to loopack.")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Thanks, that got rid of the rcu splat.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
