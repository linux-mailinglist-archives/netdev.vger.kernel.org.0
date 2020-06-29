Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568C020E101
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbgF2Uvj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 16:51:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:9538 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731397AbgF2Uvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 16:51:37 -0400
IronPort-SDR: KGC9trzAZj8tlqEdtxStBgCI6c+leZkSudgZZBDurcPaLSIzW28R+/TmLwtT/1ezEKjQRiZ9aN
 OfeHJDOcCGSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="147630893"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="147630893"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 13:51:35 -0700
IronPort-SDR: fnhmaK0UHih/rpGhBgG8JDncDAI4lCB8e4BUrDG783kKNhRPjxZHU3LQhy+jWcWch6jYfWiI5K
 EJd0ayqzmIug==
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="266296711"
Received: from rramire2-mobl.amr.corp.intel.com (HELO localhost) ([10.213.184.115])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 13:51:33 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200626213035.45653c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com> <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com> <20200626213035.45653c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of ptp_tx_skb
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Aaron Brown <aaron.f.brown@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date:   Mon, 29 Jun 2020 13:51:32 -0700
Message-ID: <159346389229.30391.2954936254801502352@rramire2-mobl.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Quoting Jakub Kicinski (2020-06-26 21:30:35)
> On Fri, 26 Jun 2020 18:54:23 -0700 Jeff Kirsher wrote:
> > From: Andre Guedes <andre.guedes@intel.com>
> > 
> > The __IGC_PTP_TX_IN_PROGRESS flag indicates we have a pending Tx
> > timestamp. In some places, instead of checking that flag, we check
> > adapter->ptp_tx_skb. This patch fixes those places to use the flag.
> > 
> > Quick note about igc_ptp_tx_hwtstamp() change: when that function is
> > called, adapter->ptp_tx_skb is expected to be valid always so we
> > WARN_ON_ONCE() in case it is not.
> > 
> > Quick note about igc_ptp_suspend() change: when suspending, we don't
> > really need to check if there is a pending timestamp. We can simply
> > clear it unconditionally.
> > 
> > Signed-off-by: Andre Guedes <andre.guedes@intel.com>
> > Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> >  drivers/net/ethernet/intel/igc/igc_ptp.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
> > index b1b23c6bf689..e65fdcf966b2 100644
> > --- a/drivers/net/ethernet/intel/igc/igc_ptp.c
> > +++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
> > @@ -404,9 +404,6 @@ void igc_ptp_tx_hang(struct igc_adapter *adapter)
> >       bool timeout = time_is_before_jiffies(adapter->ptp_tx_start +
> >                                             IGC_PTP_TX_TIMEOUT);
> >  
> > -     if (!adapter->ptp_tx_skb)
> > -             return;
> > -
> >       if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
> >               return;
> >  
> > @@ -435,6 +432,9 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
> >       struct igc_hw *hw = &adapter->hw;
> >       u64 regval;
> >  
> > +     if (WARN_ON_ONCE(!skb))
> > +             return;
> > +
> >       regval = rd32(IGC_TXSTMPL);
> >       regval |= (u64)rd32(IGC_TXSTMPH) << 32;
> >       igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
> > @@ -466,7 +466,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
> >       struct igc_hw *hw = &adapter->hw;
> >       u32 tsynctxctl;
> >  
> > -     if (!adapter->ptp_tx_skb)
> > +     if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
> >               return;
> 
> Not that reading ptp_tx_skb is particularly correct here, but I think
> it's better. See how they get set:
> 
>                 if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
>                     !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS,
>                                            &adapter->state)) {
>                         skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>                         tx_flags |= IGC_TX_FLAGS_TSTAMP;
> 
>                         adapter->ptp_tx_skb = skb_get(skb);
>                         adapter->ptp_tx_start = jiffies;
> 
> bit is set first and other fields after. Since there is no locking here
> we may just see the bit but none of the fields set.

I see your point, but note that the code within the if-block and the code in
igc_ptp_tx_work() don't execute concurrently. adapter->ptp_tx_work is scheduled
only on a time-sync interrupt, which is triggered if IGC_TX_FLAGS_TSTAMP is
set (so adapter->ptp_tx_skb is valid).

- Andre
