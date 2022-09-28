Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C8F5EDEC3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiI1O20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiI1O2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:28:24 -0400
X-Greylist: delayed 901 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Sep 2022 07:28:20 PDT
Received: from pm.theglu.org (pm.theglu.org [5.39.81.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99CFAB05D;
        Wed, 28 Sep 2022 07:28:20 -0700 (PDT)
Received: from pm.theglu.org (localhost [127.0.0.1])
        by pm.theglu.org (Postfix) with ESMTP id 1A4C3400D6;
        Wed, 28 Sep 2022 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=theglu.org; h=message-id
        :date:mime-version:from:subject:to:cc:content-type
        :content-transfer-encoding; s=postier; bh=0q+mQXOvVlS/bsQ+pcFcyb
        Vrrl0=; b=lrBhGH/X5n5qpnZ+ACyXZ5z9O14kh4ALeq4KNfxBf6mSDHug8gn0rf
        UsEFTHaHt/wMGnXV1/yBbLFby78eJPaDxoN9Q7L/aiiiUsDWQb8tEhobxjnUCrMF
        JMz8QUpQ6PsXIMI5y9K5e3ABIXVFrtYUdkiCLs3Wo5Sx+MBu/MJPw=
Received: from [10.0.17.2] (people.swisscom.puidoux-infra.ch [146.4.119.107])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by pm.theglu.org (Postfix) with ESMTPSA id 9B65040095;
        Wed, 28 Sep 2022 14:02:44 +0000 (UTC)
Message-ID: <98348818-28c5-4cb2-556b-5061f77e112c@arcanite.ch>
Date:   Wed, 28 Sep 2022 16:02:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Maximilien Cuony <maximilien.cuony@arcanite.ch>
Subject: [REGRESSION] Unable to NAT own TCP packets from another VRF with
 tcp_l3mdev_accept = 1
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Language: en-US-large
Organization: Arcanite Solutions SARL
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We're using VRF with a machine used as a router and have a specific 
issue where the router doesn't handle his own packets correctly during 
NATing if the packet is coming from a different VRF.

We had the issue with debian buster (4.19), but the issue solved itself 
when we updated to debian bullseye (5.10.92).

However, during an upgrade of debian bullseye to the latest kernel, the 
issue appeared again (5.10.140).

We did a bisection and this leaded us to 
"b0d67ef5b43aedbb558b9def2da5b4fffeb19966 net: allow unbound socket for 
packets in VRF when tcp_l3mdev_accept set [ Upstream commit 
944fd1aeacb627fa617f85f8e5a34f7ae8ea4d8e ]".

Simplified case setup:

There is two machines in the setup. They both forward packets 
(net.ipv4.ip_forward = 1) and there is two interface between them.

The main machine has two VRF. The default VRF is using the second 
machine as the default route, on a specific interface.
The second machine has as default route to main machine, on the other 
VRF using the second pair of interfaces.

On the main machine, the second interface is in a specific VRF. In that 
VRF, packets are NATed to the internet on a third interface.

A visual schema with the normal flow is available there: 
https://etinacra.ch/kernel.png

Configuration command:

Main machine:
sysctl -w net.ipv4.tcp_l3mdev_accept = 1
sysctl -w systnet.ipv4.ip_forward = 1
iptables -t raw -A PREROUTING -i eth0 -j CT --zone 5
iptables -t raw -A OUTPUT -o eth0 -j CT --zone 5
iptables -t nat -A POSTROUTING -o eth2 -j SNAT --to 192.168.1.1
cat /etc/network/interfaces

auto firewall
iface firewall
     vrf-table 1200

auto eth0
iface eth0
     address 192.168.5.1/24
     gateway 192.168.5.2

auto eth1
iface eth1
     address 192.168.10.1/24
     vrf firewall
     up ip route add 192.168.5.0/24 via 192.168.10.2 vrf firewall

auto eth2
iface eth2
     address 192.168.1.1/24
     gateway 192.168.1.250
     vrf firewall

==

Second machine:

sysctl -w net.ipv4.ip_forward = 1

cat /etc/network/interfaces

auto eth0
iface eth0
     address 192.168.5.2/24

auto eth1
iface eth1
     address 192.168.10.2/24
     gateway 192.168.10.1

==

Without issue, if we look at a tcpdump on all interface on the main 
machine, everything is fine (output truncated):

10:28:32.811283 eth0 Out IP 192.168.5.1.55750 > 99.99.99.99.80: Flags 
[S], seq 2216112145
10:28:32.811666 eth1 In  IP 192.168.5.1.55750 > 99.99.99.99.80: Flags 
[S], seq 2216112145
10:28:32.811679 eth2 Out IP 192.168.1.1.55750 > 99.99.99.99.80: Flags 
[S], seq 2216112145
10:28:32.835138 eth2 In  IP 99.99.99.99.80 > 192.168.1.1.55750: Flags 
[S.], seq 383992840, ack 2216112146
10:28:32.835152 eth1 Out IP 99.99.99.99.80 > 192.168.5.1.55750: Flags 
[S.], seq 383992840, ack 2216112146
10:28:32.835457 eth0 In  IP 99.99.99.99.80 > 192.168.5.1.55750: Flags 
[S.], seq 383992840, ack 2216112146
10:28:32.835511 eth0 Out IP 192.168.5.1.55750 > 99.99.99.99.80: Flags 
[.], ack 1, win 502

However when the issue is present, the SYNACK does arrives on eth2, but 
is never "unNATed" back to eth1:

10:25:07.644433 eth0 Out IP 192.168.5.1.48684 > 99.99.99.99.80: Flags 
[S], seq 3207393154
10:25:07.644782 eth1 In  IP 192.168.5.1.48684 > 99.99.99.99.80: Flags 
[S], seq 3207393154
10:25:07.644793 eth2 Out IP 192.168.1.1.48684 > 99.99.99.99.80: Flags 
[S], seq 3207393154
10:25:07.668551 eth2 In  IP 54.36.61.42.80 > 192.168.1.1.48684: Flags 
[S.], seq 823335485, ack 3207393155

The issue is only with TCP connections. UDP or ICMP works fine.

Turing off net.ipv4.tcp_l3mdev_accept back to 0 also fix the issue, but 
we need this flag since we use some sockets that does not understand VRFs.

We did have a look at the diff and the code of inet_bound_dev_eq, but we 
didn't understand much the real problem - but it does seem now that 
bound_dev_if if now checked not to be False before the bound_dev_if == 
dif || bound_dev_if == sdif comparison, something that was not the case 
before (especially since it's dependent on l3mdev_accept).

Maybe our setup is wrong and we should not be able to route packets like 
that?

Thanks a lot and have a nice day!

Maximilien Cuony


