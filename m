Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C27B0DF7
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbfILLh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:37:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfILLh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:37:26 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A1E3142387A1;
        Thu, 12 Sep 2019 04:37:21 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:37:17 +0200 (CEST)
Message-Id: <20190912.133717.257813019167130934.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com, jay.vosburgh@canonical.com
Subject: Re: [PATCH net v2 01/11] net: core: limit nested device depth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAMArcTWMjTsZB8Ssx+hVMK-3-XozZw7AqVE62-H+zrJ+doC5Lw@mail.gmail.com>
References: <CAMArcTV-Qvfd7xA0huCh_dbtr7P4LA+cQ7CpnaBBhdq-tq5fZQ@mail.gmail.com>
        <20190912.113807.52193745382103083.davem@davemloft.net>
        <CAMArcTWMjTsZB8Ssx+hVMK-3-XozZw7AqVE62-H+zrJ+doC5Lw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 04:37:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu, 12 Sep 2019 19:14:37 +0900

> On Thu, 12 Sep 2019 at 18:38, David Miller <davem@davemloft.net> wrote:
>>
>> From: Taehee Yoo <ap420073@gmail.com>
>> Date: Thu, 12 Sep 2019 12:56:19 +0900
>>
>> > I tested with this reproducer commands without lockdep.
>> >
>> >     ip link add dummy0 type dummy
>> >     ip link add link dummy0 name vlan1 type vlan id 1
>> >     ip link set vlan1 up
>> >
>> >     for i in {2..200}
>> >     do
>> >             let A=$i-1
>> >
>> >             ip link add name vlan$i link vlan$A type vlan id $i
>> >     done
>> >     ip link del vlan1 <-- this command is added.
>>
>> Is there any other device type which allows arbitrary nesting depth
>> in this manner other than VLAN?  Perhaps it is the VLAN nesting
>> depth that we should limit instead of all of this extra code.
> 
> Below device types have the same problem.
> VLAN, BONDING, TEAM, VXLAN, MACVLAN, and MACSEC.
> All the below test commands reproduce a panic.

I think then we need to move the traversals over to a iterative
rather than recursive algorithm.
