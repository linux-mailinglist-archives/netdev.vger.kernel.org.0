Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6B56B2E65
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 21:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCIURM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 15:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCIURL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 15:17:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96A8FAF9C;
        Thu,  9 Mar 2023 12:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35750B82088;
        Thu,  9 Mar 2023 20:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D2DC433D2;
        Thu,  9 Mar 2023 20:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678393026;
        bh=AxPkaTQ5XSyjeKrf8KIM8TXtkH+rCYG8xnFHZi7SSwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=oh2T/2hCd9q8JKRAcfLyxoXAUk0589rZ7ocIi40cUPf3lcDKHW1EBjO1kiPTGYAY3
         YjP+BhoLg4qXFJvASdWF0ZpoTLs0pmLgvX+nmrIWHjoXYr2yzf9kCyluSTkv2/NMdE
         EJPt2syt+ewx8Vu0jDVHtPvnicthxlWub/ro92xknQXlT66MKCJRwbpHctle/0avA2
         GfIJhJVo/hhQp+ZZR0EfHzWOvp3Ry0iOXz/sviLy9HsGaXOaCh7lxGjuH2ghlj+1/a
         kexfQQR+OJ1QzIu7P7AwMBM+MP2ZiMOVzzo4nKdjXRughVfK0G3blq/uqVs2FltDhM
         rbDpH4rPUXkvQ==
Date:   Thu, 9 Mar 2023 14:17:05 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com,
        koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next v9 3/5] r8169: Consider chip-specific ASPM can
 be enabled on more cases
Message-ID: <20230309201705.GA1165139@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230225034635.2220386-4-kai.heng.feng@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 11:46:33AM +0800, Kai-Heng Feng wrote:
> To really enable ASPM on r8169 NICs, both standard PCIe ASPM and
> chip-specific ASPM have to be enabled at the same time.
> 
> Before enabling ASPM at chip side, make sure the following conditions
> are met:
> 1) Use pcie_aspm_support_enabled() to check if ASPM is disabled by
>    kernel parameter.
> 2) Use pcie_aspm_capable() to see if the device is capable to perform
>    PCIe ASPM.
> 3) Check the return value of pci_disable_link_state(). If it's -EPERM,
>    it means BIOS doesn't grant ASPM control to OS, and device should use
>    the ASPM setting as is.
> 
> Consider ASPM is manageable when those conditions are met.
> 
> While at it, disable ASPM at chip-side for TX timeout reset, since
> pci_disable_link_state() doesn't have any effect when OS isn't granted
> with ASPM control.

1) "While at it, ..." is always a hint that maybe this part could be
split to a separate patch.

2) The mix of chip-specific and standard PCIe ASPM configuration is a
mess.  Does it *have* to be intermixed at run-time, or could all the
chip-specific stuff be done once, e.g., maybe chip-specific ASPM
enable could be done at probe-time, and then all subsequent ASPM
configuration could done via the standard PCIe registers?

I.e., does the chip work correctly if chip-specific ASPM is enabled,
but standard PCIe ASPM config is *disabled*?

The ASPM sysfs controls [1] assume that L0s, L1, L1.1, L1.2 can all be
controlled simply by using the standard PCIe registers.  If that's not
the case for r8169, things will break when people use the sysfs knobs.

Bjorn

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/ABI/testing/sysfs-bus-pci?id=v6.2#n420

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
> -- 
> 2.34.1
> 
