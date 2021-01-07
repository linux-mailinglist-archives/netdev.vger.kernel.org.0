Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173FC2ED5DB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbhAGRm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:42:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbhAGRm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:42:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1CC2233FD;
        Thu,  7 Jan 2021 17:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610041307;
        bh=2Y93tEVQ+bLJJTLclrFjB1a6L6zWPOSqbe/DcLT3KdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G9fffMHkznCZTdTkz+4dbp6BjFT1N/dEb/XrCK6KcOoIz2GSlkSovHYXrw9XDCizK
         lfk/fZC0AY2Hii2M9WgYqPZiEGfdF5b2t/BetPpfJNpw+JnSrg8o1kobYwMyRufQnr
         PF5eBSd2tcDEbd5zGSZLlM2giPlnNUAYBbnH1qrr9oooOSnGHcBJZ4/UXuEECSfN++
         1ADvAiuBjeEUQHHrXbz0uOM6lN0OAUP1kr91EESMKae9Db689QOR97cZx8pcCTxNtY
         vL8XdzCloRAm1C2O5r97F3dxvkXS4Yr0v/VBYt5K1WK+8Vtms7lz7dNpZQZyDhJqp1
         BkibhSoslzngA==
Date:   Thu, 7 Jan 2021 09:41:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sysctl: cleanup net_sysctl_init()
Message-ID: <20210107094146.37f20e69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107091318.2184-1-alobakin@pm.me>
References: <20210106204014.34730-1-alobakin@pm.me>
        <20210106163056.79d75ffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210107091318.2184-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 07 Jan 2021 09:13:40 +0000 Alexander Lobakin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Wed, 6 Jan 2021 16:30:56 -0800
> 
> > On Wed, 06 Jan 2021 20:40:28 +0000 Alexander Lobakin wrote:  
> >> 'net_header' is not used outside of this function, so can be moved
> >> from BSS onto the stack.
> >> Declarations of one-element arrays are discouraged, and there's no
> >> need to store 'empty' in BSS. Simply allocate it from heap at init.  
> >
> > Are you sure? It's passed as an argument to register_sysctl()
> > so it may well need to be valid for the lifetime of net_header.  
> 
> I just moved it from BSS to the heap and allocate it using kzalloc(),
> it's still valid through the lifetime of the kernel.

I see it now, please don't break the normal flow of error handling.

What's the point of moving objects allocated in __init from BSS to 
the heap? If anything I'd think it'll take up more space when allocated
in the heap because of the metadata that needs to be tracked for
dynamic allocations.

The move of net_header makes sense AFAICT, but we may have to annotate
it somehow so kmemleak doesn't complain.
