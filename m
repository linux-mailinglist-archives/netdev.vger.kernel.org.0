Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D5D296544
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370200AbgJVTZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370188AbgJVTZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 15:25:37 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA1F24656;
        Thu, 22 Oct 2020 19:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603394736;
        bh=HbuC0qgCibXkORRUO2zEPlzxA0cbAFUdrdQRIyIJJ5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wEu8E0Gd4frjTQMR1Ypc7CBIvXaGFfiU8qfZ5lhKuLJkAZDtvzt/6/JBOA+7DVPAO
         1Moeod8a1B5xzh0Q4eOCcvP4XUx16dtvSUktlAPA78JvrFZDxHapU8xU92nwmhESOD
         e3GYF/hGA2rx6NySYnDVbmayeiGL1plSkeRozX/s=
Date:   Thu, 22 Oct 2020 12:25:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ke Li <keli@akamai.com>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kli@udel.edu,
        Ji Li <jli@akamai.com>
Subject: Re: [PATCH net v2] net: Properly typecast int values to set
 sk_max_pacing_rate
Message-ID: <20201022122534.5a700251@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CANn89iJxBMph1EZX9mYOjHsex-6thhTqSLpXA-1RDGv-QBhxaw@mail.gmail.com>
References: <20201022064146.79873-1-keli@akamai.com>
        <CANn89iJxBMph1EZX9mYOjHsex-6thhTqSLpXA-1RDGv-QBhxaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 09:48:48 +0200 Eric Dumazet wrote:
> On Thu, Oct 22, 2020 at 8:42 AM Ke Li <keli@akamai.com> wrote:
> >
> > In setsockopt(SO_MAX_PACING_RATE) on 64bit systems, sk_max_pacing_rate,
> > after extended from 'u32' to 'unsigned long', takes unintentionally
> > hiked value whenever assigned from an 'int' value with MSB=1, due to
> > binary sign extension in promoting s32 to u64, e.g. 0x80000000 becomes
> > 0xFFFFFFFF80000000.
> >
> > Thus inflated sk_max_pacing_rate causes subsequent getsockopt to return
> > ~0U unexpectedly. It may also result in increased pacing rate.
> >
> > Fix by explicitly casting the 'int' value to 'unsigned int' before
> > assigning it to sk_max_pacing_rate, for zero extension to happen.
> >
> > Fixes: 76a9ebe811fb ("net: extend sk_pacing_rate to unsigned long")
> > Signed-off-by: Ji Li <jli@akamai.com>
> > Signed-off-by: Ke Li <keli@akamai.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > ---
> > v2: wrap the line in net/core/filter.c to less than 80 chars.  
> 
> SGTM (the other version was also fine, the 80 chars rule has been
> relaxed/changed to 100 recently)

We went from old guidelines, to unclear guidelines, IDK which one is
worse :( Here the way the ternary expression was wrapping in a 80 char
window looked way less readable, so I thought I'd request a reformat.

> Reviewed-by: Eric Dumazet <edumazet@google.com>

Applied, thanks everyone!
