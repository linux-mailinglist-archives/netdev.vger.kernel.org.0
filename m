Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2839D633C36
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiKVMOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiKVMOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:14:38 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E0B30553;
        Tue, 22 Nov 2022 04:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669119278; x=1700655278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2iUJ6MdJMZ9QlczJ7Cl1gn/iA/sB8KkCg0L+jD78/hw=;
  b=KqegwyE6aWcwQpu18jsaRNFCbmAOI9RFN0g5XoliZaadh5ZaFkcMrmUX
   oS+2nZUWyhgxyJsejj6Au/1+MR3HBWku3+JS5dWnEqBXTelzIjrrhql5N
   VqxqqqqFCRtc4K3QArhVc01yJc5m5CLNqMyHT/O3WNfdBXkifNxRcpPcc
   TD2y5PuWzGsucvgnfHqUf9rAuPUKRmKhpZpFNsgxm2LkcJeALYXy6uytk
   WtHQPFjI3d7xN6/ZHLAzqSlX51v0J7Wqusc/8qNBtHui+y+VacPLb3gO9
   K8gNBCg3JI5VgnTI6pYf70E9kN8cYPwte2ABrKnXHdwJ2bbzOz+jkazRa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="340669177"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="340669177"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 04:14:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="730373146"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="730373146"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Nov 2022 04:14:27 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMCEQxo009047;
        Tue, 22 Nov 2022 12:14:26 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Tue, 22 Nov 2022 13:14:00 +0100
Message-Id: <20221122121400.420417-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122065423.19458-1-korotkov.maxim.s@gmail.com>
References: <20221122065423.19458-1-korotkov.maxim.s@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Date: Tue, 22 Nov 2022 09:54:23 +0300

> The value of an arithmetic expression "n * id.data" is subject
> to possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Used macro for multiplication instead
> operator for avoiding overflow.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> ---
>  net/ethtool/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 6a7308de192d..f845e8be4d7c 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2007,7 +2007,8 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
>  	} else {
>  		/* Driver expects to be called at twice the frequency in rc */
>  		int n = rc * 2, interval = HZ / n;
> -		u64 count = n * id.data, i = 0;
> +		u64 count = mul_u32_u32(n,id.data);

                                         ^^

Meh, you forgot to put a space after the comma :s

Other than that (please add it to a v3):

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> +		u64 i = 0;
>  
>  		do {
>  			rtnl_lock();
> -- 
> 2.17.1

Thanks,
Olek
