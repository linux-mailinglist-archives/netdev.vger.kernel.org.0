Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796973302C2
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 16:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhCGPtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 10:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhCGPsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 10:48:36 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8D6C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 07:48:36 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id p7so3695486eju.6
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 07:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gXXbjX2Ys9JmaoxhXO7zxuffwzApD/JRZz4GZ5z4P20=;
        b=Pgo6TOaGYzOB/SRRPPsa+ZZHAB/WFGZ2iQo4yfFNgk2fSl+IvaQ/E7I7BKVH9TZzIa
         UdvrZSzJGBtQ0fjjAPLaPo+hCqwpzUsVJrslKh6gtn3S8oS4DHKTgGCElqFvAajEdrO5
         t7sfXZM/fcmZ77XxwOJHe5UsUjBHDntgaWaRD9bnRLz8flqCoCQQZULboXLhBXeGD3a6
         RVClFN+VqgJL9Q4ZzTfTckEBm3saXnItz20RbNOvt7PoPxvP0pK1h0NNmOUhTC9PsmNU
         sgWa++Q6GrkinOIaAwqg1EgKttg7VQcxcReGRYw1/Mkq+tCTKCd4DLFWgZ4mtugIwrWX
         Hmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gXXbjX2Ys9JmaoxhXO7zxuffwzApD/JRZz4GZ5z4P20=;
        b=PjlCDcISX+ua7MX9GD1yGi6xEwgdLugtSQQGjUvf+S8XB+lz5bm/REQxBzGBPAUtrW
         bj+zbKbyyg1Kt2cw5VuBRJh9NQcTmuwRlqJeU7GjRnAMCHpXR7KdI3RgoJa7uRsphEDE
         WcFo/Jeb1kCflpgkOtIYMvSG2hads76WSAcVXsSKHBnGlmYhnNxv0J8Kb+S52p4Aahbt
         hNwlCdtLJk83objNcYqoNrgJhGw4p1B9G94FMkRiBhF6eq1b1tdGiE6BNYJE8Yos1/8g
         Snyoc7Mn8+xSYPPHygEDJcCGyQieQSmSiQl6jypeuu7HQvjCwuG5KVL+rnRHqoQ+//HK
         s3mQ==
X-Gm-Message-State: AOAM5301nlEhDPc/P8FHGlOHmqk8ozz1VTsqoApS4YtMYFTeGzrNuSkj
        9N4zrFlr3F5U0nFvm+RkZss=
X-Google-Smtp-Source: ABdhPJzkiAws4fkqlnzAf5dSWNwZUcaJFXMsdq0DXflHjD/3kjMfNtQr+0AOFwlgzd/H33f8lg+4/A==
X-Received: by 2002:a17:907:1b1c:: with SMTP id mp28mr10946751ejc.243.1615132113746;
        Sun, 07 Mar 2021 07:48:33 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id k26sm5141257ejx.81.2021.03.07.07.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 07:48:33 -0800 (PST)
Date:   Sun, 7 Mar 2021 17:48:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net] net: dsa: fix switchdev objects on bridge master
 mistakenly being applied on ports
Message-ID: <20210307154832.wcmbw7imachkdc3y@skbuf>
References: <20210307102156.2282877-1-olteanv@gmail.com>
 <874khnq9hh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874khnq9hh.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 04:17:14PM +0100, Tobias Waldekranz wrote:
> Please wait before applying.
> 
> I need to do some more testing later (possibly tomorrow). But I am
> pretty sure that this patch does not work with the (admittedly somewhat
> exotic) combination of:
> 
> - Non-offloaded LAG
> - Bridge with VLAN filtering enabled.
> 
> When adding the LAG to the bridge, I get an error because mv88e6xxx
> tries to add VLAN 1 to the ports (which it should not do as the LAG is
> not offloaded).

Weird, how are you testing, and why does it attempt to add VLAN 1? Is it
the mv88e6xxx driver itself that does this? Where from?

The following is my test procedure:

cat ./test_bond_no_offload.sh
#!/bin/bash

ip link del bond0
for eth in swp0 swp1 swp2; do ip link set $eth down; done
ip link add bond0 type bond mode broadcast
ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master bond0
ip link set swp1 master bond0
ip link set swp2 master br0
ip link set bond0 master br0
for eth in swp0 swp1 swp2 bond0 br0; do ip link set $eth up; done

./test_bond_no_offload.sh
[   27.004206] bond0 (unregistering): Released all slaves
[   27.068440] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii link mode
[   27.077811] 8021q: adding VLAN 0 to HW filter on device swp0
[   27.083728] bond0: (slave swp0): Enslaving as an active interface with an up link
Warning: dsa_core: Offloading not supported.
[   27.095035] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii link mode
[   27.104073] 8021q: adding VLAN 0 to HW filter on device swp1
[   27.109948] bond0: (slave swp1): Enslaving as an active interface with an up link
Warning: dsa_core: Offloading not supported.
[   27.120214] br0: port 1(swp2) entered blocking state
[   27.125407] br0: port 1(swp2) entered disabled state
[   27.131738] mscc_felix 0000:00:00.5: dsa_port_vlan_filtering: port 2 vlan_filtering 1
[   27.139625] mscc_felix 0000:00:00.5 swp2: dsa_slave_vlan_add: vid 1
[   27.149223] br0: port 2(bond0) entered blocking state
[   27.154341] br0: port 2(bond0) entered disabled state
[   27.159600] device bond0 entered promiscuous mode
[   27.164340] device swp0 entered promiscuous mode
[   27.169028] device swp1 entered promiscuous mode
[   27.173718] device swp2 entered promiscuous mode
[   27.187698] mscc_felix 0000:00:00.5 swp2: configuring for inband/qsgmii link mode
[   27.196312] 8021q: adding VLAN 0 to HW filter on device swp2
[   27.207605] 8021q: adding VLAN 0 to HW filter on device bond0
[   28.060872] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[   28.067323] br0: port 2(bond0) entered blocking state
[   28.072406] br0: port 2(bond0) entered forwarding state
[   28.077751] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
# bridge link
8: swp2@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
10: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 100
# bridge vlan add dev bond0 vid 100
# bridge vlan add dev swp2 vid 100
[   48.669422] mscc_felix 0000:00:00.5 swp2: dsa_slave_vlan_add: vid 100
# bridge vlan add dev br0 vid 100 self
