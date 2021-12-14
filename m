Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8C2473CB9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhLNFt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhLNFt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:49:26 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21286C061748
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 21:49:26 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mx0gj-000665-31; Tue, 14 Dec 2021 06:49:21 +0100
Message-ID: <28922ca0-8513-c804-7f1d-bcce30147b68@leemhuis.info>
Date:   Tue, 14 Dec 2021 06:49:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net v1] igc: Do not enable crosstimestamping for i225-V
 models
Content-Language: en-BW
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, roots@gmx.de, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, greg@kroah.com, kuba@kernel.org
References: <87wnk8qrt8.fsf@intel.com>
 <20211214003949.666642-1-vinicius.gomes@intel.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20211214003949.666642-1-vinicius.gomes@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1639460966;f13f2927;
X-HE-SMSGID: 1mx0gj-000665-31
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

Thx for working on this. Two small details:

On 14.12.21 01:39, Vinicius Costa Gomes wrote:
> It was reported that when PCIe PTM is enabled, some lockups could
> be observed with some integrated i225-V models.
> 
> While the issue is investigated, we can disable crosstimestamp for
> those models and see no loss of functionality, because those models
> don't have any support for time synchronization.
> 
> Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")

That commit is in 5.15 (and Stefan is facing the problem there), hence
to make backporting explicit it's afaics better to add this line :

Cc: stable@vger.kernel.org #5.15

> Link: https://lore.kernel.org/all/924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de/

Nitpicking: not sure if it's really important for anything, but to get
the proper format you afaik should do a s!/all/!/r/! to that line.

Ciao, Thorsten

> Reported-by: Stefan Dietrich <roots@gmx.de>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_ptp.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
> index 30568e3544cd..4f9245aa79a1 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ptp.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
> @@ -768,7 +768,20 @@ int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr)
>   */
>  static bool igc_is_crosststamp_supported(struct igc_adapter *adapter)
>  {
> -	return IS_ENABLED(CONFIG_X86_TSC) ? pcie_ptm_enabled(adapter->pdev) : false;
> +	if (!IS_ENABLED(CONFIG_X86_TSC))
> +		return false;
> +
> +	/* FIXME: it was noticed that enabling support for PCIe PTM in
> +	 * some i225-V models could cause lockups when bringing the
> +	 * interface up/down. There should be no downsides to
> +	 * disabling crosstimestamping support for i225-V, as it
> +	 * doesn't have any PTP support. That way we gain some time
> +	 * while root causing the issue.
> +	 */
> +	if (adapter->pdev->device == IGC_DEV_ID_I225_V)
> +		return false;
> +
> +	return pcie_ptm_enabled(adapter->pdev);
>  }
>  
>  static struct system_counterval_t igc_device_tstamp_to_system(u64 tstamp)
> 
