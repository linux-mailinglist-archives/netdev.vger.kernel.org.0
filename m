Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D72546DE2
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346609AbiFJT7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 15:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiFJT7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 15:59:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878198CB32
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 12:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654891177; x=1686427177;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=yUqjYbg9XEfuol0E9AvETNcK/5MwJ8Do8WYSgi731to=;
  b=DpgPHyxnTCaWUdaqitorF2zR8WSYeqYDE8W6yCq3Jz6XHK6blYycpuM0
   takfJyAPwF8FnR76DzHqR6eULw7eTbLKe/HDPeDxN3mG/pGY5M9Gy2qA7
   x6WPbiv44YqvbxZbWfAphO8FIrtmhwS16SlYhplI+PQC+nm40HQwrEiy6
   R9z6kw3lG1hCVYnPOSbDTJM2sO7zGePOWM286QdNhvH6chjvtRagl+EqQ
   X5Snd30GuauNjgVw96cmvnwCcicEF4/vnM1JUJfxwkrsSLbqvPHtN0xN2
   y2JQAJ06S3Fy5FEfiM9LI/725LcuO/VCYPJQWFzGG1DeVdrKLj3sqc6hN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="339482408"
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="339482408"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 12:59:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,291,1647327600"; 
   d="scan'208";a="909088282"
Received: from efbarbud-mobl1.amr.corp.intel.com (HELO csouzax-mobl2.amr.corp.intel.com) ([10.212.104.59])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 12:59:27 -0700
Date:   Fri, 10 Jun 2022 12:59:26 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org, Ossama Othman <ossama.othman@intel.com>,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 1/2] mptcp: fix conflict with <netinet/in.h>
In-Reply-To: <20220610111607.38b003e1@kernel.org>
Message-ID: <a74a82cf-130-9eef-d128-2c88e081ba31@linux.intel.com>
References: <20220608191919.327705-1-mathew.j.martineau@linux.intel.com> <20220608191919.327705-2-mathew.j.martineau@linux.intel.com> <20220609225936.4cba4860@kernel.org> <d4c74484-da9-8af3-e25b-93de29443840@linux.intel.com>
 <20220610111607.38b003e1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022, Jakub Kicinski wrote:

> On Fri, 10 Jun 2022 11:00:28 -0700 (PDT) Mat Martineau wrote:
>> This is a minor "fix" to be sure, which I thought did not meet the bar for
>> net and therefore submitted for net-next. It's not prep for another
>> change, it's something Ossama and I noticed when doing code review for a
>> userspace program that included the header. There's no problem with kernel
>> compilation, and there's also no issue if the userspace program happens to
>> include netinet/in.h before linux/mptcp.h
>>
>>
>> If my threshold for the net branch is too high, I have no objection to
>> having this patch applied there and will recalibrate :)
>>
>> Do you prefer to have no Fixes: tags in net-next, or did that just seem
>> ambiguous in this case?
>
> The important point is that the middle ground of marking things as fixes
> and at the same time putting them in -next, to still get them
> backported but with an extended settling time -- that middle ground
> does not exist.
>
> If we look at the patch from the "do we want it backported or not"
> perspective I think the answer is yes, hence I'd lean towards net.
> If you think it doesn't matter enough for backport - we can drop the
> fixes tag and go with net-next. Unfortunately I don't have enough
> direct experience to tell how annoying this will be to the user space.
> netinet/in.h vs linux/in.h is a mess :(
>

By that criteria, I lean towards net too. Thanks Jakub.

--
Mat Martineau
Intel
