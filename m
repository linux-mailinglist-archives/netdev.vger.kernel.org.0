Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD924211
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 22:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfETUXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 16:23:05 -0400
Received: from mail.maddes.net ([62.75.236.153]:55234 "EHLO mail.maddes.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfETUXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 16:23:05 -0400
Received: from www.maddes.net (zulu1959.startdedicated.de [62.75.236.153])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.maddes.net (Postfix) with ESMTPSA id 45CEB40463;
        Mon, 20 May 2019 22:23:04 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 May 2019 22:23:03 +0200
From:   "M. Buecher" <maddes+kernel@maddes.net>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Matthias May <matthias.may@neratec.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: IP-Aliasing for IPv6?
In-Reply-To: <20190515092618.GI22349@unicorn.suse.cz>
References: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
 <20190515092618.GI22349@unicorn.suse.cz>
Message-ID: <d10e40ae062903f15e84c7e3890a0b40@maddes.net>
X-Sender: maddes+kernel@maddes.net
User-Agent: Roundcube Webmail/1.1.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019-05-15 11:26, Michal Kubecek wrote:
> On Tue, May 14, 2019 at 08:49:12PM +0200, M. Buecher wrote:
>> According to the documentation [1] "IP-Aliasing" is an obsolete way to
>> manage multiple IP[v4]-addresses/masks on an interface.
>> For having multiple IP[v4]-addresses on an interface this is 
>> absolutely
>> true.
>> 
>> For me "IP-Aliasing" is still a valid, good and easy way to "group" ip
>> addresses to run multiple instances of the same service with different 
>> IPs
>> via virtual interfaces on a single physical NIC.
>> 
>> Short story:
>> I recently added IPv6 to my LAN setup and recognized that IP-Aliasing 
>> is not
>> support by the kernel.
>> Could IP-Aliasing support for IPv6 be added to the kernel?
> 
> You should probably better explain what is the feature you are using
> with IPv4 but you are missing for IPv6. The actual IP aliasing has been
> removed in kernel 2.2, i.e. 20 years ago. Since then, there is no IP
> aliasing even for IPv4. What exactly works for IPv4 but does not for
> IPv6?

Used feature is the label option of `ip`, which works for IPv4, but not 
with IPv6.

Goal: Use virtual interfaces to run separate instances of a service on 
different IP addresses on the same machine.
For example with dnsmasq I use `-interface ens192` for the normal main 
instance, while using `-interface ens192:0` and `-interfaces ens192:1` 
for special instances only assigned to specific machines via their MAC 
addresses.

What is the correct name when I use the label option of the ip command?
The "IP-Aliasing" doc was the only one I could find on kernel.org that 
fit the way labels are assigned with ip.

I know how to set these labels the following three ways:
a) manual iproute2 commands
ip addr add 192.168.0.1/24 broadcast + dev ens192
ip addr add 192.168.0.90/24 broadcast + label ens192:0 dev ens192
ip addr add 192.168.0.91/24 broadcast + label ens192:1 dev ens192

b) via /etc/network/interfaces
iface ens192 inet static
   address 192.168.0.1/24

iface ens192:0 inet static
   address 192.168.0.90/24

iface ens192:1 inet static
   address 192.168.0.91/24

c) via systemd-networkd
[Address]
Address=192.168.0.1/24

[Address]
Address=192.168.0.90/24
Label=ens192:0

[Address]
Address=192.168.0.91/24
Label=ens192:1

Hope this explains it much better
Matthias

>> Long story:
>> I tried to find out how to do virtual network interfaces "The Right 
>> Way
>> (tm)" nowadays.
>> So I came across MACVLAN, IPVLAN and alike on the internet, mostly in
>> conjunction with containers or VMs.
>> But MACVLAN/IPVLAN do not provide the same usability as "IP-Aliasing", 
>> e.g.
>> user needs to learn a lot about network infrastructre, sysctl 
>> settings,
>> forwarding, etc.
>> They also do not provide the same functionality, e.g. the virtual 
>> interfaces
>> cannot reach their parent interface.
>> 
>> In my tests with MACVLAN (bridge)/IPVLAN (L2) pinging between parent 
>> and
>> virtual devices with `ping -I <device> <target ip>` failed for IPv4 
>> and
>> IPV6.
> 
> This is an interesting observation but also a completely artificial
> example. You should probably explain what is the actual goal you want 
> to
> achieve.
> 
>> Pinging from outside MACVLAN worked fine for IPv4 but not IPv6, while 
>> IPVLAN
>> failed also for pinging with IPv4 to the virtual interfaces. Pinging 
>> to
>> outside only worked from the parent device.
>> Unfortunately I could not find any source on the internet that 
>> describes how
>> to setup MACVLAN/IPVLAN and their surroundings correctly for a single
>> machine. It seems they are just used for containers and VMs.
> 
> That's because containers and VMs are the primary use case (macvlan can
> also make sense if you want to use different MAC address for some
> reason). Otherwise, it should be sufficient to simply assign multiple
> IPv[46] addresses to your interface.
> 
> Michal Kubecek
