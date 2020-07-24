Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0B022C05B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 10:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXIAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 04:00:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39957 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726567AbgGXIAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 04:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595577624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFZZaan1Vm9QcX4cyVbGySAtWi0W1+vfOAfEIirdSW4=;
        b=DUAsbXSh21MOmYUr/RPNWXqcAB71pz/c7VHS6PrwF3PYOpBtAZXwLKlyREEz18d8IqiTLE
        aAAjxyEpXqGnhNIDM2qgxO5eyLN2GkkJWcEp06oMXdRk9Cjn9jHvwqtxgIWbZxdTaeDARB
        +fjgFO0Oa93tKw6qe49RMe6OVOs3OpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-6nsAJlwfMT6iOvi5cIBLpg-1; Fri, 24 Jul 2020 04:00:22 -0400
X-MC-Unique: 6nsAJlwfMT6iOvi5cIBLpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C6DA107BEF6;
        Fri, 24 Jul 2020 08:00:20 +0000 (UTC)
Received: from [10.36.112.207] (ovpn-112-207.ams2.redhat.com [10.36.112.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 815B060C84;
        Fri, 24 Jul 2020 08:00:18 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pabeni@redhat.com, pshelar@ovn.org, fw@strlen.de
Subject: Re: [PATCH net-next v2 2/2] net: openvswitch: make masks cache size
 configurable
Date:   Fri, 24 Jul 2020 10:00:16 +0200
Message-ID: <5A55F49F-24E5-4149-A212-8F00589D6777@redhat.com>
In-Reply-To: <20200723094236.04d82921@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <159550903978.849915.17042128332582130595.stgit@ebuild>
 <159550911106.849915.7304995736710705589.stgit@ebuild>
 <20200723094236.04d82921@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Jul 2020, at 18:42, Jakub Kicinski wrote:

> On Thu, 23 Jul 2020 14:58:31 +0200 Eelco Chaudron wrote:
>> +	if ((size & (size - 1)) != 0 ||
>
> is_power_of_2() ?

Was not aware of this macro, will replace…
>
>> +	    (size * sizeof(struct mask_cache_entry)) > PCPU_MIN_UNIT_SIZE)
>> +		return NULL;
>
>> +	new->cache_size = size;
>> +	if (new->cache_size > 0) {
>> +		cache = __alloc_percpu(sizeof(struct mask_cache_entry) *
>> +				       new->cache_size,
>
> array_size() ?

Will change to:

		cache = __alloc_percpu(array_size(
					       sizeof(struct mask_cache_entry),
					       new->cache_size),
				       __alignof__(struct mask_cache_entry));
		if (!cache) {
>
>> +				       __alignof__(struct mask_cache_entry));
>> +
>
> No need for the new line here

Will remove

>> +		if (!cache) {
>> +			kfree(new);
>> +			return NULL;
>> +		}
>> +	}
>
>> +	if (size == mc->cache_size || (size & (size - 1)) != 0)
>
> why check "is power of 2" twice?

Will remove as it will always call tbl_mask_cache_alloc() which has the 
check above.

>
>> @@ -454,7 +516,7 @@ void ovs_flow_tbl_destroy(struct flow_table 
>> *table)
>>  	struct table_instance *ti = rcu_dereference_raw(table->ti);
>>  	struct table_instance *ufid_ti = 
>> rcu_dereference_raw(table->ufid_ti);
>>
>> -	free_percpu(table->mask_cache);
>> +	call_rcu(&table->mask_cache->rcu, mask_cache_rcu_cb);
>>  	call_rcu(&table->mask_array->rcu, mask_array_rcu_cb);
>>  	table_instance_destroy(table, ti, ufid_ti, false);
>>  }
>
> This adds a new warning :(
>
> net/openvswitch/flow_table.c:519:24: warning: incorrect type in 
> argument 1 (different address spaces)
> net/openvswitch/flow_table.c:519:24:    expected struct callback_head 
> *head
> net/openvswitch/flow_table.c:519:24:    got struct callback_head 
> [noderef] __rcu *

:( Yes my diff with older did not work… Sure I’ve fixed them all now 
:)


Will sent out a V3 after some testing…

