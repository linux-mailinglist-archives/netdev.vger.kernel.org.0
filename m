Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EBE508078
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 07:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346191AbiDTFUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 01:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiDTFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 01:20:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C7D340C5;
        Tue, 19 Apr 2022 22:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650431854; x=1681967854;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=l0WdwVsUeyccH1Fn1OB0E52YvfyFMuwl2zNyTg/ZU5E=;
  b=V/5bp0QFmGwZGkTXV2kBMEYaoivOpIjqXqC/Sbg7WNMU/95Ry7QUgC2+
   bjveMRV2YBIwHa39lvJrvN7JRvfUZkUbNPTlrIGDOE1kLrVFQY3Ix55FB
   UUSUXmipRUkYM7XJBgFJo+KAGnKnYwrJBmHBYDJa70ZmNBdh8QLaYh1rF
   WXOzPqCBs5n6MK2YyI4bTbjx9NtW9FOqrdn1R1G7A2yvKDGSe+H1S4jGj
   dUstmB8KVU3PmMQl7AUD398VTgwy70O4C3YiBwUHkVO78ouGhWI/NQDxH
   qUUOG4MzhbLvkuHVRU/U4ZDWPyQx1PdftG5yO1SA9u0+28ognSNKSaY+B
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="264113563"
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="264113563"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 22:17:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="804919014"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 19 Apr 2022 22:17:12 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 5DCF85807D2;
        Tue, 19 Apr 2022 22:17:08 -0700 (PDT)
Date:   Wed, 20 Apr 2022 13:15:08 +0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <20220420051508.GA18173@linux.intel.com>
References: <20220413040115.2351987-1-tee.min.tan@intel.com>
 <20220413125915.GA667752@hoboy.vegasvil.org>
 <20220414072934.GA10025@linux.intel.com>
 <20220414104259.0b928249@kernel.org>
 <20220419005220.GA17634@linux.intel.com>
 <20220419132853.GA19386@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220419132853.GA19386@hoboy.vegasvil.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 06:28:53AM -0700, Richard Cochran wrote:
> On Tue, Apr 19, 2022 at 08:52:20AM +0800, Tan Tee Min wrote:
> 
> > I agree that the fsleep(1) (=1us) is a big hammer.
> > Thus in order to improve this, I’ve figured out a smaller delay
> > time that is enough for the context descriptor to be ready which
> > is ndelay(500) (=500ns).
> 
> Why isn't the context descriptor ready?
> 
> I mean, the frame already belongs to the CPU, right?

No. The context descriptor (frame) is possibly still owned by the
DMA controller in this situation.
This is why a looping in the original code to wait for the descriptor
to be owned by the application CPU. However, when NAPI is busy polling,
the context descriptor might be still owned by the DMA controller even
after the looping.

Thus, we are adding an additional nanosecond delay inside the loop,
so that the DMA controller can get a short moment to breathe and
complete the context descriptor.

Thanks,
Tee Min

> 
> Thanks,
> Richard
