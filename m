Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BEA4EE001
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 19:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiCaSAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiCaSAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:00:43 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6238F56C18;
        Thu, 31 Mar 2022 10:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648749536; x=1680285536;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=WRCw9IYWVWD2FwPoSWrfbYA0F/d4ObWuXdSimK0KSN4=;
  b=hX9zxjqDb90NVIheVTRxBvR34q7xKeIxuCZEmNMSsymoGXIx0LnY0e7O
   syXOQitrSZl9qGGobKDpcCsNmk2K0mdR5WdiRaZj9fVpIdCUXE+dVtJOW
   IhhrXTouxCRpdzqE8GR4pmMHmOFSwjKdEby3WEFfhIm4rll9icsI0SCVv
   yDqxDdnv7OGJeqC0PxAfR/U0/R41tyLIOwU3VNvgAO5YbjR7cURPnlLe5
   O0v5Gmm2XGwbnhsSmFVRVb88uevQjHIhQKLxzHneQJOqO1Z0fpwEYZag7
   9MAYYSg5Grq3Hj0hsqQyDI0EEiC8vBnNrmpjVcbqyAiDyMR1aI6KDi5V6
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="239836337"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="239836337"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 10:58:56 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="520724489"
Received: from kyelchur-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.245.225])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 10:58:55 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH] taprio: replace usage of found with dedicated list
 iterator variable
In-Reply-To: <A19238DC-24F8-4BD9-A6FA-C8019596F4A6@gmail.com>
References: <20220324072607.63594-1-jakobkoschel@gmail.com>
 <87fsmz3uc6.fsf@intel.com>
 <A19238DC-24F8-4BD9-A6FA-C8019596F4A6@gmail.com>
Date:   Thu, 31 Mar 2022 10:58:55 -0700
Message-ID: <877d8a3sww.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakob Koschel <jakobkoschel@gmail.com> writes:

>> On 31. Mar 2022, at 01:15, Vinicius Costa Gomes <vinicius.gomes@intel.com> wrote:
>> 
>> Hi,
>> 
>> Jakob Koschel <jakobkoschel@gmail.com> writes:
>> 
>>> To move the list iterator variable into the list_for_each_entry_*()
>>> macro in the future it should be avoided to use the list iterator
>>> variable after the loop body.
>>> 
>>> To *never* use the list iterator variable after the loop it was
>>> concluded to use a separate iterator variable instead of a
>>> found boolean [1].
>>> 
>>> This removes the need to use a found variable and simply checking if
>>> the variable was set, can determine if the break/goto was hit.
>>> 
>>> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
>>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>>> ---
>> 
>> Code wise, patch look good.
>> 
>> Just some commit style/meta comments:
>> - I think that it would make more sense that these were two separate
>> patches, but I haven't been following the fallout of the discussion
>> above to know what other folks are doing;
>
> Thanks for the input, I'll split them up.
>
>> - Please use '[PATCH net-next]' in the subject prefix of your patch(es)
>> when you next propose this (net-next is closed for new submissions for
>> now, it should open again in a few days);
>
> I'll include that prefix, thanks.
>
> Paolo Abeni [CC'd] suggested to bundle all net-next patches in one series [1].
> If that's the general desire I'm happy to do that.

I agree with that, having one series for the whole net-next is going to
be easier for everyone.


Cheers,
-- 
Vinicius
