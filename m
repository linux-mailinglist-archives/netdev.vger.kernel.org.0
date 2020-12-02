Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8410F2CBB8A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgLBL3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:29:35 -0500
Received: from mx04.lhost.no ([5.158.192.85]:45071 "EHLO mx04.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgLBL3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 06:29:34 -0500
X-ASG-Debug-ID: 1606908529-0ffc0612ed3a4f50001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx04.lhost.no with ESMTP id SzoUS7V14HFkJtd1 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Wed, 02 Dec 2020 12:28:49 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Wed, 2 Dec
 2020 12:28:46 +0100
Subject: Re: [PATCH net-next v3] macvlan: Support for high multicast packet
 rate
To:     Jakub Kicinski <kuba@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH net-next v3] macvlan: Support for high multicast packet
 rate
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se>
 <20201201111143.2a82d744@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <333d17ee-b01c-3286-bc7c-30d100b223ae@paneda.se>
Date:   Wed, 2 Dec 2020 12:28:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201201111143.2a82d744@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606908529
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx04.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 5790
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-01 20:11, Jakub Kicinski wrote:
> On Mon, 30 Nov 2020 15:00:43 +0100 Thomas Karlsson wrote:
>> Background:
>> Broadcast and multicast packages are enqueued for later processing.
>> This queue was previously hardcoded to 1000.
>>
>> This proved insufficient for handling very high packet rates.
>> This resulted in packet drops for multicast.
>> While at the same time unicast worked fine.
>>
>> The change:
>> This patch make the queue length adjustable to accommodate
>> for environments with very high multicast packet rate.
>> But still keeps the default value of 1000 unless specified.
>>
>> The queue length is specified as a request per macvlan
>> using the IFLA_MACVLAN_BC_QUEUE_LEN parameter.
>>
>> The actual used queue length will then be the maximum of
>> any macvlan connected to the same port. The actual used
>> queue length for the port can be retrieved (read only)
>> by the IFLA_MACVLAN_BC_QUEUE_LEN_USED parameter for verification.
>>
>> This will be followed up by a patch to iproute2
>> in order to adjust the parameter from userspace.
>>
>> Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
> 
> Looks good! Minor nits below:

:)

> 
>> @@ -1218,6 +1220,7 @@ static int macvlan_port_create(struct net_device *dev)
>>  	for (i = 0; i < MACVLAN_HASH_SIZE; i++)
>>  		INIT_HLIST_HEAD(&port->vlan_source_hash[i]);
>>  
>> +	port->bc_queue_len_used = MACVLAN_DEFAULT_BC_QUEUE_LEN;
> 
> Should this be inited to 0? Otherwise if the first link asks for lower
> queue len than the default it will not get set, right?

Indeed, looks you are right, see also below

 
>>  	skb_queue_head_init(&port->bc_queue);
>>  	INIT_WORK(&port->bc_work, macvlan_process_broadcast);
>>  
>> @@ -1486,6 +1489,12 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
>>  			goto destroy_macvlan_port;
>>  	}
>>  
>> +	vlan->bc_queue_len_requested = MACVLAN_DEFAULT_BC_QUEUE_LEN;
>> +	if (data && data[IFLA_MACVLAN_BC_QUEUE_LEN])
>> +		vlan->bc_queue_len_requested = nla_get_u32(data[IFLA_MACVLAN_BC_QUEUE_LEN]);
>> +	if (vlan->bc_queue_len_requested > port->bc_queue_len_used)
>> +		port->bc_queue_len_used = vlan->bc_queue_len_requested;
> 
> Or perhaps we should just call update_port_bc_queue_len() here?

That would also have prevented the above bug... So yes, I think that is better
to keep the logic only in one place. I'll change to that.

 
>>  	err = register_netdevice(dev);
>>  	if (err < 0)
>>  		goto destroy_macvlan_port;
> 
>> @@ -1658,6 +1684,8 @@ static const struct nla_policy macvlan_policy[IFLA_MACVLAN_MAX + 1] = {
>>  	[IFLA_MACVLAN_MACADDR] = { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
>>  	[IFLA_MACVLAN_MACADDR_DATA] = { .type = NLA_NESTED },
>>  	[IFLA_MACVLAN_MACADDR_COUNT] = { .type = NLA_U32 },
>> +	[IFLA_MACVLAN_BC_QUEUE_LEN] = { .type = NLA_U32 },
>> +	[IFLA_MACVLAN_BC_QUEUE_LEN_USED] = { .type = NLA_U32 },
> 
> This is an input policy, so you can set type to NLA_REJECT and you
> won't have to check if it's set on input.
> 

Great!

>>  };
>>  
>>  int macvlan_link_register(struct rtnl_link_ops *ops)
>> @@ -1688,6 +1716,18 @@ static struct rtnl_link_ops macvlan_link_ops = {
>>  	.priv_size      = sizeof(struct macvlan_dev),
>>  };
>>  
>> +static void update_port_bc_queue_len(struct macvlan_port *port)
>> +{
>> +	struct macvlan_dev *vlan;
>> +	u32 max_bc_queue_len_requested = 0;
> 
> Please reorder so that the vars are longest line to shortest.
> 
got it

>> +	list_for_each_entry_rcu(vlan, &port->vlans, list) {
> 
> I don't think you need the _rcu() flavor here, this is always called
> from the configuration paths holding RTNL lock, right?
> 

To be honest, what to use/not to use when traversing the list was what caused me the most
doubt/trouble of the patch :)

I sort of assumed that there must be some outer synchronisation that prevented
two or more concurrent calls to new/delte/change link. but wasn't sure how
and where that synchonisation took place. Now that I have googled RTLN lock I understand
that part much better.

The main reason I went with _rcu was because the existing code is using list_del_rcu and
list_add_tail_rcu when modifying the list as well as _rcu when accessing/traversing (in some places).
So I figured if they needed the _rcu variants I too would need that.

But from a closer inspection I think in that situation it is only needed because the list is accessed
from for example macvlan_handle_frame (obviously not protected by the RTLN lock) using _rcu version
and under the rcu_read_lock as protection. So then it must also be updated with _rcu 
in all places of course. Even if all the updates are done under the RTNL lock.

This was a long ramble :)
But thanks, I think I understand the synchronisation mechanism in the kernel a bit better now!

As I'm only calling my function from the netlink configuration functions under RTLN lock
It should be safe to drop the _rcu version as you say, because the list is only
modified in those functions too. Great!


>> +		if (vlan->bc_queue_len_requested > max_bc_queue_len_requested)
>> +			max_bc_queue_len_requested = vlan->bc_queue_len_requested;
>> +	}
>> +	port->bc_queue_len_used = max_bc_queue_len_requested;
>> +}
>> +
>>  static int macvlan_device_event(struct notifier_block *unused,
>>  				unsigned long event, void *ptr)
>>  {


I also noticed I got a few line length warnings in patchworks but none when I ran the ./scrips/checkpatch.pl
locally. So is the net tree using strict 80 chars? I would prefer not to introduce extra line breaks
on those lines as I think it will hurt readability but of course I will if needed.

I will publish a v4 later today.

/Thomas
