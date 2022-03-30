Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E6E4EC78C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347567AbiC3O6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344103AbiC3O6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:58:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91EC41015
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 07:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648652193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51rZIuCEQ86hv/OQgOn8FfXQK8pkiQqNdNplPiBUWHk=;
        b=dSomugj7efjsrIqytsofgv/FDm3ub06QCGxxv39afKgBjG9O82P8w5c4yLMOaUxFY6tdjf
        /LFACOxftZZwXJsa9g7eDaTO/4pk2wa8K2C4Eg1ZL048m7L5kcFjD5HaV62FDVav7PPAQV
        eKvOKweCQQx7CXn3sj2ABTf7nEvt2u0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-2wKRjANuMUisVG_GTddqDw-1; Wed, 30 Mar 2022 10:56:32 -0400
X-MC-Unique: 2wKRjANuMUisVG_GTddqDw-1
Received: by mail-qv1-f72.google.com with SMTP id ke13-20020a056214300d00b00443901b0386so904340qvb.14
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 07:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=51rZIuCEQ86hv/OQgOn8FfXQK8pkiQqNdNplPiBUWHk=;
        b=I+pYW1WdI2PiqEfVbZwOHj43xC2znQCleBi569SexAZmumeg9w/BJoSQKqxO4Mb35u
         iz/eBBklUp3XLGJqINNeo42TExR+kYRN0NU11lQsBFQHSj+2SnwEZFUcbzY9sseMbxNl
         KKntw4CoM9BDaDquthRreylvkwz7MtfsEnhw77UgNWh7OfeUWw0y1xSGSnu9bBnA/rcx
         l99nlxuGYfZhTCmvrNzrhK89iijhTNfdM+OGMICRfCXtvXhEv5xwdwrsxr/nURv4muUW
         n4KcFca2cUNC2S3tzEBVUmc2ilmkCwP4D2Cdw2bwSNuIHCno+QZDjnAJl83j6VJ5oPkM
         MtyA==
X-Gm-Message-State: AOAM532FPm4LklTuJiRpqNKqORjvoU8w+9b9uzgm2yLkiez+0qobQcTX
        MHyi471Tfjkn5MSou8kNLg4ew9fbCrSU9jh0ljbfXkwbNgBjkAjMDETCXk873uHEcnlEUN0JFar
        WEeVX6E7qoBtLeiAC
X-Received: by 2002:ac8:4417:0:b0:2e1:a82c:1a6f with SMTP id j23-20020ac84417000000b002e1a82c1a6fmr33226481qtn.375.1648652191553;
        Wed, 30 Mar 2022 07:56:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE0G7dAUmx5tFrJAQgrw7PhjfnuImzUiQanEz4R3ogQWDdO8J1cp1tK+Q6hVnCBX+HiD2jJA==
X-Received: by 2002:ac8:4417:0:b0:2e1:a82c:1a6f with SMTP id j23-20020ac84417000000b002e1a82c1a6fmr33226448qtn.375.1648652191183;
        Wed, 30 Mar 2022 07:56:31 -0700 (PDT)
Received: from [192.168.98.18] ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id w8-20020a05622a134800b002eb8401862bsm8036849qtk.34.2022.03.30.07.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 07:56:30 -0700 (PDT)
Message-ID: <bb66fc08-9f23-2f68-c0aa-1fbe06bb81c5@redhat.com>
Date:   Wed, 30 Mar 2022 10:56:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] bond: add mac filter option for balance-xor
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Long Xin <lxin@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b03f0896e1a0b65cc1b278aecc9d080b2ec9d8a6.1648136359.git.jtoppins@redhat.com>
 <12686.1648169401@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <12686.1648169401@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/22 20:50, Jay Vosburgh wrote:
> 	Considering this as an RFC given that net-next is closed...
> 	
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> Attempt to replicate the OvS SLB Bonding[1] feature by preventing
>> duplicate frame delivery on a bond whos members are connected to
>> physically different switches.
>>
>> Combining this feature with vlan+srcmac hash policy allows a user to
>> create an access network without the need to use expensive switches that
>> support features like Cisco's VCP.
> 
> 	Could you describe this use case / implementation in a bit more
> detail?  I.e., how exactly that configuration works.  I don't think this
> patch is replicating everything in the OVS SLB documentation.
> 

The original ask was to provide OvS SLB like functionality in Linux's 
bonding as they wanted to move away from OvS. This does not try and 
implement OvS SLB in its entirety as that would require implementing 
bonding in the Linux bridging code. Instead we implemented a MAC filter 
that prevents duplicate frame delivery when handling BUM traffic. We 
currently do not handle individual vlans.

