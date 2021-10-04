Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923A5421A5F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhJDW6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236984AbhJDW6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 18:58:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1222613AC;
        Mon,  4 Oct 2021 22:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633388203;
        bh=i6ulNormSIWlQQqKHj+2j7C0TrI/jvl82mpagj6SXos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ACj6heyZ40ajjsBptLaqZ0jcXu/Ph+Mis5f5615mHIhmvKbICRsYSr+i7b8Snl2iv
         iI7T9PSniMejgLSeNgTgIuDFdGuJtV3PmEYd+LQ25UW5gZsL3ibUYxZj8d+BD1xQqh
         3ZiyjDjdIrApCJvO/1IUCX4kzQ8Levovfsxpd45LZQfqu6lQXO7o3Cj0i4Kd5cvRqM
         xuvDCZIOi2pyMNZMxrW6gflED2GuEYPKrrSxWrEDAWXqsZ9Eo7ioxecX9ZRo4A+1SU
         i6UGOnntEWSQnQdcbViBpwG+cHBWYKM6ax6FGu1u84wlyuJK71118zTfcwd/YwrfsM
         2+4i/tDs7YKdw==
Date:   Mon, 4 Oct 2021 15:56:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] ethernet: use eth_hw_addr_set() for
 dev->addr_len cases
Message-ID: <20211004155642.369db0ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVt9xbVVoNb3p9ro@lunn.ch>
References: <20211004160522.1974052-1-kuba@kernel.org>
        <YVt9xbVVoNb3p9ro@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 00:18:45 +0200 Andrew Lunn wrote:
> On Mon, Oct 04, 2021 at 09:05:21AM -0700, Jakub Kicinski wrote:
> > Convert all Ethernet drivers from memcpy(... dev->addr_len)
> > to eth_hw_addr_set():
> > 
> >   @@
> >   expression dev, np;
> >   @@
> >   - memcpy(dev->dev_addr, np, dev->addr_len)
> >   + eth_hw_addr_set(dev, np)  
> 
> eth_hw_addr_set() uses ether_addr_copy(), which says:
> 
> Please note: dst & src must both be aligned to u16.
> 
> memcpy() does not have this restriction. If the source is something
> funky, like an EEPROM, it could be oddly aligned.
> 
> If you are going to do this, i think the assumption needs removing, a
> test added for unaligned addresses and fall back to memcpy().

Thanks for pointing that out, I'll queue up a fix.

At the end of the conversion eth_hw_addr_set() calls dev_addr_set()
which is a memcpy() but I created the former first hence the wrong
ordering.
