Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9D82BB962
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgKTWs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbgKTWs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 17:48:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00732236F;
        Fri, 20 Nov 2020 22:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605912506;
        bh=xMNr71BNYsQHRN8HnEGa9yBKOceQUoklXMNC5J8nkGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=COifunyRAOTpDmGcsGBJcHS/I+QjzNsOFSpH9B0AOXRY0mn2TVcsbM4szBcBnt1EB
         bnieLgERm26lcleQNGnqDaPd4smc6JR+GjF9hXokL/yQgt7UI0CLMXnH2kStF5x9UM
         7ZzhRtF0+VgHrOwCaazROvwlyaZdf8m2a+X1eZ/Q=
Date:   Fri, 20 Nov 2020 14:48:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] net: don't include ethtool.h from netdevice.h
Message-ID: <20201120144824.2fc3eda0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9b722328efd90104d0c0819f530c296213c19450.camel@sipsolutions.net>
References: <20201120221328.1422925-1-kuba@kernel.org>
        <9b722328efd90104d0c0819f530c296213c19450.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 23:28:28 +0100 Johannes Berg wrote:
> On Fri, 2020-11-20 at 14:13 -0800, Jakub Kicinski wrote:
> > linux/netdevice.h is included in very many places, touching any
> > of its dependecies causes large incremental builds.
> > 
> > Drop the linux/ethtool.h include, linux/netdevice.h just needs
> > a forward declaration of struct ethtool_ops.
> > 
> > Fix all the places which made use of this implicit include.  
> 
> >  include/net/cfg80211.h                                   | 1 +  
> 
> Sounds good to me, thanks. Will still cause all wireless drivers to
> rebuild this way though. Maybe I'll see later if something can be done
> about that.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Same for RDMA, sadly. Both need the firmware version string length.

One simple way to narrow things down would be to include only the uapi
version. Or we can duplicate the define, AFAIR duplicate defines are ok
as long as they are identical.

But not sure it's worth it, I'm happy enough with the 2x reduction in
objects getting rebuilt :)
