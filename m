Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC4A2B789D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgKRI2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:28:43 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:35959 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgKRI2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:28:43 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfIpP-0004fq-Gx; Wed, 18 Nov 2020 09:28:35 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfIpO-0008Lm-DO; Wed, 18 Nov 2020 09:28:34 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E4AB5240041;
        Wed, 18 Nov 2020 09:28:33 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 669A3240040;
        Wed, 18 Nov 2020 09:28:33 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 01AC020049;
        Wed, 18 Nov 2020 09:28:32 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 09:28:32 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/6] net/x25: replace x25_kill_by_device with
 x25_kill_by_neigh
Organization: TDT AG
In-Reply-To: <CAJht_EN0fhD08+wH5kSBWvciHU7uM7iKJu_UcEXwZBKssuqNVw@mail.gmail.com>
References: <20201116135522.21791-1-ms@dev.tdt.de>
 <20201116135522.21791-4-ms@dev.tdt.de>
 <CAJht_EN0fhD08+wH5kSBWvciHU7uM7iKJu_UcEXwZBKssuqNVw@mail.gmail.com>
Message-ID: <352e0095deb8f1f3b08e335942eabac2@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1605688115-000013A4-791AC271/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-17 20:50, Xie He wrote:
> On Mon, Nov 16, 2020 at 6:00 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> Remove unnecessary function x25_kill_by_device.
> 
>> -/*
>> - *     Kill all bound sockets on a dropped device.
>> - */
>> -static void x25_kill_by_device(struct net_device *dev)
>> -{
>> -       struct sock *s;
>> -
>> -       write_lock_bh(&x25_list_lock);
>> -
>> -       sk_for_each(s, &x25_list)
>> -               if (x25_sk(s)->neighbour && x25_sk(s)->neighbour->dev 
>> == dev)
>> -                       x25_disconnect(s, ENETUNREACH, 0, 0);
>> -
>> -       write_unlock_bh(&x25_list_lock);
>> -}
>> -
>>  /*
>>   *     Handle device status changes.
>>   */
>> @@ -273,7 +257,11 @@ static int x25_device_event(struct notifier_block 
>> *this, unsigned long event,
>>                 case NETDEV_DOWN:
>>                         pr_debug("X.25: got event NETDEV_DOWN for 
>> device: %s\n",
>>                                  dev->name);
>> -                       x25_kill_by_device(dev);
>> +                       nb = x25_get_neigh(dev);
>> +                       if (nb) {
>> +                               x25_kill_by_neigh(nb);
>> +                               x25_neigh_put(nb);
>> +                       }
>>                         x25_route_device_down(dev);
>>                         x25_link_device_down(dev);
>>                         break;
> 
> This patch might not be entirely necessary. x25_kill_by_neigh and
> x25_kill_by_device are just two helper functions. One function takes
> nb as the argument and the other one takes dev as the argument. But
> they do almost the same things. It doesn't harm to keep both. In C++
> we often have different functions with the same name doing almost the
> same things.
> 

Well I don't like to have 2 functions doing the same thing.
But after another look at this code, I've found that I also need to
remove the call to x25_clear_forward_by_dev() in the function
x25_route_device_down(). Otherwise, it will be called twice.

> The original code also seems to be a little more efficient than the new 
> code.

The only difference would be the x25_get_neigh() and x25_neigh_put()
calls. That shouldn't cost to much.
