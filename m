Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C2849F0EB
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345304AbiA1CXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345300AbiA1CXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:23:16 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECDBC06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:23:15 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 23so14291053ybf.7
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9eZnlJSlBPw0a4/YSci8FWmERiqsXY6ici0KSijmpAw=;
        b=SKZmyCGsDIXgtr/fnOwVNDVgUma2QH1AyJ0h7xMpPArlqtIOURvn7flShTjE1iGcu8
         IbYih/8vGUNZoVoDiJfVUyrlekuQBqV0wxjhAuxx2rx2uBL/cjw9gaoCVKeLnYAnIUi5
         KrMxBy8Q/lf+9pzcCi/WzCWHjP7iea/rqkVsXVDNn9TJmkHowwb3duxIii2ue5uOzj/I
         ae6Jqx2VJuyey+wVeUXe2j3C6bOFmOXLUH7SYhTq1NC3+xZApwCWg0Ke/oc7YvrzxXpN
         MBgI5UL5+6NWgrW0Z6DyterNVKH4pmFcTSoW4koeso1fICJVcccUHLSF4vJByzHIloAV
         xSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9eZnlJSlBPw0a4/YSci8FWmERiqsXY6ici0KSijmpAw=;
        b=pLh2tZA/VSS5NWk0XScLsJFM/7UO6Yk+1jmcu0NW286T2oOPOgW7WKEHmXCBMZrcBA
         TTGTZXhzzO7Af66wdHf5PV+bN96aVA/1q6pQhtJD8XH/ABdyTkOMEt38qlGPZhn8gax6
         GI5rtbmco7buEuxw4+3EfeH4Wa1laGFKTjiPG6fsZgsZYlugS7qB74fbBSOxMjV+reoI
         vDtZ6l00YBiiGcqKyY+RTXG4KxUd3TgKzLhq8Cw9epiKGR3yv6SDMgh8jYTBj0fwofiJ
         ZNP5xwwKmfL0yboNz1JhYZ8laEQOu+RaOvIk/19uw/cthg6MNTn8hZZYjYujh6CN2DKv
         qEiQ==
X-Gm-Message-State: AOAM530ArzZmhqMGlwM/Z41pNklh6zaKHnS13QqMSSfpgCuKvUNzzxiT
        v7u8RcSwAkPo3QLrcEpW6+BySzAdBrMWiOIzFoFJfQ==
X-Google-Smtp-Source: ABdhPJwVsfm97uUyp7RZ7RqMo7z8ka9Nyo4Q+8eVv/l89S8ziWJdQaM0yi+i0V/EltvSSqVOkELH6MK43HDGjAaqoxc=
X-Received: by 2002:a25:d2cb:: with SMTP id j194mr9481633ybg.277.1643336594537;
 Thu, 27 Jan 2022 18:23:14 -0800 (PST)
MIME-Version: 1.0
References: <20220128014303.2334568-1-jannh@google.com> <CANn89iKWaERfs1iW8jVyRZT8K1LwWM9efiRsx8E1U3CDT39dyw@mail.gmail.com>
 <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com> <20220127182219.1da582f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220127182219.1da582f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Jan 2022 18:23:03 -0800
Message-ID: <CANn89i+k4tiyQtb6fh8USDjhZGVwdx1puh8cr9NcDQECbvJvdg@mail.gmail.com>
Subject: Re: [PATCH net] net: dev: Detect dev_hold() after netdev_wait_allrefs()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jann Horn <jannh@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 6:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 28 Jan 2022 03:14:14 +0100 Jann Horn wrote:
> > Oh. Whoops. That's what I get for only testing without CONFIG_PCPU_DEV_REFCNT...
> >
> > I guess a better place to put the new check would be directly after
> > checking for "dev->reg_state == NETREG_UNREGISTERING"? Like this?
>
> Possibly a very silly suggestion but perhaps we should set
> the pointer to NULL for the pcpu case and let it crash?

It is already set to 0
