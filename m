Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183B26D3D10
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjDCGBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDCGBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:01:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4A583F0
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 23:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680501696; x=1712037696;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ot7U9s3fjbOvnQ6eNg6mimuRyfAMaus3isrVh+SmT3g=;
  b=WLbBtRwqHddLhNEVVJPHRMis16EtCUbR9fWfqOeq7Eqb0/KJwN6iBfcO
   euQWSQC7O48ZtpCyVGXd0n9hLeiwi3PAT0p0QdQuGJQm8kggKnHatUv4L
   V16OrhF8NWBVAwIkzBOb84xONp41znyAi7m2AOPhTRrp5xDznp86rcJzi
   HHf2o/sUNQ25wgGByN/uYlcdzQCq3RcEqXKo4JOnpPcBDnf4pnvqh2182
   wq4PLDZNOXadc9/LZuXRJ0MW5nDB+5l4yat6HJLh7VknupFCI50DTBNmP
   N4lt3VbMHNgk+zyGU09qR04bP8msTtY/49ICxWCISk5mfTvNJsRCTJ+Ko
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="428105222"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="428105222"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 23:01:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="750380410"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="750380410"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 23:01:34 -0700
Date:   Mon, 3 Apr 2023 08:01:26 +0200
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com
Subject: Re: [PATCH net-next 4/4] ice: use src VSI instead of src MAC in
 slow-path
Message-ID: <ZCprtqPDE8Nun2jw@localhost.localdomain>
References: <20230331105747.89612-1-michal.swiatkowski@linux.intel.com>
 <20230331105747.89612-5-michal.swiatkowski@linux.intel.com>
 <ZCfzsSmsrbRIBtsy@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCfzsSmsrbRIBtsy@corigine.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 11:04:49AM +0200, Simon Horman wrote:
> On Fri, Mar 31, 2023 at 12:57:47PM +0200, Michal Swiatkowski wrote:
> > The use of a source  MAC to direct packets from the VF to the
> > corresponding port representor is only ok if there is only one
> > MAC on a VF. To support this functionality when the number
> > of MACs on a VF is greater, it is necessary to match a source
> > VSI instead of a source MAC.
> > 
> > Let's use the new switch API that allows matching on metadata.
> > 
> > If MAC isn't used in match criteria there is no need to handle adding
> > rule after virtchnl command. Instead add new rule while port representor
> > is being configured.
> > 
> > Remove rule_added field, checking for sp_rule can be used instead.
> > Remove also checking for switchdev running in deleting rule as it can be
> > call from unroll context when running flag isn't set. Checking for
> > sp_rule cover both context (with and without running flag).
> > 
> > Rules are added in eswitch configuration flow, so there is no need to
> > have replay function.
> > 
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> > index 20f66be9ba5f..1b739e096d27 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> > @@ -256,7 +256,9 @@ struct ice_nvgre_hdr {
> >   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >   *
> >   * Source VSI = Source VSI of packet loopbacked in switch (for egress) (10b).
> > - *
> > + */
> > +#define ICE_MDID_SOURCE_VSI_MASK 0x3ff
> 
> nit: GENMASK might be appropriate here.
> 

Thanks for the review, I will fix it.

> > +/*
> >   * MDID 20
> >   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >   * |A|B|C|D|E|F|R|R|G|H|I|J|K|L|M|N|
> 
> ...
