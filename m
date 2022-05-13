Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C74526660
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346128AbiEMPmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382182AbiEMPmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:42:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65E0E2FFDD
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652456549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qt51KmMEp2p5kZHKW2/GzlR6XIOdTGRJtza/WZphhNw=;
        b=BCyCKR/BKaTTr/3Ki48uFAVrZ7bwJG1t66mH9L6PVf1twHubYyGPi/xMExh9RZICGoyQ/S
        D+Cr7TiOftJ5VAxarIExvCeQJNVICIuhxxOC1ahOecXPlFoFQwttoT/UuiqE1DypbKt8HW
        nf19vdqB9q1vYcQhcdWimMDEwUXg9hg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-Wr2oXhRjNnK2r4JR6qdsZg-1; Fri, 13 May 2022 11:42:28 -0400
X-MC-Unique: Wr2oXhRjNnK2r4JR6qdsZg-1
Received: by mail-qt1-f197.google.com with SMTP id w21-20020a05622a135500b002f3b801f51eso6570554qtk.23
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qt51KmMEp2p5kZHKW2/GzlR6XIOdTGRJtza/WZphhNw=;
        b=N3YXUsZ3i3a+/FEoPmt3nQlZE0Wc+SzIUjMcPXr9OLNTWNllQkgdLa1QIuU2pWDKZU
         xFQO+y2qQ1flVKrHwJGRzC81UkKNs6i8sHQ5pFxSlklc4z8UETC0AusN7IFeJ1kvlOgg
         QI0/BhEMMgrHyIjpof/WCXhopOemcX/0RELImiK98//4PjCWltGINj2Seq6563LhJ3A7
         9LY721TOCElGu1hQVISaHaB2kPseGyvazsyzlwy8/4RH1196bY/0ZAD+KLLnzsBXzgAU
         69Y2z2vBOdE2huZEG+KDYQ9LwqC/djYT2zofU7uTYwmN5tkAE4RIpGOtVYRIoYPPlxts
         PWdQ==
X-Gm-Message-State: AOAM533FVD9HBg7y6J+XYdfBEAHzARnONhztCQXwFh18zAbLgX6N6PPU
        AW+mLIfXfgKSZKQoyu7LnLAd7AiDk0IExn1+8zBgv2trFxvUMGOFtNwr0NrclE3o8BuWyiohqf9
        Q6AzSb/tGL+5TsaVX
X-Received: by 2002:ac8:5e0c:0:b0:2f3:adfd:bd30 with SMTP id h12-20020ac85e0c000000b002f3adfdbd30mr5067544qtx.277.1652456547221;
        Fri, 13 May 2022 08:42:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKaXPR/x6m9eRtDhITZ/mgkh3K8v85o3GPEiQQ767o63X5SoQJyaXZc+UC5jRKP4V4ZeURSA==
X-Received: by 2002:ac8:5e0c:0:b0:2f3:adfd:bd30 with SMTP id h12-20020ac85e0c000000b002f3adfdbd30mr5067495qtx.277.1652456546522;
        Fri, 13 May 2022 08:42:26 -0700 (PDT)
Received: from [192.168.98.18] ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id f10-20020ac8498a000000b002f39b99f6b9sm1599192qtq.83.2022.05.13.08.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 08:42:25 -0700 (PDT)
Message-ID: <d2696dab-2490-feb5-ccb2-96906fc652f0@redhat.com>
Date:   Fri, 13 May 2022 11:42:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] bond: add mac filter option for balance-xor
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     Long Xin <lxin@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <6227427ef3b57d7de6d4d95e9dd7c9b222a37bf6.1651689665.git.jtoppins@redhat.com>
 <f85a0a66-d3b8-9d20-9abb-fc9fa5e84eab@blackwall.org>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <f85a0a66-d3b8-9d20-9abb-fc9fa5e84eab@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik, thanks for the review. Responses below.

