Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3666F132E
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345407AbjD1IVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjD1IVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:21:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A737DB1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682670051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/X/cFEgH36A5U0YY2QeK4zjLtfP9IW8B7ylbzdQSmM=;
        b=ehDosuQTi4ZtzMrXL4Sb8+68X86H8KKn5wPGvFkFd9eyIGaKviI/O7SKy1v6Ed8pNmNQEK
        C4qy4APPy+XYatMdfio1fQMu6oFJtgofexII+mxy5lJIMQo3fBIyC50WI6ZNSHVsEfv8qe
        Tc1aCuCJy3/DWYSgJrKIr6xEublXdHM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-wPDZ8PfeOuGkhcbKaNnpSA-1; Fri, 28 Apr 2023 04:20:48 -0400
X-MC-Unique: wPDZ8PfeOuGkhcbKaNnpSA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65E863814966;
        Fri, 28 Apr 2023 08:20:47 +0000 (UTC)
Received: from [10.45.224.217] (unknown [10.45.224.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48EEA483EC4;
        Fri, 28 Apr 2023 08:20:45 +0000 (UTC)
Message-ID: <bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
Date:   Fri, 28 Apr 2023 10:20:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Pedro Tammela <pctammela@mojatatu.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, paulb@nvidia.com,
        Paolo Abeni <pabeni@redhat.com>
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com> <1bf81145-0996-e473-4053-09f410195984@redhat.com>
 <ZEtxvPaa/L3jHa2d@corigine.com>
From:   Ivan Vecera <ivecera@redhat.com>
In-Reply-To: <ZEtxvPaa/L3jHa2d@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28. 04. 23 9:11, Simon Horman wrote:
> On Wed, Apr 26, 2023 at 05:39:09PM +0200, Ivan Vecera wrote:
>>
>>
>> On 26. 04. 23 16:46, Vlad Buslov wrote:
>>> On Wed 26 Apr 2023 at 11:22, Pedro Tammela <pctammela@mojatatu.com> wrote:
>>>> On 26/04/2023 09:14, Vlad Buslov wrote:
>>>>> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
>>>>> new filter to idr is postponed until later in code since handle is already
>>>>> provided by the user. However, the error handling code in fl_change()
>>>>> always assumes that the new filter had been inserted into idr. If error
>>>>> handler is reached when replacing existing filter it may remove it from idr
>>>>> therefore making it unreachable for delete or dump afterwards. Fix the
>>>>> issue by verifying that 'fold' argument wasn't provided by caller before
>>>>> calling idr_remove().
>>>>> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization
>>>>> earlier")
>>>>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>>>>> ---
>>>>>     net/sched/cls_flower.c | 3 ++-
>>>>>     1 file changed, 2 insertions(+), 1 deletion(-)
>>>>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>>>>> index 1844545bef37..a1c4ee2e0be2 100644
>>>>> --- a/net/sched/cls_flower.c
>>>>> +++ b/net/sched/cls_flower.c
>>>>> @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>>>>>     errout_mask:
>>>>>     	fl_mask_put(head, fnew->mask);
>>>>>     errout_idr:
>>>>> -	idr_remove(&head->handle_idr, fnew->handle);
>>>>> +	if (!fold)
>>>>> +		idr_remove(&head->handle_idr, fnew->handle);
>>>>>     	__fl_put(fnew);
>>>>>     errout_tb:
>>>>>     	kfree(tb);
>>>>
>>>> Actually this seems to be fixing the same issue:
>>>> https://lore.kernel.org/all/20230425140604.169881-1-ivecera@redhat.com/
>>>
>>> Indeed it does, I've missed that patch. However, it seems there
>>> is an issue with Ivan's approach. Consider what would happen when
>>> fold!=NULL && in_ht==false and rhashtable_insert_fast() fails here:
>>>
>>>
>>>           if (fold) {
>>>                   /* Fold filter was deleted concurrently. Retry lookup. */
>>>                   if (fold->deleted) {
>>>                           err = -EAGAIN;
>>>                           goto errout_hw;
>>>                   }
>>>
>>>                   fnew->handle = handle; // <-- fnew->handle is assigned
>>>
>>>                   if (!in_ht) {
>>>                           struct rhashtable_params params =
>>>                                   fnew->mask->filter_ht_params;
>>>
>>>                           err = rhashtable_insert_fast(&fnew->mask->ht,
>>>                                                        &fnew->ht_node,
>>>                                                        params);
>>>                           if (err)
>>>                                   goto errout_hw; /* <-- err is set, go to
>>>                                                        error handler here */
>>>                           in_ht = true;
>>>                   }
>>>
>>>                   refcount_inc(&fnew->refcnt);
>>>                   rhashtable_remove_fast(&fold->mask->ht,
>>>                                          &fold->ht_node,
>>>                                          fold->mask->filter_ht_params);
>>>                   /* !!! we never get to insert fnew into idr here, if ht insertion fails */
>>>                   idr_replace(&head->handle_idr, fnew, fnew->handle);
>>>                   list_replace_rcu(&fold->list, &fnew->list);
>>>                   fold->deleted = true;
>>>
>>>                   spin_unlock(&tp->lock);
>>>
>>>                   fl_mask_put(head, fold->mask);
>>>                   if (!tc_skip_hw(fold->flags))
>>>                           fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
>>>                   tcf_unbind_filter(tp, &fold->res);
>>>                   /* Caller holds reference to fold, so refcnt is always > 0
>>>                    * after this.
>>>                    */
>>>                   refcount_dec(&fold->refcnt);
>>>                   __fl_put(fold);
>>>           }
>>>
>>> ...
>>>
>>>    errout_ht:
>>>            spin_lock(&tp->lock);
>>>    errout_hw:
>>>            fnew->deleted = true;
>>>            spin_unlock(&tp->lock);
>>>            if (!tc_skip_hw(fnew->flags))
>>>                    fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
>>>            if (in_ht)
>>>                    rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
>>>                                           fnew->mask->filter_ht_params);
>>>    errout_mask:
>>>            fl_mask_put(head, fnew->mask);
>>>    errout_idr:
>>>            /* !!! On next line we remove handle that we don't actually own */
>>>            idr_remove(&head->handle_idr, fnew->handle);
>>>            __fl_put(fnew);
>>>    errout_tb:
>>>            kfree(tb);
>>>    errout_mask_alloc:
>>>            tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
>>>    errout_fold:
>>>            if (fold)
>>>                    __fl_put(fold);
>>>            return err;
>>>
>>>
>>> Also, if I understood the idea behind Ivan's fix correctly, it relies on
>>> the fact that calling idr_remove() with handle==0 is a noop. I prefer my
>>> approach slightly better as it is more explicit IMO.
>>>
>>> Thoughts?
>>
>> Yes, your approach is better...
>>
>> Acked-by: Ivan Vecera <ivecera@redhat.com>
> 
> In the meantime it seems that Ivan's patch has been accepted into net.
> 
> - [net] net/sched: flower: Fix wrong handle assignment during filter change
>    https://git.kernel.org/netdev/net/c/32eff6bacec2
> 
> Is some adjustment to this patch required to take that into account?

I think something like this is necessary to cover Vlad's findings:

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 6ab6aadc07b8da..ce937baefcf00e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2279,8 +2279,6 @@ static int fl_change(struct net *net, struct 
sk_buff *in_skb,
                         goto errout_hw;
                 }

-               fnew->handle = handle;
-
                 if (!in_ht) {
                         struct rhashtable_params params =
                                 fnew->mask->filter_ht_params;
@@ -2297,6 +2295,7 @@ static int fl_change(struct net *net, struct 
sk_buff *in_skb,
                 rhashtable_remove_fast(&fold->mask->ht,
                                        &fold->ht_node,
                                        fold->mask->filter_ht_params);
+               fnew->handle = handle;
                 idr_replace(&head->handle_idr, fnew, fnew->handle);
                 list_replace_rcu(&fold->list, &fnew->list);
                 fold->deleted = true;

Just move fnew->handle assignment immediately prior idr_replace().

Thoughts?

Ivan

