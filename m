Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AC66C06B4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCSX7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCSX7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:59:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440FE19AA;
        Sun, 19 Mar 2023 16:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679270348; x=1710806348;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JpsuJrdvik2SZDHzxaiPaOE5KFs/Im8ufn+wansR7vA=;
  b=jy4RQYim7rlOKxrEve315FAnDwagJsge9HS9dUr0kMojFkEapEANBJPQ
   hPonGz/2oj8gTfA4dP9Ui7WLjdZoDseh/FbmE73cTJ/Cp4KHXdNZ6v7cj
   TBr7/3dKnQKy07NuLNTfRVqSbrYzd3Xr6AqKERnNYIBJNvcEE6J1uPaMV
   5O81OKCrzc79uMjM+kNGQZxfLkgTTF5voe2o0dsCa4rp+QJjSOqNYlnw2
   ST45wJ70jMXptMSLGsfKvQbYtj+jD3zuWucuzk1wSg5TMhmBYJN5qYUvk
   0U6ZmkwJKJ0wO4CvnKTclYzGJCSD5mWBUSuT500D4mMJt2h1ot/9aCh5R
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="338570873"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="338570873"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:59:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="713367270"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="713367270"
Received: from msbunten-mobl1.amr.corp.intel.com (HELO intel.com) ([10.251.221.102])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 16:59:02 -0700
Date:   Mon, 20 Mar 2023 00:58:36 +0100
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
Subject: Re: [Intel-gfx] [PATCH v4 08/10] drm/i915: Correct type of wakeref
 variable
Message-ID: <ZBehrM6iDqZcKCOy@ashyti-mobl2.lan>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-8-464e8ab4c9ab@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v4-8-464e8ab4c9ab@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrzej,

On Mon, Mar 06, 2023 at 05:32:04PM +0100, Andrzej Hajda wrote:
> Wakeref has dedicated type. Assumption it will be int
> compatible forever is incorrect.
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>

easy...

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Andi
