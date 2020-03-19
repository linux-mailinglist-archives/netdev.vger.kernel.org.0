Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC818C0CF
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgCSTwb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Mar 2020 15:52:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49002 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCSTwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:52:31 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jF1DN-0000I7-4o; Thu, 19 Mar 2020 19:52:25 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 4A7F3630E4; Thu, 19 Mar 2020 12:52:23 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 42A95AC1DD;
        Thu, 19 Mar 2020 12:52:23 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH net] ipv6: don't auto-add link-local address to lag ports
In-reply-to: <CAKfmpScXTnnz6wQK3OZcqw4aM1PaLnBRfQL769JgyR7tgM-u5A@mail.gmail.com>
References: <20200318140605.45273-1-jarod@redhat.com> <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com> <CAKfmpSc0yea5-OfE1rnVdErDTeOza=owbL00QQEaH-M-A6Za7g@mail.gmail.com> <25629.1584564113@famine> <CAKfmpScbzEZAEw=zOEwguQJvr6L2fQiGmAY60SqSBQ_g-+B4tw@mail.gmail.com> <3dbabf42-90e6-4c82-0b84-d1b1a9e8fadf@gmail.com> <CAKfmpScXTnnz6wQK3OZcqw4aM1PaLnBRfQL769JgyR7tgM-u5A@mail.gmail.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Thu, 19 Mar 2020 15:29:51 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7027.1584647543.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 19 Mar 2020 12:52:23 -0700
Message-ID: <7028.1584647543@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>On Thu, Mar 19, 2020 at 1:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> On 3/19/20 9:42 AM, Jarod Wilson wrote:
>>
>> > Interesting. We'll keep digging over here, but that's definitely not
>> > working for this particular use case with OVS for whatever reason.
>>
>> I did a quick test and confirmed that my bonding slaves do not have link-local addresses,
>> without anything done to prevent them to appear.
>>
>> You might add a selftest, if you ever find what is the trigger :)
>
>Okay, have a basic reproducer, courtesy of Marcelo:
>
># ip link add name bond0 type bond
># ip link set dev ens2f0np0 master bond0
># ip link set dev ens2f1np2 master bond0
># ip link set dev bond0 up
># ip a s
>1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
>group default qlen 1000
>    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>    inet 127.0.0.1/8 scope host lo
>       valid_lft forever preferred_lft forever
>    inet6 ::1/128 scope host
>       valid_lft forever preferred_lft forever
>2: ens2f0np0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
>mq master bond0 state UP group default qlen 1000
>    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
>5: ens2f1np2: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
>mq master bond0 state DOWN group default qlen 1000
>    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
>11: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc
>noqueue state UP group default qlen 1000
>    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
>    inet6 fe80::20f:53ff:fe2f:ea40/64 scope link
>       valid_lft forever preferred_lft forever
>
>(above trimmed to relevant entries, obviously)
>
># sysctl net.ipv6.conf.ens2f0np0.addr_gen_mode=0
>net.ipv6.conf.ens2f0np0.addr_gen_mode = 0
># sysctl net.ipv6.conf.ens2f1np2.addr_gen_mode=0
>net.ipv6.conf.ens2f1np2.addr_gen_mode = 0
>
># ip a l ens2f0np0
>2: ens2f0np0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
>mq master bond0 state UP group default qlen 1000
>    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
>    inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
>       valid_lft forever preferred_lft forever
># ip a l ens2f1np2
>5: ens2f1np2: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
>mq master bond0 state DOWN group default qlen 1000
>    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
>    inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
>       valid_lft forever preferred_lft forever
>
>Looks like addrconf_sysctl_addr_gen_mode() bypasses the original "is
>this a slave interface?" check, and results in an address getting
>added, while w/the proposed patch added, no address gets added.

	I wonder if this also breaks for the netvsc usage of IFF_SLAVE
to suppress ipv6 addrconf?  Adding the hyperv maintainers to Cc.

	In any event, it looks like addrconf_sysctl_addr_gen_mode()
calls addrconf_dev_config() directly, which bypasses the IFF_SLAVE check
in addrconf_notify() that would gate other callers.

	From my reading, your patch appears to cover a superset of cases
as compared to the existing IFF_SLAVE test from c2edacf80e15.

>Looking back through git history again, I see a bunch of 'Fixes:
>d35a00b8e33d ("net/ipv6: allow sysctl to change link-local address
>generation mode")' patches, and I guess that's where this issue was
>also introduced.

	Can the problem be induced via ip link set ... addrgenmode ?
That functionality predates the sysctl interface, looks like it was
introduced with

bc91b0f07ada ipv6: addrconf: implement address generation modes

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
