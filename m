Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D27D315855
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhBIVIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:08:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234062AbhBIU44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 15:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79C0064E31;
        Tue,  9 Feb 2021 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612897316;
        bh=Bq6/qF83WSu8TGSQ7oeFnamQKM3lFz0d7njfdmZqdS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bCVq9/z/D7Vyz2rJd347Hfa52WpnbUmSbhsfApppKzHvHIJ3BLTqOEo6XMgZj1rrE
         pWm36Da/OJEL+UGYjxn+bNFyFkaamCCoR1xhRfxUMcF7K7IOyq4Qu2ngdsFyrssR0L
         0Dxn57HK4wIPthn0FLMbCUa9phIXdOhQp8kA7z1WC/hOtb7s/1FouDKjNwCezqGPJP
         FKmvxRRoLaFXwe1Y38QI6otEnR0nXU+V+HkRWUUnnAeYSlyx5goCFvOikv6xgA/g2O
         wbMyru9A2gr/GyGHsXBdilxHARSPJ9UC16uaUE9Sy/63uo3BMutqcY8G+/SBxBHhbd
         YWNyHNCdz9sVQ==
Date:   Tue, 9 Feb 2021 21:01:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210209190152.GD139298@unreal>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal>
 <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210209061511.GI20265@unreal>
 <20210209085938.579f3187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209085938.579f3187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 08:59:38AM -0800, Jakub Kicinski wrote:
> On Tue, 9 Feb 2021 08:15:11 +0200 Leon Romanovsky wrote:
> > At least in my tree, we have the length check:
> >   4155                 if (len > sizeof(zc)) {
> >   4156                         len = sizeof(zc);
> >   4157                         if (put_user(len, optlen))
> >   4158                                 return -EFAULT;
> >   4159                 }
> >
> >
> > Ad David wrote below, the "if (zc.reserved)" is enough.
> >
> > We have following options:
> > 1. Old kernel that have sizeof(sz) upto .reserved and old userspace
> > -> len <= sizeof(sz) - works correctly.
> > 2. Old kernel that have sizeof(sz) upto .reserved and new userspace that
> > sends larger struct -> "f (len > sizeof(zc))" will return -EFAULT
>
> Based on the code you quoted? I don't see how. Maybe I need a vacation.
> put_user() just copies len back to user space after truncation.

It is me who needs to go to vacation, you are right it doesn't return
for lengths larger than sizeof(zc).

>
> > 3. New kernel that have sizeof(sz) beyond reserved and old userspace
> > -> any new added field to struct sz should be checked and anyway it is the same as item 1.
> > 4. New kernel and new userspace
> > -> standard flow.
