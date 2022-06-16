Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F1954E842
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377156AbiFPRAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376865AbiFPRAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:00:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE59A49FB6;
        Thu, 16 Jun 2022 10:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655398814; x=1686934814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AFZhHva36n9bSC1o+D2V/qCWtqlnJrh6gWIkUf10m8U=;
  b=HX2/SGAGWf9epOlvpRZlDDAaHS6GrCnPzkWQQYqEqA5ovjrHQ+/jGX9s
   n59OfLNd/STVXgT2tgvI1PFkP6P0zje7eZqsAHtit4GWLUcL3EsTZaEl/
   lxJQaGgOfKoCsgGabLMapDvtBW+vQ/CKxvN0Gw68+xDwI6mH1yezjtkMO
   hLrTx1e5by6/r8nMVGm+DFJ6tSXkH8MvIYXupUOpIPnejLsmUWugSR3ci
   FSDUmu+ETruDoPCZ58W/uXABu6RRWMCZyIVpFTb7poxR4mIP2eyzve/PH
   7Iv2ARRyqxnI9sixOTHSjmDSKgEYmbb1A2UJn0sfFu56y8DUFFAdYOKgM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="279353117"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="279353117"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 10:00:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="583705493"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 16 Jun 2022 10:00:12 -0700
Date:   Thu, 16 Jun 2022 19:00:11 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH v2 bpf-next 01/10] ice: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <Yqthm2ZFoJ1SnK6B@boxer>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
 <20220614174749.901044-2-maciej.fijalkowski@intel.com>
 <20220615164740.5e1f8915@kernel.org>
 <YqtTqP+S0jvDNRJF@boxer>
 <20220616094740.276b8312@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616094740.276b8312@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 09:47:40AM -0700, Jakub Kicinski wrote:
> On Thu, 16 Jun 2022 18:00:40 +0200 Maciej Fijalkowski wrote:
> > > Loopback or not, I don't think we should be accepting the shutdown ->
> > > set config -> pray approach in modern drivers. ice_open() seems to be
> > > allocating all the Rx memory, and can fail.  
> > 
> > They say that those who sing pray twice, so why don't we sing? :)
> > 
> > But seriously, I'll degrade this to ice_down/up and check retvals. I think
> > I just mimicked flow from ice_self_test(), which should be fixed as
> > well...
> > 
> > I'll send v4.
> 
> checking retval is not enough, does ice not have the ability to
> allocate resources upfront? I think iavf was already restructured
> to follow the "resilient" paradigm, time for ice to follow suit?

I'm not aware of such restructure TBH. FWIW ice_down() won't free
irqs/rings. I said I'll switch to it plus check its retval whereas I feel
like you took it like I would want to keep the ice_stop() and check its
retval.

> 
> This is something DaveM complained about in the first Ethernet driver 
> I upstreamed, which must have been a decade ago by now. It's time we
> all get on board :)
