Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95D62BC56D
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 12:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgKVLmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 06:42:25 -0500
Received: from correo.us.es ([193.147.175.20]:33206 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbgKVLmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 06:42:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C03553D26B
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 12:42:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E735DA722
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 12:42:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64ABADA84A; Sun, 22 Nov 2020 12:42:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36DC1DA704;
        Sun, 22 Nov 2020 12:42:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 22 Nov 2020 12:42:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1549141FF201;
        Sun, 22 Nov 2020 12:42:20 +0100 (CET)
Date:   Sun, 22 Nov 2020 12:42:19 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, fw@strlen.de,
        razor@blackwall.org, jeremy@azazel.net, tobias@waldekranz.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,v5 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201122114219.GA27397@salvia>
References: <20201122102605.2342-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201122102605.2342-1-alobakin@pm.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 10:26:16AM +0000, Alexander Lobakin wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Fri, 20 Nov 2020 13:49:12 +0100
[...]
> > Something like this:
> > 
> >                        fast path
> >                 .------------------------.
> >                /                          \
> >                |           IP forwarding   |
> >                |          /             \  .
> >                |       br0               eth0
> >                .       / \
> >                -- veth1  veth2
> >                    .
> >                    .
> >                    .
> >                  eth0
> >            ab:cd:ef:ab:cd:ef
> >                   VM
> 
> I'm concerned about bypassing vlan and bridge's .ndo_start_xmit() in
> case of this shortcut. We'll have incomplete netdevice Tx stats for
> these two, as it gets updated inside this callbacks.

TX device stats are being updated accordingly.

# ip netns exec nsr1 ip -s link
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast   
    0          0        0       0       0       0       
    TX: bytes  packets  errors  dropped carrier collsns 
    0          0        0       0       0       0       
2: veth0@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 82:0d:f3:b5:59:5d brd ff:ff:ff:ff:ff:ff link-netns ns1
    RX: bytes  packets  errors  dropped overrun mcast   
    213290848248 4869765  0       0       0       0       
    TX: bytes  packets  errors  dropped carrier collsns 
    315346667  4777953  0       0       0       0       
3: veth1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 4a:81:2d:9a:02:88 brd ff:ff:ff:ff:ff:ff link-netns ns2
    RX: bytes  packets  errors  dropped overrun mcast   
    315337919  4777833  0       0       0       0       
    TX: bytes  packets  errors  dropped carrier collsns 
    213290844826 4869708  0       0       0       0       
4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 82:0d:f3:b5:59:5d brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    4101       73       0       0       0       0       
    TX: bytes  packets  errors  dropped carrier collsns 
    5256       74       0       0       0       0       
5: veth0.10@veth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 82:0d:f3:b5:59:5d brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    4101       73       0       0       0       62      
    TX: bytes  packets  errors  dropped carrier collsns 
    315342363  4777893  0       0       0       0       

