Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719DD25F0A4
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 23:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgIFV3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 17:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgIFV3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 17:29:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B2FC061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 14:29:14 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c18so13398988wrm.9
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 14:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cdl9efMcAoNEveqStkBCk/t96vJJ9p7Xq7BYNCaD9mE=;
        b=KtJZ9Ymns9vxEj2Dy9ujxWcaYxXrDqEtd7OkeyfWPSHuSPBdVxcMS107jf4ehG84ML
         1axRv96qjrP5WxJSdgfmzKFYIePdVy9/usQ80NCnCMLmqzftITyLobH0C8MoJr8Lhg5V
         uqwOJQr1O4hmz4mzpmAahYmEhG6o9v/qaHwCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cdl9efMcAoNEveqStkBCk/t96vJJ9p7Xq7BYNCaD9mE=;
        b=DOhs/LpXTlHcdV+nBMOXQMOyXaS0WX69XLt55V5H5NuR/RFwsrgVoyklFTreodGmcO
         s23q042k/Lxp4t1F/Mie11nULLVCtwvDWL9MfNPUenwolfQbfMv3/nMDzdfrHu/C/yHn
         d+lg8RO7qeaYhshKGO/yxLYyeSQ1PICDeggB2mbUzMRVazCuUvzid4AqjoYXO7PlEFpk
         UiPoPiw8syxZn7Ft42NZiSfFQaBshu7nPkg/fdkjHlkN0lzubMtnQ7PjACV49Dl6qGC7
         JO2euT/zqUoPbKMytBBlPm5v0/2QgLQKfZWpokEyiL8ZKi5filACYTLvj64lNbV6KUMo
         djsA==
X-Gm-Message-State: AOAM533vwqvYd3RmVDMDsBpck33DfXgnKFGnBDi9XwBv8zTZKimxfo1C
        wJCqXYj1X4mPOcY9W00cSINeTw==
X-Google-Smtp-Source: ABdhPJzIKEvz9JeQB9DkE/0Eo5vb+GtHuj8kZpFf2poYm58BccFYE4XAk5FwQa4HBrbvENHjl7nRZQ==
X-Received: by 2002:a5d:4bcf:: with SMTP id l15mr18197371wrt.384.1599427752957;
        Sun, 06 Sep 2020 14:29:12 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id y1sm23390187wma.36.2020.09.06.14.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2020 14:29:12 -0700 (PDT)
Subject: Re: [PATCH net-next v3 05/15] net: bridge: mcast: factor out port
 group del
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
 <20200905082410.2230253-6-nikolay@cumulusnetworks.com>
 <20200906135604.4d47b7a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <89eb1120-5776-081e-52ce-1ef92f41ecbe@cumulusnetworks.com>
Date:   Mon, 7 Sep 2020 00:29:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200906135604.4d47b7a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/20 11:56 PM, Jakub Kicinski wrote:
> On Sat,  5 Sep 2020 11:24:00 +0300 Nikolay Aleksandrov wrote:
>> @@ -843,24 +843,11 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
>>   		if (!p->port || p->port->dev->ifindex != entry->ifindex)
>>   			continue;
>>   
>> -		if (!hlist_empty(&p->src_list)) {
>> -			err = -EINVAL;
>> -			goto unlock;
>> -		}
>> -
>>   		if (p->port->state == BR_STATE_DISABLED)
>>   			goto unlock;
>>   
>> -		__mdb_entry_fill_flags(entry, p->flags);
> 
> Just from staring at the code it's unclear why the list_empty() check
> and this __mdb_entry_fill_flags() are removed as well.
> 

The hlist_empty check is added by patch 01 temporarily for correctness.
Otherwise I'd have to edit all open-coded pg del places and add src delete
code and then remove it here.

__mdb_entry_fill_flags() are called by __mdb_fill_info() which is the only
function used to fill an mdb both for dumping and notifications after patch 08.

>> -		rcu_assign_pointer(*pp, p->next);
>> -		hlist_del_init(&p->mglist);
>> -		del_timer(&p->timer);
>> -		kfree_rcu(p, rcu);
>> +		br_multicast_del_pg(mp, p, pp);
>>   		err = 0;
>> -
>> -		if (!mp->ports && !mp->host_joined &&
>> -		    netif_running(br->dev))
>> -			mod_timer(&mp->timer, jiffies);
>>   		break;
> 
> 
>> +void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
>> +			 struct net_bridge_port_group *pg,
>> +			 struct net_bridge_port_group __rcu **pp)
>> +{
>> +	struct net_bridge *br = pg->port->br;
>> +	struct net_bridge_group_src *ent;
>> +	struct hlist_node *tmp;
>> +
>> +	rcu_assign_pointer(*pp, pg->next);
>> +	hlist_del_init(&pg->mglist);
>> +	del_timer(&pg->timer);
>> +	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
>> +		br_multicast_del_group_src(ent);
>> +	br_mdb_notify(br->dev, pg->port, &pg->addr, RTM_DELMDB, pg->flags);
>> +	kfree_rcu(pg, rcu);
>> +
>> +	if (!mp->ports && !mp->host_joined && netif_running(br->dev))
>> +		mod_timer(&mp->timer, jiffies);
>> +}
> 
>> @@ -1641,16 +1647,7 @@ br_multicast_leave_group(struct net_bridge *br,
>>   			if (p->flags & MDB_PG_FLAGS_PERMANENT)
>>   				break;
>>   
>> -			rcu_assign_pointer(*pp, p->next);
>> -			hlist_del_init(&p->mglist);
>> -			del_timer(&p->timer);
>> -			kfree_rcu(p, rcu);
>> -			br_mdb_notify(br->dev, port, group, RTM_DELMDB,
>> -				      p->flags | MDB_PG_FLAGS_FAST_LEAVE);
> 
> And here we'll loose MDB_PG_FLAGS_FAST_LEAVE potentially?
> 

Good catch, we will lose the fast leave indeed.
This is a 1 line change to set the flag before notifying. Would you prefer
me to send a v4 or a follow up for it?

Thanks,
  Nik

>> -			if (!mp->ports && !mp->host_joined &&
>> -			    netif_running(br->dev))
>> -				mod_timer(&mp->timer, jiffies);
>> +			br_multicast_del_pg(mp, p, pp);

