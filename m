Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21A71FFD8F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgFRVu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:50:58 -0400
Received: from smtp4.emailarray.com ([65.39.216.22]:22296 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgFRVu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:50:58 -0400
Received: (qmail 50261 invoked by uid 89); 18 Jun 2020 21:50:55 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 18 Jun 2020 21:50:55 -0000
Date:   Thu, 18 Jun 2020 14:50:53 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        Govindarajulu Varadarajan <gvaradar@cisco.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [RFC PATCH 06/21] mlx5: add header_split flag
Message-ID: <20200618215053.qxnjegm4h5i3mvfu@bsd-mbp.dhcp.thefacebook.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
 <20200618160941.879717-7-jonathan.lemon@gmail.com>
 <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 11:12:57AM -0700, Eric Dumazet wrote:
> 
> 
> On 6/18/20 9:09 AM, Jonathan Lemon wrote:
> > Adds a "rx_hd_split" private flag parameter to ethtool.
> > 
> > This enables header splitting, and sets up the fragment mappings.
> > The feature is currently only enabled for netgpu channels.
> 
> We are using a similar idea (pseudo header split) to implement 4096+(headers) MTU at Google,
> to enable TCP RX zerocopy on x86.
> 
> Patch for mlx4 has not been sent upstream yet.
> 
> For mlx4, we are using a single buffer of 128*(number_of_slots_per_RX_RING),
> and 86 bytes for the first frag, so that the payload exactly fits a 4096 bytes page.
> 
> (In our case, most of our data TCP packets only have 12 bytes of TCP options)
> 
> 
> I suggest that instead of a flag, you use a tunable, that can be set by ethtool,
> so that the exact number of bytes can be tuned, instead of hard coded in the driver.

Sounds reasonable - in the long run, it would be ideal to have the
hardware actually perform header splitting, but for now using a tunable
fixed offset will work.  In the same vein, there should be a similar
setting for the TCP option padding on the sender side.
-- 
Jonathan
