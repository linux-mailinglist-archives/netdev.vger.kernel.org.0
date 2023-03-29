Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6816CD969
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjC2MgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjC2MgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:36:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00133ABE;
        Wed, 29 Mar 2023 05:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680093364; x=1711629364;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FpWoRE35I2ZTLQ2/dkg0MkmNNfID58WTvJw6X4novL8=;
  b=gHzJqG7G55GXBMaFbSwTI9J8KgNec/V1G25HbpVykUL+B9TAJ4ZhRL/g
   PrjpIFmhUqbmIwkJuzyWMNNBC39D6yjXoNWqvUaFofXTtpKMPM23gFP18
   cQK/B/avgKVgXwDMe/pWI+bgFB39J2lSQs8R7054bvXDALqHxDWEZSkCV
   qVvRS91ZOQBhHwEy/6tVzffQARH9lQkW9yzbrUEipAknnDEJnx/Ka0Qhh
   KeZhp7qnVoRJjEdldExSEnZGkjTGvLjP8cZ750FqiuNYhH/pC9PCQHun1
   YGKkL9PMmQms4TB16XLUJsgsM2icVYKmuUwcDHKmbyv0xXQZRLN+c3Gt6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="329330743"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="329330743"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:36:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="684249702"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="684249702"
Received: from ostermam-mobl.amr.corp.intel.com (HELO intel.com) ([10.249.32.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 05:35:57 -0700
Date:   Wed, 29 Mar 2023 14:35:32 +0200
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
Subject: Re: [PATCH v6 1/8] lib/ref_tracker: add unlocked leak print helper
Message-ID: <ZCQwlAkAUrtCimj4@ashyti-mobl2.lan>
References: <20230224-track_gt-v6-0-0dc8601fd02f@intel.com>
 <20230224-track_gt-v6-1-0dc8601fd02f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v6-1-0dc8601fd02f@intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On Wed, Mar 29, 2023 at 09:24:12AM +0200, Andrzej Hajda wrote:
> To have reliable detection of leaks, caller must be able to check under the same
> lock both: tracked counter and the leaks. dir.lock is natural candidate for such
> lock and unlocked print helper can be called with this lock taken.
> As a bonus we can reuse this helper in ref_tracker_dir_exit.
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Thanks,
Andi
