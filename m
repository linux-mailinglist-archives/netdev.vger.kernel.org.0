Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777526F13B5
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345741AbjD1I51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345627AbjD1I5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:57:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2413A9D;
        Fri, 28 Apr 2023 01:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682672193; x=1714208193;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9pexECH/mgIvrvJ2poPTW606fGUoKNk4Fi15axrvXsU=;
  b=h1gl3pAsZcQOlMuwWqD4eOtbcOYT89MVUYl2p6sk7XgCXECWrrskXyg5
   zjmSvrkgyVbHLlp6fHdinGzumgoznfMgmuJFVtCugp/30biulSMDKYS0Q
   xPrOxI5G0nFd4RNNDjEFjm7mn9PLzqpU114g/5PkzGkwaBebWpwKh1ZUZ
   Gn0cu5vQLrrQrWP18L0/ZiCV9/EAkIcqlIU1svc5y+L+o6R9s+udMinVK
   zrttPd0vpaLKTP2HjHm0LpXcqOhP5yjBkwAoS2XnX+KTt6/QRHA85HT0r
   w/lmtOUVh+4CxVYbnlP3IlGtI3Mlb7NTxv5oaiVQNK/cAWmjTI///L/93
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="375681423"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="375681423"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 01:55:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="784131306"
X-IronPort-AV: E=Sophos;i="5.99,234,1677571200"; 
   d="scan'208";a="784131306"
Received: from ahermans-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.35.91])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 01:55:54 -0700
Date:   Fri, 28 Apr 2023 10:55:52 +0200
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
Subject: Re: [PATCH v8 7/7] drm/i915: Track gt pm wakerefs
Message-ID: <ZEuKGN7S7L/FfYRV@ashyti-mobl2.lan>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
 <20230224-track_gt-v8-7-4b6517e61be6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v8-7-4b6517e61be6@intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On Tue, Apr 25, 2023 at 12:05:44AM +0200, Andrzej Hajda wrote:
> Track every intel_gt_pm_get() until its corresponding release in
> intel_gt_pm_put() by returning a cookie to the caller for acquire that
> must be passed by on released. When there is an imbalance, we can see who
> either tried to free a stale wakeref, or who forgot to free theirs.
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com> 

Andi
