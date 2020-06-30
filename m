Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10E20EC06
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgF3DeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbgF3DeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:34:00 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1DFC061755;
        Mon, 29 Jun 2020 20:34:00 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l9so16416188ilq.12;
        Mon, 29 Jun 2020 20:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gft05NxUENPXKFTcU3ULPY4HOvG0ZoW35LjzI7t7EsQ=;
        b=kTIZrS2bbkCQ7MC1Ioc4nlAADj9SYiWwivDlq+RB9twRHHGlKmStcPpftWwWfKDgkW
         qehPwSB7++lnbpHwmWjCwq8j+4rRGMXKWs/ecVJnrN+/Jzk2iD/DhYlC31M3uVYfF+4m
         ZZ+mSTpTWV/e56wJ/Z6LsuAwinf8vUBo34Z5Bfmwym0/tKElIpzxXGju1TQtUZce8i7b
         4K3oaXAEaQ5hZvjfcR/BoPVAx28M1K25LJtQPvgQHCcIh3gEzKnECQ+1tyhHlRkn7yus
         DN/YOyHoxRE+2Isv02nB7xMYrxYxGs68Cjwr00Qd9IkCmEwNqpTKiCIfUf6/Phed+XHE
         nm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gft05NxUENPXKFTcU3ULPY4HOvG0ZoW35LjzI7t7EsQ=;
        b=ZACU2EXOgCXCi1b8j0KTg2s0ywY4TSE1j7f6PtoU7O/8wXDi3PhfIWcD1EV5NS8b8X
         USmtalIq/xoxHUYqntOCWV30I8yOmSP9o/ch5+pPcqPpN13q9DU0XGypTQWsuXIJO/DT
         /vY6LYz48A50o7if69jpdAfRNsRPOSBAZaPA+iH0LzedYEevUGQvniDFO2mDVTZ9AKHW
         efkyu3dZ9GD3TR+VrvErKZkfRprMvm/+huOFTbz9IDr2yh3Uy9+x8axqpdNyAcxMIGKY
         T4L3vWdM2KBq8A65Nj6dVvbBGtvzQIDkca0iy59uGVqbYA/D8W+HJenIulPeCbpPNTsm
         njCQ==
X-Gm-Message-State: AOAM532YWlLvhSblSlN/K30Ow08LZG6JGr3f9obCW33LhaKUG4NhO2zP
        xZWWki/WpTPJV60nNUmpQ85I31LNwdzP7jV+lJE=
X-Google-Smtp-Source: ABdhPJyNp5+HJ0f+g9oh5UeEYmKAPB5B8NvhjqDCBPZP8YaYPdsIM43A+IrZRf4hWcPMLl/aAlqnUN7pmuqqW5P2zI4=
X-Received: by 2002:a05:6e02:147:: with SMTP id j7mr724676ilr.22.1593488039570;
 Mon, 29 Jun 2020 20:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006eb8b705a9426b8b@google.com> <CAHmME9qOR4h7hsQ4_QuztPN+6w4KcoaYNs75yJn=L3S2Mhq9rA@mail.gmail.com>
In-Reply-To: <CAHmME9qOR4h7hsQ4_QuztPN+6w4KcoaYNs75yJn=L3S2Mhq9rA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Jun 2020 20:33:48 -0700
Message-ID: <CAM_iQpVxrUinOBjqaw4U5u9PZZSTDY=FgSAsBxMju8uu=F5jfQ@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in netdev_name_node_lookup_rcu
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     syzbot <syzbot+a82be85e09cd5df398fe@syzkaller.appspotmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 6:17 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hey Cong,

Hi, Jason

>
> I'm wondering if the below error is related to what you've been
> looking at yesterday. AFAICT, there's a simple UaF on the attrbuf
> passed to the start method. I recall recently you were working on the
> locking in genetlink's family buffers and wound up mallocing some
> things, so it seems like this might be related. See below.

Yeah, very likely it is the same bug I have fixed. I will close
this together with others.

Thanks.
