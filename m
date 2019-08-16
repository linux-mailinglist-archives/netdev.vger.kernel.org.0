Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB08E90823
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfHPTSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:18:36 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:33236 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHPTSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:18:35 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 15:18:35 EDT
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 9380B65936;
        Fri, 16 Aug 2019 12:13:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 9380B65936
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1565982813;
        bh=/d37AcDSDQIP6K8g3VXZdf1EpP99pk58OsAuSeUWORg=;
        h=To:Cc:From:Subject:Date:From;
        b=WcF3XcodWjQivcNXay9FGreg/YJ3ZE2J5B/Rd7tEUkdKFTtLb1MWFyzfpnoZRa+nJ
         3NTWb+zzrZ6x8/0oWyXPZvlMnLwMzCyIs91Khs1IhbckQJv+Qx+54cgQog3MIpkgEY
         0rq3Lb9yoTyvVIXK8mxKCZCVo5WV+/oG3teaBQtA=
To:     netdev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Subject: IPv6 addr and route is gone after adding port to vrf (5.2.0+)
Organization: Candela Technologies
Message-ID: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
Date:   Fri, 16 Aug 2019 12:13:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have a problem with a VETH port when setting up a somewhat complicated
VRF setup. I am loosing the global IPv6 addr, and also the route, apparently
when I add the veth device to a vrf.  From my script's output:

### commands to set up the veth 'rddVR0'

./local/sbin/ip link set rddVR0 down
./local/sbin/ip -4 addr flush dev rddVR0
./local/sbin/ip -6 addr flush dev rddVR0
echo 1 > /proc/sys/net/ipv4/conf/rddVR0/forwarding
echo 1 > /proc/sys/net/ipv6/conf/rddVR0/forwarding
./local/sbin/ip link set rddVR0 up
./local/sbin/ip -4 addr add 10.2.127.1/24 broadcast 10.2.127.255 dev rddVR0
./local/sbin/ip -6 addr add 2001:3::1/64 scope global dev rddVR0
./local/sbin/ip -6 addr add fe80::d0f8:6fff:fe06:8ae/64 scope link dev rddVR0
RTNETLINK answers: File exists
./local/sbin/ip -6 route add 2001:3::1/64 dev rddVR0 table 10001
./local/sbin/ip -6 route add fe80::d0f8:6fff:fe06:8ae/64 dev rddVR0 table 10001
./local/sbin/ip route add 10.2.127.0/24 dev rddVR0 table 10001
echo 1 > /proc/sys/net/ipv4/conf/rddVR0/arp_filter

#printRoutes for table 10001
broadcast 10.2.1.0 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
10.2.1.0/24 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
local 10.2.1.1 dev eth1 proto kernel scope host src 10.2.1.1
broadcast 10.2.1.255 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
broadcast 10.2.8.0 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
10.2.8.0/24 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
local 10.2.8.1 dev vap0000 proto kernel scope host src 10.2.8.1
broadcast 10.2.8.255 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
broadcast 10.2.9.0 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
10.2.9.0/24 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
local 10.2.9.1 dev vap0100 proto kernel scope host src 10.2.9.1
broadcast 10.2.9.255 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
10.2.127.0/24 dev rddVR0 scope link
2001:3::/64 dev rddVR0 metric 1024 pref medium
fe80::/64 dev rddVR0 metric 1024 pref medium

.... some other commands, route/ip is still there ....

#printRoutes for table 10001
broadcast 10.2.1.0 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
10.2.1.0/24 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
local 10.2.1.1 dev eth1 proto kernel scope host src 10.2.1.1
broadcast 10.2.1.255 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
broadcast 10.2.8.0 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
10.2.8.0/24 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
local 10.2.8.1 dev vap0000 proto kernel scope host src 10.2.8.1
broadcast 10.2.8.255 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
broadcast 10.2.9.0 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
10.2.9.0/24 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
local 10.2.9.1 dev vap0100 proto kernel scope host src 10.2.9.1
broadcast 10.2.9.255 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
10.2.127.0/24 dev rddVR0 scope link
2001:3::/64 dev rddVR0 metric 1024 pref medium
fe80::/64 dev rddVR0 metric 1024 pref medium


./local/sbin/ip link set rddVR0 vrf vrf10001

#printRoutes for table 10001
broadcast 10.2.1.0 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
10.2.1.0/24 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
local 10.2.1.1 dev eth1 proto kernel scope host src 10.2.1.1
broadcast 10.2.1.255 dev eth1 proto kernel scope link src 10.2.1.1 linkdown
broadcast 10.2.8.0 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
10.2.8.0/24 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
local 10.2.8.1 dev vap0000 proto kernel scope host src 10.2.8.1
broadcast 10.2.8.255 dev vap0000 proto kernel scope link src 10.2.8.1 linkdown
broadcast 10.2.9.0 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
10.2.9.0/24 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
local 10.2.9.1 dev vap0100 proto kernel scope host src 10.2.9.1
broadcast 10.2.9.255 dev vap0100 proto kernel scope link src 10.2.9.1 linkdown
broadcast 10.2.127.0 dev rddVR0 proto kernel scope link src 10.2.127.1
10.2.127.0/24 dev rddVR0 proto kernel scope link src 10.2.127.1
local 10.2.127.1 dev rddVR0 proto kernel scope host src 10.2.127.1
broadcast 10.2.127.255 dev rddVR0 proto kernel scope link src 10.2.127.1
fe80::/64 dev rddVR0 proto kernel metric 256 pref medium
ff00::/8 dev rddVR0 metric 256 pref medium


#### Route is gone...
#### 2001:3::/64 dev rddVR0 metric 1024 pref medium


As far as I can tell, the same actions for a wifi AP interface do not hit this problem,
but not sure if that is luck or not at this point.

Any ideas what might be going on here?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

