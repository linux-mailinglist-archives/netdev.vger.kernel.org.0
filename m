Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C8346B33
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhCWViJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:38:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:20404 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233614AbhCWVhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 17:37:53 -0400
IronPort-SDR: VgZtADgvdKW3N1JZ4IrQzmWrSPSKryeao3RAWpjOz/iIdOgiwBg7HE7ZIyxE0wTTHxw2CcKSn6
 VjJyDkyN2GsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="189972699"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="189972699"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 14:37:53 -0700
IronPort-SDR: 5FVXOxSzSoWYssa+tKWpCsLDImcTE/iCWmZMfH86422cWy9q8BlnGhR1Q2mRZmShib50hth0Sc
 5qTMra+2d/UQ==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381503183"
Received: from ckane-desk.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.48.247])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 14:37:52 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 3/3] igc: Add support for PTP
 getcrosststamp()
In-Reply-To: <20210323193923.GA597480@bjorn-Precision-5520>
References: <20210323193923.GA597480@bjorn-Precision-5520>
Date:   Tue, 23 Mar 2021 14:37:52 -0700
Message-ID: <87eeg5k0un.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Helgaas <helgaas@kernel.org> writes:

> On Mon, Mar 22, 2021 at 09:18:22AM -0700, Vinicius Costa Gomes wrote:
>> i225 has support for PCIe PTM, which allows us to implement support
>> for the PTP_SYS_OFFSET_PRECISE ioctl(), implemented in the driver via
>> the getcrosststamp() function.
>
>> +static bool igc_is_ptm_supported(struct igc_adapter *adapter)
>> +{
>> +#if IS_ENABLED(CONFIG_X86_TSC) && IS_ENABLED(CONFIG_PCIE_PTM)
>> +	return adapter->pdev->ptm_enabled;
>> +#endif
>
> It's not obvious why you make this x86-specific.  Maybe a comment?

Sure. Will add a comment.

>
> You shouldn't have to test for CONFIG_PCIE_PTM, either.  We probably
> should have a pdev->ptm_enabled() predicate with a stub that returns
> false when CONFIG_PCIE_PTM is not set.

Makes sense. Will add that predicate for next version.

>
>> +	return false;
>> +}
>
>> +/* PCIe Registers */
>> +#define IGC_PTM_CTRL		0x12540  /* PTM Control */
>> +#define IGC_PTM_STAT		0x12544  /* PTM Status */
>> +#define IGC_PTM_CYCLE_CTRL	0x1254C  /* PTM Cycle Control */
>> +
>> +/* PTM Time registers */
>> +#define IGC_PTM_T1_TIM0_L	0x12558  /* T1 on Timer 0 Low */
>> +#define IGC_PTM_T1_TIM0_H	0x1255C  /* T1 on Timer 0 High */
>> +
>> +#define IGC_PTM_CURR_T2_L	0x1258C  /* Current T2 Low */
>> +#define IGC_PTM_CURR_T2_H	0x12590  /* Current T2 High */
>> +#define IGC_PTM_PREV_T2_L	0x12584  /* Previous T2 Low */
>> +#define IGC_PTM_PREV_T2_H	0x12588  /* Previous T2 High */
>> +#define IGC_PTM_PREV_T4M1	0x12578  /* T4 Minus T1 on previous PTM Cycle */
>> +#define IGC_PTM_CURR_T4M1	0x1257C  /* T4 Minus T1 on this PTM Cycle */
>> +#define IGC_PTM_PREV_T3M2	0x12580  /* T3 Minus T2 on previous PTM Cycle */
>> +#define IGC_PTM_TDELAY		0x12594  /* PTM PCIe Link Delay */
>> +
>> +#define IGC_PCIE_DIG_DELAY	0x12550  /* PCIe Digital Delay */
>> +#define IGC_PCIE_PHY_DELAY	0x12554  /* PCIe PHY Delay */
>
> I assume the above are device-specific registers, right?  Nothing that
> would be found in the PCIe base spec?

Yeah, these registers control the corrections the NIC hardware make to
the timestamps based on the PCIe link delays from the NIC to its
upstream PCIe port.

I don't remember seeing anything like that on the PCIe base spec. Will
take another look to make sure.


Cheers,
-- 
Vinicius
