Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F7F4ECFEF
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 01:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351779AbiC3XSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 19:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiC3XSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 19:18:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0E63F889;
        Wed, 30 Mar 2022 16:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648682179; x=1680218179;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=y4DLfy2pzwgVQOJCh+BUqzSf3DbodzSEIqyQmkhlB44=;
  b=R4kBARKm9l0uWr/974JLNzhkkHZQlPdvtk2f92Kb3hf0KbkDrvWhrmYg
   jlyT0BOM5SR/6etT/tAbxJIPEuvcCgX4bj/1ydD3gi4UsDMuWXbz3MS05
   js5K7RqDIU+MfAYGU8GkhKzls7d2qTo/WyKB1xVjiW3K+5BFjTaSQLpXm
   WKrAkHOPuLHChtFf9FfouFD9xNzXvUXNt6ykP+Rlw/Oefysp4JWbMGWWG
   XGbafkoEL2GfR2cvIgHLRsvBpmkbSAGsAk5VFda7NYla4SigaYCT/Bvbp
   VrI8zv0a0NOosDB7nJTWtZQWF28e3iaVxsuByDE6oStMycXPg2Bk1X697
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="241819753"
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="241819753"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 16:16:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="522094772"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.50])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 16:16:05 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: Re: [PATCH] taprio: replace usage of found with dedicated list
 iterator variable
In-Reply-To: <20220324072607.63594-1-jakobkoschel@gmail.com>
References: <20220324072607.63594-1-jakobkoschel@gmail.com>
Date:   Wed, 30 Mar 2022 16:15:53 -0700
Message-ID: <87fsmz3uc6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Jakob Koschel <jakobkoschel@gmail.com> writes:

> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
>
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
>
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
>
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> ---

Code wise, patch look good.

Just some commit style/meta comments:
 - I think that it would make more sense that these were two separate
 patches, but I haven't been following the fallout of the discussion
 above to know what other folks are doing;
 - Please use '[PATCH net-next]' in the subject prefix of your patch(es)
 when you next propose this (net-next is closed for new submissions for
 now, it should open again in a few days);
  

Cheers,
-- 
Vinicius
