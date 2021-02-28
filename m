Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2123274A7
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 22:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhB1VkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 16:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhB1Vj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 16:39:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D050C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 13:39:18 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lGTmU-0008TD-Rw; Sun, 28 Feb 2021 22:39:14 +0100
Date:   Sun, 28 Feb 2021 22:39:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     William Chen <williamchen32335@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: rename the command ip
Message-ID: <20210228213914.GS22016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        William Chen <williamchen32335@gmail.com>, netdev@vger.kernel.org
References: <6039381f.1c69fb81.45e6d.4dea@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6039381f.1c69fb81.45e6d.4dea@mx.google.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

William,

[Cc'ing netdev list as that's the place to discuss iproute2
development.]

On Fri, Feb 26, 2021 at 12:04:12PM -0600, William Chen wrote:
> I see your excellent contributions to iproute2. I hope that you are well.

Thanks!

> But I have to say the command name "ip" is not good. It renders the command ungoogleable. Why not give it a more googleable name in the first place? Maybe just iproute2? If it is too long, then maybe iprt2?

Well, first of all, this is not my decision to make. Stephen Hemminger
maintains the project, he's the one to ask about such a thing. Apart
from that, renaming a tool because (some)one fails to google it is a
stupid idea: Existing resources won't change spontaneously, also people
will continue to use the old name as they are used to it so you won't
find anything in the future, either.

> The `ip route show` result is not a column-wise format making it hard to see the alignment. In the aspect of output representation, it is worse than both route and netstat.
> 
> $ ip route show
> default via 192.168.1.1 dev eth0 proto dhcp metric 100
> 10.6.0.0/17 dev tun0 proto kernel scope link src 10.6.49.100
> 10.10.0.0/16 via 10.6.0.1 dev tun0 metric 1000
> 192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.104 metric 100

You could implement 'brief' output support for ip-route, it is available
for ip-addr and ip-link:

| % ip -br a s
| lo               UNKNOWN        127.0.0.1/8 ::1/128 
| e1000            UP             fe80::215:17ff:fe0b:bf49/64 
| enp34s0          DOWN           fe80::2d8:61ff:fea7:d2fa/64 
| % ip -br l sh
| lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
| e1000            UP             00:15:17:0b:bf:49 <BROADCAST,MULTICAST,UP,LOWER_UP> 
| enp34s0          DOWN           00:d8:61:a7:d2:fa <NO-CARRIER,BROADCAST,MULTICAST,UP> 


> Anyway, the `ip route show` result seems to be different from `route` and `netstat`. Where are, Flags, MSS, Window, Ref and Use?
> 
> $ route -n
> Kernel IP routing table
> Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
> 0.0.0.0         192.168.1.1     0.0.0.0         UG    100    0        0 eth0
> 10.6.0.0        0.0.0.0         255.255.128.0   U     0      0        0 tun0
> 10.10.0.0       10.6.0.1        255.255.0.0     UG    1000   0        0 tun0
> 192.168.1.0     0.0.0.0         255.255.255.0   U     100    0        0 eth0
> $ netstat -rn
> Kernel IP routing table
> Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
> 0.0.0.0         192.168.1.1     0.0.0.0         UG        0 0          0 eth0
> 10.6.0.0        0.0.0.0         255.255.128.0   U         0 0          0 tun0
> 10.10.0.0       10.6.0.1        255.255.0.0     UG        0 0          0 tun0
> 192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth0

Call 'ip -d r s' to see the route type ('U' flag above). 'G' flag is
redundant, assume it's present if a route contains 'via <IP>'. MSS,
Window, Ref and Use are all zero in your output, are they still
relevant?

> The output of `ip route show` is also not of a fixed number of fields. How to interpret what are of a field and what are not of a field?
> 
> $ ip route show | exec awk -e '{ print NF }'
> 9
> 9
> 7
> 11
> 
> Is there a way to make the output maybe in TSV format (or at least in a column-wise format) so that the command `column` can be used to make the output easier to read?

Have a look at '-json' option if you want to parse the output.

> Your help is much appreciated! I look forward to hearing from you. Thanks.
> 
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.

Luckily I'm the intended recipient so I may choose to disclose the
content (e.g. to a mailing list).

Cheers, Phil
