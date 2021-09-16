Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7FA40E82D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350471AbhIPRoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355819AbhIPRmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 383E560F11;
        Thu, 16 Sep 2021 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631812062;
        bh=2DlbyUjSYEPcA1CMZ9Xj/nlxDT/ODrhL02P3+ejffBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=c5nCEV/4NySYk2cRe22gcl1DZ7WShDxH6uPrunRQ1wDUKlITwE5b4D/XqMgvYoCGw
         nO7WtMQBbNIJWSdWkagTA1pA4Uql5Ly5JqoXj4CkR+1YiD4GLe7IheiwfCtss9Fbnt
         rL/njAfGrIuT6hUtZH60zMDTN4L6jaxB9tiZlSQ0sMzoZcesBRI9RiFXjSkUhvCH/e
         Nxdy7kc37Gse82AxSz3r4emrLHv5YCoT4Ojg4hUq0t+6tpXpqA+56tDGlILmlSzC9K
         rRpukdOhay2GDin+lY+pyGGVrSOQ927FMnis/cNgK6eRlCFA9NAvY3b2y0WbVWXuFU
         kXquaGnCBnW/w==
Date:   Thu, 16 Sep 2021 12:07:40 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com,
        davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH net-next v5 2/3] r8169: Use PCIe ASPM status for
 NIC ASPM enablement
Message-ID: <20210916170740.GA1624437@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916154417.664323-3-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 11:44:16PM +0800, Kai-Heng Feng wrote:
> Because ASPM control may not be granted by BIOS while ASPM is enabled,
> and ASPM can be enabled via sysfs, so use pcie_aspm_enabled() directly
> to check current ASPM enable status.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v5:
>  - New patch.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 0199914440abc..6f1a9bec40c05 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -622,7 +622,6 @@ struct rtl8169_private {
>  	} wk;
>  
>  	unsigned supports_gmii:1;
> -	unsigned aspm_manageable:1;
>  	dma_addr_t counters_phys_addr;
>  	struct rtl8169_counters *counters;
>  	struct rtl8169_tc_offsets tc_offset;
> @@ -2664,8 +2663,13 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
>  
>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  {
> -	/* Don't enable ASPM in the chip if OS can't control ASPM */
> -	if (enable && tp->aspm_manageable) {
> +	struct pci_dev *pdev = tp->pci_dev;
> +
> +	/* Don't enable ASPM in the chip if PCIe ASPM isn't enabled */
> +	if (!pcie_aspm_enabled(pdev) && enable)
> +		return;

What happens when the user enables or disables ASPM via sysfs (see
https://git.kernel.org/linus/72ea91afbfb0)?

The driver is not going to know about that change.

> +	if (enable) {
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>  	} else {
> @@ -5272,8 +5276,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	/* Disable ASPM L1 as that cause random device stop working
>  	 * problems as well as full system hangs for some PCIe devices users.
>  	 */
> -	rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> -	tp->aspm_manageable = !rc;
> +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
>  
>  	/* enable device (incl. PCI PM wakeup and hotplug setup) */
>  	rc = pcim_enable_device(pdev);
> -- 
> 2.32.0
> 
