Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1BA42A7E1
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhJLPHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:07:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:45826 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbhJLPHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 11:07:54 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maJLf-000E6O-6P; Tue, 12 Oct 2021 17:05:47 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1maJLe-000EwE-VC; Tue, 12 Oct 2021 17:05:46 +0200
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, Ido Schimmel <idosch@idosch.org>
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net>
 <05807c5b-59aa-839d-fbb0-b9712857741e@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bf31a3fe-c12d-fd75-c2eb-9685cc8528f2@iogearbox.net>
Date:   Tue, 12 Oct 2021 17:05:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <05807c5b-59aa-839d-fbb0-b9712857741e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26320/Tue Oct 12 10:17:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 4:51 PM, David Ahern wrote:
> On 10/11/21 6:12 AM, Daniel Borkmann wrote:
>> @@ -66,12 +68,22 @@ enum {
>>   #define NUD_PERMANENT	0x80
>>   #define NUD_NONE	0x00
>>   
>> -/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
>> - * and make no address resolution or NUD.
>> - * NUD_PERMANENT also cannot be deleted by garbage collectors.
>> +/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change and make no
>> + * address resolution or NUD.
>> + *
>> + * NUD_PERMANENT also cannot be deleted by garbage collectors. This holds true
>> + * for dynamic entries with NTF_EXT_LEARNED flag as well. However, upon carrier
>> + * down event, NUD_PERMANENT entries are not flushed whereas NTF_EXT_LEARNED
>> + * flagged entries explicitly are (which is also consistent with the routing
>> + * subsystem).
>> + *
>>    * When NTF_EXT_LEARNED is set for a bridge fdb entry the different cache entry
>>    * states don't make sense and thus are ignored. Such entries don't age and
>>    * can roam.
>> + *
>> + * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
>> + * of a user space control plane, and automatically refreshed so that (if
>> + * possible) they remain in NUD_REACHABLE state.
> 
> switchdev use cases need this capability as well to offload routes.
> Similar functionality exists in mlxsw to resolve gateways. It would be
> good for this design to cover both needs - and that may be as simple as
> mlxsw setting the MANAGED flag on the entry to let the neigh subsystem
> takeover.

Ack, that would definitely be nice to reuse it there as well.

>>    */
>>   
>>   struct nda_cacheinfo {
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index 5245e888c981..eae73efa9245 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -122,6 +122,8 @@ static void neigh_mark_dead(struct neighbour *n)
>>   		list_del_init(&n->gc_list);
>>   		atomic_dec(&n->tbl->gc_entries);
>>   	}
>> +	if (!list_empty(&n->managed_list))
>> +		list_del_init(&n->managed_list);
>>   }
>>   
>>   static void neigh_update_gc_list(struct neighbour *n)
>> @@ -130,7 +132,6 @@ static void neigh_update_gc_list(struct neighbour *n)
>>   
>>   	write_lock_bh(&n->tbl->lock);
>>   	write_lock(&n->lock);
>> -
> 
> I like the extra newline - it makes locks stand out.

Ok, will drop, and add one to neigh_update_managed_list(), too.

