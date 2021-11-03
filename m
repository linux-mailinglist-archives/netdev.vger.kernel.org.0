Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F3B44475B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhKCRlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:41:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:7748 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhKCRlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 13:41:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="231507916"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="231507916"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 10:38:54 -0700
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="449904523"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 10:38:51 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1miKDb-003KNS-J8;
        Wed, 03 Nov 2021 19:38:35 +0200
Date:   Wed, 3 Nov 2021 19:38:35 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v3 2/2] mwifiex: Add quirk to disable deep sleep with
 certain hardware revision
Message-ID: <YYLJG1y8owwehew+@smile.fi.intel.com>
References: <20211103171055.16911-1-verdre@v0yd.nl>
 <20211103171055.16911-3-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103171055.16911-3-verdre@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 06:10:55PM +0100, Jonas Dreﬂler wrote:
> The 88W8897 PCIe+USB card in the hardware revision 20 apparently has a
> hardware issue where the card wakes up from deep sleep randomly and very
> often, somewhat depending on the card activity, maybe the hardware has a
> floating wakeup pin or something. This was found by comparing two MS
> Surface Book 2 devices, where one devices wifi card experienced spurious
> wakeups, while the other one didn't.
> 
> Those continuous wakeups prevent the card from entering host sleep when
> the computer suspends. And because the host won't answer to events from
> the card anymore while it's suspended, the firmwares internal power
> saving state machine seems to get confused and the card can't sleep
> anymore at all after that.
> 
> Since we can't work around that hardware bug in the firmware, let's
> get the hardware revision string from the firmware and match it with
> known bad revisions. Then disable auto deep sleep for those revisions,
> which makes sure we no longer get those spurious wakeups.
> 
> Signed-off-by: Jonas Dreﬂler <verdre@v0yd.nl>
> ---
>  drivers/net/wireless/marvell/mwifiex/main.c   | 18 +++++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/main.h   |  1 +
>  .../wireless/marvell/mwifiex/sta_cmdresp.c    | 20 +++++++++++++++++++
>  3 files changed, 39 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 19b996c6a260..ace7371c4773 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -226,6 +226,23 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
>  	return 0;
>  }
>  
> +static void maybe_quirk_fw_disable_ds(struct mwifiex_adapter *adapter)
> +{
> +	struct mwifiex_private *priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
> +	struct mwifiex_ver_ext ver_ext;
> +
> +	if (test_and_set_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &adapter->work_flags))
> +		return;
> +
> +	memset(&ver_ext, 0, sizeof(ver_ext));
> +	ver_ext.version_str_sel = 1;

> +	if (mwifiex_send_cmd(priv, HostCmd_CMD_VERSION_EXT,
> +			     HostCmd_ACT_GEN_GET, 0, &ver_ext, false)) {
> +		mwifiex_dbg(priv->adapter, MSG,
> +			    "Checking hardware revision failed.\n");
> +	}

Checkpatch won't warn you if string literal even > 100. So move it to one line
and drop curly braces. Ditto for the case(s) below.

> +}
> +
>  /*
>   * The main process.
>   *
> @@ -356,6 +373,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
>  			if (adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE) {
>  				adapter->hw_status = MWIFIEX_HW_STATUS_READY;
>  				mwifiex_init_fw_complete(adapter);
> +				maybe_quirk_fw_disable_ds(adapter);
>  			}
>  		}
>  
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 65609ea2327e..eabd0e0a9f56 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -524,6 +524,7 @@ enum mwifiex_adapter_work_flags {
>  	MWIFIEX_IS_SUSPENDED,
>  	MWIFIEX_IS_HS_CONFIGURED,
>  	MWIFIEX_IS_HS_ENABLING,
> +	MWIFIEX_IS_REQUESTING_FW_VEREXT,
>  };
>  
>  struct mwifiex_band_config {
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> index 20b69a37f9e1..6c7b0b9bc4e9 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> @@ -708,6 +708,26 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
>  {
>  	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
>  
> +	if (test_and_clear_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &priv->adapter->work_flags)) {
> +		if (strncmp(ver_ext->version_str, "ChipRev:20, BB:9b(10.00), RF:40(21)",
> +			    MWIFIEX_VERSION_STR_LENGTH) == 0) {
> +			struct mwifiex_ds_auto_ds auto_ds = {
> +				.auto_ds = DEEP_SLEEP_OFF,
> +			};
> +
> +			mwifiex_dbg(priv->adapter, MSG,
> +				    "Bad HW revision detected, disabling deep sleep\n");
> +
> +			if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
> +					     DIS_AUTO_PS, BITMAP_AUTO_DS, &auto_ds, false)) {
> +				mwifiex_dbg(priv->adapter, MSG,
> +					    "Disabling deep sleep failed.\n");
> +			}
> +		}
> +
> +		return 0;
> +	}
> +
>  	if (version_ext) {
>  		version_ext->version_str_sel = ver_ext->version_str_sel;
>  		memcpy(version_ext->version_str, ver_ext->version_str,
> -- 
> 2.33.1
> 

-- 
With Best Regards,
Andy Shevchenko


