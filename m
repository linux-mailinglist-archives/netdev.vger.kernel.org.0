Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AC854E692
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377288AbiFPQAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377954AbiFPQAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:00:44 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB0443ADA;
        Thu, 16 Jun 2022 09:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655395243; x=1686931243;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FSXmpx4dqVbCkfG/hff82NY1uJ6SEx/Gz6EVD2j/qY8=;
  b=U4UFWeJa5ffXL6h2YO9eAwmFX2vdew6UH15LCf5Lp20sIzOz4D90lDBy
   Al4ACprxL7pK5mZMXznoOjPkMEXcJCXF85zeJAzH8u1OK7QLu7gVOTxOH
   oUFwIEOW1I9kU0AVwVXtl15+E1R/m+bHGnchxPshNauz+7pU0iE6pexrd
   ldvPilUdaCql+OaL8HGuobMwhFLW5zDQqtOcdZpGYsGhLvCgJggQD5q7F
   fd24pDXx4FR2DyDXXP/DVRV1KUHjRChcsGv/pwhtTMoGVe5RX4JllvV/c
   US1I049ZdVZDP5FSiryOLyWZyZFIPN6tJyFmIsYUMPq8EOFCBbdzcoH12
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278075902"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="278075902"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 09:00:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="831616758"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2022 09:00:41 -0700
Date:   Thu, 16 Jun 2022 18:00:40 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH v2 bpf-next 01/10] ice: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <YqtTqP+S0jvDNRJF@boxer>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
 <20220614174749.901044-2-maciej.fijalkowski@intel.com>
 <20220615164740.5e1f8915@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615164740.5e1f8915@kernel.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 04:47:40PM -0700, Jakub Kicinski wrote:
> On Tue, 14 Jun 2022 19:47:40 +0200 Maciej Fijalkowski wrote:
> > +	if (if_running)
> > +		ice_stop(netdev);
> > +	if (ice_aq_set_mac_loopback(&pf->hw, ena, NULL))
> > +		dev_err(ice_pf_to_dev(pf), "Failed to toggle loopback state\n");
> > +	if (if_running)
> > +		ice_open(netdev);
> 
> Loopback or not, I don't think we should be accepting the shutdown ->
> set config -> pray approach in modern drivers. ice_open() seems to be
> allocating all the Rx memory, and can fail.

They say that those who sing pray twice, so why don't we sing? :)

But seriously, I'll degrade this to ice_down/up and check retvals. I think
I just mimicked flow from ice_self_test(), which should be fixed as
well...

I'll send v4.
