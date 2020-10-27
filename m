Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C5D29A2A2
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504462AbgJ0CS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:18:56 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34172 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504454AbgJ0CS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 22:18:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id x20so10429469qkn.1;
        Mon, 26 Oct 2020 19:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z7k2jFeuyFxR40oKjqp6f6jzB45rr1tSUQm9Sp7Fuu8=;
        b=emCTFPfbMA8sqwapkNGv73E7/ekn1Du95YiS6OJf6VKhj83eNKepggO/2T4LRV4NO1
         PkbCx2E+A5beMSWBNmgrliLMH6pDiIY1xkZqGjRmOjAoodhsLVTIOzxsGPre5zCjbbss
         dPrY42iAFezg5u4Dt2arPi7ADacfYvJUbN2xU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z7k2jFeuyFxR40oKjqp6f6jzB45rr1tSUQm9Sp7Fuu8=;
        b=LUoJj30pR8TDGscW52gJtfAdRL6oJ9JTDTnD7vWh3+LRY8v3zwgwUC5vUCdEVFaiNi
         o2I2ntEaGMZNhjWwTcIM4OBJf9OK5VtRUV2c51k5u+Kqky9qz3wt5n2rojuOrT2Q86al
         LB042AnTwN10zEm9JQShwSvMKjAbzurYAN+umU54JF+ioJdaFz+lOQzeqmim2/NqOJjU
         PORm9h19tnShzgYDRw/USIeNDhWxCJikyhc8CGJ++GooLUqJ3Iyrt6ATm05mYmnQK9/g
         OZm7JXGGA/18DD6UPYMs66V5qb2IC0RRB76W+zrz8sc159ls7O1mU+I0QD30ZTNyEXbl
         fRtQ==
X-Gm-Message-State: AOAM530dI9SOyCT01mKPlDq5y2Txhtmg8eXTMpamlaOr0/RxKbG/rsER
        d0QBkwvTWaLe4Yia5YudYYPa5lB23VPIdbI9xas=
X-Google-Smtp-Source: ABdhPJwLM6M52ok+8DkCFDJBuR8rBAX3I0lJIGG88g+lugudrUqWAV3/suj2AD1bT6mETyOedwi0T/fgRJegAvl+rLk=
X-Received: by 2002:a37:a81:: with SMTP id 123mr39228qkk.487.1603765133628;
 Mon, 26 Oct 2020 19:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
 <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
 <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PS1PR0601MB1849166CBF6D1678E6E1210C9C1F0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
 <CAK8P3a2pEfbLDWTppVHmGxXduOWPCwBw-8bMY9h3EbEecsVfTA@mail.gmail.com>
 <32bfb619bbb3cd6f52f9e5da205673702fed228f.camel@kernel.crashing.org>
 <529612e1-c6c4-4d33-91df-2a30bf2e1675@www.fastmail.com> <PS1PR0601MB18498469F0263306A6E5183F9C1A0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
 <e6c8e96bb26a5505e967e697946d359c22ac68c5.camel@kernel.crashing.org>
In-Reply-To: <e6c8e96bb26a5505e967e697946d359c22ac68c5.camel@kernel.crashing.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 27 Oct 2020 02:18:41 +0000
Message-ID: <CACPK8XdPB0wnvuvwxO5BST7EzDuPqGcjHTkZm=7A0ZofzyXHag@mail.gmail.com>
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Dylan Hung <dylan_hung@aspeedtech.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        BMC-SW <BMC-SW@aspeedtech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        netdev <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 at 22:22, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> On Fri, 2020-10-23 at 13:08 +0000, Dylan Hung wrote:
> > The issue was found on our test chip (ast2600 version A0) which is
> > just for testing and won't be mass-produced.  This HW bug has been
> > fixed on ast2600 A1 and later versions.
> >
> > To verify the HW fix, I run overnight iperf and kvm tests on
> > ast2600A1 without this patch, and get stable result without hanging.
> > So I think we can discard this patch.
>
> This is great news. Thanks !

That is excellent news. I agree; we do not need fixes for A0 issues to
be kept in the mainline kernel. Thanks for updating us Dylan.

Cheers,

Joel
