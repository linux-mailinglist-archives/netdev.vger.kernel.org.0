Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAA56DBF78
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjDIKeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjDIKeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A9244BF
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D8B60B9B
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47CDC433EF;
        Sun,  9 Apr 2023 10:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681036450;
        bh=iqWFymEU6hWEQa1gWG19IWc72Okfkhm8Rs5GNih9oHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IIq6Yp/4cAJgoYDx9BsgmfdagrAHimQ/mNI+FD7DuAmWksTyrr0+o3qBvJ48PbmPQ
         BLBJQtYL+oj74Nx1flKAdgdNWSmp7MZZnRKuxFu5PQG/MuqkNrR/dv8qc4Ci46duzV
         NtKEwMpTu4Q7EtACG8E6GEahp2xnvhHxqS0sBRpey8fcdQKfO21O7Wo5TLy8JXik6+
         3Pa2zWij+LfZCaKBLLQ0panr2Z927qI+6yIUOVredMojkDTi/V3n1oxu+UN1rfzcsJ
         gHfdp1r4wAV38UEJK34O8ILf2osrxCcngBdcsVTkmXhRmnfjTJJImkWsLCO/faVlWD
         vZE3RqwpmihEw==
Date:   Sun, 9 Apr 2023 13:34:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de, aleksander.lobakin@intel.com,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v4 5/5] ice: use src VSI instead of src MAC in
 slow-path
Message-ID: <20230409103406.GM14869@unreal>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-6-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407165219.2737504-6-michal.swiatkowski@linux.intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:52:19PM +0200, Michal Swiatkowski wrote:
> The use of a source MAC to direct packets from the VF to the corresponding
> port representor is only ok if there is only one MAC on a VF. To support
> this functionality when the number of MACs on a VF is greater, it is
> necessary to match a source VSI instead of a source MAC.
> 
> Let's use the new switch API that allows matching on metadata.
> 
> If MAC isn't used in match criteria there is no need to handle adding
> rule after virtchnl command. Instead add new rule while port representor
> is being configured.
> 
> Remove rule_added field, checking for sp_rule can be used instead.
> Remove also checking for switchdev running in deleting rule as it can be
> called from unroll context when running flag isn't set. Checking for
> sp_rule covers both context (with and without running flag).
> 
> Rules are added in eswitch configuration flow, so there is no need to
> have replay function.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c  | 83 ++++++-------------
>  drivers/net/ethernet/intel/ice/ice_eswitch.h  | 14 ----
>  .../ethernet/intel/ice/ice_protocol_type.h    |  5 +-
>  drivers/net/ethernet/intel/ice/ice_repr.c     | 17 ----
>  drivers/net/ethernet/intel/ice/ice_repr.h     |  5 +-
>  drivers/net/ethernet/intel/ice/ice_switch.c   |  6 ++
>  drivers/net/ethernet/intel/ice/ice_switch.h   |  1 +
>  drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  3 -
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c |  8 --
>  9 files changed, 40 insertions(+), 102 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
