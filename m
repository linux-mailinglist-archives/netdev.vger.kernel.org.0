Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B818493005
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343787AbiARVcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:32:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60850 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343490AbiARVco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:32:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3EA00CE19F4;
        Tue, 18 Jan 2022 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E80CC340E0;
        Tue, 18 Jan 2022 21:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642541561;
        bh=+Lop5S91fRlLmWbmodfTUKU3Hh1qgGucRzozCDUPOg0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l4k5mRVrA4OUuQm0qoAbSO/nYe67jXYf7Wip286oq0DkJ3vZsHKK2kWBxSTGoBgo/
         WKquSF6qdlqHnx7lQwKFuMlTjxtyaGBLz2zFNXwhStVHPHPcg9hYy1BBWcLB2RqUHC
         Uuyn8JcGK36O6Y4KWySsoIjlE+ee+V0HHCGkFG/74VJ0c+IW7qM03zT6XFGd14m7yc
         XCw/FOYLgJFTvPGokOKFiNGvqwidpC2X7V8gYVYagGIxaRPKtEVYZhRPdWvRs6Ey9C
         NQFEgTICgODKGOqy+7oeOYFJ0TgSGMVWZqfrN1v72mr1tZ7VKR3gbUxlNfgrzI5DTA
         yLB7Y9QWC1Qlg==
Received: by mail-wm1-f48.google.com with SMTP id e9-20020a05600c4e4900b0034d23cae3f0so1321375wmq.2;
        Tue, 18 Jan 2022 13:32:41 -0800 (PST)
X-Gm-Message-State: AOAM533JLPoDsUgYUeEIoKVI4eKuiBkKy4wnbbDJazZp19HM2/Nea0jx
        oBU5aiGU5S5TjtUCrcrlDOlkD8ib5LqbXire+2s=
X-Google-Smtp-Source: ABdhPJz9ba5Z59vwHf4ieyFBo2oiBMaUU4OMn6GvsgQl1eKmx2DaVto6kekEzVEPJGh9YFArfblpSWgPUDZutiA/Yw0=
X-Received: by 2002:a5d:6d85:: with SMTP id l5mr11451237wrs.447.1642541559888;
 Tue, 18 Jan 2022 13:32:39 -0800 (PST)
MIME-Version: 1.0
References: <20220118102204.1258645-1-ardb@kernel.org> <20220118130313.411fb05c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118130313.411fb05c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Jan 2022 22:32:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFCWZ7sx-5_bRNv32OxLBsTSVGdqqzYSJXQtFAipQWmig@mail.gmail.com>
Message-ID: <CAMj1kXFCWZ7sx-5_bRNv32OxLBsTSVGdqqzYSJXQtFAipQWmig@mail.gmail.com>
Subject: Re: [PATCH net] net: cpsw: avoid alignment faults by taking
 NET_IP_ALIGN into account
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, linux-omap <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 at 22:03, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 18 Jan 2022 11:22:04 +0100 Ard Biesheuvel wrote:
> > Both versions of the CPSW driver declare a CPSW_HEADROOM_NA macro that
> > takes NET_IP_ALIGN into account, but fail to use it appropriately when
> > storing incoming packets in memory. This results in the IPv4 source and
> > destination addresses to appear misaligned in memory, which causes
> > aligment faults that need to be fixed up in software.
> >
> > So let's switch from CPSW_HEADROOM to CPSW_HEADROOM_NA where needed.
> > This gets rid of any alignment faults on the RX path on a Beaglebone
> > White.
> >
> > Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")
>

I suspect so, as that patch removes a call to
__netdev_alloc_skb_ip_align(), and replaces it with
page_pool_dev_alloc_pages() et al
