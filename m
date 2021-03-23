Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D896A346935
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCWTjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhCWTjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 247C3614A5;
        Tue, 23 Mar 2021 19:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616528365;
        bh=tnWhfJQiaw5ptja+gnHDao9U3U7TNeGkUgzd8HGqX6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=J803I7TanM+5tCsc4HOkg9etCbENfY9Os0QAKLg1TBkk6guFrojwPL8wMjCLhUcLI
         P5oJ6/Dg/TbiQCy9MBIKviL8zMS+mtcxxsr491pepxwCAH8QuWpty5m2TJ4+29lG8+
         FyOP4fewglEZVpgSdGSAqfQqN2CBlE5wefJseV+T153ZQvXO8m3kP0u3MfL+PQEXeR
         8dxpeCmVNK/0IE/+mK943kLJJUolc9NtFPMjG5KsWiP1kqrtRljKjmvSJZ6/q1/M1p
         ZqxXdpM4tO54KhQNH2wPhwP+i9bkgmCo7E0jf9Yw3jxVqlj4rNhFsVUt9fbhzUfej/
         DedIhuOtq72EQ==
Date:   Tue, 23 Mar 2021 14:39:23 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 3/3] igc: Add support for PTP
 getcrosststamp()
Message-ID: <20210323193923.GA597480@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322161822.1546454-4-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 09:18:22AM -0700, Vinicius Costa Gomes wrote:
> i225 has support for PCIe PTM, which allows us to implement support
> for the PTP_SYS_OFFSET_PRECISE ioctl(), implemented in the driver via
> the getcrosststamp() function.

> +static bool igc_is_ptm_supported(struct igc_adapter *adapter)
> +{
> +#if IS_ENABLED(CONFIG_X86_TSC) && IS_ENABLED(CONFIG_PCIE_PTM)
> +	return adapter->pdev->ptm_enabled;
> +#endif

It's not obvious why you make this x86-specific.  Maybe a comment?

You shouldn't have to test for CONFIG_PCIE_PTM, either.  We probably
should have a pdev->ptm_enabled() predicate with a stub that returns
false when CONFIG_PCIE_PTM is not set.

> +	return false;
> +}

> +/* PCIe Registers */
> +#define IGC_PTM_CTRL		0x12540  /* PTM Control */
> +#define IGC_PTM_STAT		0x12544  /* PTM Status */
> +#define IGC_PTM_CYCLE_CTRL	0x1254C  /* PTM Cycle Control */
> +
> +/* PTM Time registers */
> +#define IGC_PTM_T1_TIM0_L	0x12558  /* T1 on Timer 0 Low */
> +#define IGC_PTM_T1_TIM0_H	0x1255C  /* T1 on Timer 0 High */
> +
> +#define IGC_PTM_CURR_T2_L	0x1258C  /* Current T2 Low */
> +#define IGC_PTM_CURR_T2_H	0x12590  /* Current T2 High */
> +#define IGC_PTM_PREV_T2_L	0x12584  /* Previous T2 Low */
> +#define IGC_PTM_PREV_T2_H	0x12588  /* Previous T2 High */
> +#define IGC_PTM_PREV_T4M1	0x12578  /* T4 Minus T1 on previous PTM Cycle */
> +#define IGC_PTM_CURR_T4M1	0x1257C  /* T4 Minus T1 on this PTM Cycle */
> +#define IGC_PTM_PREV_T3M2	0x12580  /* T3 Minus T2 on previous PTM Cycle */
> +#define IGC_PTM_TDELAY		0x12594  /* PTM PCIe Link Delay */
> +
> +#define IGC_PCIE_DIG_DELAY	0x12550  /* PCIe Digital Delay */
> +#define IGC_PCIE_PHY_DELAY	0x12554  /* PCIe PHY Delay */

I assume the above are device-specific registers, right?  Nothing that
would be found in the PCIe base spec?

Bjorn
