Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53CF6E1351
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjDMRRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDMRRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:17:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F11C7D8E;
        Thu, 13 Apr 2023 10:17:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2405E6403A;
        Thu, 13 Apr 2023 17:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE555C433D2;
        Thu, 13 Apr 2023 17:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681406234;
        bh=WVGfre3QBuukzcuJT8qpJQMfItIiegxThh0TEh6FLlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MbSTT/OuM1W9kazwfGCuX7qMry/bvpClkZ6rzFpsmqQSpq/Ar9sPKGBiiRtvQA5Li
         xdVDkmFJYHFppAe1nyI6Jtnki9ooxHLNj2pNwA0Chx7PMS2MNGvDr9zbaqif8eL3rz
         UfzWQ5fVRYl9RCzgFNoWmr+2kxLjZpiTn0fYhIej7p2KEkGhghuN5ab3+rtCcOA7p8
         CmIvdKtCSJjMglB0MTBxF6njyb9oL8ZRzlN0mcGUDtvK9RvW+KL6945ES2R/e9rtyF
         RgSlWo8uZ9oCfK9g2FaiXLe3x8FC8Zyib4PuQpxSARaY1T5IUq0htYdbBbxtI8yDwb
         cmtUzqIOYU4hA==
Date:   Thu, 13 Apr 2023 20:17:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH v1] ice: add CGU info to devlink info callback
Message-ID: <20230413171710.GW17993@unreal>
References: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
 <20230413131726.GQ17993@unreal>
 <DM6PR11MB4657BB5D26421ECA7709C79B9B989@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657BB5D26421ECA7709C79B9B989@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 02:04:33PM +0000, Kubalewski, Arkadiusz wrote:
> >From: Leon Romanovsky <leon@kernel.org>
> >Sent: Thursday, April 13, 2023 3:17 PM
> >
> >On Wed, Apr 12, 2023 at 03:38:11PM +0200, Arkadiusz Kubalewski wrote:
> >> If Clock Generation Unit and dplls are present on NIC board user shall
> >> know its details.
> >> Provide the devlink info callback with a new:
> >> - fixed type object `cgu.id` - hardware variant of onboard CGU
> >> - running type object `fw.cgu` - CGU firmware version
> >> - running type object `fw.cgu.build` - CGU configuration build version
> >>
> >> These information shall be known for debugging purposes.
> >>
> >> Test (on NIC board with CGU)
> >> $ devlink dev info <bus_name>/<dev_name> | grep cgu
> >>         cgu.id 8032
> >>         fw.cgu 6021
> >>         fw.cgu.build 0x1030001
> >>
> >> Test (on NIC board without CGU)
> >> $ devlink dev info <bus_name>/<dev_name> | grep cgu -c
> >> 0
> >>
> >> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> >> ---
> >>  Documentation/networking/devlink/ice.rst     | 14 +++++++++
> >>  drivers/net/ethernet/intel/ice/ice_devlink.c | 30 ++++++++++++++++++++
> >>  drivers/net/ethernet/intel/ice/ice_main.c    |  5 +++-
> >>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c  | 12 ++++----
> >>  drivers/net/ethernet/intel/ice/ice_type.h    |  9 +++++-
> >>  5 files changed, 62 insertions(+), 8 deletions(-)
> >
> ><...>
> >
> >>  Flash Update
> >>  ============
> >> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c
> >b/drivers/net/ethernet/intel/ice/ice_devlink.c
> >> index bc44cc220818..06fe895739af 100644
> >> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> >> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> >> @@ -193,6 +193,33 @@ ice_info_pending_netlist_build(struct ice_pf
> >>__always_unused *pf,
> >>  		snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", netlist->hash);
> >>  }
> >>
> >> +static void ice_info_cgu_id(struct ice_pf *pf, struct ice_info_ctx *ctx)
> >> +{
> >> +	if (ice_is_feature_supported(pf, ICE_F_CGU)) {
> >> +		struct ice_hw *hw = &pf->hw;
> >> +
> >> +		snprintf(ctx->buf, sizeof(ctx->buf), "%u", hw->cgu.id);
> >> +	}
> >
> >Please use kernel coding style - success oriented flow
> >
> >struct ice_hw *hw = &pf->hw;
> >
> >if (!ice_is_feature_supported(pf, ICE_F_CGU))
> >  return;
> >
> >snprintf(ctx->buf, sizeof(ctx->buf), "%u", hw->cgu.id);
> >
> >
> >However, it will be nice to have these callbacks only if CGU is
> >supported, in such way you won't need any of ice_is_feature_supported()
> >checks.
> >
> >Thanks
> 
> Sure, I will fix as suggested in the next version.
> Although most important is to achieve common understanding and agreement if
> This way is the right one. Maybe those devlink id's shall be defined as a
> part of "include/net/devlink.h", so other vendors could use it?

Once second vendor materialize, it will be his responsibility to move
common code to devlink.h.

> Also in such case probably naming might need to be unified.
> 
> Thank you!
> Arkadiusz
