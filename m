Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD3028AAAD
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgJKVVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgJKVVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 17:21:43 -0400
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [IPv6:2001:470:1f0b:3b7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F245DC0613CE;
        Sun, 11 Oct 2020 14:21:41 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 553363FEE; Sun, 11 Oct 2020 23:21:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1602451295;
        bh=DWSdWIEFcj59lt2Dg2oaxr8ttrmTzhkrS26U+qIS/Ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=3D12xxrIHVU0FmvNsrY5ormL7Pu69SbMGOD+gUWYA30k0XbfV8LQdUZY9kkPFzAUi
         Fv1FL0bphwaFFx8Sg3YckaaSwUwM/SYp3ffadbXsrpuVZm2/8poPEmIcvlA/oK//Zl
         SttL+yYij3xrDDHMF1cjrS1dZW5qgWPuveFQxjGKu8sesOZrdcRo7ud746hSKwQkDP
         ThEq2NLe6vCQ7ctrLRXh0tCb5ljf7NKoeuYeRt77ccanpETHe7f1bvUAIcspaM73cL
         vjAuvQcBNFz+lx3F+HdWTRHF+dSN2+fJtNkR/dLCQWJHwBVC+hdDcJ/vOqioJ27PDb
         yo1OwT6Zw0A2On+bA4KwlFltlHnt8uE+hFM/U1AylRnXDf3MtOHYmFA5UH/Ng9oUrJ
         XfRmc/SDKbFyfrmdXQD5GjOelEJhdq63oLNb0jM4ehXQGQ5kFEF0pZeoZVjI9J1CzF
         VFSSur6PH0qyQg0K2KCuOMvPzqPpKVLKDQlF9/OweNG7H4KTw3Wh9GQODOXqrG75WT
         GMrTA3m0/8Ye1hp4lX1wdBegZLFJ1fqDUeCXkv6IziM9xa7jJcM4OhbiTLPjGC/TD+
         p/XVU9s9e4kh9MvS3FwRt/4tFrzBHYfV4hNJEyzVq3coxnqifUvWSPEiQ5Oiu0MV86
         Dr7x2E3zw2Tl2fNMgobX3Y8A=
Date:   Sun, 11 Oct 2020 23:21:35 +0200
From:   Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Philip Rischel <rischelp@idt.com>,
        Florian Fainelli <florian@openwrt.org>,
        Roman Yeryomin <roman@advem.lv>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: korina: free array used for rx/tx descriptors
Message-ID: <20201011212135.GD8773@valentin-vidic.from.hr>
References: <20201011113955.19511-1-vvidic@valentin-vidic.from.hr>
 <CA+FuTScdX+kN_XHJiY9YCst6JTQHZ0g28XYakhcK92Oo2Kp5vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScdX+kN_XHJiY9YCst6JTQHZ0g28XYakhcK92Oo2Kp5vw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 02:37:33PM -0400, Willem de Bruijn wrote:
> Slightly off-topic, but I don't fully fathom what goes on with this
> pointer straight after the initial kmalloc.
> 
>         lp->td_ring = (struct dma_desc *)KSEG1ADDR(lp->td_ring);

KSEG1ADDR should rewrite the memory address into the uncached region
for memory mapped I/O. Not sure if this would case problems for kfree
since there is another kfree on the fail path:

probe_err_register:
        kfree(lp->td_ring);

-- 
Valentin
