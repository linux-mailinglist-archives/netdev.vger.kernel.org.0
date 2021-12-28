Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D97480B2A
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 17:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhL1QRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 11:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbhL1QRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 11:17:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06F3C061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 08:17:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E796611DF
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 16:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E420C36AE8;
        Tue, 28 Dec 2021 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640708269;
        bh=NElLusGAURpqz9itGdvXaIXjmiUbKpwVIdnNJ6tQX8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EAJEfd18MMwZNFdKD0ZDPNmFehXx98H4wGi/2UUL1PXVxJMhMiStFFD6A5U+1lN5a
         gm1gYexUg/fnwk3rvmjaJzLZbWcuipQMzhiDPFdw1+5lKjfGE3+5oJlL0KQ+59j0/0
         voiUv58LoL+rD80jj6y8XSGUV+EmyPp2L8j6aPbgfXbUJE3mRHPzgLt3zkt9Ay7zO9
         zj9P2ZJDOjJaealmCe15UrOU07ZEgamutgH9BkMwYJHUmCSM8nECTX2iBYZq6YvpUe
         JGtd/qSgXQiPu+SlEFhf4TFtaD0QLtqBT9WA6byvhFyLTHJs4XxcxcDSKc/WqVsyeR
         Ll9xdYgTQS5sA==
Date:   Tue, 28 Dec 2021 08:17:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211228081748.084e9215@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211228160050.GA13274@hoboy.vegasvil.org>
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
        <20211210085959.2023644-2-liuhangbin@gmail.com>
        <Ycq2Ofad9UHur0qE@Laptop-X1>
        <20211228071528.040fd3e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20211228160050.GA13274@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 08:00:50 -0800 Richard Cochran wrote:
> On Tue, Dec 28, 2021 at 07:15:28AM -0800, Jakub Kicinski wrote:
> > On Tue, 28 Dec 2021 15:01:13 +0800 Hangbin Liu wrote:  
> > > When implement the user space support for this feature. I realized that
> > > we can't use the new flag directly as the user space tool needs to have
> > > backward compatibility. Because run the new tool with this flag enabled
> > > on old kernel will get -EINVAL error. And we also could not use #ifdef
> > > directly as HWTSTAMP_FLAG_BONDED_PHC_INDEX is a enum.
> > > 
> > > Do you think if we could add a #define in linux/net_tstamp.h like
> > > 
> > > #define HWTSTAMP_FLAGS_SUPPORT 1
> > > 
> > > So that the user space tool could use it like
> > > 
> > > #ifdef HWTSTAMP_FLAGS_SUPPORT
> > >        cfg->flags = HWTSTAMP_FLAG_BONDED_PHC_INDEX;
> > > #endif  
> > 
> > We could set it on SIOCGHWTSTAMP to let user space know that it's
> > necessary for a given netdev.  
> 
> What about adding matching #defines into the enum declaration?
> 
> enum hwtstamp_flags {
> 	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
> #define HWTSTAMP_FLAG_BONDED_PHC_INDEX (1<<0)
> };
> 
> IIRC I have seen this pattern used in the kernel, but ATM I can't find any example :(

That's still just a compile-time fix, if the user space binary 
is distributed in binary form (distro package) there is no knowing
on which kernel versions it will run. I think runtime probing will
be necessary.

If we want the define it should be to the enum name:

What about adding matching #defines into the enum declaration?

enum hwtstamp_flags {
	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
#define HWTSTAMP_FLAG_BONDED_PHC_INDEX HWTSTAMP_FLAG_BONDED_PHC_INDEX
};

Examples in include/uapi/linux/rtnetlink.h
