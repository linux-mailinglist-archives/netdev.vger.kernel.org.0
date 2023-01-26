Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332F467D982
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjAZXPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbjAZXPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:15:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B499D6A706;
        Thu, 26 Jan 2023 15:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53374B81C5E;
        Thu, 26 Jan 2023 23:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B504CC433EF;
        Thu, 26 Jan 2023 23:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674774929;
        bh=yLxfhl2XeMsnGXh8m4CYuImOEZKgrEUslX63nDnPLrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VPk1P6ShqdMJdgOLDXfAg3hmy8SL4IAesCX9ibxD3BDdaupVSCJa7vRBe9x1k72s3
         0WT3de7uDz1Kh7XfvLBViNk61oDrsMXN3jDJ09HhctMhpqHlfJ81OdtfBE+PohHfd4
         tw+89BwTzSlRTG8QDGtuRInId/FBPYFZd6NTyYImd89YX/3OfczFjJj4qstBXsQrRh
         9Ede9P3N6bh8AVRHs4Hg7Qyumb+wJn3pVA0l3XyLzekrglV+HU1C6A/7KeCFZypUD2
         XMOBOd5CEzMzRNhi3tlSuHqf1WLHI2Os2wURhy0PtV93Cg6KqWu3qHavIsmPzpQGf+
         GH4IkWzOisVbQ==
Date:   Thu, 26 Jan 2023 17:15:27 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, Stefan Roese <sr@denx.de>,
        Ashok Raj <ashok.raj@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH 0/9] PCI/AER: Remove redundant Device Control Error
 Reporting Enable
Message-ID: <20230126231527.GA1322015@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118234612.272916-1-helgaas@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc all the folks I forgot to cc when sending the original cover
letter, sorry about that, plus the folks who very generously tested
the driver patches]

On Wed, Jan 18, 2023 at 05:46:03PM -0600, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
> ths PCI core sets the Device Control bits that enable error reporting for
> PCIe devices.
> 
> This series removes redundant calls to pci_enable_pcie_error_reporting()
> that do the same thing from the AER driver and several NIC drivers.
> 
> There are several more drivers where this should be removed; I started with
> just the Intel drivers here.
> 
> Bjorn Helgaas (9):
>   PCI/AER: Remove redundant Device Control Error Reporting Enable
>   e1000e: Remove redundant pci_enable_pcie_error_reporting()
>   fm10k: Remove redundant pci_enable_pcie_error_reporting()
>   i40e: Remove redundant pci_enable_pcie_error_reporting()
>   iavf: Remove redundant pci_enable_pcie_error_reporting()
>   ice: Remove redundant pci_enable_pcie_error_reporting()
>   igb: Remove redundant pci_enable_pcie_error_reporting()
>   igc: Remove redundant pci_enable_pcie_error_reporting()
>   ixgbe: Remove redundant pci_enable_pcie_error_reporting()

Thank you very much for reviewing and testing these.  I applied the
first (PCI/AER) patch to the PCI tree.

I think Jakub is planning to merge the rest via the netdev tree.
There are no dependencies, so they can be squashed if desired.  Let me
know if you'd prefer me to merge them or squash them.

>  drivers/net/ethernet/intel/e1000e/netdev.c    |  7 ---
>  drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  5 --
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 --
>  drivers/net/ethernet/intel/iavf/iavf_main.c   |  5 --
>  drivers/net/ethernet/intel/ice/ice_main.c     |  3 --
>  drivers/net/ethernet/intel/igb/igb_main.c     |  5 --
>  drivers/net/ethernet/intel/igc/igc_main.c     |  5 --
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 --
>  drivers/pci/pcie/aer.c                        | 48 -------------------
>  9 files changed, 87 deletions(-)
> 
> -- 
> 2.25.1
> 
