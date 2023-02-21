Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0053969DD01
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbjBUJh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjBUJhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:37:25 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01ED624130;
        Tue, 21 Feb 2023 01:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676972245; x=1708508245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0XV6h1ZraJRrPNJnz0Nn+lGjt/UMC9hNp09/LCtIWzM=;
  b=d1lrLmc75chJBLUJMRM7IfUwLDLG4u/HARyD8a2dzcFISQOafZTWTYkD
   P3TWPVchMi6BT/po0LAluLJsxecqwNr2eL+dxLmu3tsIzmgb1Ua4nPTFf
   9pPQU0DG9bljqw7e8jAuQuh3rU+BoBm/dFaI5YN6S39CgO41lz7vE+5l+
   5RxujOxKRENOFjBbHq2SfkG9EOkoRQQv7GSCwQQFVBMao/u+EV8Y/+iuP
   URSi7HLVpUzULXAun1O4lZlNokWVVpTuv1XkqKIi+v3Wi9StvvcGyVLxb
   h0I+K90XP8S290EPP/pjjqjwVwQnYKr7Zn7lWAnXklqnoxr/Tf4vkOFQG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="397275070"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="397275070"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 01:37:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="671584774"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="671584774"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 21 Feb 2023 01:37:19 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pUP5J-009u7E-0E;
        Tue, 21 Feb 2023 11:37:17 +0200
Date:   Tue, 21 Feb 2023 11:37:16 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        netdev@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/2] string: Make memscan() to take const
Message-ID: <Y/SQzLV5pwonA6Wc@smile.fi.intel.com>
References: <20230216114234.36343-1-andriy.shevchenko@linux.intel.com>
 <20230220162653.0836ebfc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220162653.0836ebfc@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 04:26:53PM -0800, Jakub Kicinski wrote:
> On Thu, 16 Feb 2023 13:42:33 +0200 Andy Shevchenko wrote:
> > Make memscan() to take const so it will be easier replace
> > some memchr() cases with it.
> 
> Let's do this after the merge window.

Sure, it needs to be revised anyway. I just noticed that one corner case might
not work properly.

-- 
With Best Regards,
Andy Shevchenko


