Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1285A6D7C94
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbjDEM25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDEM24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:28:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445CF1BC5
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680697735; x=1712233735;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QVBWo7w42V5s3EEXcmoiUrqQhYHiAhIK3f/nXmfgxks=;
  b=SpqDLjJOWG3ZzMn+a8WTRfNu1ZaEaqMMS0k2bapK38aNFdECACiYBCvI
   bssscGtczOFDW2gmq9sTCPJLNXR/4DvAQK0Oa4+9ujzBi7iYvxRAas3hq
   6bEDR0hJ1XAO1W4v7ZejoSSuPAawioB1myXNQlBlF5QIAAyX6OTN3Z66X
   9Jh5dZfQppftR6JC7UP4egBwIuAvJZmZeVoMXv/r8gTVc8ut+bx/ZLvKs
   QqgOoEuHUD3cyd5EQr0w9epj4Qn2XyJwutqdBeghh97bhgb+0AvMpk6Wv
   09ax1//a+Iz//PRqWGXmKQzXOVtsoTyBahZk6r3hwMPVCbG0Jz0MDQ6KN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="345017941"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="345017941"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 05:28:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="755986440"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="755986440"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 05 Apr 2023 05:28:52 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id B0A8D1D5; Wed,  5 Apr 2023 15:28:54 +0300 (EEST)
Date:   Wed, 5 Apr 2023 15:28:54 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: thunderbolt: Fix sparse warnings
Message-ID: <20230405122854.GU33314@black.fi.intel.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
 <20230404053636.51597-2-mika.westerberg@linux.intel.com>
 <ZC01N8tU9SN70GDh@smile.fi.intel.com>
 <20230405095224.GT33314@black.fi.intel.com>
 <ZC1QgGW5HZqcYIug@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZC1QgGW5HZqcYIug@smile.fi.intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 01:42:08PM +0300, Andy Shevchenko wrote:
> > How they are different? The complain is pretty much the same for all
> > these AFAICT:
> > 
> > expected restricted xxx [usertype] yyy
> > got restricted zzz [usertype]
> 
> While the main part is about header data type and endianess conversion between
> protocol and CPU (with cpu_*() and *_cpu() macros) this one is completely network
> related stuff as it's using hton*() and ntoh*() conversion macros. Yes, underneeth
> it may be the same, but semantically these two parts are not of the same thing.

Okay, fair enough :) I'll make this split in v2.
