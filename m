Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2B720BE4A
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgF0Eai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgF0Eah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 00:30:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 558972067D;
        Sat, 27 Jun 2020 04:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593232237;
        bh=cpq2Pf2xFvP5TLL/54LK3xnyNNLyYNPNBeFn+lcRuyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1/coI59Cvii2a7i4JKWUio/SE7Od1z/h7x3/bz3cARwqZC5LyUhKRdieeL8945dK9
         Ki+S+eac1JeP1y0KYOr+SawMdsMimD2E8xZIamBTujnMt9W/7tgdcnh5EIAmY/1ZDd
         5dZjbs20Jv1AaH94Go346jHtTDEszGsyh5OZHK2I=
Date:   Fri, 26 Jun 2020 21:30:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Andre Guedes <andre.guedes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of
 ptp_tx_skb
Message-ID: <20200626213035.45653c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
        <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 18:54:23 -0700 Jeff Kirsher wrote:
> From: Andre Guedes <andre.guedes@intel.com>
> 
> The __IGC_PTP_TX_IN_PROGRESS flag indicates we have a pending Tx
> timestamp. In some places, instead of checking that flag, we check
> adapter->ptp_tx_skb. This patch fixes those places to use the flag.
> 
> Quick note about igc_ptp_tx_hwtstamp() change: when that function is
> called, adapter->ptp_tx_skb is expected to be valid always so we
> WARN_ON_ONCE() in case it is not.
> 
> Quick note about igc_ptp_suspend() change: when suspending, we don't
> really need to check if there is a pending timestamp. We can simply
> clear it unconditionally.
> 
> Signed-off-by: Andre Guedes <andre.guedes@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_ptp.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
> index b1b23c6bf689..e65fdcf966b2 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ptp.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
> @@ -404,9 +404,6 @@ void igc_ptp_tx_hang(struct igc_adapter *adapter)
>  	bool timeout = time_is_before_jiffies(adapter->ptp_tx_start +
>  					      IGC_PTP_TX_TIMEOUT);
>  
> -	if (!adapter->ptp_tx_skb)
> -		return;
> -
>  	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
>  		return;
>  
> @@ -435,6 +432,9 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
>  	struct igc_hw *hw = &adapter->hw;
>  	u64 regval;
>  
> +	if (WARN_ON_ONCE(!skb))
> +		return;
> +
>  	regval = rd32(IGC_TXSTMPL);
>  	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
>  	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
> @@ -466,7 +466,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
>  	struct igc_hw *hw = &adapter->hw;
>  	u32 tsynctxctl;
>  
> -	if (!adapter->ptp_tx_skb)
> +	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
>  		return;

Not that reading ptp_tx_skb is particularly correct here, but I think
it's better. See how they get set:

		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
		    !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS,
					   &adapter->state)) {
			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
			tx_flags |= IGC_TX_FLAGS_TSTAMP;

			adapter->ptp_tx_skb = skb_get(skb);
			adapter->ptp_tx_start = jiffies;

bit is set first and other fields after. Since there is no locking here
we may just see the bit but none of the fields set.

>  	if (time_is_before_jiffies(adapter->ptp_tx_start +
> @@ -588,11 +588,9 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
>  		return;
>  
>  	cancel_work_sync(&adapter->ptp_tx_work);
> -	if (adapter->ptp_tx_skb) {
> -		dev_kfree_skb_any(adapter->ptp_tx_skb);
> -		adapter->ptp_tx_skb = NULL;
> -		clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
> -	}
> +	dev_kfree_skb_any(adapter->ptp_tx_skb);
> +	adapter->ptp_tx_skb = NULL;
> +	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
>  }
>  
>  /**

