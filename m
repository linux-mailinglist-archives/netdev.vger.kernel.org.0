Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8C020E9E3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgF3AHN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 20:07:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:55645 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgF3AHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:07:13 -0400
IronPort-SDR: YfJ89ur8jfdGbc71/ZndDeK9JirucbB3GIRnKFaYg3R+mp16/uTcRDe2v2irOPxSr81J+U9mkr
 xPyHVO+tFYSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="133546808"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="133546808"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 17:07:12 -0700
IronPort-SDR: sH1c5QPssDemAOCqmrIkXM8zGb6N9bvmFduIaWhkDzXFZgF37jwhWpytCNYGxN9cbl1vV+Q00U
 /9ecVcKINCvQ==
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="424997374"
Received: from shabnaja-mobl.amr.corp.intel.com (HELO localhost) ([10.212.142.17])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 17:07:11 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200629151117.63b466c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com> <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com> <20200626213035.45653c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <159346389229.30391.2954936254801502352@rramire2-mobl.amr.corp.intel.com> <20200629151117.63b466c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of ptp_tx_skb
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 29 Jun 2020 17:07:00 -0700
Message-ID: <159347562079.35713.11550779660753529150@shabnaja-mobl.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2020-06-29 15:11:17)
> On Mon, 29 Jun 2020 13:51:32 -0700 Andre Guedes wrote:
> > > > @@ -435,6 +432,9 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
> > > >       struct igc_hw *hw = &adapter->hw;
> > > >       u64 regval;
> > > >  
> > > > +     if (WARN_ON_ONCE(!skb))
> > > > +             return;
> > > > +
> > > >       regval = rd32(IGC_TXSTMPL);
> > > >       regval |= (u64)rd32(IGC_TXSTMPH) << 32;
> > > >       igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
> > > > @@ -466,7 +466,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
> > > >       struct igc_hw *hw = &adapter->hw;
> > > >       u32 tsynctxctl;
> > > >  
> > > > -     if (!adapter->ptp_tx_skb)
> > > > +     if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
> > > >               return;  
> > > 
> > > Not that reading ptp_tx_skb is particularly correct here, but I think
> > > it's better. See how they get set:
> > > 
> > >                 if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
> > >                     !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS,
> > >                                            &adapter->state)) {
> > >                         skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> > >                         tx_flags |= IGC_TX_FLAGS_TSTAMP;
> > > 
> > >                         adapter->ptp_tx_skb = skb_get(skb);
> > >                         adapter->ptp_tx_start = jiffies;
> > > 
> > > bit is set first and other fields after. Since there is no locking here
> > > we may just see the bit but none of the fields set.  
> > 
> > I see your point, but note that the code within the if-block and the code in
> > igc_ptp_tx_work() don't execute concurrently. adapter->ptp_tx_work is scheduled
> > only on a time-sync interrupt, which is triggered if IGC_TX_FLAGS_TSTAMP is
> > set (so adapter->ptp_tx_skb is valid).
> 
> What if timeout happens, igc_ptp_tx_hang() starts cleaning up and then
> irq gets delivered half way through? Perhaps we should just add a spin
> lock around the ptp_tx_s* fields?

Yep, I think this other scenario is possible indeed, and we should probably
protect ptp_tx_s* with a lock. Thanks for pointing that out. In fact, it seems
this issue can happen even with current net-next code.

Since that issue is not introduced by this patch, would it be OK we move forward
with it, and fix the issue in a separate patch?

- Andre
