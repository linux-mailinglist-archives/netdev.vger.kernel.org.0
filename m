Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B4B63CFD5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 08:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiK3Hp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 02:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiK3Hpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 02:45:54 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE4B61756;
        Tue, 29 Nov 2022 23:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669794353; x=1701330353;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HaVmUGK72metvKvFhKmIqLQywyLRFYn/B8IU58n+gnU=;
  b=AyaTmx4qV0ungnI+aYOyKdFFRtQMMoKTgkCvDZO4YT6WAqwUrrnOL9kv
   59wCkmwyY4J2H2QJA3H4JE0pJ76qjzrLZe+Q8y7z1NVD+EF8kI5tBfPPx
   bph9Rj+Hqo7FEOVeOREwWWfHhoXz45DiUEkjaEzJWuo3SQGaQZCWdY8S/
   OjJAECcueGplzjC0pAIyVcYejRGRMUOTqeQ1+66FT+2KaOpUALe033svp
   4NkE0Jy8oWce7oY9XxYUMlCVf3NSiqreFKDr/uQwmpu8UWbLNZYt38OoF
   0f+Z5QJNSkpa1MSBs3Nir5S1loxggl183elD0mYgwCC0cFiyrpVD6pR+j
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="317180663"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="317180663"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 23:45:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="732885048"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="732885048"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Nov 2022 23:45:50 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id E44AD10E; Wed, 30 Nov 2022 09:46:16 +0200 (EET)
Date:   Wed, 30 Nov 2022 09:46:16 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [resend, PATCH net-next v1 2/2] net: thunderbolt: Use separate
 header data type for the Rx
Message-ID: <Y4cKSJI/TSQVMMJr@black.fi.intel.com>
References: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
 <20221129161359.75792-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221129161359.75792-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 06:13:59PM +0200, Andy Shevchenko wrote:
> The same data type structure is used for bitwise operations and
> regular ones. It makes sparse unhappy, for example:
> 
>   .../thunderbolt.c:718:23: warning: cast to restricted __le32
> 
>   .../thunderbolt.c:953:23: warning: incorrect type in initializer (different base types)
>   .../thunderbolt.c:953:23:    expected restricted __wsum [usertype] wsum
>   .../thunderbolt.c:953:23:    got restricted __be32 [usertype]
> 
> Split the header to bitwise one and specific for Rx to make sparse
> happy. Assure the layout by involving static_assert() against size
> and offsets of the member of the structures.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/thunderbolt.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)

I would much rather keep the humans reading this happy than add 20+
lines just to silence a tool. Unless this of course is some kind of a
real bug.
