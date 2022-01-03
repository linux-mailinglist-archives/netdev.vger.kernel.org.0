Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F248389A
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 22:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiACVmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 16:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiACVmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 16:42:10 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FF5C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 13:42:09 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id k21so77563085lfu.0
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 13:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5KDjk+ndg5cvhUb20FFrW+RbKvyb529Te3a2jOAmACY=;
        b=EfezxFkq9di8jkbQHG8//2IJCGREJjfJRcqdBaSH8QAr6YxnrPa6otyYY/quw0RZ4S
         /FpQ0NE8PLJDhPpJCQKZ6qKuK7KswaK6IjaBiIzWcPZzfRxaPunmHW+NuaK9NRk7aB8O
         lGYUuWTnALEH3Yn+bpKFTbzg5HOLJgKibPTOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5KDjk+ndg5cvhUb20FFrW+RbKvyb529Te3a2jOAmACY=;
        b=P1lXQGSE2hcvZI4GFbrO8A9t2pSIFTr4VieOkE4m/Cdk2wW6wf52sPaHakdWOXJV3v
         ohsrss3YWsV95KuktpwNT94qb4HLSPgyv2gPzLDnGdGI6yNj67RhN9sIWVhbaHamqy/l
         odzdh+zqXAOV7F2s72G445ZdaHhCArEw4bFznCeJ5KfuHLyJ/jggjuEQrxZr0uZBLBJy
         Vz5D3yqc2HDLAXmSypd2kvoTcvh54rkFVZ7KnUckIH9jX7BcowYmFulO+sfMj/8dXwH7
         nVEjhX3HLJ2e9z/OeUsQEs3pVU6SVQQ/dvxS4GsMZ4S8g/om3Z+pToyCTaQobEjpAtfe
         7AGQ==
X-Gm-Message-State: AOAM530cAYWaWntaL2deUVeJCrCeiiJd2sdeyygW/rqb4zBM+oad5tKf
        3IJ9CGIUhZ2esuTktkF7/ybX+XwlFhqTfP1tkv0tDv8q6ro=
X-Google-Smtp-Source: ABdhPJw8pMWyOhtV++1/NhLU8O2+dShnPOavf854zMf4trE4sWQMA9v2+jy8e7sQ92SnixqnX4mXZ0NRf2RLAO3q2Hg=
X-Received: by 2002:a05:6512:3093:: with SMTP id z19mr32757722lfd.670.1641246127826;
 Mon, 03 Jan 2022 13:42:07 -0800 (PST)
MIME-Version: 1.0
References: <20211231090833.98977-1-dmichail@fungible.com> <20211231182643.3f4fa542@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211231182643.3f4fa542@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Mon, 3 Jan 2022 13:41:55 -0800
Message-ID: <CAOkoqZnbUzxdud0XVNwmz_9QiLBcmnqe1xaNana_+TD+TBUHJA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/8] new Fungible Ethernet driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 6:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 31 Dec 2021 01:08:25 -0800 Dimitris Michailidis wrote:
> > This patch series contains a new network driver for the Ethernet
> > functionality of Fungible cards.
> >
> > It contains two modules. The first one in patch 2 is a library module
> > that implements some of the device setup, queue managenent, and support
> > for operating an admin queue. These are placed in a separate module
> > because the cards provide a number of PCI functions handled by different
> > types of drivers and all use the same common means to interact with the
> > device. Each of the drivers will be relying on this library module for
> > them.
> >
> > The remaining patches provide the Ethernet driver for the cards.
>
> Still fails to build for me, I use:
>
> make C=1 W=1 O=build_allmodconfig/ drivers/net/ethernet/fungible/

I've figured it out and will be fixed in v3. There's one issue with O= and
one with builds on 32b architectures.
