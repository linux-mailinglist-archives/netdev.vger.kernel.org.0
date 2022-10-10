Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247B55FA723
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 23:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJJVos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 17:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJJVor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 17:44:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDF9FAF9;
        Mon, 10 Oct 2022 14:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6950B810F1;
        Mon, 10 Oct 2022 21:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371AAC433D6;
        Mon, 10 Oct 2022 21:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665438282;
        bh=8i9Sp/zDP5LGHEO1+Oz/sZ8i5e+xyIwvdtaV+G68Qb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=JVYyYeemTOQzhjCLpkSbxcPnk4m3qeNpHxpVw0JoVcI8v0BR5DGHgoENzQEl/70da
         Q7FKNlAP2X1golzwCvsPjaY1nQTOm64bcZPSbH0MaJv4rePGoaWTpxev59zP520YnW
         lHLYWHBTr5t2JdNqD9Oth78/xyN5y4yG8HCjt2ZWygKjhUtrzVXFVUacuVV4UAZ8T9
         OHE13TQ6w+W8PzI6gf0EMEZdjrmIiVRlOzsA2qOzsL8/uBSSTEr2fQBjXN7YSqpeY1
         zTUn2zuusN/nPsh5WKBQUaIlZKaRq9t7c5fn2z9yiJk1mePnbmC1prrWoxd7HgEZWj
         fkIF1h4fSwRww==
Date:   Mon, 10 Oct 2022 16:44:40 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, Ram.Amrani@caviumnetworks.com,
        Michal.Kalderon@caviumnetworks.com, dledford@redhat.com,
        linux-pci@vger.kernel.org,
        Yuval Mintz <Yuval.Mintz@caviumnetworks.com>
Subject: Re: [PATCH net-next 3/7] qed: Add support for RoCE hw init
Message-ID: <20221010214440.GA2940104@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007154830.GA2630865@bhelgaas>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ping, updated Ariel's address]

On Fri, Oct 07, 2022 at 10:48:32AM -0500, Bjorn Helgaas wrote:
> On Sat, Oct 01, 2016 at 09:59:57PM +0300, Yuval Mintz wrote:
> > From: Ram Amrani <Ram.Amrani@caviumnetworks.com>
> > 
> > This adds the backbone required for the various HW initalizations
> > which are necessary for the qedr driver - FW notification, resource
> > initializations, etc.
> > ...
> 
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > ...
> > +	/* Check atomic operations support in PCI configuration space. */
> > +	pci_read_config_dword(cdev->pdev,
> > +			      cdev->pdev->pcie_cap + PCI_EXP_DEVCTL2,
> > +			      &pci_status_control);
> > +
> > +	if (pci_status_control & PCI_EXP_DEVCTL2_LTR_EN)
> > +		SET_FIELD(dev->dev_caps, QED_RDMA_DEV_CAP_ATOMIC_OP, 1);
> 
> I don't understand this.
> 
>   1) PCI_EXP_DEVCTL2 is a 16-bit register ("word"), not a 32-bit one
>   ("dword").
> 
>   2) QED_RDMA_DEV_CAP_ATOMIC_OP is set here but is not read anywhere
>   in this patch.  Is it used by the qed device itself?
> 
>   3) PCI_EXP_DEVCTL2_LTR_EN is for Latency Tolerance Reporting and is
>   not related to atomic ops.  I don't know what
>   QED_RDMA_DEV_CAP_ATOMIC_OP means, but possibly one of these was
>   intended instead?
> 
>     - PCI_EXP_DEVCAP2_ATOMIC_COMP32 means the device supports 32-bit
>       AtomicOps as a completer.
>     - PCI_EXP_DEVCAP2_ATOMIC_COMP64 means the device supports 64-bit
>       AtomicOps as a completer.
>     - PCI_EXP_DEVCAP2_ATOMIC_COMP128 means the device supports 128-bit
>       AtomicOps as a completer.
>     - PCI_EXP_DEVCTL2_ATOMIC_REQ means the device is allowed to
>       initiate AtomicOps.
> 
> (This code is now in qed_rdma.c)
