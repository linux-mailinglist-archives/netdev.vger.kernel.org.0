Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66778632772
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiKUPLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiKUPKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:10:55 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD0ABE26F;
        Mon, 21 Nov 2022 07:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669043004; x=1700579004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5RWd18AYM8qZ2G0T55nRrEcCmtlsgrCwUf2MXvWY9jE=;
  b=ZQx6P1eQuFgLB9qOM7mGFphjU6msXpi1+2oXPUG9t+tXXKe4g4Y1zgns
   gXL2qAdkjjiyOYKwo2xtuLsknuCJMII6opqecEMQY52Ig4DEwljRKq0gd
   pA4TOa4xhyv7v6AGPU0R6j9B63tY4emUD87JVjUbdtgv5gxQ+Ho0ItYJs
   7OJKjlDjemYl4fui4gC7y/ngk0aIfc7bIQ+o7Jzr11z99GhRBd7J0EGmt
   ogaUWxG0QftAwkv+kzaFCyu+lZ4Pra+JsmMjoc55v3I0nyVcM70LIgb5l
   Jf5z1fIjif0k46gfk9Xj9E+rJNbRXYjdTxm62/puaXIeQfECyd5Pztg/b
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313604131"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="313604131"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 07:03:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="704589627"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="704589627"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 21 Nov 2022 07:03:17 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ALF3F8P004714;
        Mon, 21 Nov 2022 15:03:16 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
Date:   Mon, 21 Nov 2022 16:03:14 +0100
Message-Id: <20221121150314.393682-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y3uGyrxeSbajJqpr@lunn.ch>
References: <20221121075618.15877-1-korotkov.maxim.s@gmail.com> <Y3uGyrxeSbajJqpr@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 21 Nov 2022 15:10:18 +0100

> On Mon, Nov 21, 2022 at 10:56:18AM +0300, Maxim Korotkov wrote:
> > The value of an arithmetic expression "n * id.data" is subject
> > to possible overflow due to a failure to cast operands to a larger data
> > type before performing arithmetic. Added cast of first operand to u64
> > for avoiding overflow.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: 2adc6edcaec0 ("ethtool: fix error handling in ethtool_phys_id")
> > Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> > ---
> >  net/ethtool/ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> > index 6a7308de192d..cf87e53c2e74 100644
> > --- a/net/ethtool/ioctl.c
> > +++ b/net/ethtool/ioctl.c
> > @@ -2007,7 +2007,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
> >  	} else {
> >  		/* Driver expects to be called at twice the frequency in rc */
> >  		int n = rc * 2, interval = HZ / n;
> > -		u64 count = n * id.data, i = 0;
> > +		u64 count = (u64)n * id.data, i = 0;
> 
> 
> How about moving the code around a bit, change n to a u64 and drop the
> cast? Does this look correct?
> 
> 		int interval = HZ / rc / 2;
> 		u64 n = rc * 2;
> 		u64 count = n * id.data;
> 
> 		i = 0;
> 
> I just don't like casts, they suggest the underlying types are wrong,
> so should fix that, not add a cast.

This particular one is absolutely fine. When you want to multiply
u32 by u32, you always need a cast, otherwise the result will be
truncated. mul_u32_u32() does it the very same way[0].

> 
> 	Andrew
> 

[0] https://elixir.bootlin.com/linux/v6.1-rc6/source/include/linux/math64.h#L153

Thanks,
Olek
