Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C8B2F4155
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbhAMBtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbhAMBtE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 20:49:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 569CD2310A;
        Wed, 13 Jan 2021 01:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610502503;
        bh=43aJ9tyLYObjqala5EtmpQdOSUPdjov/kxghKOSUQfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pJrmKAe4U7o3rUbX7j4XJF+YSidpUGn5ou0Fos34mixb7eoYW47/3JtMGkRZGPnk7
         8Xz9is3hnWW2BhYEtOWqOVfig9xdEfmV5iGAHohvHoRzrIgPmXxyRd27oGAQ6m/6q2
         uh/4stT9gdMd1Yz2pWKsfWCt59ixFof7r1L6N9fEYhviWCe4s6dY+ea6dUg1fTxawd
         JRtVsVO8qgVbJZ8OIS12Tnl0cVh4u8u/gHNcFi8/LwhEqGncNSd4GzjED0kSTqXTc8
         vqzIZhukGg5D5ClnborttsSK7rPoKgK4XG3Xpvyla2NREWzSdd8eIKX8eF/LsUmkxW
         vIFmUXlf1iwJg==
Date:   Tue, 12 Jan 2021 17:48:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] can: dev: add software tx timestamps
Message-ID: <20210112174822.7ee9b67d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112174625.40c02021@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210112095437.6488-1-mailhol.vincent@wanadoo.fr>
        <20210112095437.6488-2-mailhol.vincent@wanadoo.fr>
        <f9ebb060-f190-79af-d57a-d5394390d222@pengutronix.de>
        <20210112174625.40c02021@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 17:46:25 -0800 Jakub Kicinski wrote:
> On Tue, 12 Jan 2021 11:03:00 +0100 Marc Kleine-Budde wrote:
> > On 1/12/21 10:54 AM, Vincent Mailhol wrote:  
> > > Call skb_tx_timestamp() within can_put_echo_skb() so that a software
> > > tx timestamp gets attached on the skb.
> > > 
> > > There two main reasons to include this call in can_put_echo_skb():
> > > 
> > >   * It easily allow to enable the tx timestamp on all devices with
> > >     just one small change.
> > > 
> > >   * According to Documentation/networking/timestamping.rst, the tx
> > >     timestamps should be generated in the device driver as close as
> > >     possible, but always prior to passing the packet to the network
> > >     interface. During the call to can_put_echo_skb(), the skb gets
> > >     cloned meaning that the driver should not dereference the skb
> > >     variable anymore after can_put_echo_skb() returns. This makes
> > >     can_put_echo_skb() the very last place we can use the skb without
> > >     having to access the echo_skb[] array.
> > > 
> > > Remark: by default, skb_tx_timestamp() does nothing. It needs to be
> > > activated by passing the SOF_TIMESTAMPING_TX_SOFTWARE flag either
> > > through socket options or control messages.
> > > 
> > > References:
> > > 
> > >  * Support for the error queue in CAN RAW sockets (which is needed for
> > >    tx timestamps) was introduced in:
> > >    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eb88531bdbfaafb827192d1fc6c5a3fcc4fadd96
> > > 
> > >   * Put the call to skb_tx_timestamp() just before adding it to the
> > >     array: https://lkml.org/lkml/2021/1/10/54
> > > 
> > >   * About Tx hardware timestamps
> > >     https://lore.kernel.org/linux-can/20210111171152.GB11715@hoboy.vegasvil.org/
> > > 
> > > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>    
> > 
> > Applied to linux-can-next/testing  
> 
> Please make sure to address the warnings before this hits net-next:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20210112130538.14912-2-mailhol.vincent@wanadoo.fr/
> 
> Actually it appears not to build with allmodconfig..?

Erm, apologies, I confused different CAN patches, this one did not get
build tested.
