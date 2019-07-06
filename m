Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4619060E51
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 02:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfGFAq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 20:46:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44951 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGFAq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 20:46:29 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1hjYqQ-0004Ac-8H; Sat, 06 Jul 2019 00:46:26 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 82FBC5FF68; Fri,  5 Jul 2019 17:46:24 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7D1BF9FA39;
        Fri,  5 Jul 2019 17:46:24 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "Brian J. Murrell" <brian@interlinx.bc.ca>
cc:     netdev@vger.kernel.org
Subject: Re: bonded active-backup ethernet-wifi drops packets
In-reply-to: <8d40b6ed3bf8a7540cff26e3834f0296228d9922.camel@interlinx.bc.ca>
References: <0292e9eefb12f1b1e493f5af8ab78fa00744ed20.camel@interlinx.bc.ca> <8d40b6ed3bf8a7540cff26e3834f0296228d9922.camel@interlinx.bc.ca>
Comments: In-reply-to "Brian J. Murrell" <brian@interlinx.bc.ca>
   message dated "Thu, 04 Jul 2019 11:12:20 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6133.1562373984.1@famine>
Date:   Fri, 05 Jul 2019 17:46:24 -0700
Message-ID: <6134.1562373984@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian J. Murrell <brian@interlinx.bc.ca> wrote:

>On Tue, 2019-06-18 at 14:57 -0400, Brian J. Murrell wrote:
>> Hi.
>> 
>> I have an active-backup bonded connection on a 5.1.6 kernel where the
>> slaves are an Ethernet interface and a wifi interface.  The goal is
>> to
>> have network transparent (i.e. same and IP address on both
>> interfaces)
>> interface which takes advantage of high-speed and low-latency when it
>> can be physically plugged into the wired network but have portability
>> when unplugged through WiFi.
>> 
>> It all works, mostly.  :-/
>> 
>> I find that even when the primary interface, being the Ethernet
>> interface is plugged in and active, the bonded interface will drop
>> packets periodically.
>> 
>> If I down the bonded interface and plumb the Ethernet interface
>> directly, not as a slave of the bonded interface, no such packet
>> dropping occurs.
>> 
>> My measure of packet dropping, is by observing the output of "sudo
>> ping
>> -f <ip_address>.  In less than a few minutes even, on the bonded
>> interface, even with the Ethernet interface as the active slave, I
>> will
>> have a long string of dots indicating pings that were never
>> replied.  On the unbonded Ethernet interface, no dots, even when
>> measured over many days.
>> 
>> My bonding config:
>> 
>> $ cat /proc/net/bonding/bond0
>> Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
>> 
>> Bonding Mode: fault-tolerance (active-backup)
>> Primary Slave: enp0s31f6 (primary_reselect always)
>> Currently Active Slave: enp0s31f6
>> MII Status: up
>> MII Polling Interval (ms): 100
>> Up Delay (ms): 0
>> Down Delay (ms): 0
>> 
>> Slave Interface: enp0s31f6
>> MII Status: up
>> Speed: 1000 Mbps
>> Duplex: full
>> Link Failure Count: 0
>> Permanent HW addr: 0c:54:15:4a:b2:0d
>> Slave queue ID: 0
>> 
>> Slave Interface: wlp2s0
>> MII Status: up
>> Speed: Unknown
>> Duplex: Unknown
>> Link Failure Count: 1
>> Permanent HW addr: 0c:54:15:4a:b2:0d
>> Slave queue ID: 0
>> 
>> Current interface config/stats:
>> 
>> $ ifconfig bond0
>> bond0: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
>>         inet 10.75.22.245  netmask 255.255.255.0  broadcast
>> 10.75.22.255
>>         inet6 fe80::ee66:b8c9:d55:a28f  prefixlen 64  scopeid
>> 0x20<link>
>>         inet6 2001:123:ab:123:d36d:5e5d:acc8:e9bc  prefixlen
>> 64  scopeid 0x0<global>
>>         ether 0c:54:15:4a:b2:0d  txqueuelen 1000  (Ethernet)
>>         RX packets 1596206  bytes 165221404 (157.5 MiB)
>>         RX errors 0  dropped 0  overruns 0  frame 0
>>         TX packets 1590552  bytes 162689350 (155.1 MiB)
>>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>> 
>> Devices:
>> 00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection
>> (2) I219-LM (rev 31)
>> 02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275
>> (rev 78)
>> 
>> Happy to provide any other useful information.
>> 
>> Any ideas why the dropping, only when using the bonded interface?
>
>Wondering if I have the wrong list with this question.  Is there a list
>where this question would be more on-topic or focused?

	Not that I'm aware of; netdev is where bonding development
discussions and such take place.

>Perhaps I didn't provide enough information?  I am happy to provide
>whatever is needed.  I just don't know what more is needed at this
>point.

	I did set this up and test it, but haven't had time to analyze
in depth.

	What I saw was that ping (IPv4) flood worked fine, bonded or
not, over a span of several hours.  However, ping6 showed small numbers
of drops on a ping6 flood when bonded, on the order of 200 drops out of
48,000,000 requests sent.  Zero losses when no bond in the stack.  Both
tests to the same peer connected to the same switch.  All of the above
with the bond using the Ethernet slave.  I haven't tracked down where
those losses are occurring, so I don't know if it's on the transmit or
receive sides (or both).

	I did this testing on a laptop with iwlwifi (Centrino 6205) and
an e1000e (82579LM) network device, using the a kernel built from
net-next as of earlier this week (it claimed to be 5.2.0-rc5+).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
