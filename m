Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B056EE831
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbjDYT0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 15:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbjDYT0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 15:26:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C388318B8E;
        Tue, 25 Apr 2023 12:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682450748; x=1713986748;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HOAC/vLL0DpnjM4KLA7wvfcyNWTRHuEgYKkZK8Nx2kI=;
  b=dxBnGHnWX8uC15hE8bOHF4syJPMraB5VBb/9gyMcH/8HwPafOc1P9a/I
   CSrMF/5qeYqvAMuYGY8nY2mSEa1JAhEAREK5q7DdXh6AUt1GL0l7xOW0n
   qbFiWmmiWlln8bME+A3qQcbpk14vsgAl7Ah69mT4nU+vdr+9spUiewu7d
   8PiyXEJVfZm7UGyGokzqnTc06EbB3KtMhedML05+0iFAbws4Ut+O4DGdX
   0tp4NlwjPdvOCr7Gv1I44TuiLQYdp/Pe+wnwnrh7imhWMNeCgJYeQ/s1A
   IXdqe1KljZu67Bm5tjKPkLbkouoQdub+RN6Tvu/ASsfhGObbST1YtIO3G
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="331099928"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="331099928"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 12:25:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="726240109"
X-IronPort-AV: E=Sophos;i="5.99,226,1677571200"; 
   d="scan'208";a="726240109"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.59.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 12:25:26 -0700
Date:   Tue, 25 Apr 2023 21:25:24 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v8 6/7] drm/i915: Replace custom intel runtime_pm tracker
 with ref_tracker library
Message-ID: <ZEgpJN6GzSK/w4TV@ashyti-mobl2.lan>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
 <20230224-track_gt-v8-6-4b6517e61be6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v8-6-4b6517e61be6@intel.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On Tue, Apr 25, 2023 at 12:05:43AM +0200, Andrzej Hajda wrote:
> Beside reusing existing code, the main advantage of ref_tracker is
> tracking per instance of wakeref. It allows also to catch double
> put.
> On the other side we lose information about the first acquire and
> the last release, but the advantages outweigh it.
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Andi
