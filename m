Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3084FC15E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiDKPsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348655AbiDKPsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:48:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824AA2B2;
        Mon, 11 Apr 2022 08:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649691970; x=1681227970;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9AYLuO9hFLI9yuodQaoQWp698tiNMu9aQk41vZwCDjQ=;
  b=npRUBF6t/9PGczwCCgKr1tG1SYVS8K31+tXiXSVNCGpo9QkGgmQD6gVI
   R2pdCMGcrFWSQG+P5g6MF0pUfnYbt7C49lJTOrJg7dJTke950YY7890ld
   rhx21C4mK8zIwwaihYr5phPIg2HMrtWn93TnD4C9xh9dNaROMnCNN56mJ
   WMRMKTWg2FUO7kaMZn+XsnmnWOM9jQ+HUPZSoUiNOw+J8DSixjHzcsQce
   i/i+BALeaAzfFFMpOEwmuc+8T6TWdotbQ2ofxw1RLCz/9MEpqf4vVfwEF
   Vy1a6oTYkLvL2TecZD1fMXDNX/ScKWIfBobWf5acu0e6xIUPAES3NjcH1
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="242085941"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="242085941"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 08:46:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="526027673"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 11 Apr 2022 08:46:07 -0700
Date:   Mon, 11 Apr 2022 17:46:06 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, magnus.karlsson@intel.com,
        bjorn@kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
Message-ID: <YlRNPuHdN5RTZjDn@boxer>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com>
 <Yk/7mkNi52hLKyr6@boxer>
 <82a1e9c1-6039-7ead-e663-2b0298f31ada@nvidia.com>
 <20220408111756.1339cb68@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408111756.1339cb68@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 11:17:56AM -0700, Jakub Kicinski wrote:
> On Fri, 8 Apr 2022 15:48:44 +0300 Maxim Mikityanskiy wrote:
> > >> 4. A slow or malicious AF_XDP application may easily cause an overflow of
> > >> the hardware receive ring. Your feature introduces a mechanism to pause the
> > >> driver while the congestion is on the application side, but no symmetric
> > >> mechanism to pause the application when the driver is close to an overflow.
> > >> I don't know the behavior of Intel NICs on overflow, but in our NICs it's
> > >> considered a critical error, that is followed by a recovery procedure, so
> > >> it's not something that should happen under normal workloads.  
> > > 
> > > I'm not sure I follow on this one. Feature is about overflowing the XSK
> > > receive ring, not the HW one, right?  
> > 
> > Right. So we have this pipeline of buffers:
> > 
> > NIC--> [HW RX ring] --NAPI--> [XSK RX ring] --app--> consumes packets
> > 
> > Currently, when the NIC puts stuff in HW RX ring, NAPI always runs and 
> > drains it either to XSK RX ring or to /dev/null if XSK RX ring is full. 
> > The driver fulfills its responsibility to prevent overflows of HW RX 
> > ring. If the application doesn't consume quick enough, the frames will 
> > be leaked, but it's only the application's issue, the driver stays 
> > consistent.
> > 
> > After the feature, it's possible to pause NAPI from the userspace 
> > application, effectively disrupting the driver's consistency. I don't 
> > think an XSK application should have this power.
> 
> +1
> cover letter refers to busy poll, but did that test enable prefer busy
> poll w/ the timeout configured right? It seems like similar goal can 
> be achieved with just that.

AF_XDP busy poll where app and driver runs on same core, without
configuring gro_flush_timeout and napi_defer_hard_irqs does not bring much
value, so all of the busy poll tests were done with:

echo 2 | sudo tee /sys/class/net/ens4f1/napi_defer_hard_irqs
echo 200000 | sudo tee /sys/class/net/ens4f1/gro_flush_timeout

That said, performance can still suffer and packets would not make it up
to user space even with timeout being configured in the case I'm trying to
improve.
