Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB4439338D
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbhE0QV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232891AbhE0QVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 12:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1972860FF3;
        Thu, 27 May 2021 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622132392;
        bh=gXo5Trz51gu1lgHD9BHyalYs7vTOUlBdoPHVtRudE3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bo/qf0yAa3QdHjn1DqywHQ6oWcjitvvOW8YzNP/5Q+jRHD5gCDCs2Nbl7QT3B+/sQ
         /hzbd0TQMcrQbnMJ2knxOi0ozwnjpqY1O0K1k+B1Aykm7bAtDMofcPyw/RS3G4JDYW
         I/mJvTykBHO/JNMN3RgnFxOFJCth6p5D9RFXoxPZMbmnNkk0pV7rgkUJ6NfWvXHCUj
         4hO6WrrE8blw7xWNGg6K7owvdMJo/vjS3JGmem3ooezJM7PR8EqQfMSQHBfz4H6QiJ
         /uiFyF2cCQK0sBbWOg31XjfenhlOoL7jCIzroiXialfd1Pun3S7XJ0JEvYNkMAqYdU
         82+1Pl+IDZGbg==
Date:   Thu, 27 May 2021 09:19:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] atl1c: add 4 RX/TX queue support for
 Mikrotik 10/25G NIC
Message-ID: <20210527091951.7db60cc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d2651c5f20d072f99e66f9e1df3956f0@mikrotik.com>
References: <20210526075830.2959145-1-gatis@mikrotik.com>
        <20210526181609.1416c4eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d2651c5f20d072f99e66f9e1df3956f0@mikrotik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 16:49:22 +0300 Gatis Peisenieks wrote:
> On 2021-05-27 04:16, Jakub Kicinski wrote:
> >> +/**
> >> + * atl1c_clean_rx - NAPI Rx polling callback
> >> + * @napi: napi info
> >> + * @budget: limit of packets to clean
> >> + */
> >> +static int atl1c_clean_rx(struct napi_struct *napi, int budget)
> >>  {
> >> +	struct atl1c_rrd_ring *rrd_ring =
> >> +		container_of(napi, struct atl1c_rrd_ring, napi);
> >> +	struct atl1c_adapter *adapter = rrd_ring->adapter;
> >> +	int work_done = 0;
> >> +	unsigned long flags;
> >>  	u16 rfd_num, rfd_index;
> >> -	u16 count = 0;
> >>  	u16 length;
> >>  	struct pci_dev *pdev = adapter->pdev;
> >>  	struct net_device *netdev  = adapter->netdev;
> >> -	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
> >> -	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
> >> +	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[rrd_ring->num];
> >>  	struct sk_buff *skb;
> >>  	struct atl1c_recv_ret_status *rrs;
> >>  	struct atl1c_buffer *buffer_info;
> >> 
> >> +	/* Keep link state information with original netdev */
> >> +	if (!netif_carrier_ok(adapter->netdev))
> >> +		goto quit_polling;  
> > 
> > Interesting, I see you only move this code, but why does this driver
> > stop reading packets when link goes down? Surely there may be packets
> > already on the ring which Linux should process?  
> 
> Jakub, I do not know what possible HW quirks this check might be
> covering up, so I left it there. If you feel it is safe to remove
> I can do a separate patch for that. I think it is fine for the
> HW I work with, but that is far from everything this driver supports.

No strong feelings either way. I was mostly surprised to see such code,
so I thought I'd ask in case you knew why it was there.
