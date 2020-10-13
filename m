Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D7828D29C
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 18:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgJMQum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 12:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbgJMQum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 12:50:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 603F4252DA;
        Tue, 13 Oct 2020 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602607841;
        bh=UzdiRRE828PH0FyGjY1BxSN00JwHbWSHKpnKAGihyyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JthnFAEiOjojkDtYrg5+vYMr4MBL+WwWol21n0YV5LRb/LRkp3OkughkYTXt43sTb
         rO6dQ16m/DBvanVTS4NhW/ALlfDRysObBGjoftWZEj05kWm/Q55346gtTz2jne3DaL
         Lj/XQGrWJWl+wC2WybYKXTb0QrV1KRzt2eK7tggs=
Date:   Tue, 13 Oct 2020 09:50:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksandr Nogikh <a.nogikh@gmail.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
Message-ID: <20201013095038.61ba8f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADpXja8i4YPT=vcuCr412RYqRMjTOGuaMW2dyV0j7BtEwNBgFA@mail.gmail.com>
References: <20201007101726.3149375-1-a.nogikh@gmail.com>
        <20201007101726.3149375-2-a.nogikh@gmail.com>
        <20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4Y+ZF_umjBpyJiCb8YPQOOSofG-M9h0CB=xn3bCgK=Kr=9w@mail.gmail.com>
        <20201010081431.1f2d9d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4Y+aEQoRMO6eA7iQZf4dhOu2cD1ZbbH6TT4Rs_uQwG0PWYg@mail.gmail.com>
        <CADpXja8i4YPT=vcuCr412RYqRMjTOGuaMW2dyV0j7BtEwNBgFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 18:59:28 +0300 Aleksandr Nogikh wrote:
> On Mon, 12 Oct 2020 at 09:04, Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Sat, Oct 10, 2020 at 5:14 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > >
> > > On Sat, 10 Oct 2020 09:54:57 +0200 Dmitry Vyukov wrote:  
> > > > On Sat, Oct 10, 2020 at 1:16 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> [...]
> > > > > Could you use skb_extensions for this?  
> > > >
> > > > Why? If for space, this is already under a non-production ifdef.  
> > >
> > > I understand, but the skb_ext infra is there for uncommon use cases
> > > like this one. Any particular reason you don't want to use it?
> > > The slight LoC increase?
> > >
> > > Is there any precedent for adding the kcov field to other performance
> > > critical structures?  
> 
> It would be great to come to some conclusion on where exactly to store
> kcov_handle. Technically, it is possible to use skb extensions for the
> purpose, though it will indeed slightly increase the complexity.
> 
> Jakub, you think that kcov_handle should be added as an skb extension,
> right?

That'd be preferable. I understand with current use cases it doesn't
really matter, but history shows people come up with all sort of
wonderful use cases down the line. And when they do they rarely go back 
and fix such fundamental minutiae.

> Though I do not really object to moving the field, it still seems to
> me that sk_buff itself is a better place. Right now skb extensions
> store values that are local to specific protocols and that are only
> meaningful in the context of these protocols (correct me if I'm
> wrong). Although this patch only adds remote kcov coverage to the wifi
> code, kcov_handle can be meaningful for other protocols as well - just
> like the already existing sk_buff fields. So adding kcov_handle to skb
> extensions will break this logical separation.

It's not as much protocols as subsystems. The values are meaningful to
a subsystem which inserts them, that doesn't mean single layer of the
stack. If it was about storing layer's context we would just use
skb->cb.

So I think the kcov use matches pretty well. 

Florian, what's your take?
