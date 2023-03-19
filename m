Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D966C0693
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCSXUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCSXT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:19:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B95166D7;
        Sun, 19 Mar 2023 16:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679267998; x=1710803998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k5YhXb+NAZBCV+CnDfy6zOuEF+iC3mHrv3Nr1Nz9D/Y=;
  b=PynE33HcwzTAqxFRNuEk8vS5+6EXkBqk176ab00E+GKODH9Ihh2jV9dh
   rlPF4YeEdBfUpm7tiGkn+wXPiA6L0mrB6pvEyOwYHeKCjSwe/eSR43ns9
   hE1D/GRcRHC4/j4/N4eFfbKxL3MyUA8iBDcC9ni7QaUKPUQ9QaC0TpbdC
   HzlShkY8Fgm83xdf2LISMq7jz6CeYojinBl1Z5yESSN/nQRTbj4DF19Q2
   Mq7zbMI5G4xs+NmRgYpymHHUY6rxXDWv8boLiCnze492VLZ3dgdWWdU2t
   KoHHDok1+hCgjgfj75XSD9wXSUCe1rnWPGG1tTl/HRVUOhpn90PEVN79B
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="340906305"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="340906305"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:19:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="658158494"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="658158494"
Received: from msbunten-mobl1.amr.corp.intel.com (HELO intel.com) ([10.251.221.102])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:19:53 -0700
Date:   Mon, 20 Mar 2023 00:19:29 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [Intel-gfx] [PATCH v4 04/10] lib/ref_tracker: remove warnings in
 case of allocation failure
Message-ID: <ZBeYgaAPBZa8jmnZ@ashyti-mobl2.lan>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-4-464e8ab4c9ab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v4-4-464e8ab4c9ab@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On Mon, Mar 06, 2023 at 05:32:00PM +0100, Andrzej Hajda wrote:
> Library can handle allocation failures. To avoid allocation warnings
> __GFP_NOWARN has been added everywhere. Moreover GFP_ATOMIC has been
> replaced with GFP_NOWAIT in case of stack allocation on tracker free
> call.
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Andi
