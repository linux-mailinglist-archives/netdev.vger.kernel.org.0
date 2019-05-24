Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E7F29BD8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390163AbfEXQKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389588AbfEXQKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 12:10:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39D2ADF26;
        Fri, 24 May 2019 16:10:41 +0000 (UTC)
Received: from Hades.local (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAB7310027B9;
        Fri, 24 May 2019 16:10:39 +0000 (UTC)
Subject: Re: [PATCH net] bonding: make debugging output more succinct
To:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190524135623.17326-1-jarod@redhat.com>
 <f6286af05b1eda38b103ef1337cd7086d3ea4372.camel@perches.com>
From:   Jarod Wilson <jarod@redhat.com>
Message-ID: <c6555d3b-6e78-73b0-4fde-e39189149d18@redhat.com>
Date:   Fri, 24 May 2019 12:10:39 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <f6286af05b1eda38b103ef1337cd7086d3ea4372.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 24 May 2019 16:10:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/19 11:19 AM, Joe Perches wrote:
> On Fri, 2019-05-24 at 09:56 -0400, Jarod Wilson wrote:
>> Seeing bonding debug log data along the lines of "event: 5" is a bit spartan,
>> and often requires a lookup table if you don't remember what every event is.
>> Make use of netdev_cmd_to_name for an improved debugging experience, so for
>> the prior example, you'll see: "bond_netdev_event received NETDEV_REGISTER"
>> instead (both are prefixed with the device for which the event pertains).
>>
>> There are also quite a few places that the netdev_dbg output could stand to
>> mention exactly which slave the message pertains to (gets messy if you have
>> multiple slaves all spewing at once to know which one they pertain to).
> []
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> []
>> @@ -1515,7 +1515,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>>   	new_slave->original_mtu = slave_dev->mtu;
>>   	res = dev_set_mtu(slave_dev, bond->dev->mtu);
>>   	if (res) {
>> -		netdev_dbg(bond_dev, "Error %d calling dev_set_mtu\n", res);
>> +		netdev_dbg(bond_dev, "Error %d calling dev_set_mtu for slave %s\n",
>> +			   res, slave_dev->name);
> 
> Perhaps better to add and use helper mechanisms like:
> 
> #define slave_dbg(bond_dev, slave_dev, fmt, ...)				\
> 	netdev_dbg(bond_dev, "(slave %s) " fmt, (slave_dev)->name, ##__VA_ARGS__)
> 
> So this might be
> 		slave_dbg(bond_dev, slave_dev, "Error %d calling dev_set_mtu\n",
> 			  res);
> etc...
> 
> So there would be a unified style to grep in the logs.

I do kind of like that idea. Might also need slave_info and friends as 
well if you really want to get consistent, and eliminate bond_dev as an 
arg to it, since you can figure that out from slave_dev. I'd be game to 
take that little project on. Might be worth peeling out the 
netdev_cmd_to_name() bit from this for consideration right now, since 
it's not quite part of that same conversion.

-- 
Jarod Wilson
jarod@redhat.com
