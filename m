Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B211E551648
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbiFTKyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbiFTKyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:54:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DB2BF71;
        Mon, 20 Jun 2022 03:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655722444; x=1687258444;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sWWrJvt0f2JA/y++h4KmXVDTMns3DbXchTZxLejYHAU=;
  b=EM3yooowdc4BzLrb44g8RyP/5FaH/N0wXnxQI2dTqYAdmP/y7PVXW27E
   CYaVXcXC2oUxG0nbekuPhIcQ/METJXZ05rwyQSFTysEBkkWhtHUAhXFnn
   n+ttfYNjXomfYmjz+CrD4baklKa0kaJPfrp8XUFOGFv07Qhr8X3a/joHo
   oLDuOVQFahXvJ8sJzLrNlu/1xc/meJZ1Mw8zk7CgZ399pkesu6ImMJQDe
   8CKp5EKJAssrhG2nnusmugFP+E1tZWX/yHSvXm0PFBMr7kN5UQPBvrCif
   LM9oL71LoA9Dz41o0x0fsJRLnKgDczo8t1DMmgctxFchnJ46ggpDHk309
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343857218"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="343857218"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 03:54:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="584847399"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 20 Jun 2022 03:53:58 -0700
Date:   Mon, 20 Jun 2022 12:53:57 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org
Subject: Re: [PATCH v4 bpf-next 03/10] ice: check DD bit on Rx descriptor
 rather than (EOP | RS)
Message-ID: <YrBRxeIXhmxBDOgr@boxer>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-4-maciej.fijalkowski@intel.com>
 <62ad31611159b_24b3420829@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ad31611159b_24b3420829@john.notmuch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 06:58:57PM -0700, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > Tx side sets EOP and RS bits on descriptors to indicate that a
> > particular descriptor is the last one and needs to generate an irq when
> > it was sent. These bits should not be checked on completion path
> > regardless whether it's the Tx or the Rx. DD bit serves this purpose and
> > it indicates that a particular descriptor is either for Rx or was
> > successfully Txed.
> > 
> > Look at DD bit being set in ice_lbtest_receive_frames() instead of EOP
> > and RS pair.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Is this a bugfix? If so it should go to bpf tree.

Previous logic worked without this patch by an accident, so I don't change
the behaviour of the loopback self test itself, therefore I was not sure
if this could be classified as a bugfix.

Rx descriptor's status_error0 field has ICE_RX_FLEX_DESC_STATUS0_DD_S and
ICE_RX_FLEX_DESC_STATUS0_EOF_S set, which have the following values:

enum ice_rx_flex_desc_status_error_0_bits {
	/* Note: These are predefined bit offsets */
	ICE_RX_FLEX_DESC_STATUS0_DD_S = 0,
	ICE_RX_FLEX_DESC_STATUS0_EOF_S,
	(...)
};

Old code was only ORing two following enums:

enum ice_tx_desc_cmd_bits {
	ICE_TX_DESC_CMD_EOP			= 0x0001,
	ICE_TX_DESC_CMD_RS			= 0x0002,
	(...)
};

If BIT() was used around ICE_TX_DESC_CMD_EOP and ICE_TX_DESC_CMD_RS and if
they were checked separately then on RS bit we would fail.

(let me also check for EOF bit in next revision)

> 
> > ---
> >  drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > index 1e71b70f0e52..b6275a29fa0d 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > @@ -658,7 +658,7 @@ static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
> >  		rx_desc = ICE_RX_DESC(rx_ring, i);
> >  
> >  		if (!(rx_desc->wb.status_error0 &
> > -		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
> > +		    cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S))))
> >  			continue;
> >  
> >  		rx_buf = &rx_ring->rx_buf[i];
> > -- 
> > 2.27.0
> > 
> 
> 
