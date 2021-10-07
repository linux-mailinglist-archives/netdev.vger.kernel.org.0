Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC144254E2
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241905AbhJGN65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241788AbhJGN64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:58:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D78EB603E9;
        Thu,  7 Oct 2021 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633615023;
        bh=wnCvNqyaxGh8sSe6zt+S0akuuzrzk8rKXkAJa+yoiFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nJGhiPiL0vjJXnWxkl70ZeXy+psjXowH8jyMeMs5xJ01/Jk57/N3Bdvud1lcgU1w2
         p9kQZil8bCVm+V0GBapDGawdduRrT80gUc7HQik/jCgPS5hOHqr142HTFx2gPF4PnS
         FVBxi8JGTlQJqy4fCZn6PHZMP+HxuEzQE5XMICbSU4g9po3uPh8Tbi4sQTQzCUYyWq
         Flvtc0/sjBZYtU29fCSGvS5ThWoq8C2ZAhRiXduDh9/2XAqGRjryD8wLY+NAHOjmF7
         LJdL2S4+swe3+i4ng8RGje/nC9BARnsbsxPNLb6L4qtp2Af8yaOgiYgVUMaIPCHkWV
         AQ19Wxdhm/C7Q==
Date:   Thu, 7 Oct 2021 06:57:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 2/3] eth: platform: add a helper for loading
 netdev->dev_addr
Message-ID: <20211007065701.1ee88762@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <16f34ede9a885a443bb7c46255ee804f@walle.cc>
References: <20211007132511.3462291-1-kuba@kernel.org>
        <20211007132511.3462291-3-kuba@kernel.org>
        <16f34ede9a885a443bb7c46255ee804f@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 07 Oct 2021 15:42:17 +0200 Michael Walle wrote:
> > +int platform_get_ethdev_address(struct device *dev, struct net_device *netdev)
> > +{
> > +	u8 addr[ETH_ALEN];
> > +	int ret;
> > +
> > +	ret = eth_platform_get_mac_address(dev, addr);  
> 
> this eventually calls ether_addr_copy(), which has a note:
>    Please note: dst & src must both be aligned to u16.
> 
> Is this true for this addr on the stack?

It will but I don't think there's anything in the standard that
requires it. Let me slap __aligned(2) on it to be sure.
