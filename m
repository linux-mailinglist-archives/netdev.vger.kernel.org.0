Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5810A6C6E20
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjCWQvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjCWQvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:51:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FF9E4;
        Thu, 23 Mar 2023 09:51:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A73D5B81FDA;
        Thu, 23 Mar 2023 16:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15790C433EF;
        Thu, 23 Mar 2023 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679590277;
        bh=Oh0Ud2Yc+VS+MDZybr4MdiwYCZ6hMKbKSattijOI288=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=c8Xxdkc4btiDrNb0Md6dkSGyAwroONXVAZd9k/0OFObXTLCpnluSp4APTpy/cYvaH
         6ULR4SWaOrQ1S7bj4rNK7TIoNWz43SpcUMQMt4ow+D+ynUUvJqAx/hLmhqP7+BfBiR
         rKSBrk31im9jUIcuj2RnjySI9YUXDgipLnXN+yCYQLkP2zTONEUetSqFRocSTvtG3i
         5o9yOQnNfFCwmNEhrMbVt3ZYI1mETGzaEIBKa9+xmHZkg+0iQXucFlGszfmHjQ3s4K
         8sruLRte6YS+99woIk+v9S9qpMgnKgEUgCMcAoqeCQkYL6kZOGSpgOjZYj1F7rJkc3
         8TUi+10htWxtA==
Date:   Thu, 23 Mar 2023 11:51:15 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <20230323165115.GA2557618@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c61d07469ecf5d3053442e24d4d050405f466b76.1679502371.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr, thanks for pointing me here.

On Wed, Mar 22, 2023 at 05:49:35PM +0100, Petr Machata wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> The driver resets the device during probe and during a devlink reload.
> The current reset method reloads the current firmware version or a pending
> one, if one was previously flashed using devlink. However, the reset does
> not take down the PCI link, preventing the PCI firmware from being
> upgraded, unless the system is rebooted.

Just to make sure I understand this correctly, the above sounds like
"firmware" includes two parts that have different rules for loading:

  - Current reset method is completely mlxsw-specific and resets the
    mlxsw core but not the PCIe interface; this loads only firmware
    part A

  - A PCIe reset resets both the mlxsw core and the PCIe interface;
    this loads both firmware part A and part B

> To solve this problem, a new reset command (6) was implemented in the
> firmware. Unlike the current command (1), after issuing the new command
> the device will not start the reset immediately, but only after the PCI
> link was disabled. The driver is expected to wait for 500ms before
> re-enabling the link to give the firmware enough time to start the reset.

