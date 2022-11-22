Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8250F633DDC
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiKVNjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiKVNjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:39:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF185A6C2;
        Tue, 22 Nov 2022 05:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669124354; x=1700660354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=baUu216IUMMxROK88p879RcNlQI5RcX61iVIIKzbJhQ=;
  b=OwU79Ol2ujy/AVOnwaBtc7FBMh0+gf3D3NQLJYPLBOV/gJXX+4HQh4d0
   dp6deNDrQejRwbDsN6iMKIoRcPyzSM3LdcBSOeHNcGIRvX2CnbOEgyu1o
   7ANX2L7OxI3MXiGu0QO+tKUBTMpJV+O0pBAeLhszx5LQW11v+V9b9uxuO
   ZGmauEX9bN5mHFd78l6EkBE7iJumg4eqk7uVPl/cEYGRaSOnh8GYOCjZl
   GEgnLyD2ZbgUQrs0XHSBGDOED6hBomNQl1EuB70pnMn6VkYemsRrpj2wT
   vmRj5rsMwkG6NcVwlL7tciCxr63DbLjbD2/V0e6+jRmcJ9oBqEeu959Sx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="340684535"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="340684535"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 05:39:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="643723081"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="643723081"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 22 Nov 2022 05:39:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMDd9CW026835;
        Tue, 22 Nov 2022 13:39:09 GMT
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
Subject: Re: [PATCH v3] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Tue, 22 Nov 2022 14:39:08 +0100
Message-Id: <20221122133908.422677-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
References: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
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
Date: Tue, 22 Nov 2022 15:29:01 +0300

> The value of an arithmetic expression "n * id.data" is subject
> to possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Used macro for multiplication instead
> operator for avoiding overflow.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> ---
>  net/ethtool/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 6a7308de192d..6b59e7a1c906 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2007,7 +2007,8 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
>  	} else {
>  		/* Driver expects to be called at twice the frequency in rc */
>  		int n = rc * 2, interval = HZ / n;
> -		u64 count = n * id.data, i = 0;
> +		u64 count = mul_u32_u32(n, id.data);
> +		u64 i = 0;
>  
>  		do {
>  			rtnl_lock();
> -- 
> 2.17.1

Some notes to the process, not the code:

1) I asked to add my Reviewed-by to v3 in the previous thread, it's
   mandatory for authors to pick-up all the tags before publishing
   a new revision;
2) when sending v2, v3, ... vN, please have a changelog in the
   commit message or right below those '---' after your SoB, that
   makes it easier to review.

Thanks,
Olek
