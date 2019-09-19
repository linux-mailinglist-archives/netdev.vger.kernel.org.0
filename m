Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE74B798E
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390340AbfISMem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:34:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44481 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390333AbfISMel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:34:41 -0400
Received: by mail-qk1-f195.google.com with SMTP id i78so3114197qke.11;
        Thu, 19 Sep 2019 05:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Uyhy6Uax8YQF7rWKudmdZRWa5YwRk9haOx429+okoM=;
        b=gcuL/s5GFV01y9WW388I08iuExeSiWgxvjuGQQ6YI26IQ/9UK5jZx4tgb9wcH/gMlG
         u/NwKEcTLMeQkiA8vI+mhOfOgq2Y4o6aI76WM/BbW5UATF5B25Z1eCD/aEM5rVrafRSz
         A/R1StzLJsmY4JPHtAZlJr1oNmqO5ETgu6niCuSn4lXJBJYImr+1la93OFhJS0q9OFAR
         4etYfeQfz1MfWrJRoinqJ/s8G9Np42W/mgvwr0cHkClopnZVAPKtSbWy09+5AZNJFBzw
         LKGZK/d+ezxPP6EGKMab9EVbJvEsdYzNIr25kDV6Yu3VCT7VqFbHihXwX3+5G9JkweCg
         vVvw==
X-Gm-Message-State: APjAAAVUi+rhSMD8ICl49JQx9r8V/K0JJ7VegxAbZKlLXfv+CEVQYU+A
        xwhL+SqImqDjBc8FIo6aiPJUnaIvqyoR0gXazqw=
X-Google-Smtp-Source: APXvYqxsF0NeJ+J6q20ijNnid8HRUOX+T6xU0Euwl3Qp0xXUeXxuvP+eu08WL+MyzK8Ts+WBX7qXW2dB2Aa8EsOeWcU=
X-Received: by 2002:ae9:f503:: with SMTP id o3mr2579143qkg.3.1568896479756;
 Thu, 19 Sep 2019 05:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190918195454.2056139-1-arnd@arndb.de> <BN8PR12MB3266E044DDF00F227B9B191CD3890@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266E044DDF00F227B9B191CD3890@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 19 Sep 2019 14:34:23 +0200
Message-ID: <CAK8P3a2QXMSPdDSQTx_MrgOhg4XjMp=Qre1LNp7iX2uKzdwC1g@mail.gmail.com>
Subject: Re: [PATCH] stmmac: selftest: avoid large stack usage
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 9:58 AM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Sep/18/2019, 20:54:34 (UTC+00:00)
>
> > +     if (!cfg || !cfg->enable) {
> >               value &= ~XGMAC_RSSE;
> >               writel(value, ioaddr + XGMAC_RSS_CTRL);
> >               return 0;
> >       }
> >
> >       for (i = 0; i < (sizeof(cfg->key) / sizeof(u32)); i++) {
> > -             ret = dwxgmac2_rss_write_reg(ioaddr, true, i, *key++);
> > +             if (cfg)
> > +                     ret = dwxgmac2_rss_write_reg(ioaddr, true, i, cfg->key[i]);
> > +             else
> > +                     ret = dwxgmac2_rss_write_reg(ioaddr, true, i, 0);
> > +
> >               if (ret)
> >                       return ret;
> >       }
> >
> >       for (i = 0; i < ARRAY_SIZE(cfg->table); i++) {
> > -             ret = dwxgmac2_rss_write_reg(ioaddr, false, i, cfg->table[i]);
> > +             if (cfg)
> > +                     ret = dwxgmac2_rss_write_reg(ioaddr, false, i, cfg->table[i]);
> > +             else
> > +                     ret = dwxgmac2_rss_write_reg(ioaddr, false, i, 0);
> > +
>
> I don't get these "if (cfg)" checks. You already check earlier if cfg is
> NULL and return if so. I don't think you need these extra checks.

Ah, you are right, I missed the 'return 0', that makes it much easier.

> Also, your subject line should be something like: "net: stmmac:
> selftests: ..."

I think both styles is common for network drivers, though I think most
just leave out the 'net:'. I changed it in v2 now.

      Arnd
