Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775EA2EEDEB
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbhAHHfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbhAHHfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 02:35:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4562523403;
        Fri,  8 Jan 2021 07:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610091260;
        bh=ET7EZ4mvypeXbGjc6I95Szrku1HDtcYcljZd497LRCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1AKdmLGWNoFs4I4RUZUXI4nRu4Gvzplk5OuaUSq0tUYrXaWfobwlD+AfAQf1fWVy/
         lA2NuiuqvqUnQQTSh9BEgb+St3vMr7BT/djoUSnbub56JhCkBkUBdt7Lw45zsrBRiy
         VqVTG7vGlC+79EUir++sxgYHPw9UhIacV/onh0vs=
Date:   Fri, 8 Jan 2021 08:34:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Your Real Name <zhutong@amazon.com>
Cc:     David Miller <davem@davemloft.net>, sashal@kernel.org,
        edumazet@google.com, vvs@virtuozzo.com, netdev@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] neighbour: Disregard DEAD dst in neigh_update
Message-ID: <X/gK+KBlROogPCol@kroah.com>
References: <20201230225415.GA490@ucf43ac461c9a53.ant.amazon.com>
 <20210105.160521.1279064249478522010.davem@davemloft.net>
 <20210108023637.GA31904@ucf43ac461c9a53.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210108023637.GA31904@ucf43ac461c9a53.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 09:36:37PM -0500, Your Real Name wrote:
> On Tue, Jan 05, 2021 at 04:05:21PM -0800, David Miller wrote: 
> > 
> > 
> > From: Tong Zhu <zhutong@amazon.com>
> > Date: Wed, 30 Dec 2020 17:54:23 -0500
> > 
> > > In 4.x kernel a dst in DST_OBSOLETE_DEAD state is associated
> > > with loopback net_device and leads to loopback neighbour. It
> > > leads to an ethernet header with all zero addresses.
> > >
> > > A very troubling case is working with mac80211 and ath9k.
> > > A packet with all zero source MAC address to mac80211 will
> > > eventually fail ieee80211_find_sta_by_ifaddr in ath9k (xmit.c).
> > > As result, ath9k flushes tx queue (ath_tx_complete_aggr) without
> > > updating baw (block ack window), damages baw logic and disables
> > > transmission.
> > >
> > > Signed-off-by: Tong Zhu <zhutong@amazon.com>
> > 
> > Please repost with an appropriate Fixes: tag.
> > 
> > Thanks.
> 
> I had a second thought on this. This fix should go mainline too. This is a 
> case we are sending out queued packets when arp reply from the neighbour 
> comes in. With 5.x kernel, a dst in DST_OBSOLETE_DEAD state leads to dropping
> of this packet. It is not as bad as with 4.x kernel that may end up with an
> all-zero mac address packet out to ethernet or choking up ath9k when using 
> block ack. Dropping the packet is still wrong. I’ll repost as a fix to
> mainline and target backport to 4.x LTS releases.

That's how kernel development works, please read
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how stable kernels are allowed to accept patches.

good luck!

greg k-h
