Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15453E3AE
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiFFG1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 02:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiFFG1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 02:27:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9465F29816;
        Sun,  5 Jun 2022 23:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654496825; x=1686032825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wdDYJ5XqGQgotDlH0rFCdHOAVHtDqbqcv/4oCjtcY4I=;
  b=A4zUZgV4cVJvZ45p9572u95F0/ec887nDtj2lJ25lFO3u23AJ1iwEWMo
   9UejRtSjBeIKCBr3cNoWNc+H/fnBP71HVGkEbF/hSY1VF9DZNXKONcXaY
   lGSO+iXbkvy4mEJdoprzizZhJUNJYnjLhFZcisV6zv0RCGuS/Nr9hDl1a
   weBt2B6p/xk2JcQPrc4oH85UTt7zOuPefO+fsx38G2n7K4cmCNolIfj5W
   tGYJUu4h1CGFmdRVxfSUGk4rvy4lo8DyIE8MUk1cWpQRCqVoBUDyBoewD
   QvAhEyQLTc4pah9gixynrj9uQG47JH29sStULb4kz/c5AnQVymPe2GHS1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276510333"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276510333"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2022 23:26:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="532005010"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 05 Jun 2022 23:26:56 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 953F658068A;
        Sun,  5 Jun 2022 23:26:53 -0700 (PDT)
Date:   Mon, 6 Jun 2022 14:26:50 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] stmmac: intel: Fix an error handling path in
 intel_eth_pci_probe()
Message-ID: <20220606062650.GA31937@linux.intel.com>
References: <1ac9b6787b0db83b0095711882c55c77c8ea8da0.1654462241.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ac9b6787b0db83b0095711882c55c77c8ea8da0.1654462241.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 05, 2022 at 10:50:48PM +0200, Christophe JAILLET wrote:
> When the managed API is used, there is no need to explicitly call
> pci_free_irq_vectors().
> 
> This looks to be a left-over from the commit in the Fixes tag. Only the
> .remove() function had been updated.
> 
> So remove this unused function call and update goto label accordingly.
> 
> Fixes: 8accc467758e ("stmmac: intel: use managed PCI function on probe and resume")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 

LGTM

Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

