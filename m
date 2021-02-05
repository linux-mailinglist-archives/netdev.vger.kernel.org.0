Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3C0311373
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 22:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhBEVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 16:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhBEPBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:01:50 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13073C06178C;
        Fri,  5 Feb 2021 08:39:53 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m13so8336139wro.12;
        Fri, 05 Feb 2021 08:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=me3FTzSZcjdT1PtgwoMZ44tI5YCzuNgZ6Xp92yrSWsI=;
        b=chMzKh9krAIVQBkvSAjBKpWjzUixITFCXMcHcmhPA73u52j3zBYtIzvKm6tw0BOqpk
         urjGp6JT0FBojBuCxIZVxedw4TO+bif6EkvV4+LJtOLhNnP79lg+SNBTQQcLxLyBlEDG
         2Hr215ArgD2GJUbjNe5t0mVbzsAGyq8P6gQXy74VknBVk2P79NWzBh3LINJo+BkrYzaH
         AgOTgYH8H5UT6Jr8+GLeAa7iQ8V+oRq031I91NY7p8WwKce5FvA9y0zreg/USfaYrdTn
         FTix8/FvBQIkXZ9wjhICoHAkUWGKPkOwP9QCdSwuVzxwrAtmCzPv8w360fzHBtdH9+vr
         t2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=me3FTzSZcjdT1PtgwoMZ44tI5YCzuNgZ6Xp92yrSWsI=;
        b=OKN7lCBw0XC2wT8TAg8VEp45xRwGSNcqeL2s2dVT2rg0Oepa79F9HUwNHKRnym9hrG
         huVUJADbaUsCvokOMk9MMLpnFzC8PV6ZHNB5ZN758DK3zE9K3dzKri2g9iuHWr9DAuFC
         DIpN9Zv6zf7OLfG30tIMMeAlCQP7KdEJ3uX2T5QSdtGok7UozwvfHk8yetpMWO+BCxLQ
         JfN/iHgUEobZMe0wvbdIEtMcdsgfLf2R76cnz7ZH6Lqv7V3ptMyoVBe12xD07bkTtUel
         V6LRAaCDlItpVj9eJN66pC1AAMjZZf7GETZPBAG5Elus+rotvm25hBweF7MzzpKgO03v
         biXg==
X-Gm-Message-State: AOAM5300OVL/lOHsuwnIXxrxkZWeHggmTtdS/kN2eUn9wq6f6BihUKeB
        P5ntDf8tUou/TtVSQdvHrFA14WoIEzQP1OyURWw=
X-Google-Smtp-Source: ABdhPJyvzE1xjGUvO+f+OKFMTgJhKfcepV0Sxx1TJV6X1ZwKvB3DMuGm22+N/LLGi9tP9kI0mcBAk75bYhP+4qbk/BA=
X-Received: by 2002:a5d:65ca:: with SMTP id e10mr6118874wrw.166.1612543191744;
 Fri, 05 Feb 2021 08:39:51 -0800 (PST)
MIME-Version: 1.0
References: <CAGngYiUgjsgWYP76NKnrhbQthWbceaiugTFL=UVh_KvDuRhQUw@mail.gmail.com>
 <20210205150936.23010-1-sbauer@blackbox.su>
In-Reply-To: <20210205150936.23010-1-sbauer@blackbox.su>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 5 Feb 2021 11:39:40 -0500
Message-ID: <CAGngYiUwzzmF2iPyBmrWBW_Oe=ffNbpxrZSyyQ6U_kLmNV56xg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Andrew Lunn <andrew@lunn.ch>, Markus.Elfring@web.de,
        Alexey Denisov <rtgbnm@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        "maintainer:MICROCHIP LAN743X ETHERNET DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:MICROCHIP LAN743X ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergej,

On Fri, Feb 5, 2021 at 10:09 AM Sergej Bauer <sbauer@blackbox.su> wrote:
>
> Tests after applying patches [2/6] and [3/6] are:
> $ ifmtu eth7 500
> $ sudo test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf

Thank you! Is there a way for me to run test_ber myself?
Is this a standard, or a bespoke testing tool?
