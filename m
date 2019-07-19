Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909AF6E12B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 08:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfGSGty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 02:49:54 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33629 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGSGty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 02:49:54 -0400
Received: by mail-qt1-f194.google.com with SMTP id r6so25710925qtt.0;
        Thu, 18 Jul 2019 23:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zfGToBds18suaPosWKE/2T3izyW6zSmNZU6D/7RAmgE=;
        b=dRlMdD6mtIvR0/lIBO7qZ8eZanxbmLa9LS2pl3Gk2gRHle7GnFA9x8Ufdu80b+Bbzo
         qOWVmyEMaIBhUTSSO1WpQ6KPP/2QwjjNaAJDcrGCisdBwfrZqJtur+qLDZ9j/Roe/eqR
         kk7k3sVm/NEOkCkeBzijehXxwH0H84URbgl5yC0n/x8v5YPWruBTsjVvFUQJ3z7fJFsu
         zVnTxBHJqbZfCunETl7C/pFS8HTsoBBje3kPnkPioTLEP3BsGettdIwC0fyV4A4F93Mg
         GriaJ0nSVs9Al8Y6EhspnSbThYjrLWgD98KwG9gkDDTRBgwQzVR9r4D0BMaSoJnQAVkP
         6J9g==
X-Gm-Message-State: APjAAAVduD1myj4y0lCl/BYHzITkCbSYixglICsUZRY0TYBJek3R8pTm
        aiL/sMP8Fm66Bmee924+5nBE+F3nZivItCIAli8=
X-Google-Smtp-Source: APXvYqyNjTc42pQ1sKjehQS1untTD4duEeurrsI/kTdOBEK71qAdbybFsNiZBlVojBbGxe4c1/U/qrE8abUEnZ12d+8=
X-Received: by 2002:a0c:ba2c:: with SMTP id w44mr35836449qvf.62.1563518993465;
 Thu, 18 Jul 2019 23:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190710080835.296696-1-arnd@arndb.de> <20190718190110.akn54iwb2mui72cd@salvia>
 <20190719063749.45io5pxcxrlmrqqn@salvia>
In-Reply-To: <20190719063749.45io5pxcxrlmrqqn@salvia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Jul 2019 08:49:37 +0200
Message-ID: <CAK8P3a0XzP3Oj9rZGBbcj8=na94QgUJiLNsNPxCBC_xK7O6AoQ@mail.gmail.com>
Subject: Re: [PATCH] [net-next] netfilter: bridge: make NF_TABLES_BRIDGE tristate
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>, wenxu <wenxu@ucloud.cn>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 8:37 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Thu, Jul 18, 2019 at 09:01:10PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jul 10, 2019 at 10:08:20AM +0200, Arnd Bergmann wrote:
> > > The new nft_meta_bridge code fails to link as built-in when NF_TABLES
> > > is a loadable module.
> > >
> > > net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_eval':
> > > nft_meta_bridge.c:(.text+0x1e8): undefined reference to `nft_meta_get_eval'
> > > net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_get_init':
> > > nft_meta_bridge.c:(.text+0x468): undefined reference to `nft_meta_get_init'
> > > nft_meta_bridge.c:(.text+0x49c): undefined reference to `nft_parse_register'
> > > nft_meta_bridge.c:(.text+0x4cc): undefined reference to `nft_validate_register_store'
> > > net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_exit':
> > > nft_meta_bridge.c:(.exit.text+0x14): undefined reference to `nft_unregister_expr'
> > > net/bridge/netfilter/nft_meta_bridge.o: In function `nft_meta_bridge_module_init':
> > > nft_meta_bridge.c:(.init.text+0x14): undefined reference to `nft_register_expr'
> > > net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x60): undefined reference to `nft_meta_get_dump'
> > > net/bridge/netfilter/nft_meta_bridge.o:(.rodata+0x88): undefined reference to `nft_meta_set_eval'
> > >
> > > This can happen because the NF_TABLES_BRIDGE dependency itself is just a
> > > 'bool'.  Make the symbol a 'tristate' instead so Kconfig can propagate the
> > > dependencies correctly.
> >
> > Hm. Something breaks here. Investigating. Looks like bridge support is
> > gone after this, nft fails to register the filter chain type:
> >
> > # nft add table bridge x
> > # nft add chain bridge x y { type filter hook input priority 0\; }
> > Error: Could not process rule: No such file or directory
>
> Found it. It seems this patch is needed, on top of your patch.

Right, makes sense.

> I can just squash this chunk into your original patch and push it out
> if you're OK witht this.

Yes, please do.

      Arnd
