Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED73E50616E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244410AbiDSA5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 20:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbiDSA5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 20:57:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2452F27FED;
        Mon, 18 Apr 2022 17:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650329664; x=1681865664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bIElZ/ONSNAGuUnukdJ+HAUfMCgaREX0brCFR/k/fuk=;
  b=oEtC8PbWQUGBvsb8WcIqPHk45JNrgOEGOeXhbWe649hKijpkSpukyKY/
   WobKjJZISjGVNdX4OXpXZlCyEBcnoMZnxXwPA6YdZnMQ46+XXTF/8YALS
   PonZv2A2B4iuOz0K0vGp72XNszGZggfUFJ9U6fuS+EkEfr8U5BZ2la1Ed
   mUakX9DiIetY7QWGzL0tmVK9Dni7Ugnlt1E8IQ7XSXsNZFq2LzYVKQQ6W
   HkjqjN2WaguLm3wACp07pWSa/z2tZHjH/HVmX+BURRD+cRlEWPtiODcZA
   C2+a+GvVmm21gFWOf5HEnCCcv2p47s4qwsweRkHlmaVCBRtxifJRRW9v8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="324085422"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="324085422"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 17:54:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="554472469"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 18 Apr 2022 17:54:23 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 66F865808AE;
        Mon, 18 Apr 2022 17:54:19 -0700 (PDT)
Date:   Tue, 19 Apr 2022 08:52:20 +0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add fsleep() in HW Rx timestamp
 checking loop
Message-ID: <20220419005220.GA17634@linux.intel.com>
References: <20220413040115.2351987-1-tee.min.tan@intel.com>
 <20220413125915.GA667752@hoboy.vegasvil.org>
 <20220414072934.GA10025@linux.intel.com>
 <20220414104259.0b928249@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414104259.0b928249@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 10:42:59AM +0200, Jakub Kicinski wrote:
> On Thu, 14 Apr 2022 15:29:34 +0800 Tan Tee Min wrote:
> > > > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> > > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> > > > @@ -279,10 +279,11 @@ static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
> > > >  			/* Check if timestamp is OK from context descriptor */
> > > >  			do {
> > > >  				ret = dwmac4_rx_check_timestamp(next_desc);
> > > > -				if (ret < 0)
> > > > +				if (ret <= 0)
> > > >  					goto exit;
> > > >  				i++;
> > > >  
> > > > +				fsleep(1);  
> > > 
> > > This is nutty.  Why isn't this code using proper deferral mechanisms
> > > like work or kthread?  
> > 
> > Appreciate your comment.
> > The dwmac4_wrback_get_rx_timestamp_status() is called by stmmac_rx()
> > function which is scheduled by NAPI framework.
> > Do we still need to create deferred work inside NAPI work?
> > Would you mind to explain it more in detail?
> 
> fsleep() is a big hammer, can you try cpu_relax() and bumping the max
> loop count a little?

Thanks for the suggestion!
I tried cpu_relax(), unfortunately the issue still happens when
the system is in a high-load situation.

I agree that the fsleep(1) (=1us) is a big hammer.
Thus in order to improve this, I’ve figured out a smaller delay
time that is enough for the context descriptor to be ready which
is ndelay(500) (=500ns).

Would you think this is more acceptable?

