Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C0E2AA76E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 19:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgKGSjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 13:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGSjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 13:39:52 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EEC120888;
        Sat,  7 Nov 2020 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604774391;
        bh=HhKzWuLOy4BkSb6u8xQ53yeGh9rBlF6vLW5C9Xo1uSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eOeTDanjgk4t/SEL4eHvpJ/d3pmppFrcnb+Vp8V0fHp/Jame8VAMlaze6ZhxkS2gk
         vIQqlwglhb6+FfaN1HCdu9pHyEUp4MM5nYMiPs8hgWlvYrQLbQhtZXBc8Wv6t0hC2Z
         NxfpU11ZU/77pyjIyToEt4D/uFv/XiRtGIF0y3L8=
Date:   Sat, 7 Nov 2020 10:39:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     LIU Yulong <liuyulong.xa@gmail.com>
Cc:     netdev@vger.kernel.org, LIU Yulong <i@liuyulong.me>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH v2] net: bonding: alb disable balance for IPv6 multicast
 related mac
Message-ID: <20201107103950.70cf9353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103130559.0335c353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1603850163-4563-1-git-send-email-i@liuyulong.me>
        <1604303803-30660-1-git-send-email-i@liuyulong.me>
        <20201103130559.0335c353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 13:05:59 -0800 Jakub Kicinski wrote:
> On Mon,  2 Nov 2020 15:56:43 +0800 LIU Yulong wrote:
> > According to the RFC 2464 [1] the prefix "33:33:xx:xx:xx:xx" is defined to
> > construct the multicast destination MAC address for IPv6 multicast traffic.
> > The NDP (Neighbor Discovery Protocol for IPv6)[2] will comply with such
> > rule. The work steps [6] are:
> >   *) Let's assume a destination address of 2001:db8:1:1::1.
> >   *) This is mapped into the "Solicited Node Multicast Address" (SNMA)
> >      format of ff02::1:ffXX:XXXX.
> >   *) The XX:XXXX represent the last 24 bits of the SNMA, and are derived
> >      directly from the last 24 bits of the destination address.
> >   *) Resulting in a SNMA ff02::1:ff00:0001, or ff02::1:ff00:1.
> >   *) This, being a multicast address, can be mapped to a multicast MAC
> >      address, using the format 33-33-XX-XX-XX-XX
> >   *) Resulting in 33-33-ff-00-00-01.
> >   *) This is a MAC address that is only being listened for by nodes
> >      sharing the same last 24 bits.
> >   *) In other words, while there is a chance for a "address collision",
> >      it is a vast improvement over ARP's guaranteed "collision".
> > Kernel related code can be found at [3][4][5].  
> 
> Please make sure you keep maintainers CCed on your postings, adding bond
> maintainers now.

Looks like no reviews are coming in, so I had a closer look.

It's concerning that we'll disable load balancing for all IPv6 multicast
addresses now. AFAIU you're only concerned about 33:33:ff:00:00:01, can
we not compare against that?

The way the comparison is written now it does a single 64bit comparison
per address, so it's the same number of instructions to compare the top
two bytes or two full addresses.
