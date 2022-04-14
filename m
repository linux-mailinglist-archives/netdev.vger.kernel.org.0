Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF365006E8
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 09:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbiDNHeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 03:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240330AbiDNHeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 03:34:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E4625C57;
        Thu, 14 Apr 2022 00:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649921507; x=1681457507;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xTe/USNWGaWU+a+ifxzMMD7mLSnomvLGY2rXT/S2iZk=;
  b=OcuDrYV/xMu4I2YGZfIv6bhGHOAR19e9liepVkLFLdGiCvuD9/ZI/ndM
   MMMhm5XeZkc58OC6Hg/NppGPhZ3Fb7JqpxcUWF/Nu90CDybkORAADFYag
   4w2tAAebvuzXovyNpB1WIMNCML4Gx6UpZ5IIaUdO9FHZ22gX1iazaGAzP
   aJoHziDnmGOE0TkcMGjadBFci/WKJyE1IkyyDhSK5i0BUBvdzVwesmVKv
   sMn9S8kTobsEmZnyZVblhbLOnx5iXqcobcrgjehwZH/06ofYH1I/9eqUM
   IaSC3DngVjlSmq6g6n73mBMtbghVJF2BkBaJVvejS8lpD2I1srpsIgbLq
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="262623045"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="262623045"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 00:31:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="624010417"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 14 Apr 2022 00:31:46 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 527075807E8;
        Thu, 14 Apr 2022 00:31:42 -0700 (PDT)
Date:   Thu, 14 Apr 2022 15:29:34 +0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Tan Tee Min <tee.min.tan@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add fsleep() in HW Rx timestamp
 checking loop
Message-ID: <20220414072934.GA10025@linux.intel.com>
References: <20220413040115.2351987-1-tee.min.tan@intel.com>
 <20220413125915.GA667752@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413125915.GA667752@hoboy.vegasvil.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 05:59:15AM -0700, Richard Cochran wrote:
> On Wed, Apr 13, 2022 at 12:01:15PM +0800, Tan Tee Min wrote:
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> > index d3b4765c1a5b..289bf26a6105 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> > @@ -279,10 +279,11 @@ static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
> >  			/* Check if timestamp is OK from context descriptor */
> >  			do {
> >  				ret = dwmac4_rx_check_timestamp(next_desc);
> > -				if (ret < 0)
> > +				if (ret <= 0)
> >  					goto exit;
> >  				i++;
> >  
> > +				fsleep(1);
> 
> This is nutty.  Why isn't this code using proper deferral mechanisms
> like work or kthread?

Appreciate your comment.
The dwmac4_wrback_get_rx_timestamp_status() is called by stmmac_rx()
function which is scheduled by NAPI framework.
Do we still need to create deferred work inside NAPI work?
Would you mind to explain it more in detail?

> 
> >  			} while ((ret == 1) && (i < 10));
> >  
> >  			if (i == 10)
> > -- 
> > 2.25.1
> > 
> 
> Thanks,
> Richard

Thanks,
Tee Min
