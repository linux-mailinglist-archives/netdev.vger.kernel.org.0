Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A4D2D1ABA
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgLGUnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgLGUnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:43:15 -0500
Date:   Mon, 7 Dec 2020 12:42:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607373754;
        bh=DRHUS9nc3VeZ6aImldRvU+F7Vbm/BnCYaDCQq4JSfsg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=cTNLXKuj88DuS3zaWAXdqoEJ4YotHaqUWHrDRaBh6rl5JoTLTT2muhTd0pgcihvuu
         AvGFWnUMum+CnIg4fL8y5GGOg8vaINPsn4eu2xF+KvOKH5afSGXhL6Ff0ep/L55f/r
         J4zSMjsP/fBIK0jvML5NQEj2BH/bNCkmTqzfawwpnAyBAN2tU5kvubxiEPB8IybiEY
         LdvsGTaDjKWNrFOFF07O5laDLbY50U0WgiM/SgSWFqFxa5Tlsfz2aY6ZQwuX+7+m3L
         P1vLCxekrOO/nkncXcuUoD91qs+rDCoY0GGpg6J4tY8DlBcygNUd/FtpC78QRGi9M7
         l9A5d7NQgMFRQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201207124233.22540545@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207151906.GA30105@hoboy.vegasvil.org>
References: <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
        <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
        <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
        <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
        <20201206170834.GA4342@hoboy.vegasvil.org>
        <a03538c728bf232ccae718d78de43883c4fca70d.camel@kernel.org>
        <20201207151906.GA30105@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 07:19:06 -0800 Richard Cochran wrote:
> On Mon, Dec 07, 2020 at 12:37:45AM -0800, Saeed Mahameed wrote:
> > we are not adding any new mechanism.  
> 
> Sorry, I didn't catch the beginning of this thread.  Are you proposing
> adding HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY to net_tstamp.h ?
> 
> If so, then ...
> 
> > Our driver feature is and internal enhancement yes, but the suggested
> > flag is very far from indicating any internal enhancement, is actually
> > an enhancement to the current API, and is a very simple extension with
> > wide range of improvements to all layers.  
> 
> No, that would be no enhancement but rather a hack for poorly designed
> hardware.
> 
> > Our driver can optimize accuracy when this flag is set, other drivers
> > might be happy to implement it since they already have a slow hw  
> 
> Name three other drivers that would "be happy" to implement this.  Can
> you name even one other?

The behavior is not entirely dissimilar to the time stamps on
multi-layered devices (e.g. DSA switches). The time stamp can either 
be generated when the packet enters the device (current mlx5 behavior)
or when it actually egresses thru the MAC (what this set adds).

So while we could find other hardware like this if we squint hard enough
- I'm not sure how much practical use for CPU-side stamps there is in DSA.


My main concern is the user friendliness. I think there is no question
that user running ptp4l would want this mlx5 knob to be enabled. Would
we rather see a patch to ptp4l that turns per driver knob or should we
shoot for some form of an API that tells the kernel that we're
expecting ns level time accuracy? 

That's how I would phrase the dilemma here.
