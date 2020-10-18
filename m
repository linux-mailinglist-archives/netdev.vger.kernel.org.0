Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D9829206A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 00:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgJRWFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 18:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgJRWFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 18:05:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D75021D7F;
        Sun, 18 Oct 2020 22:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603058719;
        bh=NqUsUcqL3zD4uNoVS8imyqZhRSFuLsiKrJBHH79dFwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DUyUkcf/9yn4K/ng4OZmHWaL8ezcZEgkdy8hKvs7lU2Ld/YZjgXQi8KvXqDQXtjt/
         6gsatLvvzPXptff7ZET/L4Dit04lpE2IPtZuCAucmKsGOwgkC+iJUqA1AIlQv1mcr/
         LQDM0iDwvEtyFu8pCWLH8uG4gNookWsblyZxB4MQ=
Date:   Sun, 18 Oct 2020 15:05:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next] drivers/net/wan/hdlc_fr: Improve fr_rx and add
 support for any Ethertype
Message-ID: <20201018150517.2f3dfb5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201017051951.363514-1-xie.he.0141@gmail.com>
References: <20201017051951.363514-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 22:19:51 -0700 Xie He wrote:
> 1. Change the fr_rx function to make this driver support any Ethertype
> when receiving. (This driver is already able to handle any Ethertype
> when sending.)
> 
> Originally in the fr_rx function, the code that parses the long (10-byte)
> header only recognizes a few Ethertype values and drops frames with other
> Ethertype values. This patch replaces this code to make fr_rx support
> any Ethertype. This patch also creates a new function fr_snap_parse as
> part of the new code.
> 
> 2. Change the use of the "dev" variable in fr_rx. Originally we do
> "dev = something", and then at the end do "if (dev) skb->dev = dev".
> Now we do "if (something) skb->dev = something", then at the end do
> "dev = skb->dev".
> 
> This is to make the logic of our code consistent with eth_type_trans
> (which we call). The eth_type_trans function expects a non-NULL pointer
> as a parameter and assigns it directly to skb->dev.
> 
> 3. Change the initial skb->len check in fr_fx from "<= 4" to "< 4".
> At first we only need to ensure a 4-byte header is present. We indeed
> normally need the 5th byte, too, but it'd be more logical to check its
> existence when we actually need it.
> 
> Also add an fh->ea2 check to the initial checks in fr_fx. fh->ea2 == 1
> means the second address byte is the final address byte. We only support
> the case where the address length is 2 bytes.
> 
> 4. Use "goto rx_drop" whenever we need to drop a valid frame.

Whenever you make a list like that it's a strong indication that 
each of these should be a separate commit. That makes things easier 
to review.


We have already sent a pull request for 5.10 and therefore net-next 
is closed for new drivers, features, and code refactoring.

Please repost when net-next reopens after 5.10-rc1 is cut.

(http://vger.kernel.org/~davem/net-next.html will not be up to date 
 this time around, sorry about that).

RFC patches sent for review only are obviously welcome at any time.
