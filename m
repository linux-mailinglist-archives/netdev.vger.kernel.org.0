Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1D3615CC
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbhDOXGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234949AbhDOXGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E8A1600EF;
        Thu, 15 Apr 2021 23:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527957;
        bh=Ma+4GngwoiuNrgt7eUuYZhNtch4A2y4OCnP2LeuuCOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VjbV2dUZiapGh/XX5QV4YTDCdfcs+nJq6u3AcZ0HW4M++EeEjcl3Y4puCqtIBdJDa
         +ZkSShVd/whVEUrjQci30WSu23HJ6xeeDQHWx591qhL+2TR3xgXmWeZO4muC4KmBvs
         xyYPpdABnV5cxQb4W3Cf8EuijyCUD8RieicMy65dK7d4UjzsqDSyjO86gKdwEOc+mE
         nydSh0kKftJZnSXTXyb9uu/9v4NfuLSFrmalBcPLnyDkyvytG2l/l/N5cynrCoVVmf
         sgBCavIQOBnIdN+L333YRb9TXnXOX8lYYqbNCXCcztmgsvy2eYaHGozf+FOUyyaUbh
         JnzV43SJi4AKw==
Date:   Thu, 15 Apr 2021 16:05:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com
Subject: Re: [RFC net-next 4/6] ethtool: add interface to read standard MAC
 stats
Message-ID: <20210415160556.1b4f32b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7e82c145335a2cdd080cf9bcb731a315ca317fb3.camel@kernel.org>
References: <20210414202325.2225774-1-kuba@kernel.org>
        <20210414202325.2225774-5-kuba@kernel.org>
        <335639a79d72cec4abb3775bc84336f8390a57b7.camel@kernel.org>
        <20210415083837.6dfc0af9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7e82c145335a2cdd080cf9bcb731a315ca317fb3.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 15:46:52 -0700 Saeed Mahameed wrote:
> > > best practice here is to centralize all the data structures and
> > > information definitions in one place, you define the stat id,
> > > string,
> > > and value offset, then a generic loop can generate the strset and
> > > fill
> > > up values in the correct offset.
> > > 
> > > similar implementation is already in mlx5:
> > > 
> > > see pport_802_3_stats_desc:
> > >   
> > > https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c#L682
> > > 
> > > the "pport_802_3_stats_desc" has a description of the strings and
> > > offsets of all stats in this stats group
> > > and the fill/put functions are very simple and they just iterate
> > > over
> > > the array/group and fill up according to the descriptor.  
> > 
> > We can maybe save 60 lines if we generate stats_eth_mac_names 
> > in a initcall, is it really worth it? I prefer the readability 
> > / grepability.  
> 
> I don't think readability will be an issue if the infrastructure is
> generic enough.. 
> 
> This just a preference, of course you can go with the current code.
> My point is that someone doesn't need to change multiple places and
> possibly files every time they need to expose a new stat, you just
> update some central database of the new data you want to expose.

Understood, I've written those table-based generators for ethtool stats
in the drivers in the past as well, but here we can only generate the
dumping and the names. We'll need to manually fill in defines/enums in
uAPI, struct members and the generator table. I'd rather stick to
real struct members in the core<->driver API than indexing an array
with an enums. So the savings are 4 places => 3 places?

Unless I'm missing some clever, yet robust and readable ways of coding
this up..

Can we leave as is as starting point and see where we go from here?
So far MAC stats are the only sizable ones were we'd see noticeable
gain.
