Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885AB31E2EB
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 00:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhBQXIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 18:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231234AbhBQXIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 18:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2104961606;
        Wed, 17 Feb 2021 23:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613603239;
        bh=ZZc9czH4DE7VQ2o/G/8NddPCzF/64tfAd9rosqGIoXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FcehgQNjeyZg1aGc0q4mdJS/QamyJLWGMfVsugPwPZJo04A1ZGVR9ZQNIrugooY0R
         3sitFlRY9r6xjCX8twe5+PjRyImStaDRWq0NoLtiWx59cOGfs/jEOfqI6b6pZHTZBK
         E/EiUi8rwb7X0GBzUHrvyYtvewDr7k0U5mVH5+9i8NWGUKxyxUoVZO6PhL5KYPwLw4
         7T/L+2GUJkS2MBPoYEHeHpPR2D9acxtu9ljUyMPJMs9Mu2BEBQutw03OZRKXlj8JIT
         FqdIrEjzRYvnOeNf6YGw8300x2NGUlw1naTLzcMahJzn4LsYV78G+tSvLWSU/SP0pZ
         Iz/49uH5VpEBA==
Date:   Wed, 17 Feb 2021 15:07:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Min Li <min.li.xe@renesas.com>,
        Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Message-ID: <20210217150718.1c691cd1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
        <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
        <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
        <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
        <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
        <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
        <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
        <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
        <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
        <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com>
        <OSBPR01MB477394546AE3BC1F186FC0E9BA869@OSBPR01MB4773.jpnprd01.prod.outlook.com>
        <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021 22:30:14 +0100 Arnd Bergmann wrote:
> On Wed, Feb 17, 2021 at 9:20 PM Min Li <min.li.xe@renesas.com> wrote:
> > I attached the G.8273.2 document, where chapter 6 is about supporting physical layer
> > frequency. And combo mode is Renesas way to support this requirement. Other companies
> > may come up with different ways to support it.
> >
> > When EEC quality is below certain level, we would wanna turn off combo mode.  
> 
> Maybe this is something that could be handled inside of the device driver then?
> 
> If the driver can use the same algorithm that is in your user space software
> today, that would seem to be a nicer way to handle it than requiring a separate
> application.

Other points sound more time than networking, so no suggestions
from me, but on using PHC for L1 freq - that seems like a good 
fit for ethtool?
