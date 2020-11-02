Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B252A2668
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 09:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgKBIw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 03:52:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727806AbgKBIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 03:52:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604307146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M8L52r0cFEeeVAVbV60vymrevzQJGA//H7vC0s5Cf+E=;
        b=deuWvpiAJKj+U7iK1ALwzwY7ze2OWG76CL0L2YVPUnuQXj1jr3usvMVRAJmPgCpT0JPpJx
        DBsoBbSehwDWe1NURWkgWoGt5Ab3aIh/u9r5LVrk9tkGzGoZJtnZ++OJ/lx/XCUfx7tpwc
        BbNHm/cOm0I6LUgB7Dck4avAgTVN6nQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-wXgWDCU9N4qiYBHcfN7OCg-1; Mon, 02 Nov 2020 03:52:23 -0500
X-MC-Unique: wXgWDCU9N4qiYBHcfN7OCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48AED1074651;
        Mon,  2 Nov 2020 08:52:22 +0000 (UTC)
Received: from [10.36.112.137] (ovpn-112-137.ams2.redhat.com [10.36.112.137])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F0105DA60;
        Mon,  2 Nov 2020 08:52:21 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org
Subject: Re: [PATCH net] net: openvswitch: silence suspicious RCU usage
 warning
Date:   Mon, 02 Nov 2020 09:52:19 +0100
Message-ID: <AFFC5913-5595-464B-9B1B-EB25E730C2E2@redhat.com>
In-Reply-To: <20201030142852.7d41eecc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <160398318667.8898.856205445259063348.stgit@ebuild>
 <20201030142852.7d41eecc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Oct 2020, at 22:28, Jakub Kicinski wrote:

> On Thu, 29 Oct 2020 15:53:21 +0100 Eelco Chaudron wrote:
>> Silence suspicious RCU usage warning in 
>> ovs_flow_tbl_masks_cache_resize()
>> by replacing rcu_dereference() with rcu_dereference_ovsl().
>>
>> In addition, when creating a new datapath, make sure it's configured 
>> under
>> the ovs_lock.
>>
>> Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size 
>> configurable")
>> Reported-by: syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>  net/openvswitch/datapath.c   |    8 ++++----
>>  net/openvswitch/flow_table.c |    2 +-
>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
>> index 832f898edb6a..020f8539fede 100644
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -1695,6 +1695,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, 
>> struct genl_info *info)
>>  	if (err)
>>  		goto err_destroy_ports;
>>
>> +	/* So far only local changes have been made, now need the lock. */
>> +	ovs_lock();
>
> Should we move the lock below assignments to param?
>
> Looks a little strange to protect stack variables with a global lock.

You are right, I should have moved it down after the assignment. I will 
send out a v2.

>>  	/* Set up our datapath device. */
>>  	parms.name = nla_data(a[OVS_DP_ATTR_NAME]);
>>  	parms.type = OVS_VPORT_TYPE_INTERNAL;
>> @@ -1707,9 +1710,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, 
>> struct genl_info *info)
>>  	if (err)
>>  		goto err_destroy_meters;
>>
>> -	/* So far only local changes have been made, now need the lock. */
>> -	ovs_lock();
>> -
>>  	vport = new_vport(&parms);
>>  	if (IS_ERR(vport)) {
>>  		err = PTR_ERR(vport);
>> @@ -1725,7 +1725,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, 
>> struct genl_info *info)
>>  				ovs_dp_reset_user_features(skb, info);
>>  		}
>>
>> -		ovs_unlock();
>>  		goto err_destroy_meters;
>>  	}
>>
>> @@ -1742,6 +1741,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, 
>> struct genl_info *info)
>>  	return 0;
>>
>>  err_destroy_meters:
>
> Let's update the name of the label.

Guess now it is, unlock and destroy meters, so what label are you 
looking for?

err_unlock_and_destroy_meters: which looks a bit long, or just 
err_unlock:

>> +	ovs_unlock();
>>  	ovs_meters_exit(dp);
>>  err_destroy_ports:
>>  	kfree(dp->ports);
>> diff --git a/net/openvswitch/flow_table.c 
>> b/net/openvswitch/flow_table.c
>> index f3486a37361a..c89c8da99f1a 100644
>> --- a/net/openvswitch/flow_table.c
>> +++ b/net/openvswitch/flow_table.c
>> @@ -390,7 +390,7 @@ static struct mask_cache 
>> *tbl_mask_cache_alloc(u32 size)
>>  }
>>  int ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 
>> size)
>>  {
>> -	struct mask_cache *mc = rcu_dereference(table->mask_cache);
>> +	struct mask_cache *mc = rcu_dereference_ovsl(table->mask_cache);
>>  	struct mask_cache *new;
>>
>>  	if (size == mc->cache_size)
>>

