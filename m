Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB1141037
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgAQRuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:50:05 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:35350 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQRuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:50:05 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A9819D940
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 09:49:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A9819D940
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1579283375;
        bh=XqiMvcWpaVpft9VHPntO9tYkrkGpp6T8oijTJkAOeYA=;
        h=To:From:Subject:Date:From;
        b=r31qJF9z28z6xDkknfJQ7BolyJfwCMoblhlnJGEm3F0IaIw4ux/y0nzC9IEL6qVk2
         f5d9weA+6zWDpsfPiQmJ2jaPqfZAfYQxSHj3Iwzki29S5OvSt7G37rd1oD6ClCcL2w
         uBduoBOjjkxB8QgGxDsedAAPdqSl96Xy+kEN3/IE=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: vrf and ipsec xfrm routing problem
Organization: Candela Technologies
Message-ID: <1425d02c-de99-b708-e543-b7fe3f0ef07e@candelatech.com>
Date:   Fri, 17 Jan 2020 09:49:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm back to mucking with xfrm and vrfs.  I am currently able to get the
xfrm interface to connect to the ipsec peer and get an IP address.

But, when I bind a UDP socket to the x_eth4 xfrm device, the packets
go out of eth4 instead.

Based on the problems I was having with multicast, I am thinking this might just be some routing problem.

# ip route show vrf _vrf4
default via 192.168.5.1 dev eth4
192.168.5.0/24 dev eth4 scope link src 192.168.5.4

# ip addr show dev eth4
7: eth4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master _vrf4 state UP group default qlen 1000
     link/ether 00:30:18:01:63:eb brd ff:ff:ff:ff:ff:ff
     inet 192.168.5.4/24 brd 192.168.5.255 scope global eth4
        valid_lft forever preferred_lft forever

# ip addr show dev x_eth4
30: x_eth4@eth4: <NOARP,UP,LOWER_UP> mtu 1440 qdisc noqueue master _vrf4 state UNKNOWN group default qlen 1000
     link/none 00:30:18:01:63:eb brd ff:ff:ff:ff:ff:ff
     inet 192.168.10.101/32 scope global x_eth4
        valid_lft forever preferred_lft forever
     inet6 fe80::f6ec:3e67:9b7b:60c9/64 scope link stable-privacy
        valid_lft forever preferred_lft forever


I tried adding a route to specify the x_frm as source, but that does not appear to work:

[root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via 192.168.5.1 dev x_eth4 table 4
[root@lf0313-63e7 lanforge]# ip route show vrf _vrf4
default via 192.168.5.1 dev eth4
192.168.5.0/24 dev eth4 scope link src 192.168.5.4
192.168.10.0/24 via 192.168.5.1 dev eth4

I also tried this, but no luck:

[root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via 192.168.10.1 dev x_eth4 table 4
Error: Nexthop has invalid gateway.

Any ideas about where my problem might lie?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

