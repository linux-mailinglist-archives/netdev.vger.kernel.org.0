Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27564484D2D
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 05:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbiAEEtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 23:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237365AbiAEEtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 23:49:32 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23FDC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 20:49:31 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id o12so86523090lfk.1
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 20:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=03vLP2TxW9YI7TN/Wh/F4umLmU9k0qgOkFE2Vo++b74=;
        b=TN0DmSeUU74/pf8XyHtar5HstH4Wn25Vv02kOea3OLv3pJ7zt1j6gfR+rpivjchBPq
         79PnFuXMjXWn1AUUjhz+gjayMR64ZBeAEtWTNmfv1Tojn7lNqW1rWJFWqOI6LSphq+Oe
         z+gBmjhfrnFByKYTFCXd7vPNeXeiGPVnVYquM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=03vLP2TxW9YI7TN/Wh/F4umLmU9k0qgOkFE2Vo++b74=;
        b=wRA0V7J6KembL9Xl6O9bDFF/Yv5vdBynbO7HnmqtB4NDm1PXxuryzhgFsBe3j3bGSc
         Vh7QLli4khHijx27YMsC3ZkpbWwrHzqauBKZGSfdKNaN1oMDCODgOWQ0rCF2/P7u5Ryy
         yCuCy57HaeN6gFVnZ1ibIG9dEm4WMJo4/itooNKW91YLcmOsUCw0YXOt/I2fuNimOuBd
         L1oimAv1SY4bSaDL1MzJTFlf2ieap4H1+JfBLh9an20J1If+0ItzSybOGV4iosVJ4Uev
         5AFLvjts3WpYKfxR34LUM0gpdDIPONxKm+trFj3AxWsb0pYKA+oiJ4GK63nLjOr0y25M
         7pNA==
X-Gm-Message-State: AOAM53382XNIEAgG/t9MtGxhrP1f6959obMO2p1QwRvXxmE0bnxglLH5
        KjpExD++PTM+UY0sP4ss6Ytq8VQU1pHpTF137gy8QA==
X-Google-Smtp-Source: ABdhPJwn5r77d3w7myHuWQgknHTcuBAC55paxS6rBireqIn83df9Bdr7SbTOSOf1+N04rpY7p9LRlOG8tTz51hMXwKU=
X-Received: by 2002:a05:6512:3223:: with SMTP id f3mr46715921lfe.593.1641358169980;
 Tue, 04 Jan 2022 20:49:29 -0800 (PST)
MIME-Version: 1.0
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-3-dmichail@fungible.com> <20220104180959.1291af97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104180959.1291af97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Tue, 4 Jan 2022 20:49:14 -0800
Message-ID: <CAOkoqZnTv_xc6oB13jdTEK65wbYzyOO1kigmMv7KsJug58bBpA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/8] net/fungible: Add service module for
 Fungible drivers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 6:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  3 Jan 2022 22:46:51 -0800 Dimitris Michailidis wrote:
> > Fungible cards have a number of different PCI functions and thus
> > different drivers, all of which use a common method to initialize and
> > interact with the device. This commit adds a library module that
> > collects these common mechanisms. They mainly deal with device
> > initialization, setting up and destroying queues, and operating an admin
> > queue. A subset of the FW interface is also included here.
> >
> > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
>
> CHECK: Unnecessary parentheses around 'fdev->admin_q->rq_depth > 0'
> #630: FILE: drivers/net/ethernet/fungible/funcore/fun_dev.c:584:
> +       if (cq_count < 2 || sq_count < 2 + (fdev->admin_q->rq_depth > 0))

I saw this one but checkpatch misunderstands this expression.
There are different equivalent expressions that wouldn't have them
but this one needs them.
