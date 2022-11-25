Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DC6638E09
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiKYQEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 11:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiKYQEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 11:04:00 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917334C246;
        Fri, 25 Nov 2022 08:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669392239; x=1700928239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ogMIFJsSPtXr34UU0OZ654UJ+S1J3B2EduR1CCJaTuc=;
  b=TA+UQAqYzgUcXoGVLcFjQ58VIvYLKrd+PpdpAOHGml7gbiuB6lH7u7cH
   Fu1DD+znE7pSHNEf7GWqFZePQ42dEjOQuEiB6lCEjxDQBQbizduPlCnUY
   //EjiNGiBs/58gvmH+81dKVGVvW5pVXIKpCjqd+K1nK1L0nVcJES2UnVe
   nAMBykF55znd4yrupiRmOnHCrgG2ccvNYI5bVQPnb03XMB5rWCIXAVNEq
   VFnBouAETBWWkbdpUg0bG5aG+h0R7ZQJt1LJi9JZEEEfTP8ZtHB2ToT/d
   qBXYE52Ibt3p2Jx7pdsVaXbir+rnDGMod4ETWdjlbw7Yaz+TKIEE5y7WR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="400794754"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="400794754"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 08:01:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="784975819"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="784975819"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 25 Nov 2022 08:01:53 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2APG1pIt005314;
        Fri, 25 Nov 2022 16:01:51 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Ahmad Tarmizi Noor Azura <noor.azura.ahmad.tarmizi@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>
Subject: Re: [PATCH net v4] net: stmmac: Set MAC's flow control register to reflect current settings
Date:   Fri, 25 Nov 2022 17:01:35 +0100
Message-Id: <20221125160135.83994-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123105110.23617-1-wei.sheng.goh@intel.com>
References: <20221123105110.23617-1-wei.sheng.goh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Date: Wed, 23 Nov 2022 18:51:10 +0800

> Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
> correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
> is issued. This fix ensures the flow control change is reflected directly
> in the GMAC_RX_FLOW_CTRL_RFE register.

Any particular reason why you completely ignored by review comments
to the v3[0]? I'd like to see them fixed or at least replied.

> 
> Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> ---
> V3 -> V4: Fix commit message and incorrect insertions(+) value
> V2 -> V3: Removed value assign for 'flow' in else statement based on review comments
> V1 -> V2: Removed needless condition based on review comments
> 
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  2 ++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)

[...]

> -- 
> 2.17.1

[0] https://lore.kernel.org/netdev/20221123180947.488302-1-alexandr.lobakin@intel.com

Thanks,
Olek
