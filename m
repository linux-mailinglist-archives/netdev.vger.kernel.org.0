Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B862C30D0
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKXTnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbgKXTnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 14:43:09 -0500
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C56208CA
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606246989;
        bh=EV7Vrjxu254zd8Wi24pWppgJWAct6pwmhWS4lTWPHCo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2qqcMRdwUo7xUOqFLhV8WoiHkmpW16DQmN2REbhm7RrqXkmo0stZ1ouXjo2Kp81QQ
         ISFA+eyicRQIYROnDYEfHjyybEePUZz6sM6nN2q4N7+VfTRb2iK64dRlmZRJgvfB7j
         DRkAHiRB0uvY6a5QBmOxLFMy939J0GwHPnDB0Z3g=
Received: by mail-oi1-f173.google.com with SMTP id k26so4252oiw.0
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:43:08 -0800 (PST)
X-Gm-Message-State: AOAM5319WfFZyVYEmuTYByKF5EZ0l/cqpqSRKrBV5ld8vr5s//LRUPOj
        ftZZs7PLCSCgm21gWk6mIe8cJEzW2nQr0esg5gQ=
X-Google-Smtp-Source: ABdhPJyZFBdzNBenm9Q4gD44WoxCyQ+29UQhc5JD2lbPz1+hpblPQ3OTAWQ9STF2Inaw4uZbU2HzSe4cibg6mZGlktI=
X-Received: by 2002:aca:180a:: with SMTP id h10mr143764oih.4.1606246988070;
 Tue, 24 Nov 2020 11:43:08 -0800 (PST)
MIME-Version: 1.0
References: <20201124151828.169152-1-arnd@kernel.org> <20201124151828.169152-2-arnd@kernel.org>
 <4d1a587e7a9e4b65ac3a0c20554abdd3@AcuMS.aculab.com>
In-Reply-To: <4d1a587e7a9e4b65ac3a0c20554abdd3@AcuMS.aculab.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 24 Nov 2020 20:42:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3tqW8J65nyLg2YY+2ZEfhtqsOpR9cZDJgtSenT+1BENQ@mail.gmail.com>
Message-ID: <CAK8P3a3tqW8J65nyLg2YY+2ZEfhtqsOpR9cZDJgtSenT+1BENQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] ethtool: improve compat ioctl handling
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 5:19 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Arnd Bergmann
> > Sent: 24 November 2020 15:18
> >
> > The ethtool compat ioctl handling is hidden away in net/socket.c,
> > which introduces a couple of minor oddities:
> >
> ...
> > +
> > +static int ethtool_rxnfc_copy_from_compat(struct ethtool_rxnfc *rxnfc,
> > +                                       const struct compat_ethtool_rxnfc __user *useraddr,
> > +                                       size_t size)
> > +{
>
> I think this (and possibly others) want a 'noinline_for_stack'.
> So that both the normal and compat structures aren't both on the
> stack when the real code is called.

Yes, makes sense. I checked that the difference is small unless
CONFIG_KASAN_STACK is enabled, and that gcc is smart enough
not to inline these by default, but adding noinline_for_stack is
both consistent with the rest of the file and the safe bet here.

     Arnd
