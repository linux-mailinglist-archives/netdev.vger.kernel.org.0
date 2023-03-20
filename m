Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892BB6C1A02
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbjCTPmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbjCTPmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:42:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9594531BC0;
        Mon, 20 Mar 2023 08:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679326409; x=1710862409;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YLTTzXJrZjbA4Wxj46rjaO2JWSkZPqUuFi5sx1rWTvc=;
  b=kMQeEY56WRMzLMttUYjk5b31e1Jz6blzaKVWpKihxq19q3t8QGucGuvU
   zH13unBQ9YNaqf7nA+lZ5Y5pbbVakvmAwt5dM/M0saHEB44Ma5gDp2HAu
   C6+6uvMhJc/QWWciP8Zi65FzZ49AANyegXLLNrV3dDPOsvPrUZGbUURRK
   YKRZyyhDvsLZAsC8+a3DZUuaXbz21THZqrj0hidVqukrkcDvQi0ppSXbB
   KyJUKP4qg3xAgIJNeuxgXgndfA9m+UeJoI+INkr9EMLpE7wWIwiXpYryD
   /OuEZltLM7PTd2GHMUwt6wpkQz0lKq6VW6IthIJNc+CALA8lb2OM5gFFU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="322533716"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="322533716"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="791648659"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="791648659"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.6.65]) ([10.213.6.65])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:30:38 -0700
Message-ID: <1b9729c0-8831-87bd-8cc2-2cc23e929351@intel.com>
Date:   Mon, 20 Mar 2023 16:30:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH v4 01/10] lib/ref_tracker: add unlocked leak
 print helper
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>
Cc:     Chris Wilson <chris.p.wilson@intel.com>, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Dumazet <edumazet@google.com>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20230224-track_gt-v4-0-464e8ab4c9ab@intel.com>
 <20230224-track_gt-v4-1-464e8ab4c9ab@intel.com>
 <ZBeT5cWWqY4hkqu6@ashyti-mobl2.lan>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <ZBeT5cWWqY4hkqu6@ashyti-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.03.2023 23:59, Andi Shyti wrote:
> Hi Andrzej,
> 
> [...]
> 
>> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
>> index dc7b14aa3431e2..5e9f90bbf771b0 100644
>> --- a/lib/ref_tracker.c
>> +++ b/lib/ref_tracker.c
>> @@ -14,6 +14,38 @@ struct ref_tracker {
>>   	depot_stack_handle_t	free_stack_handle;
>>   };
>>   
>> +void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>> +			   unsigned int display_limit)
> 
> can we call this ref_tracker_dir_print_locked() instead of using
> the '__'?
> 

OK, 'locked' convention looks better.

Regards
Andrzej

>> +{
>> +	struct ref_tracker *tracker;
>> +	unsigned int i = 0;
>> +
>> +	lockdep_assert_held(&dir->lock);
>> +
>> +	list_for_each_entry(tracker, &dir->list, head) {
>> +		if (i < display_limit) {
>> +			pr_err("leaked reference.\n");
>> +			if (tracker->alloc_stack_handle)
>> +				stack_depot_print(tracker->alloc_stack_handle);
>> +			i++;
>> +		} else {
>> +			break;
>> +		}
>> +	}
>> +}
>> +EXPORT_SYMBOL(__ref_tracker_dir_print);
>> +
>> +void ref_tracker_dir_print(struct ref_tracker_dir *dir,
>> +			   unsigned int display_limit)
>> +{
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&dir->lock, flags);
>> +	__ref_tracker_dir_print(dir, display_limit);
>> +	spin_unlock_irqrestore(&dir->lock, flags);
>> +}
>> +EXPORT_SYMBOL(ref_tracker_dir_print);
>> +
>>   void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>>   {
>>   	struct ref_tracker *tracker, *n;
>> @@ -27,13 +59,13 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
>>   		kfree(tracker);
>>   		dir->quarantine_avail++;
>>   	}
>> -	list_for_each_entry_safe(tracker, n, &dir->list, head) {
>> -		pr_err("leaked reference.\n");
>> -		if (tracker->alloc_stack_handle)
>> -			stack_depot_print(tracker->alloc_stack_handle);
>> +	if (!list_empty(&dir->list)) {
>> +		__ref_tracker_dir_print(dir, 16);
>>   		leak = true;
>> -		list_del(&tracker->head);
>> -		kfree(tracker);
>> +		list_for_each_entry_safe(tracker, n, &dir->list, head) {
>> +			list_del(&tracker->head);
>> +			kfree(tracker);
>> +		}
> 
> Just thinking whether this should go on a different patch, but I
> don't have a strong opinion.
> 
> Looks good!
> 
> Andi

