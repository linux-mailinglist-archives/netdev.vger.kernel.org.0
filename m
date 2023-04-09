Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3277C6DBF40
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 10:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjDIIyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 04:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIIyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 04:54:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A925146B3;
        Sun,  9 Apr 2023 01:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F616118C;
        Sun,  9 Apr 2023 08:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E597DC433D2;
        Sun,  9 Apr 2023 08:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681030469;
        bh=Oko4BOsX0p2Y6o6EhAvfUlbM6+JFTmdsQOEDiHoM358=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=onzUumLUUOzSBwTMu2NEH3LHQRTNf1rT8aDOAraILt6dgOUsDMeeMz7qsgZdVSiL5
         hOrJZR8LC4NFuKEtZbl5tfAWla+ASf9Tu4RWpQSrltlVH5p2Nvl9YlzgnM55XMe1nx
         FXRMKmAgztU3A6XfqvfB4iJNYFOqUOtNaYCJE5A66hZAmfqSGzosHPbiqgQfYr3IoW
         z28AkEihjDRfNC44CWDfZC7gGjdgrtNLhfQQ46TCIO5glcb5VHj+9kirDUEZOCMBbA
         AyJ9swfEsnhLgCMkbqV/opKBCBkWydMbNcQQ6E9BlOiYulnloBcTIXcrzWXLCV+448
         dE8kadILXq5AQ==
Date:   Sun, 9 Apr 2023 11:54:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: stop waiting for PCI link if reset is required
Message-ID: <20230409085425.GC14869@unreal>
References: <a25455eac6a02eeb9710d9204dfe0b91938f61a1.camel@linux.ibm.com>
 <20230405210613.GA3638573@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405210613.GA3638573@bhelgaas>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 04:06:13PM -0500, Bjorn Helgaas wrote:
> On Tue, Apr 04, 2023 at 05:27:35PM +0200, Niklas Schnelle wrote:
> > On Mon, 2023-04-03 at 21:21 +0300, Leon Romanovsky wrote:
> > > On Mon, Apr 03, 2023 at 09:56:56AM +0200, Niklas Schnelle wrote:
> > > > after an error on the PCI link, the driver does not need to wait
> > > > for the link to become functional again as a reset is required. Stop
> > > > the wait loop in this case to accelerate the recovery flow.
> > > > 
> > > > Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
> > > > Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
> > > > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > > > ---
> > > >  drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
> > > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > > index f9438d4e43ca..81ca44e0705a 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > > @@ -325,6 +325,8 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
> > > >  	while (sensor_pci_not_working(dev)) {
> > > 
> > > According to the comment in sensor_pci_not_working(), this loop is
> > > supposed to wait till PCI will be ready again. Otherwise, already in
> > > first iteration, we will bail out with pci_channel_offline() error.
> > 
> > Well yes. The problem is that this works for intermittent errors
> > including when the card resets itself which seems to be the use case in
> > mlx5_fw_reset_complete_reload() and mlx5_devlink_reload_fw_activate().
> > If there is a PCI error that requires a link reset though we see some
> > problems though it does work after running into the timeout.
> > 
> > As I understand it and as implemented at least on s390,
> > pci_channel_io_frozen is only set for fatal errors that require a reset
> > while non fatal errors will have pci_channel_io_normal (see also
> > Documentation/PCI/pcieaer-howto.rst)
> 
> Yes, I think that's true, see handle_error_source().
> 
> > thus I think pci_channel_offline()
> > should only be true if a reset is required or there is a permanent
> > error.
> 
> Yes, I think pci_channel_offline() will only be true when a fatal
> error has been reported via AER or DPC (or a hotplug driver says the
> device has been removed).  The driver resetting the device should not
> cause such a fatal error.

Thank you for an explanation and confirmation.
