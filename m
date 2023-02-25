Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E7E6A2779
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 07:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBYGNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 01:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBYGNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 01:13:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA5272B2;
        Fri, 24 Feb 2023 22:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677305594; x=1708841594;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ky27VsTDRNahF/4AEiY/YZMORSp+j0g+w7RIpvQrRUY=;
  b=NYtvdhWpv+9Dkm2bjNPRrrnAhRBP/g7S0QqSEHWqoEvNTscFDY55af0/
   Z1dB7DGZcryS1H/QBUTvG+oYiNZ3v9JIogGbkR4Wo4EeR/b1lcWAwT/6E
   ttSgQ4lcJiqqYI6ISe6CbrMSnEpSUkk1ZlTLP6VCLyE9fN5nNZbIdlMl2
   aIySY9rYM79o3dErfc40+UoVfxuFn6gTtptuWdZPYAcJSLrFeO67AUYg2
   krsrmwmCnXuWiVAK2u+kd1ry302XHCnJznC/gTVD7yVLjtuTkJmhJCnLM
   +tAMaAXxW/3pgs0olretCiGBEnmQYPHHlc+JdtwWkO/NiGndIWiitAGow
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="317395794"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="317395794"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:13:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="666385264"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="666385264"
Received: from soniyas1-mobl.amr.corp.intel.com (HELO [10.212.244.166]) ([10.212.244.166])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:13:13 -0800
Message-ID: <247ba0d1-12e6-f21b-fbb9-9906a5197e03@linux.intel.com>
Date:   Fri, 24 Feb 2023 22:13:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 3/5] r8169: Consider chip-specific ASPM can be
 enabled on more cases
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, hkallweit1@gmail.com,
        nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
 <20230225034635.2220386-4-kai.heng.feng@canonical.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20230225034635.2220386-4-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/23 7:46 PM, Kai-Heng Feng wrote:
> To really enable ASPM on r8169 NICs, both standard PCIe ASPM and
> chip-specific ASPM have to be enabled at the same time.
> 
> Before enabling ASPM at chip side, make sure the following conditions
> are met:
> 1) Use pcie_aspm_support_enabled() to check if ASPM is disabled by
>    kernel parameter.
> 2) Use pcie_aspm_capable() to see if the device is capable to perform
>    PCIe ASPM.

Why not club the support check within pcie_aspm_capable()?

> 3) Check the return value of pci_disable_link_state(). If it's -EPERM,
>    it means BIOS doesn't grant ASPM control to OS, and device should use
>    the ASPM setting as is.
> 
> Consider ASPM is manageable when those conditions are met.
> 
> While at it, disable ASPM at chip-side for TX timeout reset, since
> pci_disable_link_state() doesn't have any effect when OS isn't granted
> with ASPM control.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v9:
>  - No change.
> 
> v8:
>  - Enable chip-side ASPM only when PCIe ASPM is already available.
>  - Wording.
> 
> v7:
>  - No change.
> 
> v6:
>  - Unconditionally enable chip-specific ASPM.
> 
> v5:
>  - New patch.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 45147a1016bec..a857650c2e82b 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2675,8 +2675,11 @@ static void rtl_disable_exit_l1(struct rtl8169_private *tp)
>  
>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  {
> -	/* Don't enable ASPM in the chip if OS can't control ASPM */
> -	if (enable && tp->aspm_manageable) {
> +	/* Skip if PCIe ASPM isn't possible */
> +	if (!tp->aspm_manageable)
> +		return;
> +
> +	if (enable) {
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>  
> @@ -4545,8 +4548,13 @@ static void rtl_task(struct work_struct *work)
>  		/* ASPM compatibility issues are a typical reason for tx timeouts */
>  		ret = pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_L1 |
>  							  PCIE_LINK_STATE_L0S);
> +
> +		/* OS may not be granted to control PCIe ASPM, prevent the driver from using it */
> +		tp->aspm_manageable = 0;
> +
>  		if (!ret)
>  			netdev_warn_once(tp->dev, "ASPM disabled on Tx timeout\n");
> +
>  		goto reset;
>  	}
>  
> @@ -5227,13 +5235,19 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	 * Chips from RTL8168h partially have issues with L1.2, but seem
>  	 * to work fine with L1 and L1.1.
>  	 */
> -	if (rtl_aspm_is_safe(tp))
> +	if (!pcie_aspm_support_enabled() || !pcie_aspm_capable(pdev))
> +		rc = -EINVAL;
> +	else if (rtl_aspm_is_safe(tp))
>  		rc = 0;
>  	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
>  		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
>  	else
>  		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> -	tp->aspm_manageable = !rc;
> +
> +	/* -EPERM means BIOS doesn't grant OS ASPM control, ASPM should be use
> +	 * as is. Honor it.
> +	 */
> +	tp->aspm_manageable = (rc == -EPERM) ? 1 : !rc;
>  
>  	tp->dash_type = rtl_check_dash(tp);
>  

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
