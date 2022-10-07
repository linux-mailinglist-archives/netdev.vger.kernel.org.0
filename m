Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA735F7B01
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 17:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiJGPsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 11:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJGPsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 11:48:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE8024F2D;
        Fri,  7 Oct 2022 08:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B58561D65;
        Fri,  7 Oct 2022 15:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C3DC433C1;
        Fri,  7 Oct 2022 15:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665157712;
        bh=IVrCfu+9kAkOmJoCLZuXN66Vw4CSeE7htFDvsSlA7co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=oHTLK//A/5yFw/3c6zX9/xOD4a4YHBnsKyQdsMrxyXBO0xBo49rXERJUrp85bgtf5
         /DQAk0N9+ub/SrvcyIBNSD9In+6MCJDCxTyguw7HeejySDX2i0qohZYAZ6yk6XAsrI
         oAHmXpOlarN1ho3xPhynfJ7/eUVlyHk+TA2jkNmR8mf2C/kbTf6r6R6hUPITIqk9Cm
         VuRqTG4Iuqge9rmnk283R09ggyhv07LhCjpUko4RYO5U3dutPtgiUaHYp0So4zHkwD
         bMzABmBwPEoWDF8nBCTh6R4l1NW5N0b67QHDgfUNF/kXQqfAqhXrqsGxBR26uOgbTj
         BYXyiNqnhmuIQ==
Date:   Fri, 7 Oct 2022 10:48:30 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Yuval Mintz <Yuval.Mintz@caviumnetworks.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, Ram.Amrani@caviumnetworks.com,
        Michal.Kalderon@caviumnetworks.com, Ariel.Elior@caviumnetworks.com,
        dledford@redhat.com, Manish Chopra <manishc@marvell.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] qed: Add support for RoCE hw init
Message-ID: <20221007154830.GA2630865@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475348401-31392-4-git-send-email-Yuval.Mintz@caviumnetworks.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Manish, linux-pci]

On Sat, Oct 01, 2016 at 09:59:57PM +0300, Yuval Mintz wrote:
> From: Ram Amrani <Ram.Amrani@caviumnetworks.com>
> 
> This adds the backbone required for the various HW initalizations
> which are necessary for the qedr driver - FW notification, resource
> initializations, etc.
> ...

> diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> ...
> +	/* Check atomic operations support in PCI configuration space. */
> +	pci_read_config_dword(cdev->pdev,
> +			      cdev->pdev->pcie_cap + PCI_EXP_DEVCTL2,
> +			      &pci_status_control);
> +
> +	if (pci_status_control & PCI_EXP_DEVCTL2_LTR_EN)
> +		SET_FIELD(dev->dev_caps, QED_RDMA_DEV_CAP_ATOMIC_OP, 1);

I don't understand this.

  1) PCI_EXP_DEVCTL2 is a 16-bit register ("word"), not a 32-bit one
  ("dword").

  2) QED_RDMA_DEV_CAP_ATOMIC_OP is set here but is not read anywhere
  in this patch.  Is it used by the qed device itself?

  3) PCI_EXP_DEVCTL2_LTR_EN is for Latency Tolerance Reporting and is
  not related to atomic ops.  I don't know what
  QED_RDMA_DEV_CAP_ATOMIC_OP means, but possibly one of these was
  intended instead?

    - PCI_EXP_DEVCAP2_ATOMIC_COMP32 means the device supports 32-bit
      AtomicOps as a completer.
    - PCI_EXP_DEVCAP2_ATOMIC_COMP64 means the device supports 64-bit
      AtomicOps as a completer.
    - PCI_EXP_DEVCAP2_ATOMIC_COMP128 means the device supports 128-bit
      AtomicOps as a completer.
    - PCI_EXP_DEVCTL2_ATOMIC_REQ means the device is allowed to
      initiate AtomicOps.

(This code is now in qed_rdma.c)
