Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45219266D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgCYLAU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 07:00:20 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39821 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCYLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 07:00:20 -0400
Received: by mail-ot1-f67.google.com with SMTP id x11so1479561otp.6;
        Wed, 25 Mar 2020 04:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BTMHj3/tkhCnEmpB7LsQBwq/tFBT9+rcWHyey0JcTsk=;
        b=o0lB5icoT9YjDmTmdzb4KwKxDch4lBUbQTa6reOAk3TqpxKk813UAve+csOSKJar03
         5/lKMnu+yBHLC3zl7psKQluEEmzBQ7HPRiOGEwpFEI8uPLax6ekE16xgVhsT+/zrzIE9
         QwUVtTGiN5mcZ1t88bislKZPcgEKBnMoWRkYqMn9C7z0TjZib/eYi85FTHn1/lpKaOrT
         tXDFwTI9TFJiM4ATrYUiCR6hu1u7zjkM9TTYdbPsPjCsnRZWCVabpkWo2Yl/6R2PJ9PN
         7vNh0vhz+5UGbWg93GsbLYhGRkarR3bFFPdzWnZf3/fOA/TiuoWCXEZsCI9y+2uCcUgt
         cs8w==
X-Gm-Message-State: ANhLgQ2bGMMIFm4maq/MGabnfwYuSHuCMoPDWWErJbTd/d1n60BUmYEX
        kD7cAXPv2D1FWTROdlzo79FNWPIaymJSRma5RTc=
X-Google-Smtp-Source: ADFU+vusLssuzC7MoQ5z3Tds0SeKd1JjbmbIavrTauKWte1Ml0qg4+iT3jbm0HclqcTskKJmYmlIA3fOvG7fgr0FvsQ=
X-Received: by 2002:a9d:5c0c:: with SMTP id o12mr1990576otk.145.1585134019634;
 Wed, 25 Mar 2020 04:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200325093300.5455-1-geert@linux-m68k.org> <20200325104001.yekvtbrw3lvkhvta@salvia>
In-Reply-To: <20200325104001.yekvtbrw3lvkhvta@salvia>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 25 Mar 2020 12:00:08 +0100
Message-ID: <CAMuHMdWRKW3HoWk+drmbwKi6wArN9qjgjp=8NcyBK7P2kT=cLg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_fwd_netdev: Fix CONFIG_NET_CLS_ACT=n build
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

On Wed, Mar 25, 2020 at 11:40 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 25, 2020 at 10:33:00AM +0100, Geert Uytterhoeven wrote:
> > If CONFIG_NET_CLS_ACT=n:
> >
> >     net/netfilter/nft_fwd_netdev.c: In function ‘nft_fwd_netdev_eval’:
> >     net/netfilter/nft_fwd_netdev.c:32:10: error: ‘struct sk_buff’ has no member named ‘tc_redirected’
> >       pkt->skb->tc_redirected = 1;
> >             ^~
> >     net/netfilter/nft_fwd_netdev.c:33:10: error: ‘struct sk_buff’ has no member named ‘tc_from_ingress’
> >       pkt->skb->tc_from_ingress = 1;
> >             ^~
> >
> > Fix this by protecting this code hunk with the appropriate #ifdef.
>
> Sorry about this, and thank you for fixing up this so fast.
>
> I'm attaching an alternative fix to avoid a dependency on tc from
> netfilter. Still testing, if fine and no objections I'll formally
> submit this.

Thanks, that fixes the issue, too.
(Note that I didn't do a full build).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
