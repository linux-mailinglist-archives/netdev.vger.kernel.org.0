Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15F92B5F24
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgKQMad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:30:33 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:4480 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgKQMad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 07:30:33 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kf07v-0003IK-JD; Tue, 17 Nov 2020 13:30:27 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kf07u-0003Hg-Lj; Tue, 17 Nov 2020 13:30:26 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 2ADD9240041;
        Tue, 17 Nov 2020 13:30:26 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 9C971240040;
        Tue, 17 Nov 2020 13:30:25 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 0FD9321E5D;
        Tue, 17 Nov 2020 13:30:25 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 17 Nov 2020 13:30:24 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/6] net/x25: support NETDEV_CHANGE notifier
Organization: TDT AG
In-Reply-To: <CAJht_ENE5fGr-rgOd-5Tk_g5RJibaWBn_ey5Avo-2R2opMGcDA@mail.gmail.com>
References: <20201116135522.21791-1-ms@dev.tdt.de>
 <20201116135522.21791-5-ms@dev.tdt.de>
 <CAJht_ENE5fGr-rgOd-5Tk_g5RJibaWBn_ey5Avo-2R2opMGcDA@mail.gmail.com>
Message-ID: <93e2a7226531ce6832241be1c4296b9d@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1605616227-00008E89-3C9B13AB/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-17 12:41, Xie He wrote:
> On Mon, Nov 16, 2020 at 6:00 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> This makes it possible to handle carrier lost and detection.
>> In case of carrier lost, we shutdown layer 3 and flush all sessions.
>> 
>> @@ -275,6 +275,19 @@ static int x25_device_event(struct notifier_block 
>> *this, unsigned long event,
>>                                  dev->name);
>>                         x25_link_device_remove(dev);
>>                         break;
>> +               case NETDEV_CHANGE:
>> +                       pr_debug("X.25: got event NETDEV_CHANGE for 
>> device: %s\n",
>> +                                dev->name);
>> +                       if (!netif_carrier_ok(dev)) {
>> +                               pr_debug("X.25: Carrier lost -> set 
>> link state down: %s\n",
>> +                                        dev->name);
>> +                               nb = x25_get_neigh(dev);
>> +                               if (nb) {
>> +                                       x25_link_terminated(nb);
>> +                                       x25_neigh_put(nb);
>> +                               }
>> +                       }
>> +                       break;
>>                 }
>>         }
> 
> I think L2 will notify L3 if the L2 connection is terminated. Is this
> patch necessary?

Hmm... well I guess you're right. Admittedly, these patches were made
about 7 - 8 years ago and I have to keep thinking about them.
But I can't think of any situation where this patch should be necessary
at the moment.

I will drop this patch from the patch-set.
