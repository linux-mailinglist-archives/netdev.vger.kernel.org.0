Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CD463D611
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiK3M6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiK3M6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:58:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6342019E;
        Wed, 30 Nov 2022 04:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669813088; x=1701349088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P+B9D+I/DdG1og2ijWgNYumi4veq1JZcmYFFnx4RACo=;
  b=GkDw/B3bzcxOu0ra01m0nz3nXgv9SA6OGCISwpBY3ClWr/8oDEdvdMnW
   XiZEQYX3w8dpHF+iXz+sOB9dRhT2qlf9Ni5cOVfj2/38u2aQho5u2bB75
   dYeaD3HdGwDig16kmOcTTM/kZ4DCFadIpBT3y9nWIsLDoXJrDgxY4+Uqn
   P+PE2r6CX8RSixuXmw4u2+gatixR/+/3bGve6IwHBl5NJclJTdtGUxgIA
   4gba1Bwnn0OjOW7lyEwO0nna3nq+43N6iw0U4dSkRSfIBFrCnwSscIwpK
   RYfx6lN6BDvmFzYV0h7j+6R/E/t1UnA9aQKCMbDWxfxtyMDoQdf2gNMd0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="298760712"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="298760712"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:58:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="750334495"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="750334495"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 30 Nov 2022 04:58:05 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 07B7610E; Wed, 30 Nov 2022 14:58:31 +0200 (EET)
Date:   Wed, 30 Nov 2022 14:58:31 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/2] net: thunderbolt: Use bitwise types in
 the struct thunderbolt_ip_frame_header
Message-ID: <Y4dTd1Ni2pIH1wbd@black.fi.intel.com>
References: <20221130123613.20829-1-andriy.shevchenko@linux.intel.com>
 <20221130123613.20829-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221130123613.20829-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 02:36:13PM +0200, Andy Shevchenko wrote:
> The main usage of the struct thunderbolt_ip_frame_header is to handle
> the packets on the media layer. The header is bound to the protocol
> in which the byte ordering is crucial. However the data type definition
> doesn't use that and sparse is unhappy, for example (17 altogether):
> 
>   .../thunderbolt.c:718:23: warning: cast to restricted __le32
> 
>   .../thunderbolt.c:966:42: warning: incorrect type in assignment (different base types)
>   .../thunderbolt.c:966:42:    expected unsigned int [usertype] frame_count
>   .../thunderbolt.c:966:42:    got restricted __le32 [usertype]
> 
> Switch to the bitwise types in the struct thunderbolt_ip_frame_header to
> reduce this, but not completely solving (9 left), because the same data
> type is used for Rx header handled locally (in CPU byte order).
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Looks good to me. I assume you tested this against non-Linux OS to
ensure nothing broke? ;-)

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
