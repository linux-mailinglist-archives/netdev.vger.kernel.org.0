Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4912357623E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiGOMv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiGOMvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:51:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DF23FA1D;
        Fri, 15 Jul 2022 05:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657889514; x=1689425514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=XsGDBcS88q7D9OrBG2oRt2Ha1lahH1bzbIJidg/N+fo=;
  b=VukXf4KNyR9knKs/VgbA2lV61RgQoCvJewjPKCpAODx0HKtv4cf0Ef2I
   IHcwb2ExrhWFxWNrscVJIbeBcKMrxBB3lnhUaJASPFchVKFTZSIkIMT65
   /CQu+NHCveBiIDLAJOj4ydoQCvla3/ILLdc4psogmPwkmgmzTZwMsi5Ao
   Y0Qw9n6nsrkqtRPO5cwBqnSEWnRLLCwGKSweaByPa5jx0MhhTNojarmza
   c5TTEkecZD3WOnGHwtra6rZYhgk1RJ3qLBoYGGvouW2XlpFp2fLn2EQbU
   FME4e4U88dNgl5vjRPNmlfDNP9CSddJYx5e75DPAMvvHwXO12HaLFWORU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266199925"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="266199925"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 05:51:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="596459264"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 15 Jul 2022 05:51:53 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 11086580970;
        Fri, 15 Jul 2022 05:51:50 -0700 (PDT)
Date:   Fri, 15 Jul 2022 20:51:48 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pei.lee.ling@intel.com
Subject: Re: [PATCH net 1/1] net: stmmac: Resolve poor line rate after
 switching from TSO off to TSO on
Message-ID: <20220715125148.GA21603@linux.intel.com>
References: <20220228111558.3825974-1-vee.khee.wong@linux.intel.com>
 <20220302223248.2492658e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220302223248.2492658e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:32:48PM -0800, Jakub Kicinski wrote:
> On Mon, 28 Feb 2022 19:15:58 +0800 Wong Vee Khee wrote:
> > From: Ling Pei Lee <pei.lee.ling@intel.com>
> > 
> > Sequential execution of these steps:
> > i) TSO ON – iperf3 execution,
> > ii) TSO OFF – iperf3 execution,
> > iii) TSO ON – iperf3 execution, it leads to iperf3 0 bytes transfer.
> 
> IMHO the iperf output can be dropped from the commit message, 
> it doesn't add much beyond this description.
>

Noted. Will drop those on next revision of pull request.
 
> > Clear mss in TDES and call stmmac_enable_tso() to indicate
> > a new TSO transmission when it is enabled from TSO off using
> > ethtool command
> 
> How does the TSO get disabled I don't see any ...enable_tso(, 0, )
> calls in the driver? And why call enable in fix_features rather 
> than set_features?

It is disable when 'priv->tso = 0' in this same function.
The reason I put this in fix_features rather than set_features is
because the commit f748be531d70("stmmac: support new GMAC4") has
already introduced the following codes in fix_features:-

+	/* Disable tso if asked by ethtool */
+	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
+		if (features & NETIF_F_TSO)
+			priv->tso = true;
+		else
+			priv->tso = false;
+	}

BR,
 Vee Khee
