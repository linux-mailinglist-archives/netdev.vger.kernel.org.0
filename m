Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5F82AC05
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfEZUNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 16:13:13 -0400
Received: from mail.maddes.net ([62.75.236.153]:39831 "EHLO mail.maddes.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfEZUNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 16:13:13 -0400
Received: from www.maddes.net (zulu1959.startdedicated.de [62.75.236.153])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.maddes.net (Postfix) with ESMTPSA id D4B3540463;
        Sun, 26 May 2019 22:13:11 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 26 May 2019 22:13:11 +0200
From:   "M. Buecher" <maddes+kernel@maddes.net>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?Q?Toke_H=C3=B8iland-J?= =?UTF-8?Q?=C3=B8rgensen?= 
        <toke@redhat.com>
Subject: Re: IP-Aliasing for IPv6? (actually "labels")
In-Reply-To: <20190520205358.GB25473@unicorn.suse.cz>
References: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
 <20190515092618.GI22349@unicorn.suse.cz>
 <d10e40ae062903f15e84c7e3890a0b40@maddes.net>
 <20190520205358.GB25473@unicorn.suse.cz>
Message-ID: <250540ba499b95437d0811c246eb5a7a@maddes.net>
X-Sender: maddes+kernel@maddes.net
User-Agent: Roundcube Webmail/1.1.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019-05-20 22:53, Michal Kubecek wrote:
> On Mon, May 20, 2019 at 10:23:03PM +0200, M. Buecher wrote:
>> Used feature is the label option of `ip`, which works for IPv4, but 
>> not with
>> IPv6.
> 
> The only reason for having these labels is to allow old tools like
> ifconfig to partially work even if the underlying implementation
> changed. There is no need for labels with IPv6 as even ifconfig (and 
> the
> ioctl interface it uses) does not pretend there are virtual interfaces
> and 1:1 mapping between interfaces and addresses and usess add/remove 
> to
> add or remove addresses to/from the list.
> 
>> Goal: Use virtual interfaces to run separate instances of a service on
>> different IP addresses on the same machine.
>> For example with dnsmasq I use `-interface ens192` for the normal main
>> instance, while using `-interface ens192:0` and `-interfaces ens192:1` 
>> for
>> special instances only assigned to specific machines via their MAC
>> addresses.
> 
> Configuration syntax based on "listening on an interface" is in most
> cases a historical relic because  this "interface" is just used to get
> the address the daemon is to listen on (bind the listening socket to).
> Most daemons support also identifying the listening address(es) 
> directly
> which should be preferred as then your configuration matches what the
> daemon is actually doing. (There are exceptions, e.g. "ping -I eth1"
> does something different than "ping -I 1.2.3.4" but these are rather
> rare.) Any daemon supporting IPv6 should definitely support setting the
> listening address(es) directly.

"Listening on an interface" is extremly convenient: configure/change ip 
addresses on the "label", then just reload/signal the services.
No tedious tasks needed to define each and every IP address (v4+v6) for 
each and every service.
Therefore I prefer the "oldschool" way of "listening on an interface".
Especially with the standard multi-homing of IPv6 I still vote for the 
old style and introducing labels also for IPv6.

Otherwise I just have to obey the decisions of the Kernel team and adopt 
my setups.
All explanation have been much appreciated from everybody that answered. 
This helped me to understand the topic much better. Thanks a lot.

Btw today ping doesn't work anymore with "labels", e.g. "-I eth0:0", as 
it incorrectly assumes an IP address due to the colon, although an IPv6 
address has always at least two colons in it (::1, 
2001:0DB8:3:4:1:2:3:4)

>> What is the correct name when I use the label option of the ip 
>> command?
>> The "IP-Aliasing" doc was the only one I could find on kernel.org that 
>> fit
>> the way labels are assigned with ip.
> 
> They are just labels. The term "IP aliasing" denotes the older
> implementation in 2.0 kernels where there were actual virtual
> interfaces, allowing you to assign the extra addresses to them. Since
> kernel 2.2, it's no longer the case, there is just the actual interface
> and it has a list of IPv4 addresses.
> 
>                                                          Michal Kubecek
