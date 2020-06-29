Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E0720E885
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbgF2WLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 18:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgF2WLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 18:11:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D32C20656;
        Mon, 29 Jun 2020 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593468679;
        bh=J4DajGjkybuN5ME2QGmjwbtqrR2hj+3nS6TbLyQC3dE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wXELsMR5QQ0GLzR2RyI4Yu5KxjILM7eBaQZQF8tZUx+Q+YJM7ymlWbEIoXjPEyMAp
         tvp4nAeTMcds5xMft777dqSGtfGnppx/BoEqnk3dPZDpD3yesg9ArZN2Z45qkeQmVW
         u3zTJpkjLGWstI4MVMIf8UchmX7kFCz/tXjgrhdc=
Date:   Mon, 29 Jun 2020 15:11:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andre Guedes <andre.guedes@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of
 ptp_tx_skb
Message-ID: <20200629151117.63b466c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <159346389229.30391.2954936254801502352@rramire2-mobl.amr.corp.intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
        <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com>
        <20200626213035.45653c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <159346389229.30391.2954936254801502352@rramire2-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 13:51:32 -0700 Andre Guedes wrote:
> > > @@ -435,6 +432,9 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
> > >       struct igc_hw *hw = &adapter->hw;
> > >       u64 regval;
> > >  
> > > +     if (WARN_ON_ONCE(!skb))
> > > +             return;
> > > +
> > >       regval = rd32(IGC_TXSTMPL);
> > >       regval |= (u64)rd32(IGC_TXSTMPH) << 32;
> > >       igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
> > > @@ -466,7 +466,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
> > >       struct igc_hw *hw = &adapter->hw;
> > >       u32 tsynctxctl;
> > >  
> > > -     if (!adapter->ptp_tx_skb)
> > > +     if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
> > >               return;  
> > 
> > Not that reading ptp_tx_skb is particularly correct here, but I think
> > it's better. See how they get set:
> > 
> >                 if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
> >                     !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS,
> >                                            &adapter->state)) {
> >                         skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> >                         tx_flags |= IGC_TX_FLAGS_TSTAMP;
> > 
> >                         adapter->ptp_tx_skb = skb_get(skb);
> >                         adapter->ptp_tx_start = jiffies;
> > 
> > bit is set first and other fields after. Since there is no locking here
> > we may just see the bit but none of the fields set.  
> 
> I see your point, but note that the code within the if-block and the code in
> igc_ptp_tx_work() don't execute concurrently. adapter->ptp_tx_work is scheduled
> only on a time-sync interrupt, which is triggered if IGC_TX_FLAGS_TSTAMP is
> set (so adapter->ptp_tx_skb is valid).

What if timeout happens, igc_ptp_tx_hang() starts cleaning up and then
irq gets delivered half way through? Perhaps we should just add a spin
lock around the ptp_tx_s* fields?
