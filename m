Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B16050AD35
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 03:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443050AbiDVBaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 21:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbiDVBaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 21:30:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AC949935
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 18:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650590835; x=1682126835;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=vuhPyiUpbs5Vn4HHzw2so1+k4kwq/gf/4SWcZQ1A9kE=;
  b=GSWRDKea/Vhymp2zQfREITBGQLwF+FxRCelhFkK2zLTL2wfjkFPAjuVO
   vEyBSpW0Fotqb5lQDgD7FUB0hpC9VUcHKof5HY7G2yHbz4SOWDOLveG1k
   6iAcYBVS7+LzVMHz4gMST7cNKODP9khAid9uLkSS5eBzoTav4qzLglh8G
   t3exl1f+fWSa0aQgFOoagrRQQVLB2FRMSqIlDkWoc9hITiksm/oRok7RH
   9gbXxZtEKkL1M7rrrt52cuVtCFtonziHNrfoOqygxusFrxGpWcgsoBuGY
   X2viB+UXmE6G+JBZFSjUvNzOXh30VaIGU1myJ0b7otAjl29YzlKh2riBT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="251857897"
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="251857897"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 18:27:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="533823756"
Received: from vcostago-mobl3.jf.intel.com (HELO vcostago-mobl3) ([10.24.14.84])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 18:27:15 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v5 net-next 4/4] rtnetlink: return EINVAL when request
 cannot succeed
In-Reply-To: <20220415122601.0b793cb9@hermes.local>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
 <20220415165330.10497-5-florent.fourcot@wifirst.fr>
 <20220415122601.0b793cb9@hermes.local>
Date:   Thu, 21 Apr 2022 18:27:15 -0700
Message-ID: <87pml9vrf0.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:

> On Fri, 15 Apr 2022 18:53:30 +0200
> Florent Fourcot <florent.fourcot@wifirst.fr> wrote:
>
>> A request without interface name/interface index/interface group cannot
>> work. We should return EINVAL
>> 
>> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
>> Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
>> ---
>>  net/core/rtnetlink.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> index 73f2cbc440c9..b943336908a7 100644
>> --- a/net/core/rtnetlink.c
>> +++ b/net/core/rtnetlink.c
>> @@ -3457,7 +3457,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>>  			return rtnl_group_changelink(skb, net,
>>  						nla_get_u32(tb[IFLA_GROUP]),
>>  						ifm, extack, tb);
>> -		return -ENODEV;
>> +		return -EINVAL;
>
> Sometimes changing errno can be viewed as ABI change and break applications.

It seems that this is already breaking applications. iproute2 ip-link
depends on the returned error:

https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/ip/iplink.c#n221


Cheers,
-- 
Vinicius
