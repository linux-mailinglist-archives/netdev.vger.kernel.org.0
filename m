Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BECC2F8524
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbhAOTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbhAOTKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:10:36 -0500
X-Greylist: delayed 394 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jan 2021 11:09:55 PST
Received: from forward106p.mail.yandex.net (forward106p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F1EC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 11:09:55 -0800 (PST)
Received: from myt6-3955a48a7d81.qloud-c.yandex.net (myt6-3955a48a7d81.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1eae:0:640:3955:a48a])
        by forward106p.mail.yandex.net (Yandex) with ESMTP id B42391C807B5
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 22:03:18 +0300 (MSK)
Received: from myt4-ee976ce519ac.qloud-c.yandex.net (myt4-ee976ce519ac.qloud-c.yandex.net [2a02:6b8:c00:1da4:0:640:ee97:6ce5])
        by myt6-3955a48a7d81.qloud-c.yandex.net (mxback/Yandex) with ESMTP id CMFfm9P9Nk-3ID0erdC;
        Fri, 15 Jan 2021 22:03:18 +0300
Authentication-Results: myt6-3955a48a7d81.qloud-c.yandex.net; dkim=pass
Received: by myt4-ee976ce519ac.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id pavOlJqdJS-3HI4Pd4x;
        Fri, 15 Jan 2021 22:03:17 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   <diniboy@travitia.xyz>
To:     <netdev@vger.kernel.org>
Subject: Potential bug with uidrange based routing over IPv6
Date:   Fri, 15 Jan 2021 20:03:17 +0100
Message-ID: <000201d6eb71$15c74120$4155c360$@travitia.xyz>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdbrcRU88GpJBJ0fQ1ewoYyTzzWaNQ==
Content-Language: hu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day,
 
I have recently tried to set up a Hurricane Electronic IPv6 tunnel
(https://tunnelbroker.net) as they provide a /48 block whilst my hosting
provider doesn't support IPv6 out of the box. They offered the following
commands to establish a connection:
 
modprobe ipv6
ip tunnel add he-ipv6 mode sit remote heipv4washere local myipv4washere ttl
255
ip link set he-ipv6 up
ip addr add 2001:470:1f0a:1394::2/64 dev he-ipv6
ip route add ::/0 dev he-ipv6
ip -f inet6 addr
 
I didn't quite like this approach as this adds a default route that will be
used everywhere then and most of my services will keep using the tunnel too
for their traffic instead of using the IPv4 address over my physical network
interface. I simply just wanted to have the opportunity to run specific
daemons with ipv6 support but didn't want to have it applied the whole
server wide. So I decided to create a user called ipv6 and wanted to use
uidrange to define the default routing for it:
 
adduser ipv6; id ipv6 # outputs 1004 as gid and 1005 as uid in my case
modprobe ipv6
ip tunnel add he-ipv6 mode sit remote heipv4washere local myexternalipv4 ttl
255
ip link set he-ipv6 up
ip addr add 2001:470:1f0a:1394::2/64 dev he-ipv6
# the commands above this line were untouched and copied from the he
recommended config
ip -6 rule add uidrange 1004-1004 table he-ipv6
ip -6 rule add default dev he-ipv6 table he-ipv6
 
And then if I log in as the ipv6 user, ping6 shows a 100% packet loss to
Google's IPv6 address. A HTTP GET curl request with the -6 flag to their
direct IP also hangs indefinitely. However if I use "from all" instead of
the uidrange, everything starts to work as expected though then all traffic
is routed not just the specific user's. I confirmed the same setup works
with a wireguard based IPv4 VPN. So I assume IPv6 is broken with uidrange.
Could you confirm that it's indeed the case?
 
Might be useful for debugging:
 
# ip -6 rule list
0: from all lookup local
32765: from all uidrange 1004-1004 lookup he-ipv6
32766: from all lookup main
 
(I have also tried setting the uidrange rule's priority to 60000, same issue
with the packet loss)
 
# ip -6 rule list table he-ipv6
32765: from all uidrange 1004-1004 lookup he-ipv6
 
My "ip6tables-save -c" is literally empty therefore I don't think it's worth
pasting here. I use Fedora Server 32 with kernel version
5.9.13-100.fc32.x86_64 and firewalld + selinux active. Altough I have tried
disabling selinux and the issue still persist there.
 
Thank you!
 
PS: Apologies if something wasn't clear, it is my first time writing to this
mailing list and neither am I a network nerd. Feel free to ask for further
command outputs if needed!

