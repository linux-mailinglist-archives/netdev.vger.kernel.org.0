Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A454674C31
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjATF0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjATF0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:26:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97907E6BD;
        Thu, 19 Jan 2023 21:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DB98B825D3;
        Thu, 19 Jan 2023 18:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CD0C433D2;
        Thu, 19 Jan 2023 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674153646;
        bh=GheWbXSmySnzBphtK+e1BAQMhvFJrqswnLr0pq7sCks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=tnKpcCZTqFBf8z9XQyNMTe6d/NvPOIR3jwBR9YtVK3zPAzFgJe52jb/gOmYWzRSt/
         UN4WtvMYVHy1T7GpHbvTbZ+ACQAySX75cmiRbPii98b7s87tvDD/jypLJ4ikgW3WOf
         l/fQX4Ma+jh7Jnn14+bncoW8SiERq4OTZZTr0NNueZRheAwFrGP+r5kPXuoKG/2KBW
         dVipueMcE6lrix5cWeUzkadeIJRa7d2ZlU/8Rs1esGZBs3vHigUwnA9mT6ViKN7y2L
         nD8Dmk4HbnugSeN3Na9sPucu3RgLtlV3mWFtcgRZip8db+cY0yfUqjgGU2qyxhT4l8
         Lxbp9YWPrFRGQ==
Date:   Thu, 19 Jan 2023 12:40:45 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/9] e1000e: Remove redundant
 pci_enable_pcie_error_reporting()
Message-ID: <20230119184045.GA482553@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4274cde6-3a64-e549-a833-3930732c756d@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Sathy]

On Thu, Jan 19, 2023 at 10:28:16AM -0800, Tony Nguyen wrote:
> On 1/18/2023 3:46 PM, Bjorn Helgaas wrote:
> > From: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > pci_enable_pcie_error_reporting() enables the device to send ERR_*
> > Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> > native"), the PCI core does this for all devices during enumeration.
> > 
> > Remove the redundant pci_enable_pcie_error_reporting() call from the
> > driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> > from the driver .remove() path.
> > 
> > Note that this doesn't control interrupt generation by the Root Port; that
> > is controlled by the AER Root Error Command register, which is managed by
> > the AER service driver.
> > 
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Cc: intel-wired-lan@lists.osuosl.org
> > Cc: netdev@vger.kernel.org
> > ---
> >   drivers/net/ethernet/intel/e1000e/netdev.c | 7 -------
> >   1 file changed, 7 deletions(-)
> 
> Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Thanks a million for taking a look at these, Tony!

These driver patches are all independent and have no dependency on the
1/9 PCI/AER patch.  What's your opinion on merging these?  Should they
go via netdev?  Should they be squashed into a single patch that does
all the Intel drivers at once?

I'm happy to squash them and/or merge them via the PCI tree, whatever
is easiest.

Bjorn
