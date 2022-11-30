Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E96863D409
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiK3LKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbiK3LKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:10:31 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E12474CC6;
        Wed, 30 Nov 2022 03:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669806630; x=1701342630;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SHCCZ8tHX7swHS+8I5E5Yfv024KDVI1AhlbR7nZOZSI=;
  b=LBAYZ7W3HYv5kaT6uLUBSxdX5aptsu5H97aHAk05xV5MGDSXl2e/pcwa
   IsHCZCCMEeGGcjYRmw78c8mwuNMbfHicucG80gq5mEGzoDqnC8JG/uUmG
   KUIhGWeconyQ1Veodu3ms+EHb76PXtUwruUFuwSt9E8NxPlwMhMn/oe2V
   Oedy8nKcfDXPmvVR5WIMUDFXb2UQNBAJsonHre9RyavybdJgkEeBDhnTV
   H+eC4aSvaY1A/cnEAxOfR/jPSE5r1iE+DggD8gaq9piS9vch7sNn9R3PV
   2WegSojcau9gEGKbf7V/LFTn5DCcJCpkEnXC1ZEkBJ8tkrJV7UGQN5Zkh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="342289945"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="342289945"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 03:09:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="786425773"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="786425773"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 30 Nov 2022 03:09:32 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 8F510184; Wed, 30 Nov 2022 13:09:59 +0200 (EET)
Date:   Wed, 30 Nov 2022 13:09:59 +0200
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
Message-ID: <Y4c6B/mj+g2BCwy9@black.fi.intel.com>
References: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
 <20221129161359.75792-2-andriy.shevchenko@linux.intel.com>
 <Y4cKSJI/TSQVMMJr@black.fi.intel.com>
 <Y4c1mtUlJfcxUQSi@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y4c1mtUlJfcxUQSi@smile.fi.intel.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 12:51:06PM +0200, Andy Shevchenko wrote:
> On Wed, Nov 30, 2022 at 09:46:16AM +0200, Mika Westerberg wrote:
> > On Tue, Nov 29, 2022 at 06:13:59PM +0200, Andy Shevchenko wrote:
> > > The same data type structure is used for bitwise operations and
> > > regular ones. It makes sparse unhappy, for example:
> > > 
> > >   .../thunderbolt.c:718:23: warning: cast to restricted __le32
> > > 
> > >   .../thunderbolt.c:953:23: warning: incorrect type in initializer (different base types)
> > >   .../thunderbolt.c:953:23:    expected restricted __wsum [usertype] wsum
> > >   .../thunderbolt.c:953:23:    got restricted __be32 [usertype]
> > > 
> > > Split the header to bitwise one and specific for Rx to make sparse
> > > happy. Assure the layout by involving static_assert() against size
> > > and offsets of the member of the structures.
> 
> > I would much rather keep the humans reading this happy than add 20+
> > lines just to silence a tool. Unless this of course is some kind of a
> > real bug.
> 
> Actually, changing types to bitwise ones reduces the sparse noise
> (I will double check this) without reducing readability.
> Would it be accepted?

Sure if it makes it more readable and does not add too many lines :)
