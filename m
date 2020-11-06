Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87092A9F1E
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgKFVdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbgKFVdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 16:33:45 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F46E20735;
        Fri,  6 Nov 2020 21:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604698424;
        bh=JYrd411jLEgnlbtCWgJUXv6BtR0BTLaOn9QUNBsP+yo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=q62qEl52Akk6r0EzQRJ8ZlyQrUhKh6wi41/cwakjB3e42U/ZCFm5Pi8HlonqYq8OA
         tOBNv7Ze/i0de06Eu2GY4Y4dQAgwKZnKLe3iPCFO8Mf8j9NOgyo1b8a7PkkP4iIKlK
         hc23sTDGqfe/Eh/+mLVFywgVIH6uMtihG+y2Py3Y=
Message-ID: <5cf579a6b137b569b5f01871561f83ca2e9ac659.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 6/8] ionic: flatten calls to
 ionic_lif_rx_mode
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Date:   Fri, 06 Nov 2020 13:33:43 -0800
In-Reply-To: <20201106001220.68130-7-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
         <20201106001220.68130-7-snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 16:12 -0800, Shannon Nelson wrote:
> The _ionic_lif_rx_mode() is only used once and really doesn't
> need to be broken out.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../net/ethernet/pensando/ionic/ionic_lif.c   | 38 ++++++++---------
> --
>  1 file changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index a0d26fe4cbc3..ef092ee33e59 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1129,29 +1129,10 @@ static void ionic_lif_rx_mode(struct
> ionic_lif *lif, unsigned int rx_mode)
>  		lif->rx_mode = rx_mode;
>  }
>  
> -static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int
> rx_mode,
> -			       bool from_ndo)
> -{
> -	struct ionic_deferred_work *work;
> -
> -	if (from_ndo) {
> -		work = kzalloc(sizeof(*work), GFP_ATOMIC);
> -		if (!work) {
> -			netdev_err(lif->netdev, "%s OOM\n", __func__);
> -			return;
> -		}
> -		work->type = IONIC_DW_TYPE_RX_MODE;
> -		work->rx_mode = rx_mode;
> -		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
> -		ionic_lif_deferred_enqueue(&lif->deferred, work);
> -	} else {
> -		ionic_lif_rx_mode(lif, rx_mode);
> -	}
> -}
> -
>  static void ionic_set_rx_mode(struct net_device *netdev, bool
> from_ndo)
>  {
>  	struct ionic_lif *lif = netdev_priv(netdev);
> +	struct ionic_deferred_work *work;
>  	unsigned int nfilters;
>  	unsigned int rx_mode;
>  
> @@ -1197,8 +1178,21 @@ static void ionic_set_rx_mode(struct
> net_device *netdev, bool from_ndo)
>  			rx_mode &= ~IONIC_RX_MODE_F_ALLMULTI;
>  	}
>  
> -	if (lif->rx_mode != rx_mode)
> -		_ionic_lif_rx_mode(lif, rx_mode, from_ndo);
> +	if (lif->rx_mode != rx_mode) {
> +		if (from_ndo) {
> +			work = kzalloc(sizeof(*work), GFP_ATOMIC);
> +			if (!work) {
> +				netdev_err(lif->netdev, "%s OOM\n",
> __func__);
> +				return;
> +			}
> +			work->type = IONIC_DW_TYPE_RX_MODE;
> +			work->rx_mode = rx_mode;
> +			netdev_dbg(lif->netdev, "deferred: rx_mode\n");
> +			ionic_lif_deferred_enqueue(&lif->deferred,
> work);
> +		} else {
> +			ionic_lif_rx_mode(lif, rx_mode);
> +		}
> +	}
>  }

You could move this logic one level up and totally eliminate the if
condition 

ionic_set_rx_mode_needed() {
      //sync driver data base
      return lif->rx_mode != rx_mode;
}

ndo_set_rx_mode() {
      if (!ionic_set_rx_mode_needed())
            return; // no change;
      schedule_work(set_rx_mode_hw);
}

none_ndo_set_rx_mode() {
      if (!ionic_set_rx_mode_needed())
            return; // no change;
      set_rx_mode_hw();
}

Future improvement:

One more thing I've noticed about you current ionic_set_rx_mode()
is that in case of from_ndo, when it syncs mac addresses it will
schedule a deferred mac address update work to hw per address. which i
think is an overkill, a simpler design which will totally eliminate the
need for from_ndo flags, is to do similar to the above but with a minor
change.

ionic_set_rx_mode_needed() {
      // Just sync driver mac table here and update hw later
      // in one deferred work rather than scheduling multi work
      addr_changed = ionic_dev_uc_sync();
      addr_changed |= ionic_dev_mc_sync();
      rx_mode_changed = sync_driver_rx_mode(rx_mode);

      return rx_mode_changed || addr_changed;
}

/* might sleep */
set_rx_mode_hw() {
      commit_addr_change_to_hw();
      commit_rx_mode_changes_to_hw();
}

ndo_set_rx_mode() {
      if (!ionic_set_rx_mode_needed())
            return; // no change;
      schedule_work(set_rx_mode_hw);
}

none_ndo_set_rx_mode() {
      if (!ionic_set_rx_mode_needed())
            return; // no change;
      set_rx_mode_hw();
} 

