Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBE12490BD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHRWZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgHRWZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:25:24 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316DAC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:25:24 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g14so22888363iom.0
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IAt27MnWzH/SwbfdLt4os43JrfSAgoO4Bp/urnVrBYY=;
        b=cU6Bo0Z6oW0gmINVvbMlgXrJZ/Tm8LHIfawequm6oBSAv89ijx8sVnNqoZWNFYlPT7
         Sl0ZsK/xViiDL16ixuef7ePjzQ8BCi3jXBj1wQHWfAqWaNPe6HQva5+ZeSG3okt3pxhd
         q71WaPpigscXPCL10wRymcUfK0BY9aI0tDBpTAaYIsCYnL3KOuunz6C3SDtqeYbk9bou
         GFFRIH6is6lfMHbe37B1YExDNQYcdxknNEr+zJmBInE3kVEwOjAmeN2+qSRYgxZSLUvw
         OBUMAKzeka5rmgTEKoo02A+R3q8wKw86MmgS0Fs08EJ0fe3xOZHsdbwbpTanqR2rlWpT
         P06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IAt27MnWzH/SwbfdLt4os43JrfSAgoO4Bp/urnVrBYY=;
        b=YeG+v0gqrQt10Si777DEbKeqj7MVaKH6zjZwKxiYy1sqS8nQEnhUis1BjIKdynKfJd
         p14yvly2F4kV/B0MCSDBEhGJgHn1QefsdbfxkVL76uwHRg3b/ti4IYb1jKj7tlWpPC+B
         2TgL98ltMQtzOQXc2rhsoklubv0SQrqfqFE2+61oETHex/3e5uKbCQbaGlZcjhY3hxh3
         yS32zWkYrXa9F3nZYc3ePvEDYmaXsKEjJs5zyug3NCMs/uyyqvUOaPyEAOQG+6eUIxOh
         cK6x+AfzPb5b88NPZ+KHQB8w+0gzVOnKH8O/Pco0zPhxuyUplaP3YUM7Q/igUjQGA35d
         9ndQ==
X-Gm-Message-State: AOAM532oVqO6DKUG/mFk082A0ikXkD11Kfm3/MeNSJ8iugy++1fCZbnl
        q8Kin1+x7JpNxO2FtXavkwuVL5MdHAAJzLbMwTrUmw==
X-Google-Smtp-Source: ABdhPJxPp+AhKDo+cHnEuhzsvBFUGhAnOVUicE0oEuD3kKEhcJ74aWF2P6CT5/iUZmvgCB1K26mLPWgORqnfNwlpqFM=
X-Received: by 2002:a6b:2c8:: with SMTP id 191mr17801768ioc.41.1597789523249;
 Tue, 18 Aug 2020 15:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-11-awogbemila@google.com> <20200818.131818.1808468591889996886.davem@davemloft.net>
In-Reply-To: <20200818.131818.1808468591889996886.davem@davemloft.net>
From:   David Awogbemila <awogbemila@google.com>
Date:   Tue, 18 Aug 2020 15:25:12 -0700
Message-ID: <CAL9ddJcrJScrU94z6O2x4iCoLg=D8Qii+AbTJ87RSBj05LhNkA@mail.gmail.com>
Subject: Re: [PATCH net-next 10/18] gve: Add support for raw addressing to the
 rx path
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 1:18 PM David Miller <davem@davemloft.net> wrote:
>
> From: David Awogbemila <awogbemila@google.com>
> Date: Tue, 18 Aug 2020 12:44:09 -0700
>
> >  static void gve_rx_free_ring(struct gve_priv *priv, int idx)
> >  {
> >       struct gve_rx_ring *rx = &priv->rx[idx];
> >       struct device *dev = &priv->pdev->dev;
> >       size_t bytes;
> > -     u32 slots;
> > +     u32 slots = rx->mask + 1;
>
> Reverse christmas tree ordering for local variables please.
Got it. I'll fix this.
