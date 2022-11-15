Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEC6629201
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 07:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiKOGuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 01:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiKOGt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 01:49:59 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1820AE72
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 22:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668494998; x=1700030998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WJPfoBXwWWUlfYGZbGPQiXLGnCRjrkM4dB/g1VMm6M0=;
  b=dued6j6XuczJVhHS5s90mfVvwmzmd8kbFdGttAmnpkY8v7AKJFrmRTCA
   4hR+1CYcfvGRx+WZ8PcAznM/DcyZEdq5b5dJhm1xFSfBpCCJA8OAoK0to
   r1PY40iCc/Q0DAA+wPpWXfU77zBJbsw7MHyU2OJoRvNs1lVG8lWdDOXI+
   rHNtbmRn6ImoWkL9YMTx4xIIxw5sGbh1Tf4daUdWJCSdJMn+4KEGAIwoF
   E0eNGNMdVOC+Gis3tQAnHnQaaih9dfnPC6HCcTxa4jAiix5tnaDAIZb6e
   OnmZDrEe5UXKpOxmaPee5mCi6+immuT2r81ERKCdRp1LjvNl4dKrhQpxe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="374312959"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="374312959"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:49:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="638834043"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="638834043"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:49:54 -0800
Date:   Tue, 15 Nov 2022 07:49:50 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jiri@nvidia.com, anthony.l.nguyen@intel.com,
        alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com
Subject: Re: [PATCH net-next 12/13] ice, irdma: prepare reservation of MSI-X
 to reload
Message-ID: <Y3M2jjkv/sWqWwHk@localhost.localdomain>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <20221114125755.13659-13-michal.swiatkowski@linux.intel.com>
 <20221114210856.0d76bb2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114210856.0d76bb2c@kernel.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 09:08:56PM -0800, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 13:57:54 +0100 Michal Swiatkowski wrote:
> > Move MSI-X number for LAN and RDMA to structure to have it in one
> > place. Use req_msix to store how many MSI-X for each feature user
> > requested. Structure msix is used to store the current number of MSI-X.
> > 
> > The MSI-X number needs to be adjust if kernel doesn't support that many
> > MSI-X or if hardware doesn't support it. Rewrite MSI-X adjustment
> > function to use it in both cases.
> > 
> > Use the same algorithm like previously. First allocate minimum MSI-X for
> > each feature than if there is enough MSI-X distribute it equally between
> > each one.
> 
> drivers/net/ethernet/intel/ice/ice_lib.c:455: warning: Function parameter or member 'vsi' not described in 'ice_vsi_alloc_def'
> drivers/net/ethernet/intel/ice/ice_lib.c:455: warning: Excess function parameter 'vsi_type' description in 'ice_vsi_alloc_def'
> drivers/net/ethernet/intel/ice/ice_main.c:4026:9: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
>         return err;
>                ^~~
> drivers/net/ethernet/intel/ice/ice_main.c:4001:29: note: initialize the variable 'err' to silence this warning
>         int v_wanted, v_actual, err, i;
>                                    ^
>                                     = 0

Thanks, will fix 
