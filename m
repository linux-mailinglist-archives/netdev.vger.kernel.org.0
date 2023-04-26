Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9344E6EF7D1
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241285AbjDZPkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjDZPkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:40:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC042707
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682523555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=encT4KiljFu6gPHCKpAZo4HPZzDl0Jy7f37L3loH6ms=;
        b=H6CNmjRJ/JbFsOsQTUI1alwKU1GSfL37tPlth9FlZkNEhJ19bQFvOWmkfNOWVT3F3jN5OG
        QnJsXlPWt9e0SIOfgzUYbLCG4H93fCC1XT9b8P+KB1BNXDv7oH6+tRp040a/5nmssYRmpV
        wIhFZBeYiP9eW31rWxyKxK0B+WGbxIo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-2wRaxESOPzaCRyIb_a6mFQ-1; Wed, 26 Apr 2023 11:39:12 -0400
X-MC-Unique: 2wRaxESOPzaCRyIb_a6mFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C88011C0514C;
        Wed, 26 Apr 2023 15:39:11 +0000 (UTC)
Received: from [10.45.224.217] (unknown [10.45.224.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15C2F40C2064;
        Wed, 26 Apr 2023 15:39:09 +0000 (UTC)
Message-ID: <1bf81145-0996-e473-4053-09f410195984@redhat.com>
Date:   Wed, 26 Apr 2023 17:39:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>,
        Pedro Tammela <pctammela@mojatatu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, paulb@nvidia.com,
        simon.horman@corigine.com
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com>
From:   Ivan Vecera <ivecera@redhat.com>
In-Reply-To: <87bkjasmtw.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26. 04. 23 16:46, Vlad Buslov wrote:
> On Wed 26 Apr 2023 at 11:22, Pedro Tammela <pctammela@mojatatu.com> wrote:
>> On 26/04/2023 09:14, Vlad Buslov wrote:
>>> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
>>> new filter to idr is postponed until later in code since handle is already
>>> provided by the user. However, the error handling code in fl_change()
>>> always assumes that the new filter had been inserted into idr. If error
>>> handler is reached when replacing existing filter it may remove it from idr
>>> therefore making it unreachable for delete or dump afterwards. Fix the
>>> issue by verifying that 'fold' argument wasn't provided by caller before
>>> calling idr_remove().
>>> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization
>>> earlier")
>>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>>> ---
>>>    net/sched/cls_flower.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>>> index 1844545bef37..a1c4ee2e0be2 100644
>>> --- a/net/sched/cls_flower.c
>>> +++ b/net/sched/cls_flower.c
>>> @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>>>    errout_mask:
>>>    	fl_mask_put(head, fnew->mask);
>>>    errout_idr:
>>> -	idr_remove(&head->handle_idr, fnew->handle);
>>> +	if (!fold)
>>> +		idr_remove(&head->handle_idr, fnew->handle);
>>>    	__fl_put(fnew);
>>>    errout_tb:
>>>    	kfree(tb);
>>
>> Actually this seems to be fixing the same issue:
>> https://lore.kernel.org/all/20230425140604.169881-1-ivecera@redhat.com/
> 
> Indeed it does, I've missed that patch. However, it seems there
> is an issue with Ivan's approach. Consider what would happen when
> fold!=NULL && in_ht==false and rhashtable_insert_fast() fails here:
> 
> 
>          if (fold) {
>                  /* Fold filter was deleted concurrently. Retry lookup. */
>                  if (fold->deleted) {
>                          err = -EAGAIN;
>                          goto errout_hw;
>                  }
> 
>                  fnew->handle = handle; // <-- fnew->handle is assigned
> 
>                  if (!in_ht) {
>                          struct rhashtable_params params =
>                                  fnew->mask->filter_ht_params;
> 
>                          err = rhashtable_insert_fast(&fnew->mask->ht,
>                                                       &fnew->ht_node,
>                                                       params);
>                          if (err)
>                                  goto errout_hw; /* <-- err is set, go to
>                                                       error handler here */
>                          in_ht = true;
>                  }
> 
>                  refcount_inc(&fnew->refcnt);
>                  rhashtable_remove_fast(&fold->mask->ht,
>                                         &fold->ht_node,
>                                         fold->mask->filter_ht_params);
>                  /* !!! we never get to insert fnew into idr here, if ht insertion fails */
>                  idr_replace(&head->handle_idr, fnew, fnew->handle);
>                  list_replace_rcu(&fold->list, &fnew->list);
>                  fold->deleted = true;
> 
>                  spin_unlock(&tp->lock);
> 
>                  fl_mask_put(head, fold->mask);
>                  if (!tc_skip_hw(fold->flags))
>                          fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
>                  tcf_unbind_filter(tp, &fold->res);
>                  /* Caller holds reference to fold, so refcnt is always > 0
>                   * after this.
>                   */
>                  refcount_dec(&fold->refcnt);
>                  __fl_put(fold);
>          }
> 
> ...
> 
>   errout_ht:
>           spin_lock(&tp->lock);
>   errout_hw:
>           fnew->deleted = true;
>           spin_unlock(&tp->lock);
>           if (!tc_skip_hw(fnew->flags))
>                   fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
>           if (in_ht)
>                   rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
>                                          fnew->mask->filter_ht_params);
>   errout_mask:
>           fl_mask_put(head, fnew->mask);
>   errout_idr:
>           /* !!! On next line we remove handle that we don't actually own */
>           idr_remove(&head->handle_idr, fnew->handle);
>           __fl_put(fnew);
>   errout_tb:
>           kfree(tb);
>   errout_mask_alloc:
>           tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
>   errout_fold:
>           if (fold)
>                   __fl_put(fold);
>           return err;
> 
> 
> Also, if I understood the idea behind Ivan's fix correctly, it relies on
> the fact that calling idr_remove() with handle==0 is a noop. I prefer my
> approach slightly better as it is more explicit IMO.
> 
> Thoughts?

Yes, your approach is better...

Acked-by: Ivan Vecera <ivecera@redhat.com>