This is trying to solve for the logical network of the form:

                        lk1    +---+
              +-+        +-----|sw1|
h1 --linkH1--|b|        |     +---+
...          |r|--bond1-+       |lk3
hN --linkHN--|1|        |     +---+
              +-+        +-----|sw2|
                        lk2    +---+

Where h1...hN are hosts connected to a Linux bridge, br1, with bond1 and 
its associated links, lk1 & lk2, provide egress/ingress. One can assume 
bond1, br1, and hosts h1...hN are all contained in a single box and 
h1...hN are virtual machines or containers and lk1 & lk2 provide 
redundant connections to the data center. The requirement is to use all 
bandwidth when the system is functioning normally. Sw1 & Sw2 are 
physical switches that do not implement any advanced L2 management 
features such as MLAG, Cisco's VPC, or LACP. Link 3, lk3, provides a 
switch interconnect to provide layer 2 connectivity in the event a link 
or switch fails.

>> [1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
>> >> diff --git a/drivers/net/bonding/bond_mac_filter.c 
b/drivers/net/bonding/bond_mac_filter.c
>> new file mode 100644
>> index 000000000000..a16a1a000f05
>> --- /dev/null
>> +++ b/drivers/net/bonding/bond_mac_filter.c
>> @@ -0,0 +1,222 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Filter received frames based on MAC addresses "behind" the bond.
>> + */
>> +
>> +#include "bonding_priv.h"
>> +
>> +/* -------------- Cache Management -------------- */
> 
> 	I don't think this header adds anything, given that there's not
> really a lot in the section.

ok can remove.

> 
>> +static struct kmem_cache *bond_mac_cache __read_mostly;
>> +
>> +int __init bond_mac_cache_init(void)
>> +{
>> +	bond_mac_cache = kmem_cache_create("bond_mac_cache",
>> +					   sizeof(struct bond_mac_cache_entry),
>> +					   0, SLAB_HWCACHE_ALIGN, NULL);
>> +	if (!bond_mac_cache)
>> +		return -ENOMEM;
>> +	return 0;
>> +}
>> +
>> +void bond_mac_cache_destroy(void)
>> +{
>> +	kmem_cache_destroy(bond_mac_cache);
>> +}
> 
> 	There are a lot of the above sort of wrapper functions that are
> only ever called once.  Some of these, e.g., mac_delete, below, I agree
> with, as the call site is nested fairly deep and the function is
> non-trivial; or, mac_delete_rcu, which is used as a callback.
> 
> 	The above two, though, I don't see a justification for, along
> with hold_time and maybe a couple others, below.  In my opinion,
> over-abstracting these trivial things with one call site makes the code
> harder to follow.
> 

ok can remove.

>> +
>> +static inline unsigned long hold_time(const struct bonding *bond)
>> +{
>> +	return msecs_to_jiffies(5000);
>> +}
> 
> 	This shouldn't be a magic number, and if it's an important
> timeout, should it be configurable?
> 

This is the MAC entry age-out time much like Linux bridge 
"br->ageing_time". We didn't find a need to modify the age-out time 
currently, if you think another bond parameter is needed to make this 
configurable I can add it.

>> +int bond_mac_hash_init(struct bonding *bond)
>> +{
>> +	int rc;
> 
> 	As a point of style, (almost) everywhere else in bonding uses
> "ret" for a return value.  The exceptions are largely my doing, but,
> still, it'd be nice to be mostly consistent in nomenclature.
> 

ok.

>> +
>> +int bond_mac_insert(struct bonding *bond, const u8 *addr)
>> +{
>> +	struct bond_mac_cache_entry *entry;
>> +	int rc = 0;
>> +
>> +	if (!is_valid_ether_addr(addr))
>> +		return -EINVAL;
>> +
>> +	rcu_read_lock();
>> +	entry = mac_find(bond, addr);
>> +	if (entry) {
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&entry->lock, flags);
>> +		if (!test_bit(BOND_MAC_DEAD, &entry->flags)) {
>> +			mac_update(entry);
>> +			spin_unlock_irqrestore(&entry->lock, flags);
>> +			goto out;
>> +		}
>> +		spin_unlock_irqrestore(&entry->lock, flags);
> 
> 	This seems really expensive, as it will add a spin_lock_irqsave
> round trip for almost every packet transmitted when mac_filter is
> enabled (as this will be called by bond_xmit_3ad_xor_slave_get).
> 

It is, if you have a suggestion to make it less expensive I would like 
to hear ideas on this. On bond transmit the bond needs to see if a new 
MAC source is talking, if it is not new we just need to update the 
ageout time (mac_update). If the MAC is new we need to add a new entry 
to the filter table. The lock is per-entry so it is not blocking every 
entry update just the one we are dealing with right now.

>> +	}
>> +
>> +	rc = mac_create(bond, addr);
>> +
>> +out:
>> +	rcu_read_unlock();
>> +	return rc;
>> +}
>> +
>> +int bond_xor_recv(const struct sk_buff *skb, struct bonding *bond,
>> +		  struct slave *slave)
>> +{
>> +	const struct ethhdr *mac_hdr;
>> +	struct bond_mac_cache_entry *entry;
>> +	int rc = RX_HANDLER_PASS;
>> +
>> +	mac_hdr = (struct ethhdr *)skb_mac_header(skb);
>> +	rcu_read_lock();
>> +	if (is_multicast_ether_addr(mac_hdr->h_dest) &&
>> +	    slave != rcu_dereference(bond->curr_active_slave)) {
>> +		rc = RX_HANDLER_CONSUMED;
>> +		goto out;
>> +	}
>> +
>> +	entry = mac_find(bond, mac_hdr->h_source);
>> +	if (entry) {
>> +		unsigned long flags;
>> +		bool expired;
>> +
>> +		spin_lock_irqsave(&entry->lock, flags);
>> +		expired = has_expired(bond, entry);
>> +		spin_unlock_irqrestore(&entry->lock, flags);
>> +		if (!expired)
>> +			rc = RX_HANDLER_CONSUMED;
>> +	}
> 
> 	As above, really expensive, except for incoming packets here
> (since this is called as the recv_probe).
> 

By incoming packets do you mean packets received by the bond? If so not 
sure I understand the comment. On the receive side this will be run for 
every frame handled by the bond and the lock will only be taken if an 
entry is found for the source MAC.

>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 15eddca7b4b6..f5a8a50e9116 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1549,6 +1549,10 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
>> 		return RX_HANDLER_EXACT;
>> 	}
>>
>> +	/* this function should not rely on the recv_probe to set ret
>> +	 * correctly
>> +	 */
>> +	ret = RX_HANDLER_ANOTHER;
> 
> 	This change is overriding the return from a recv_probe added by
> this patch (bond_xor_recv can return RX_HANDLER_PASS).  Why?
> 
> 	Also, I don't agree with the comment; the recv_probe return
> value by design affects the return value from bond_handle_frame.
> 

Had to go back and look at why this was added, I don't see a need for it 
now so will remove.

>>
>> static const struct bond_opt_value bond_mode_tbl[] = {
>> @@ -226,6 +229,12 @@ static const struct bond_opt_value bond_missed_max_tbl[] = {
>> 	{ NULL,		-1,	0},
>> };
>>
>> +static const struct bond_opt_value bond_mac_filter_tbl[] = {
>> +	{ "off",	0,	BOND_VALFLAG_MIN | BOND_VALFLAG_DEFAULT},
>> +	{ "maxval",	18,	BOND_VALFLAG_MAX},
> 
> 	What's the magic number 18?

It is simply the maximum number the option can be set to as I thought 
2^18 was more than enough entries in the hash table.

>> /* Searches for an option by name */
>> @@ -1035,6 +1053,44 @@ static int bond_option_use_carrier_set(struct bonding *bond,
>> 	return 0;
>> }
>>
>> +static int bond_option_mac_filter_set(struct bonding *bond,
>> +				      const struct bond_opt_value *newval)
>> +{
>> +	int rc = 0;
>> +	u8 prev = bond->params.mac_filter;
>> +
>> +	if (newval->value && bond->params.arp_interval) {
>> +		netdev_err(bond->dev, "ARP monitoring cannot be used with MAC Filtering.\n");
>> +		rc = -EPERM;
>> +		goto err;
>> +	}
> 
> 	What happens if a user (a) switches to ARP monitor with
> arp_validate in balance-xor mode after mac_filter is enabled, or, (b)
> changes the mode to something other than balance-xor with mac_filter
> enabled (both by changing the configuration in real time)?

For (a) the arp config handlers will need to be modified to account for 
this. I assume they will take the same approach as with mii vs arp monitor.

For (b) the sites that test for bond->params.mac_filter will need to be 
logically anded with bond->params.mode == BOND_MODE_XOR.

Thank you for the comments.

-Jon

