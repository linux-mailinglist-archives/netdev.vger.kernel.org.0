Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132506CD9BB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjC2M5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjC2M5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:57:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAE23ABE;
        Wed, 29 Mar 2023 05:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680094632; x=1711630632;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vwS3X5AtMxUgPOZzP+yLqFDJtD0ZzmPzIp0mK7L6JFc=;
  b=Iu5YeBtYmX+X58pRVilTnWcVMwKU9k2tedGnbpAQ0p6yfUNT5fqUMX1x
   DWW2Vr54nqOX4olSqXhp7Sb9+DRiTRXmJnBmC1j/PschrHI9f0qSNZFlB
   ZPOmKeNN3MfAQnBPeS9YN8Ic0UATKF8ICMeX59ErArjGKfy/R1BH27MG7
   3WoMcyzw8/HSAm4UTn/HDyWEHtjAzayCMoh0o3beVZl1Yoo1JRAp3Jw0t
   dGvzdNE30SC6ps5Mt/wjvBaprSHo56wa6qC1Y7IFhqEaR1ljIxb8aLg4o
   h3BmlD5MHxBkCaeFkrn/I/KGLrzoK6tvszRqQhzcNHq2akiKs7D0BZeBW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="343286560"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="343286560"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:57:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="686813345"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="686813345"
Received: from ostermam-mobl.amr.corp.intel.com (HELO intel.com) ([10.249.32.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:57:06 -0700
Date:   Wed, 29 Mar 2023 14:56:42 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v6 3/8] lib/ref_tracker: add printing to memory buffer
Message-ID: <ZCQ1ihjfKHR4GRi2@ashyti-mobl2.lan>
References: <20230224-track_gt-v6-0-0dc8601fd02f@intel.com>
 <20230224-track_gt-v6-3-0dc8601fd02f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v6-3-0dc8601fd02f@intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On Wed, Mar 29, 2023 at 09:24:14AM +0200, Andrzej Hajda wrote:
> Similar to stack_(depot|trace)_snprint the patch
> adds helper to printing stats to memory buffer.
> It will be helpful in case of debugfs.
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Thanks,
Andi
