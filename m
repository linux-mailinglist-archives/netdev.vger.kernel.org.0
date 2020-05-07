Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7014C1C8E2F
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEGOOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgEGOOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:14:49 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0528C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:14:48 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id d197so2993794ybh.6
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWXFHNhxW9GiEnoFWJkxmRuRQFcUSq3yL2fyIJnlvGs=;
        b=ba7K4+GIcPqLI6MUIfvAlLOvDZ7vp9iE1T7j6+rRWAXc9S56dxIGSNBBhv/4VflE3G
         dNgAWUvQ26eYuBtrKbJS2aZP8Bbgqc4ld3vRkgymXm5NTOm3zb7+mLCK2hgarINg49y5
         8pEbOZCJOMt+vyBJBh/27d1S5WF0UyYZMtlQ50DBfdaVqPTk69l74GCLLLnm4Xrpv2bG
         yRh5sdQJhjF/vRgTo6C4U9GW8lw5ydtR6tfWYqSyZS5hwbBfNLjYEOu+dNFjJYf2S0b0
         Ejkmwg6jD45OFNVLqbnfynUa9WbAewBYLB//CpPzoYt2bb+oCYj14NsQIABXu+HfxapN
         rv5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWXFHNhxW9GiEnoFWJkxmRuRQFcUSq3yL2fyIJnlvGs=;
        b=A4ZkYAyMiMelo1yrVR3jxAk6O5e6R7579JUMTA+VOgQ/8vl77Wnn9ikKewtkW+w4xy
         1jd5Hiw8QRHStfTr+OkeFjvFo4jAF2p1aZn1VbF/GtuxP7Wj3p3eJejHG21lHHxirPH1
         j80SKQbtnEB6VOLfdYdYy/D9FXbrx7GSs+j+4HiT0RRBtgET3Oe86e5Hj1mC1ECW/3he
         AktnivpF3J25u0LBOYrWrrpckOxbDAawkTO2+6p8SPeHotmBw8//XhIzRCBS/NpMKPRS
         yE0Ssj3V7392WJ6B+LCy9m9V4GyIuusexLToD4JUHDizvYGODHrD8ZTnL+Ty7akHKZ01
         2gyQ==
X-Gm-Message-State: AGi0PuY79Ndx705+V7jvCwzM/SgPADlzW0sGvl3oDCwRMv9V+znqfm9d
        /HpfczI86sE9BQnyTXop/7Sdv642mPBSbzTSRpK3Gw==
X-Google-Smtp-Source: APiQypJWQ9nmQispmbPSfnw1R6LWB/aMBfhyGhE7Ng5GzYCOPEdDontCYqWWJA9wd7qs/g5PT4ZxfAA0hbV+KLJ0npo=
X-Received: by 2002:a5b:58a:: with SMTP id l10mr23616236ybp.173.1588860887763;
 Thu, 07 May 2020 07:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200507030830.GA8611@toolchain> <CADVnQym+O5tgCyRO+MJopXzwcxsGGkCpTpdX648fTsAjMZO3Gw@mail.gmail.com>
In-Reply-To: <CADVnQym+O5tgCyRO+MJopXzwcxsGGkCpTpdX648fTsAjMZO3Gw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 May 2020 07:14:36 -0700
Message-ID: <CANn89iKEKWQJyPoWB5DassdbYUCLjy6hNCKCd3=jA_7J3RzJTw@mail.gmail.com>
Subject: Re: [PATCH] tcp: tcp_mark_head_lost is only valid for sack-tcp
To:     Neal Cardwell <ncardwell@google.com>
Cc:     zhang kai <zhangkaiheb@126.com>, Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 6:58 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, May 6, 2020 at 11:09 PM zhang kai <zhangkaiheb@126.com> wrote:
> >
> > so tcp_is_sack/reno checks are removed from tcp_mark_head_lost.
> >
> > Signed-off-by: zhang kai <zhangkaiheb@126.com>
> > ---
>
> Nice clean-up, thanks.
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
>
> As Eric noted in previous threads, this clean-up is now possible after:
>
> 6ac06ecd3a5d1dd1aaea5c2a8f6d6e4c81d5de6a ("tcp: simpler NewReno implementation")
>
> As Yuchung noted, the tcp_mark_head_lost() function is not used today
> when RACK is enabled (which is by
> default).
>
> neal

Yes, I was hoping for a bit more detailed changelog, it always helps
for future reference.

Thank you
