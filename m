Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F612CF75F
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgLDXSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:18:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLDXSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:18:24 -0500
Date:   Fri, 4 Dec 2020 15:17:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607123864;
        bh=sSno5OIYAoA4jFBIgv/0XbtyYExZFQCFfOrnwExkA0Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=oM+et4++2s8yOLSIetLTrzQF22+IAkBbfMOnkg6WLy5IJ/QOEg8Rx0ygAqVMvBJgM
         KPfRgeS+l8RVVCW+hH6/lm34yB558Jy15lRxT5Bg9d/UR97IhM/vBcWrS87rCMDwk3
         zZQD/0YKRFJ6SkPzeTMBYsEZCN4iHfFdlvxBha4Qfmk6uf10+hLhQLwKxlzI8l0+E4
         qQOx1h0qCuvHKz4AiRoSVZaBCh1tZaWZtuKbskpEwR0wWt1bo3Z6SqGud1nqdcKX+9
         vTsMHvyJnsOj0SsL1eTPQQkMIL7mP0SfOWpfzfVC6UzZEVlKSAH5cA7fwmNevFPBW1
         JmvCPW2LIWI4g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
References: <20201203042108.232706-1-saeedm@nvidia.com>
        <20201203042108.232706-9-saeedm@nvidia.com>
        <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
        <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 13:57:49 -0800 Saeed Mahameed wrote:
> > > option 2) route PTP traffic to a special SQs per ring, this SQ will
> > > be
> > > PTP port accurate, Normal traffic will continue through regular SQs
> > > 
> > > Pros: Regular non PTP traffic not affected.
> > > Cons: High memory footprint for creating special SQs
> > > 
> > > So we prefer (2) + private flag to avoid the performance hit and
> > > the
> > > redundant memory usage out of the box.  
> > 
> > Option 3 - have only one special PTP queue in the system. PTP traffic
> > is rather low rate, queue per core doesn't seem necessary.
> 
> We only forward ptp traffic to the new special queue but we create more
> than one to avoid internal locking as we will utilize the tx softirq
> percpu.

In other words to make the driver implementation simpler we'll have
a pretty basic feature hidden behind a ethtool priv knob and a number
of queues which doesn't match reality reported to user space. Hm.
