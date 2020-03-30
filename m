Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0867619834D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgC3SXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:23:50 -0400
Received: from mail.thelounge.net ([91.118.73.15]:63701 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgC3SXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:23:50 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 48rgnt2TWgzXMK;
        Mon, 30 Mar 2020 20:23:46 +0200 (CEST)
Subject: Re: 5.6: how to enable wireguard in "make menuconfig"
To:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
References: <439d7aec-3052-bbfc-94b9-2f85085e4976@thelounge.net>
 <e8da71fe-cee8-77ac-ccbc-93478beaf998@infradead.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <c362619a-4219-ce2b-093f-c3e71b295922@thelounge.net>
Date:   Mon, 30 Mar 2020 20:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e8da71fe-cee8-77ac-ccbc-93478beaf998@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 30.03.20 um 19:10 schrieb Randy Dunlap:
> On 3/30/20 1:37 AM, Reindl Harald wrote:
>> https://i.imgur.com/jcH9Xno.png
>> https://www.wireguard.com/compilation/
>>
>> crypto wise i have in the meantime enabled everything and the same in
>> "networking options"
>>
>> but "IP: WireGuard secure network tunnel" still don#t appear anywhere :-(
>>
> 
> In menuconfig, go to Device Drivers and then
> Network Device support. It should look like this:
> 
>   │ │    --- Network device support                                       │ │  
>   │ │    [*]   Network core driver support                                │ │  
>   │ │    < >     Bonding driver support                                   │ │  
>   │ │    < >     Dummy net driver support                                 │ │  
>   │ │    < >     WireGuard secure network tunnel
> 
> 
> but it requires Networking support and Network Devices and INET (TCP/IP)

thanks, i figured it out in the meantime

all the howtows with "Address" in [interface] like
https://wiki.archlinux.org/index.php/WireGuard don't work

figured that also out in my nested Vmware ESXi setup (firewall, clients,
wan) within Vmware Workstation :-)

seems to work like a charm with "ExecStart=/usr/sbin/ip route add
172.16.0.0/24 via 10.10.10.1 dev vpn-client" on the lcient side

---------------------------

[Unit]
Description=VPN Server
After=network-up.service

[Service]
Type=oneshot
RemainAfterExit=yes
PrivateTmp=yes
ProtectHome=yes
ProtectSystem=strict
ReadWritePaths=-/run
ReadWritePaths=-/tmp
ReadWritePaths=-/var/tmp

ExecStart=/usr/sbin/ip link add vpn type wireguard
ExecStart=/usr/sbin/ip addr add 10.10.10.1/255.255.255.0 dev vpn
ExecStart=/usr/sbin/ip link set dev vpn up
ExecStart=/usr/bin/wg addconf vpn /etc/wireguard/vpn-server.conf

ExecStop=-/usr/sbin/ip link del vpn

[Install]
WantedBy=multi-user.target

---------------------------

# HOWTO GENERATE KEYS:
# umask 077; wg genkey | tee privatekey | wg pubkey > publickey
# wg genpsk > preshared

[Interface]
ListenPort = 51000
PrivateKey = ******

[Peer]
PublicKey  = +7k1cHdFoo47OfZOsauj0b7gfL/CEIUbgcx4tJK77ls=
AllowedIPs = 10.10.10.2/32

---------------------------