On 5/5/22 08:14, Nikolay Aleksandrov wrote:
> On 04/05/2022 21:47, Jonathan Toppins wrote:
>> Implement a MAC filter that prevents duplicate frame delivery when
>> handling BUM traffic. This attempts to partially replicate OvS SLB
>> Bonding[1] like functionality without requiring significant change
>> in the Linux bridging code.
>>
>> A typical network setup for this feature would be:
>>
>>              .--------------------------------------------.
>>              |         .--------------------.             |
>>              |         |                    |             |
>>         .-------------------.               |             |
>>         |    | Bond 0  |    |               |             |
>>         | .--'---. .---'--. |               |             |
>>    .----|-| eth0 |-| eth1 |-|----.    .-----+----.   .----+------.
>>    |    | '------' '------' |    |    | Switch 1 |   | Switch 2  |
>>    |    '---,---------------'    |    |          +---+           |
>>    |       /                     |    '----+-----'   '----+------'
>>    |  .---'---.    .------.      |         |              |
>>    |  |  br0  |----| VM 1 |      |      ~~~~~~~~~~~~~~~~~~~~~
>>    |  '-------'    '------'      |     (                     )
>>    |      |        .------.      |     ( Rest of Network     )
>>    |      '--------| VM # |      |     (_____________________)
>>    |               '------'      |
>>    |  Host 1                     |
>>    '-----------------------------'
>>
>> Where 'VM1' and 'VM#' are hosts connected to a Linux bridge, br0, with
>> bond0 and its associated links, eth0 & eth1, provide ingress/egress. One
>> can assume bond0, br1, and hosts VM1 to VM# are all contained in a
>> single box, as depicted. Interfaces eth0 and eth1 provide redundant
>> connections to the data center with the requirement to use all bandwidth
>> when the system is functioning normally. Switch 1 and Switch 2 are
>> physical switches that do not implement any advanced L2 management
>> features such as MLAG, Cisco's VPC, or LACP.
>>
>> Combining this feature with vlan+srcmac hash policy allows a user to
>> create an access network without the need to use expensive switches that
>> support features like Cisco's VCP.
>>
>> [1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
>>
>> Co-developed-by: Long Xin <lxin@redhat.com>
>> Signed-off-by: Long Xin <lxin@redhat.com>
>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>> ---
>>
>> Notes:
>>      v2:
>>       * dropped needless abstraction functions and put code in module init
>>       * renamed variable "rc" to "ret" to stay consistent with most of the
>>         code
>>       * fixed parameter setting management, when arp-monitor is turned on
>>         this feature will be turned off similar to how miimon and arp-monitor
>>         interact
>>       * renamed bond_xor_recv to bond_mac_filter_recv for a little more
>>         clarity
>>       * it appears the implied default return code for any bonding recv probe
>>         must be `RX_HANDLER_ANOTHER`. Changed the default return code of
>>         bond_mac_filter_recv to use this return value to not break skb
>>         processing when the skb dev is switched to the bond dev:
>>           `skb->dev = bond->dev`
>>
>>   Documentation/networking/bonding.rst  |  19 +++
>>   drivers/net/bonding/Makefile          |   2 +-
>>   drivers/net/bonding/bond_mac_filter.c | 201 ++++++++++++++++++++++++++
>>   drivers/net/bonding/bond_mac_filter.h |  39 +++++
>>   drivers/net/bonding/bond_main.c       |  27 ++++
>>   drivers/net/bonding/bond_netlink.c    |  13 ++
>>   drivers/net/bonding/bond_options.c    |  86 ++++++++++-
>>   drivers/net/bonding/bonding_priv.h    |   1 +
>>   include/net/bond_options.h            |   1 +
>>   include/net/bonding.h                 |   3 +
>>   include/uapi/linux/if_link.h          |   1 +
>>   11 files changed, 390 insertions(+), 3 deletions(-)
>>   create mode 100644 drivers/net/bonding/bond_mac_filter.c
>>   create mode 100644 drivers/net/bonding/bond_mac_filter.h
>>
> 
> Hi Jonathan,
> I must mention that this is easily solvable with two very simple ebpf programs, one on egress
> to track source macs and one on ingress to filter them, it can also easily be solved by a
> user-space agent that adds macs for filtering in many different ways, after all these VMs
> run on the host and you don't need bond-specific knowledge to do this. Also you have no visibility
> into what is currently being filtered, so it will be difficult to debug. With the above solutions
> you already have that. I don't think the bond should be doing any learning or filtering, this is
> deviating a lot from its purpose and adds unnecessary complexity.
> That being said, if you decide to continue with the set, comments are below...

This is an excellent observation, it does appear this could likely be 
done with eBPF. However, the delivery of such a solution to a user would 
be the difficult part. There appears to be no standard way for attaching 
a program to an interface, it still seems customary to write your own 
custom loader. Where would the user run this loader? In Debian likely in 
a post up hook with ifupdown, in Fedora one would have to write a 
locally custom dispatcher script (assuming Network Manager) that only 
ran the loader for a given interface. In short I do not see a reasonably 
appropriate way to deploy an eBPF program to users with the current 
infrastructure. Also, I am not aware of the bpf syscall supporting 
signed program loading. Signing kernel modules seems popular with some 
distros to identify limits of support and authentication of an 
unmodified system. I suspect similar bpf support might be needed to 
identify support and authentication for deployed programs.

[...]

>> diff --git a/drivers/net/bonding/bond_mac_filter.c b/drivers/net/bonding/bond_mac_filter.c
>> new file mode 100644
>> index 000000000000..e86b2b475df3
>> --- /dev/null
>> +++ b/drivers/net/bonding/bond_mac_filter.c
>> @@ -0,0 +1,201 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Filter received frames based on MAC addresses "behind" the bond.
>> + */
>> +
>> +#include "bonding_priv.h"
>> +
>> +static const struct rhashtable_params bond_rht_params = {
>> +	.head_offset         = offsetof(struct bond_mac_cache_entry, rhnode),
>> +	.key_offset          = offsetof(struct bond_mac_cache_entry, key),
>> +	.key_len             = sizeof(struct mac_addr),
>> +	.automatic_shrinking = true,
>> +};
>> +
>> +static inline unsigned long hold_time(const struct bonding *bond)
> 
> no inlines in .c files, let the compiler do its job
> 
>> +{
>> +	return msecs_to_jiffies(5000);
>> +}
>> +
>> +static bool has_expired(const struct bonding *bond,
>> +			struct bond_mac_cache_entry *mac)
>> +{
>> +	return time_before_eq(mac->used + hold_time(bond), jiffies);
>> +}
>> +
>> +static void mac_delete_rcu(struct callback_head *head)
>> +{
>> +	kmem_cache_free(bond_mac_cache,
>> +			container_of(head, struct bond_mac_cache_entry, rcu));
>> +}
>> +
>> +static int mac_delete(struct bonding *bond,
>> +		      struct bond_mac_cache_entry *entry)
>> +{
>> +	int ret;
>> +
>> +	ret = rhashtable_remove_fast(bond->mac_filter_tbl,
>> +				     &entry->rhnode,
>> +				     bond->mac_filter_tbl->p);
>> +	set_bit(BOND_MAC_DEAD, &entry->flags);
> 
> you don't need the atomic bitops, these flags are all modified and checked
> under the entry lock

I need to keep the atomic set_bit if I remove the [use-after-free] 
idiomatic issue later in the file.

> 
>> +	call_rcu(&entry->rcu, mac_delete_rcu);
> 
> all of these entries are queued to be freed, what happens if we unload the bonding
> driver before that?

[...]

> 
>> +
>> +	rhashtable_walk_enter(bond->mac_filter_tbl, &iter);
>> +	rhashtable_walk_start(&iter);
>> +	while ((entry = rhashtable_walk_next(&iter)) != NULL) {
>> +		if (IS_ERR(entry))
>> +			continue;
>> +
>> +		spin_lock_irqsave(&entry->lock, flags);
>> +		if (has_expired(bond, entry))
>> +			mac_delete(bond, entry);
>> +		spin_unlock_irqrestore(&entry->lock, flags);
> 
> deleting entries while holding their own lock is not very idiomatic

[use-after-free] To fix this I made has_expired take the lock, making 
has_expired atomic. Now there is no need to have the critical section 
above and mac_delete can be outside the critical section. This also 
removed the use-after-free bug that would appear if the code were not 
using RCU and cache malloc.

> 
>> +	bond->mac_filter_tbl = kzalloc(sizeof(*bond->mac_filter_tbl),
>> +				       GFP_KERNEL);
>> +	if (!bond->mac_filter_tbl)
>> +		return -ENOMEM;
>> +
>> +	ret = rhashtable_init(bond->mac_filter_tbl, &bond_rht_params);
>> +	if (ret)
>> +		kfree(bond->mac_filter_tbl);
> 
> on error this is freed, but the pointer is stale and on bond destruction
> will be accessed and potentially freed again

set to NULL.

[...]

>> +static int mac_create(struct bonding *bond, const u8 *addr)
>> +{
>> +	struct bond_mac_cache_entry *entry;
>> +	int ret;
>> +
>> +	entry = kmem_cache_alloc(bond_mac_cache, GFP_ATOMIC);
>> +	if (!entry)
>> +		return -ENOMEM;
>> +	spin_lock_init(&entry->lock);
>> +	memcpy(&entry->key, addr, sizeof(entry->key));
>> +	entry->used = jiffies;
> 
> you must zero the old fields, otherwise you can find stale values from old
> structs which were freed

good point, have done.

[...]

>> diff --git a/drivers/net/bonding/bond_mac_filter.h b/drivers/net/bonding/bond_mac_filter.h
>> new file mode 100644
>> index 000000000000..7c968d41b456
>> --- /dev/null
>> +++ b/drivers/net/bonding/bond_mac_filter.h
>> @@ -0,0 +1,39 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only
>> + *
>> + * Filter received frames based on MAC addresses "behind" the bond.
>> + */
>> +
>> +#ifndef _BOND_MAC_FILTER_H
>> +#define _BOND_MAC_FILTER_H
>> +#include <net/bonding.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/rhashtable.h>
>> +
>> +enum {
>> +	BOND_MAC_DEAD,
>> +	BOND_MAC_LOCKED,
>> +	BOND_MAC_STATIC,
> 
> What are BOND_MAC_LOCKED or STATIC ? I didn't see them used anywhere.

Stale, was going to use them to allow the user to manually add entries 
but never got around to it. Removed.

[...]

>> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>> index 64f7db2627ce..d295903a525b 100644
>> --- a/drivers/net/bonding/bond_options.c
>> +++ b/drivers/net/bonding/bond_options.c

[...]

>> @@ -1035,6 +1075,44 @@ static int bond_option_use_carrier_set(struct bonding *bond,
>>   	return 0;
>>   }
>>   
>> +static int bond_option_mac_filter_set(struct bonding *bond,
>> +				      const struct bond_opt_value *newval)
>> +{
>> +	int rc = 0;
>> +	u8 prev = bond->params.mac_filter;
> 
> reverse xmas tree
> 
>> +
>> +	if (newval->value && bond->params.arp_interval) {
> 
> what happens if we set arp_interval after enabling this, the table will be
> freed while the bond is up and is using it, also the queued work is still enabled

This is a good observation. To simplify the option setting I moved the 
init/destroy of the hash table to bond_open/close respectively. This 
allowed me to simply set the value of mac_filter. The only catch is in 
bond_option_arp_interval_set() if mac_filter is set and the interface is 
up, the user will receive an -EBUSY. This was the minimal amount of 
configuration behavioral change I could think of.

Thanks,
-Jon