I guess the idea here is that the mlxsw driver:

  - Tells the firmware we're going to reset
    (MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)

  - Saves PCI config state

  - Disables the link (mlxsw_pci_link_toggle()), which causes a PCIe
    hot reset

  - The firmware notices the link disable and starts its own internal
    reset

  - The mlxsw driver waits 500ms
    (MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS)

  - Enables link and waits for it to be active
    (mlxsw_pci_link_active_check()

  - Waits for device to be ready again (mlxsw_pci_device_id_read())

So the first question is why you don't simply use
pci_reset_function(), since it is supposed to cause a reset and do all
the necessary waiting for the device to be ready.  This is quite
complicated to do correctly; in fact, we still discover issues there
regularly.  There are many special cases in PCIe r6.0, sec 6.6.1, and
it would be much better if we can avoid trying to handle them all in
individual drivers.

Of course, pci_reset_function() does *not* include details like
MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS.

I assume that flashing the firmware to the device followed by a power
cycle (without ever doing MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)
would load the new firmware everywhere.  Can we not do the same with a
PCIe reset?

> Implement the new reset method and use it only after verifying it is
> supported by the current firmware version by querying the Management
> Capabilities Mask (MCAM) register. Consider the PCI firmware to be
> operational either after waiting for a predefined time of 2000ms or after
> reading an active link status when "Data Link Layer Link Active Reporting"
> is supported. For good measures, make sure the device ID can be read from
> the configuration space of the device.
> 
> Once the PCI firmware is operational, go back to the regular reset flow
> and wait for the entire device to become ready. That is, repeatedly read
> the "system_status" register from the BAR until a value of "FW_READY"
> (0x5E) appears.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/pci.c    | 151 ++++++++++++++++++-
>  drivers/net/ethernet/mellanox/mlxsw/pci_hw.h |   5 +
>  2 files changed, 155 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> index 73ae2fdd94c4..9b11c5280424 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> @@ -1459,6 +1459,137 @@ static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
>  	return -EBUSY;
>  }
>  
> +static int mlxsw_pci_link_active_wait(struct pci_dev *pdev)
> +{
> +	unsigned long end;
> +	u16 lnksta;
> +	int err;
> +
> +	end = jiffies + msecs_to_jiffies(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +	do {
> +		msleep(MLXSW_PCI_TOGGLE_WAIT_MSECS);
> +		err = pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
> +		if (err)
> +			return pcibios_err_to_errno(err);
> +
> +		if (lnksta & PCI_EXP_LNKSTA_DLLLA)
> +			return 0;
> +	} while (time_before(jiffies, end));
> +
> +	pci_err(pdev, "PCI link not ready (0x%04x) after %d ms\n", lnksta,
> +		MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int mlxsw_pci_link_active_check(struct pci_dev *pdev)
> +{
> +	u32 lnkcap;
> +	int err;
> +
> +	err = pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &lnkcap);
> +	if (err)
> +		goto out;
> +
> +	if (lnkcap & PCI_EXP_LNKCAP_DLLLARC)
> +		return mlxsw_pci_link_active_wait(pdev);
> +
> +	/* In case the device does not support "Data Link Layer Link Active
> +	 * Reporting", simply wait for a predefined time for the device to
> +	 * become active.
> +	 */
> +	pci_dbg(pdev, "No PCI link reporting capability (0x%08x)\n", lnkcap);
> +
> +out:
> +	/* Sleep before handling the rest of the flow and accessing to PCI. */
> +	msleep(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +	return pcibios_err_to_errno(err);
> +}
> +
> +static int mlxsw_pci_link_toggle(struct pci_dev *pdev)
> +{
> +	int err;
> +
> +	/* Disable the link. */
> +	err = pcie_capability_set_word(pdev, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_LD);
> +	if (err)
> +		return pcibios_err_to_errno(err);
> +
> +	/* Sleep to give firmware enough time to start the reset. */
> +	msleep(MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS);
> +
> +	/* Enable the link. */
> +	err = pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
> +					 PCI_EXP_LNKCTL_LD);
> +	if (err)
> +		return pcibios_err_to_errno(err);
> +
> +	/* Wait for link active. */
> +	return mlxsw_pci_link_active_check(pdev);
> +}
> +
> +static int mlxsw_pci_device_id_read(struct pci_dev *pdev, u16 exp_dev_id)
> +{
> +	unsigned long end;
> +	u16 dev_id;
> +	int err;
> +
> +	end = jiffies + msecs_to_jiffies(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +	do {
> +		msleep(MLXSW_PCI_TOGGLE_WAIT_MSECS);
> +
> +		/* Expect to get the correct PCI device ID as first indication
> +		 * that the ASIC is available.
> +		 */
> +		err = pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
> +		if (err)
> +			return pcibios_err_to_errno(err);
> +
> +		if (dev_id == exp_dev_id)
> +			return 0;
> +	} while (time_before(jiffies, end));
> +
> +	pci_err(pdev, "PCI device ID is not as expected after %d ms\n",
> +		MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int mlxsw_pci_reset_at_pci_disable(struct mlxsw_pci *mlxsw_pci)
> +{
> +	struct pci_bus *bridge_bus = mlxsw_pci->pdev->bus;
> +	struct pci_dev *bridge_pdev = bridge_bus->self;
> +	struct pci_dev *pdev = mlxsw_pci->pdev;
> +	char mrsr_pl[MLXSW_REG_MRSR_LEN];
> +	u16 dev_id = pdev->device;
> +	int err;
> +
> +	mlxsw_reg_mrsr_pack(mrsr_pl,
> +			    MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE);
> +	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
> +	if (err)
> +		return err;
> +
> +	/* Save the PCI configuration space so that we will be able to restore
> +	 * it after the firmware was reset.
> +	 */
> +	pci_save_state(pdev);
> +	pci_cfg_access_lock(pdev);
> +
> +	err = mlxsw_pci_link_toggle(bridge_pdev);
> +	if (err) {
> +		pci_err(bridge_pdev, "Failed to toggle PCI link\n");
> +		goto restore;
> +	}
> +
> +	err = mlxsw_pci_device_id_read(pdev, dev_id);
> +
> +restore:
> +	pci_cfg_access_unlock(pdev);
> +	pci_restore_state(pdev);
> +	return err;
> +}
> +
>  static int mlxsw_pci_reset_sw(struct mlxsw_pci *mlxsw_pci)
>  {
>  	char mrsr_pl[MLXSW_REG_MRSR_LEN];
> @@ -1471,6 +1602,8 @@ static int
>  mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
>  {
>  	struct pci_dev *pdev = mlxsw_pci->pdev;
> +	char mcam_pl[MLXSW_REG_MCAM_LEN];
> +	bool pci_reset_supported;
>  	u32 sys_status;
>  	int err;
>  
> @@ -1481,7 +1614,23 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
>  		return err;
>  	}
>  
> -	err = mlxsw_pci_reset_sw(mlxsw_pci);
> +	mlxsw_reg_mcam_pack(mcam_pl,
> +			    MLXSW_REG_MCAM_FEATURE_GROUP_ENHANCED_FEATURES);
> +	err = mlxsw_reg_query(mlxsw_pci->core, MLXSW_REG(mcam), mcam_pl);
> +	if (err)
> +		return err;
> +
> +	mlxsw_reg_mcam_unpack(mcam_pl, MLXSW_REG_MCAM_PCI_RESET,
> +			      &pci_reset_supported);
> +
> +	if (pci_reset_supported) {
> +		pci_dbg(pdev, "Starting PCI reset flow\n");
> +		err = mlxsw_pci_reset_at_pci_disable(mlxsw_pci);
> +	} else {
> +		pci_dbg(pdev, "Starting software reset flow\n");
> +		err = mlxsw_pci_reset_sw(mlxsw_pci);
> +	}
> +
>  	if (err)
>  		return err;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
> index 48dbfea0a2a1..ded0828d7f1f 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
> @@ -27,6 +27,11 @@
>  
>  #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
>  #define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
> +
> +#define MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS	500
> +#define MLXSW_PCI_TOGGLE_WAIT_MSECS		20
> +#define MLXSW_PCI_TOGGLE_TIMEOUT_MSECS		2000
> +
>  #define MLXSW_PCI_FW_READY			0xA1844
>  #define MLXSW_PCI_FW_READY_MASK			0xFFFF
>  #define MLXSW_PCI_FW_READY_MAGIC		0x5E
> -- 
> 2.39.0
> 
