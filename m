Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2F3327844
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhCAH0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:26:46 -0500
Received: from mx3.wp.pl ([212.77.101.9]:17860 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232490AbhCAH0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 02:26:42 -0500
Received: (wp-smtpd smtp.wp.pl 14851 invoked from network); 1 Mar 2021 08:25:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1614583548; bh=caswnsyka5PEQKPkgMw1QK+L+kDqw+U3lis6uLlqdwQ=;
          h=From:To:Cc:Subject;
          b=ij7ENGWGuXkLO6Kdm5TdqpoCfYx7ir/553xjFx4nqgoc20qUabZcbCx+QpNd71lYu
           B7Y5dDAmyFxMnvxgp9uEj+U238WRDUpZ4Ow4uc9r0NyrbTuofsJvEuX7fD+ARnOGUt
           3VfO1OeGig5L683pnbm1AykvDBZr5m5g9I9uvD4E=
Received: from ip4-46-39-164-204.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.204])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <dinghao.liu@zju.edu.cn>; 1 Mar 2021 08:25:47 +0100
Date:   Mon, 1 Mar 2021 08:25:47 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: Add missing check in il4965_commit_rxon
Message-ID: <20210301072547.GA118024@wp.pl>
References: <20210228122522.2513-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210228122522.2513-1-dinghao.liu@zju.edu.cn>
X-WP-MailID: 978dc73fa3a4319775c96140784be0be
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AbOk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 08:25:22PM +0800, Dinghao Liu wrote:
> There is one il_set_tx_power() call in this function without
> return value check. Print error message and return error code
> on failure just like the other il_set_tx_power() call.

We have few calls for il_set_tx_power(), on some cases we
check return on some not. That correct as setting tx power
can be deferred internally if not possible at the moment.

> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/net/wireless/intel/iwlegacy/4965.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
> index 9fa556486511..3235b8be1894 100644
> --- a/drivers/net/wireless/intel/iwlegacy/4965.c
> +++ b/drivers/net/wireless/intel/iwlegacy/4965.c
> @@ -1361,7 +1361,11 @@ il4965_commit_rxon(struct il_priv *il)
>  		 * We do not commit tx power settings while channel changing,
>  		 * do it now if tx power changed.
>  		 */
> -		il_set_tx_power(il, il->tx_power_next, false);
> +		ret = il_set_tx_power(il, il->tx_power_next, false);
> +		if (ret) {
> +			IL_ERR("Error sending TX power (%d)\n", ret);
> +			return ret;
> +		

This is not good change. We do not check return value of
il_commit_rxon(), except when creating interface. So this change might
broke creating interface, what worked otherwise when il_set_tx_power()
returned error.

Stanislaw
