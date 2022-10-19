Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76676043CE
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiJSLtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 07:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiJSLs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 07:48:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627CC169128;
        Wed, 19 Oct 2022 04:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666178873; x=1697714873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gq6k+2v0sgUYQcVJmhpXsMbxRry1yR7Pv/R1hXeZor8=;
  b=I+mhUoiIMYuVRx4JNxu2Qa6Y8W+rLA9k8JiI3FI6+5Lbj42CLFzYkqXE
   GkEhe5L6dE9rHGA23P/19VwSojheUfO0HJQFew/HuERc2pYFftJv3xK1Y
   bMjVb5ojQz//ppzwdPe4+p15SQHAfMZW0cn0UebTV82GnSI0BKsRC2LMx
   VYoFeo0+Viy5oWB/58e0ybcLO0AoENBRAMHFvSzZ8aNhc6dwugQw6DEyL
   jiohEeP8KyewS6+1SlXdJJS6WuON5slNMS1fIxnespt2wz+dsz7YKOfIx
   KuaKok5QQm8emuZU2r2AmbmhYDQq6sSUAKI3ikUZOM5dduTWYiWC3CryL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="392679241"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="392679241"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 04:05:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="629204413"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="629204413"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 19 Oct 2022 04:04:59 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ol6sb-009p1H-1r;
        Wed, 19 Oct 2022 14:04:57 +0300
Date:   Wed, 19 Oct 2022 14:04:57 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Stanislaw Gruszka <stf_xl@wp.pl>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Message-ID: <Y0/Z2aHKYVPsiWa5@smile.fi.intel.com>
References: <202210190108.ESC3pc3D-lkp@intel.com>
 <20221018202734.140489-1-Jason@zx2c4.com>
 <20221019085219.GA81503@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019085219.GA81503@wp.pl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 10:52:19AM +0200, Stanislaw Gruszka wrote:
> On Tue, Oct 18, 2022 at 02:27:34PM -0600, Jason A. Donenfeld wrote:
> > On some platforms, `char` is unsigned, which makes casting -7 to char
> > overflow, which in turn makes the clamping operation bogus. Instead,
> > deal with an explicit `s8` type, so that the comparison is always
> > signed, and return an s8 result from the function as well. Note that
> > this function's result is assigned to a `short`, which is always signed.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> > Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> > Cc: Kalle Valo <kvalo@kernel.org>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> I prefer s8 just because is shorter name than short :-)

Shouldn't the corresponding data structure type be fixed accordingly?

-- 
With Best Regards,
Andy Shevchenko


