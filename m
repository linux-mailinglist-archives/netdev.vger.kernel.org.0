Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A30112E75
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfLDPa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:30:29 -0500
Received: from hydra.sdinet.de ([136.243.3.21]:35456 "EHLO mail.sdinet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbfLDPa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 10:30:28 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2019 10:30:28 EST
Received: from aurora64.sdinet.de (aurora64.sdinet.de [193.103.159.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: haegar)
        by mail.sdinet.de (bofa-smtpd) with ESMTPSA id 8D82E3414F5
        for <netdev@vger.kernel.org>; Wed,  4 Dec 2019 16:22:57 +0100 (CET)
Date:   Wed, 4 Dec 2019 16:22:54 +0100 (CET)
From:   Sven-Haegar Koch <haegar@sdinet.de>
To:     netdev@vger.kernel.org
Subject: Endless "ip route show" if 255.255.255.255 route exists
Message-ID: <alpine.DEB.2.21.1912041616460.194530@aurora64.sdinet.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moin,

I see a strange problem on kernel 5.4.0, also exists in 5.3.9, but not 
in 4.19. For now only tried with the Debian binary kernels.

root@haegar-test:~# uname -a
Linux haegar-test 5.4.0-trunk-amd64 #1 SMP Debian 5.4-1~exp1 
(2019-11-26) x86_64 GNU/Linux
root@haegar-test:~# ip -V
ip utility, iproute2-ss191125
(debian 5.4.0-1)


Routing table before test:

root@haegar-test:~# ip ro sh | head -n 10
default via 10.140.184.1 dev ens18
10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244


Adding 255.255.255.255/32 route:

root@haegar-test:~# ip ro add 255.255.255.255/32 dev ens18


Then trying to show the routing table:

root@haegar-test:~# ip ro sh | head -n 10
default via 10.140.184.1 dev ens18
10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
255.255.255.255 dev ens18 scope link
default via 10.140.184.1 dev ens18
10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
255.255.255.255 dev ens18 scope link
default via 10.140.184.1 dev ens18
10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
255.255.255.255 dev ens18 scope link
default via 10.140.184.1 dev ens18 

(Repeats endless without the "head" limit)


The output of "route -n" is correct.

root@haegar-test:~# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use 
Iface
0.0.0.0         10.140.184.1    0.0.0.0         UG    0      0        0 
ens18
10.140.184.0    0.0.0.0         255.255.255.0   U     0      0        0 
ens18
255.255.255.255 0.0.0.0         255.255.255.255 UH    0      0        0 
ens18

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
