Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E7A1182ED
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfLJI7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:59:36 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:8332
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726574AbfLJI7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:59:36 -0500
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 487A8203AF;
        Tue, 10 Dec 2019 08:59:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 10 Dec 2019 09:59:29 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>, khc@pm.waw.pl,
        gregkh <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Networking <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>,
        Qiang Zhao <qiang.zhao@nxp.com>
Subject: Re: [PATCH 4/4] [RFC] staging/net: move AF_X25 into drivers/staging
Organization: TDT AG
In-Reply-To: <CAK8P3a25UGV1KS1ufZsyQJk1+9Rp9is0x6eOU7pr5Xf6Z3N2gA@mail.gmail.com>
References: <20191209151256.2497534-1-arnd@arndb.de>
 <20191209151256.2497534-4-arnd@arndb.de>
 <20191209.102950.2248756181772063368.davem@davemloft.net>
 <CAK8P3a25UGV1KS1ufZsyQJk1+9Rp9is0x6eOU7pr5Xf6Z3N2gA@mail.gmail.com>
Message-ID: <407acd92c92c3ba04578da89b1a0f191@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-09 20:26, Arnd Bergmann wrote:
> On Mon, Dec 9, 2019 at 7:29 PM David Miller <davem@davemloft.net> 
> wrote:
>> 
>> From: Arnd Bergmann <arnd@arndb.de>
>> Date: Mon,  9 Dec 2019 16:12:56 +0100
>> 
>> > syzbot keeps finding issues in the X.25 implementation that nobody is
>> > interested in fixing.  Given that all the x25 patches of the past years
>> > that are not global cleanups tend to fix user-triggered oopses, is it
>> > time to just retire the subsystem?
>> 
>> I have a bug fix that I'm currently applying to 'net' right now 
>> actually:
>> 
>>         https://patchwork.ozlabs.org/patch/1205973/
>> 
>> So your proposal might be a bit premature.
> 
> Ok, makes sense. Looking back in the history, I also see other bugfixes
> from the same author.
> 
> Adding Martin Schiller to Cc: for a few questions:
> 
> - What hardware are you using for X.25?

I would say that X.25 is (at least in Germany) not dead yet. For 
example, it is
still used in the railway network of the Deutsche Bahn AG in many 
different
areas. [1]

We deliver products for this and use the Linux X.25 stack with some 
bugfixes
and extensions that I would like to get upstream.

As hardware/interfaces we use X.21bis/G.703 adapters, which are 
connected via
HDLC_X25 and LAPB. Also for this there are extensions and bugfixes, 
which I
would like to include in the kernel.

> - Would you be available to be listed in the MAINTAINERS file
>   as a contact for net/x25?

Yes, you can add me to the MAINTAINERS file.
I have only limited time, but I will try to follow all requests 
concerning this
subsystem.

> - Does your bug fix address the latest issue found by syzbot[1],
>   or do you have an idea to fix it if not?

I don't have a direct solution for the concrete problem mentioned above, 
but at
first sight I would say that the commit 95d6ebd53c79 ("net/x25: fix
use-after-free in x25_device_event()") holds the wrong lock 
(&x25_list_lock).
Shouldn't this be the lock &x25_neigh_list_lock as in x25_get_neigh(), 
where
x25_neigh_hold() is called?

> 
>         Arnd
> 
> [1]
> https://lore.kernel.org/netdev/CAK8P3a0LdF+aQ1hnZrVKkNBQaum0WqW1jyR7_Eb+JRiwyHWr6Q@mail.gmail.com/

