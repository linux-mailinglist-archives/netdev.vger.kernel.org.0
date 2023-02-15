Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380E3697AF9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 12:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjBOLnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 06:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjBOLnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 06:43:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC623A9B;
        Wed, 15 Feb 2023 03:43:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44F2A61B36;
        Wed, 15 Feb 2023 11:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0C1C433EF;
        Wed, 15 Feb 2023 11:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676461397;
        bh=8AhOsR6a6Fx83eFRNETvJhvMv8gizxyW0KwOLiToQVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tc0VZmxB/W2+IEloWtDnfvJU6TjDu/+caGUPd+obdvUBFgIQR7LbfNx5t+R0Q2o2u
         VdotvEkQfYMoz78nuQ8dZL2ai1b3QGXgU9oErJbQeKvn0uY3kVNWjszM/L1TBkR3lg
         k3j00CqtpgT9q4+QRT2qTeP+k6xkOEZlpF6gYpL5dy29DtkwrlFvs62YWavTZFNb7l
         lZKcK+rG1QxHm6p78sdTt7+YOwReHepFNhnHyWREZbzfF0HAafLr7EuSG/pZRYNO8H
         h3KrrAgNE8JuGuvO+KBGHaSA+hzkkS8TOaQukxDglJcBzCoI8dDQsJ+v7hN5QJX/ke
         DFrYSlcvI4cbA==
Date:   Wed, 15 Feb 2023 13:43:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Veerasenareddy Burru <vburru@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, aayarekar@marvell.com,
        sedara@marvell.com, sburla@marvell.com, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 1/7] octeon_ep: defer probe if firmware not
 ready
Message-ID: <Y+zFUUhogjJyp58e@unreal>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-2-vburru@marvell.com>
 <Y+vFlfakHj33DEkt@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+vFlfakHj33DEkt@boxer>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 06:32:05PM +0100, Maciej Fijalkowski wrote:
> On Mon, Feb 13, 2023 at 09:14:16PM -0800, Veerasenareddy Burru wrote:
> > Defer probe if firmware is not ready for device usage.
> > 
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > Signed-off-by: Satananda Burla <sburla@marvell.com>
> > ---
> > v2 -> v3:
> >  * fix review comments
> >    https://lore.kernel.org/all/Y4chWyR6qTlptkTE@unreal/
> >    - change get_fw_ready_status() to return bool
> >    - fix the success oriented flow while looking for
> >      PCI extended capability
> >  
> > v1 -> v2:
> >  * was scheduling workqueue task to wait for firmware ready,
> >    to probe/initialize the device.
> >  * now, removed the workqueue task; the probe returns EPROBE_DEFER,
> >    if firmware is not ready.
> >  * removed device status oct->status, as it is not required with the
> >    modified implementation.
> > 
> >  .../ethernet/marvell/octeon_ep/octep_main.c   | 26 +++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > index 5a898fb88e37..5620df4c6d55 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > @@ -1017,6 +1017,26 @@ static void octep_device_cleanup(struct octep_device *oct)
> >  	oct->conf = NULL;
> >  }
> >  
> > +static bool get_fw_ready_status(struct pci_dev *pdev)
> > +{
> > +	u32 pos = 0;
> > +	u16 vsec_id;
> > +	u8 status;
> > +
> > +	while ((pos = pci_find_next_ext_capability(pdev, pos,
> > +						   PCI_EXT_CAP_ID_VNDR))) {
> > +		pci_read_config_word(pdev, pos + 4, &vsec_id);
> > +#define FW_STATUS_VSEC_ID  0xA3
> > +		if (vsec_id != FW_STATUS_VSEC_ID)
> > +			continue;
> > +
> > +		pci_read_config_byte(pdev, (pos + 8), &status);
> > +		dev_info(&pdev->dev, "Firmware ready status = %u\n", status);
> > +		return status ? true : false;
> 
> nit:
> 
> return !!status;

"return status;" is enough, there is no need in "!!".

Thanks
