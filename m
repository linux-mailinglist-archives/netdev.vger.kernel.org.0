Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACFD6291FF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 07:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiKOGtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 01:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiKOGtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 01:49:22 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD080AE72
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 22:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668494961; x=1700030961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AdKlt15bstQWV4p6ZflPmPa7zSXXjgiCL7DyWnHYVRI=;
  b=Wr5/6DOPV5s7+jb5VXtcuqfOhyxKfRA1c8IJCWNfGIUiOgQHA5Tn0cgh
   KP5Ucd6CK1cjYDJ50edzPpVmlEZgyZ8XHwNIRZG2Qb1hGnz/xNDv9PZlp
   Gn7u8Fpix48cI5js+z24Hxoi3NZ0CsTjA627NmCPG1egXi1uyfANlBFT4
   7g6itAUoptq7Zcp8rxD7e0Op1bFW4iRg3xu1WweoYMNR+Gatv+SVO7pEM
   FwpPyoACsN9iBAG8+O2t1J47ntDq/lrO4VgZO7ohOOCR9bsDBwbwmbuD0
   LnES6fPPyqsPM4OdsMd0/zvW9pO3avDg8fYOGDyVUT0MiwIsnf3ZCaVpu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376446634"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="376446634"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:49:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="669982854"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="669982854"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:49:16 -0800
Date:   Tue, 15 Nov 2022 07:49:05 +0100
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
Subject: Re: [PATCH net-next 04/13] ice: split ice_vsi_setup into smaller
 functions
Message-ID: <Y3M2YUJgXbuB/bnM@localhost.localdomain>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <20221114125755.13659-5-michal.swiatkowski@linux.intel.com>
 <20221114210825.5c12894c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114210825.5c12894c@kernel.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 09:08:25PM -0800, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 13:57:46 +0100 Michal Swiatkowski wrote:
> > Main goal is to reuse the same functions in VSI config and rebuild
> > paths.
> > To do this split ice_vsi_setup into smaller pieces and reuse it during
> > rebuild.
> > 
> > ice_vsi_alloc() should only alloc memory, not set the default values
> > for VSI.
> > Move setting defaults to separate function. This will allow config of
> > already allocated VSI, for example in reload path.
> > 
> > The path is mostly moving code around without introducing new
> > functionality. Functions ice_vsi_cfg() and ice_vsi_decfg() were
> > added, but they are using code that already exist.
> > 
> > Use flag to pass information about VSI initialization during rebuild
> > instead of using boolean value.
> > 
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> nit:
> 
> drivers/net/ethernet/intel/ice/ice_lib.c:459: warning: Function parameter or member 'vsi' not described in 'ice_vsi_alloc_def'
> drivers/net/ethernet/intel/ice/ice_lib.c:459: warning: Excess function parameter 'vsi_type' description in 'ice_vsi_alloc_def'
> 
> Sorry, didn't get to actually reviewing because of the weekend backlog.
> Will do tomorrow.

Thanks, I will fix it in next version.
