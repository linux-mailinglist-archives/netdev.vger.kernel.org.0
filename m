Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647166D8936
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 23:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjDEVGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 17:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjDEVGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 17:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6745B65A0;
        Wed,  5 Apr 2023 14:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E0963CF8;
        Wed,  5 Apr 2023 21:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EDFC433EF;
        Wed,  5 Apr 2023 21:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680728775;
        bh=R71QHKkeUfH8VYzRdCdAeQ6B2BQkF7BrfCwK1Xovuwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=d8bWqodR70r6m+e7Zu9a800cEEUnjBsaw3dijXkqKvp7K97SMthAI4HrP63SuFNY9
         9I9RB3l3Jd32V4DfJdFskhNcalupz6weZkbLCZU/+LPYtE+Jz5IkW1ZjNdBT5LViRv
         15/NH0M45k3ZnDMVcNTtXK3aP/QrW9LrHDKDLdgAOY0y6ZC6Z2yuCEsJjOzuVTvH0/
         B4elU0ltk5e+D/1KeoN6xmVOzwKf0GIIzualjtyPPWMPFZXCegtTHmr+qgfSGpJewY
         vD4p6com0bWhX5yWkD/j0UP7L6E7y//sFnHMbQ19EW3dlk/pyBHvYx+RMw7hH1yF1J
         CAsQzqO8gL/LA==
Date:   Wed, 5 Apr 2023 16:06:13 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <20230405210613.GA3638573@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a25455eac6a02eeb9710d9204dfe0b91938f61a1.camel@linux.ibm.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:27:35PM +0200, Niklas Schnelle wrote:
> On Mon, 2023-04-03 at 21:21 +0300, Leon Romanovsky wrote:
> > On Mon, Apr 03, 2023 at 09:56:56AM +0200, Niklas Schnelle wrote:
> > > after an error on the PCI link, the driver does not need to wait
> > > for the link to become functional again as a reset is required. Stop
> > > the wait loop in this case to accelerate the recovery flow.
> > > 
> > > Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
> > > Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
> > > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > index f9438d4e43ca..81ca44e0705a 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > @@ -325,6 +325,8 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
> > >  	while (sensor_pci_not_working(dev)) {
> > 
> > According to the comment in sensor_pci_not_working(), this loop is
> > supposed to wait till PCI will be ready again. Otherwise, already in
> > first iteration, we will bail out with pci_channel_offline() error.
> 
> Well yes. The problem is that this works for intermittent errors
> including when the card resets itself which seems to be the use case in
> mlx5_fw_reset_complete_reload() and mlx5_devlink_reload_fw_activate().
> If there is a PCI error that requires a link reset though we see some
> problems though it does work after running into the timeout.
> 
> As I understand it and as implemented at least on s390,
> pci_channel_io_frozen is only set for fatal errors that require a reset
> while non fatal errors will have pci_channel_io_normal (see also
> Documentation/PCI/pcieaer-howto.rst)

Yes, I think that's true, see handle_error_source().

> thus I think pci_channel_offline()
> should only be true if a reset is required or there is a permanent
> error.

Yes, I think pci_channel_offline() will only be true when a fatal
error has been reported via AER or DPC (or a hotplug driver says the
device has been removed).  The driver resetting the device should not
cause such a fatal error.

> Furthermore in the pci_channel_io_frozen state the PCI function
> may be isolated and the reads will not reach the endpoint, this is the
> case at least on s390.  Thus for errors requiring a reset the loop
> without pci_channel_offline() will run until the reset is performed or
> the timeout is reached. In the mlx5_health_try_recover() case during
> error recovery we will then indeed always loop until timeout, because
> the loop blocks mlx5_pci_err_detected() from returning thus blocking
> the reset (see Documentation/PCI/pci-error-recovery.rst). Adding Bjorn,
> maybe he can confirm or correct my assumptions here.

> > >  		if (time_after(jiffies, end))
> > >  			return -ETIMEDOUT;
> > > +		if (pci_channel_offline(dev->pdev))
> > > +			return -EIO;
> > >  		msleep(100);
> > >  	}
> > >  	return 0;
> > > @@ -332,10 +334,16 @@ int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
> > >  
> > >  static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
> > >  {
> > > +	int rc;
> > > +
> > >  	mlx5_core_warn(dev, "handling bad device here\n");
> > >  	mlx5_handle_bad_state(dev);
> > > -	if (mlx5_health_wait_pci_up(dev)) {
> > > -		mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
> > > +	rc = mlx5_health_wait_pci_up(dev);
> > > +	if (rc) {
> > > +		if (rc == -ETIMEDOUT)
> > > +			mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
> > > +		else
> > > +			mlx5_core_err(dev, "health recovery flow aborted, PCI channel offline\n");
> > >  		return -EIO;
> > >  	}
> > >  	mlx5_core_err(dev, "starting health recovery flow\n");
> > > 
> > > base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
> > > -- 
> > > 2.37.2
> > > 
> 