>>   	if (n->dead)
>>   		goto out;
>>   
>> @@ -149,32 +150,59 @@ static void neigh_update_gc_list(struct neighbour *n)
>>   		list_add_tail(&n->gc_list, &n->tbl->gc_list);
>>   		atomic_inc(&n->tbl->gc_entries);
>>   	}
>> +out:
>> +	write_unlock(&n->lock);
>> +	write_unlock_bh(&n->tbl->lock);
>> +}
>> +
>> +static void neigh_update_managed_list(struct neighbour *n)
>> +{
>> +	bool on_managed_list, add_to_managed;
>> +
>> +	write_lock_bh(&n->tbl->lock);
>> +	write_lock(&n->lock);
>> +	if (n->dead)
>> +		goto out;
>> +
>> +	add_to_managed = n->flags & NTF_MANAGED;
>> +	on_managed_list = !list_empty(&n->managed_list);
>>   
>> +	if (!add_to_managed && on_managed_list)
>> +		list_del_init(&n->managed_list);
>> +	else if (add_to_managed && !on_managed_list)
>> +		list_add_tail(&n->managed_list, &n->tbl->managed_list);
>>   out:
>>   	write_unlock(&n->lock);
>>   	write_unlock_bh(&n->tbl->lock);
>>   }
>>   
>> -static bool neigh_update_ext_learned(struct neighbour *neigh, u32 flags,
>> -				     int *notify)
>> +static void neigh_update_flags(struct neighbour *neigh, u32 flags, int *notify,
>> +			       bool *gc_update, bool *managed_update)
>>   {
>> -	bool rc = false;
>> -	u32 ndm_flags;
>> +	u32 ndm_flags, old_flags = neigh->flags;
>>   
>>   	if (!(flags & NEIGH_UPDATE_F_ADMIN))
>> -		return rc;
>> +		return;
>> +
>> +	ndm_flags  = (flags & NEIGH_UPDATE_F_EXT_LEARNED) ? NTF_EXT_LEARNED : 0;
>> +	ndm_flags |= (flags & NEIGH_UPDATE_F_MANAGED) ? NTF_MANAGED : 0;
>>   
>> -	ndm_flags = (flags & NEIGH_UPDATE_F_EXT_LEARNED) ? NTF_EXT_LEARNED : 0;
>> -	if ((neigh->flags ^ ndm_flags) & NTF_EXT_LEARNED) {
>> +	if ((old_flags ^ ndm_flags) & NTF_EXT_LEARNED) {
>>   		if (ndm_flags & NTF_EXT_LEARNED)
>>   			neigh->flags |= NTF_EXT_LEARNED;
>>   		else
>>   			neigh->flags &= ~NTF_EXT_LEARNED;
>> -		rc = true;
>>   		*notify = 1;
>> +		*gc_update = true;
>> +	}
>> +	if ((old_flags ^ ndm_flags) & NTF_MANAGED) {
>> +		if (ndm_flags & NTF_MANAGED)
>> +			neigh->flags |= NTF_MANAGED;
>> +		else
>> +			neigh->flags &= ~NTF_MANAGED;
>> +		*notify = 1;
>> +		*managed_update = true;
>>   	}
>> -
>> -	return rc;
>>   }
>>   
>>   static bool neigh_del(struct neighbour *n, struct neighbour __rcu **np,
>> @@ -422,6 +450,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl,
>>   	refcount_set(&n->refcnt, 1);
>>   	n->dead		  = 1;
>>   	INIT_LIST_HEAD(&n->gc_list);
>> +	INIT_LIST_HEAD(&n->managed_list);
>>   
>>   	atomic_inc(&tbl->entries);
>>   out:
>> @@ -650,7 +679,8 @@ ___neigh_create(struct neigh_table *tbl, const void *pkey,
>>   	n->dead = 0;
>>   	if (!exempt_from_gc)
>>   		list_add_tail(&n->gc_list, &n->tbl->gc_list);
>> -
>> +	if (n->flags & NTF_MANAGED)
>> +		list_add_tail(&n->managed_list, &n->tbl->managed_list);
>>   	if (want_ref)
>>   		neigh_hold(n);
>>   	rcu_assign_pointer(n->next,
>> @@ -1205,8 +1235,6 @@ static void neigh_update_hhs(struct neighbour *neigh)
>>   	}
>>   }
>>   
>> -
>> -
>>   /* Generic update routine.
>>      -- lladdr is new lladdr or NULL, if it is not supplied.
>>      -- new    is new state.
>> @@ -1218,6 +1246,7 @@ static void neigh_update_hhs(struct neighbour *neigh)
>>   				if it is different.
>>   	NEIGH_UPDATE_F_ADMIN	means that the change is administrative.
>>   	NEIGH_UPDATE_F_USE	means that the entry is user triggered.
>> +	NEIGH_UPDATE_F_MANAGED	means that the entry will be auto-refreshed.
>>   	NEIGH_UPDATE_F_OVERRIDE_ISROUTER allows to override existing
>>   				NTF_ROUTER flag.
>>   	NEIGH_UPDATE_F_ISROUTER	indicates if the neighbour is known as
>> @@ -1225,17 +1254,15 @@ static void neigh_update_hhs(struct neighbour *neigh)
>>   
>>      Caller MUST hold reference count on the entry.
>>    */
>> -
>>   static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>>   			  u8 new, u32 flags, u32 nlmsg_pid,
>>   			  struct netlink_ext_ack *extack)
>>   {
>> -	bool ext_learn_change = false;
>> -	u8 old;
>> -	int err;
>> -	int notify = 0;
>> -	struct net_device *dev;
>> +	bool gc_update = false, managed_update = false;
>>   	int update_isrouter = 0;
>> +	struct net_device *dev;
>> +	int err, notify = 0;
>> +	u8 old;
>>   
>>   	trace_neigh_update(neigh, lladdr, new, flags, nlmsg_pid);
>>   
>> @@ -1254,8 +1281,8 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>>   	    (old & (NUD_NOARP | NUD_PERMANENT)))
>>   		goto out;
>>   
>> -	ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
>> -	if (flags & NEIGH_UPDATE_F_USE) {
>> +	neigh_update_flags(neigh, flags, &notify, &gc_update, &managed_update);
>> +	if (flags & (NEIGH_UPDATE_F_USE | NEIGH_UPDATE_F_MANAGED)) {
>>   		new = old & ~NUD_PERMANENT;
> 
> so a neighbor entry can not be both managed and permanent, but you don't
> check for the combination in neigh_add and error out with a message to
> the user.

Good point, I'll error out if both NUD_PERMANENT and NTF_MANAGED is set in neigh_add().

Thanks for the review!
Daniel
