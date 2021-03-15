Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2BF33C6BB
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhCOTWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:22:33 -0400
Received: from mout01.posteo.de ([185.67.36.65]:41626 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231540AbhCOTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:22:16 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 26244160060
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 20:22:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1615836134; bh=Z082ViFyeFDgVhh/p+XHkfmDA1TT5nRho4/BMBi/P9o=;
        h=Date:From:To:Subject:From;
        b=OMiOuci7c4+FHnD166U0ZAhhgLQhtZSjiTnHDMk12PGhP2AkrgmI9kyjVVNQoD7qc
         ibse4njaEGMZqh40X11jlD0x9vDOVKKGz6PyRr+19BNFOuKi36yqXPzIamroW6CiCq
         EK/L0QbjX4N3Hys2/O57oDoEZhsn3J+rdyIisCCNPHkLA+55f9nsjRAgOAT/qDWUL/
         M88aic8TWDtvqrpQnINc4mPisKrmlGNH6sXawc0OQSRT9vqiW/jzxguizIvZsDZavX
         f00tMhM3Mad3qjrJWbaIMKnDdf+hRpVn/+aIUWZWme2tqz8Gz1SkZFbtu/jFpCtLEq
         nl2TOjM+PNn3A==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4DzmWm4wfrz9rxS
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 20:22:12 +0100 (CET)
Date:   Tue, 16 Mar 2021 06:22:08 +1100
From:   Tim Rice <trice@posteo.net>
To:     netdev@vger.kernel.org
Subject: [BUG] Iproute2 batch-mode fails to bring up veth
Message-ID: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,

Sorry if this isn't the right place to report Iproute2 bugs. It was implied by README.devel as well as a couple of entries I saw in bugzilla.

I use iproute2 batch mode to construct network namespaces. Example script:

   $ cat ~/bin/netns-test.sh
   #! /bin/bash

   gw=192.168.5.1
   ip=192.168.5.2
   ns=netns-test
   veth0=${ns}-0
   veth1=${ns}-1

   /usr/local/sbin/ip -b - << EOF
   link add $veth0 type veth peer name $veth1
   addr add $gw peer $ip dev $veth0
   link set dev $veth0 up
   netns add $ns
   link set $veth1 netns $ns
   netns exec $ns ip link set dev lo up
   netns exec $ns ip link set dev $veth1 up
   netns exec $ns ip addr add $ip/24 dev $veth1
   netns exec $ns ip addr add $ip peer $gw dev $veth1
   netns exec $ns ip route add default via $gw dev $veth1
   netns exec $ns ip route add 192.168.0.0/24 via $gw dev $veth1
   EOF


I noticed when version 5.11.0 dropped that this stops working. Batch mode fails to bring up the inner veth.

Expected usage (as produced by v5.10.0):

   $ sudo ./bin/netns-test.sh
   $ sudo ip netns exec netns-test ip route
   default via 192.168.5.1 dev netns-test-1
   192.168.0.0/24 via 192.168.5.1 dev netns-test-1
   192.168.5.0/24 dev netns-test-1 proto kernel scope link src 192.168.5.2
   192.168.5.1 dev netns-test-1 proto kernel scope link src 192.168.5.2

Actual behaviour:

   $ sudo ./bin/netns-test.sh
   $ sudo ip netns exec netns-test ip route  # Notice the empty output
   $ sudo ip netns exec netns-test ip link
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
   39: netns-test-1@if40: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
       link/ether 1a:96:4e:4f:84:31 brd ff:ff:ff:ff:ff:ff link-netnsid 0

System info:

* Distro: Void Linux
* Kernel version: 5.10.23
* CPU: AMD Ryzen 7 1800X and Ryzen 5 2600. (Reproduced on both.)

Git bisect pinpoints this commit: https://github.com/shemminger/iproute2/commit/1d9a81b8c9f30f9f4abeb875998262f61bf10577

That commit was focused on refactoring batch mode. This is consistent with my experience that only batch mode is affected. Everything works as expected when running the commands manually.

~ Tim
