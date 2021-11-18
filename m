Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79584551A2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhKRA32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233465AbhKRA30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 19:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D7A61B72;
        Thu, 18 Nov 2021 00:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637195187;
        bh=zdH4ims6ORqlp7r/6go3bLPn1Js1OpYHIvtqpJI5JSw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KEVmLjNAAA49I6BLbsPKlY2oBmAAFkWR0oe2JLJc/3vlqp4pk7x261e7DIWCCxICR
         wd6x4oepDgctHFUNymP/etXHOSHnEOSWsk3J7uT4amoaApa1Y8x3wsUuziL0Ma7I7W
         0l2f7p9YCd+kB9ungBIj9OsiBBFVmXIUiQayUFKZNYuhEEc6evoU1EMcegN+TJRTIv
         uWlOUcxh6K/Cxms++MRIeXNAaNy4tzq2T77FsjaAJp2jECVyYk2IT/Kvu1FI6aYTSj
         X4xLnT5M7ihNlwE+BJiXN4LuNJdvQXqWIPqUj2osricO+Nn/Il/JRI7knbp/tlKn0F
         B2ts+YJeOWP1Q==
Date:   Wed, 17 Nov 2021 16:26:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
Message-ID: <20211117162626.72c711c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com>
References: <20211117192031.3906502-1-eric.dumazet@gmail.com>
        <20211117192031.3906502-2-eric.dumazet@gmail.com>
        <20211117120347.5176b96f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJ8HLjjpBPyFOn3xTXSnOJCbOGq5gORgPnsws-+sB8ipA@mail.gmail.com>
        <20211117124706.79fd08c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 14:43:24 -0800 Eric Dumazet wrote:
> On 11/17/21 12:47 PM, Jakub Kicinski wrote:
> > On Wed, 17 Nov 2021 12:16:15 -0800 Eric Dumazet wrote:  
> >> I think that maintaining the tracking state in separate storage would
> >> detect cases where the object has been freed, without the help of KASAN.  
> > 
> > Makes sense, I guess we can hang more of the information of a secondary
> > object?
> > 
> > Maybe I'm missing a trick on how to make the feature consume no space
> > when disabled via Kconfig.  
> 
> If not enabled in Kconfig, the structures are empty, so consume no space.
> 
> Basically this should a nop.

Right, probably not worth going back and forth, example use will clarify
this.

I feel like the two approaches are somewhat complementary, object debug
can help us pin point where ref got freed / lost. Could be useful if
there are many release paths for the same struct.

How do you feel about the struct netdev_ref wrapper I made?  Do you
prefer to keep the tracking independent or can we provide the sort of
API I had in mind as well as yours:

void netdev_hold(struct netdev_ref *ref, struct net_device *dev)
void netdev_put(struct netdev_ref *ref)

struct net_device *netdev_ref_ptr(const struct netdev_ref *ref)

(doing both your tracking and object debug behind the scenes)
