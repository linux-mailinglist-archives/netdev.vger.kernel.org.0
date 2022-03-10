Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E9E4D51D0
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343623AbiCJTet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343625AbiCJTet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:34:49 -0500
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076B714F2AF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 11:33:46 -0800 (PST)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.134])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4B7341A0080;
        Thu, 10 Mar 2022 19:33:45 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0BC77BC006F;
        Thu, 10 Mar 2022 19:33:45 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 267F513C2B0;
        Thu, 10 Mar 2022 11:33:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 267F513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1646940824;
        bh=2H9gPujdzYaumRU5sWsGVim4r/wqcAVXts+aiI9SLt8=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=DsIjVR2FeBFk9OiBka0HNzFKd0C1DOg6Zf0Vm32eWHIVPf3PnsyL6WKOovyh6ljc1
         lIDRZdkhO3DaD+cfy2Tso4LnrnCO9+C8dk0lM/NZLhF7+nv0Rf2qHGI5BYHFPYZzGK
         2hDS6eNDZl4l9KMEmdTAM27q1lLDzfNGahpMFa3k=
Subject: Re: vrf and multicast problem
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <1e7b1aec-401d-9e70-564a-4ce96e11e1be@candelatech.com>
 <4c4f21f3-75b5-5099-7ee8-28e3c4d6b465@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <50f1a384-c312-d6ec-0f42-2b9ce3a48013@candelatech.com>
Date:   Thu, 10 Mar 2022 11:33:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4c4f21f3-75b5-5099-7ee8-28e3c4d6b465@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1646940825-QdIC3SIRmfQE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 7:54 PM, David Ahern wrote:
> On 3/9/22 3:31 PM, Ben Greear wrote:
>> [resend, sorry...sent to wrong mailing list the first time]
>>
>> Hello,
>>
>> We recently found a somewhat weird problem, and before I go digging into
>> the kernel source, I wanted to see if someone had an answer already...
>>
>> I am binding (SO_BINDTODEVICE) a socket to an Ethernet port that is in a
>> VRF with a second
>> interface.  When I try to send mcast traffic out that eth port, nothing is
>> seen on the wire.
>>
>> But, if I set up a similar situation with a single network port in
>> a vrf and send multicast, then it does appear to work as I expected.
>>
>> I am not actually trying to do any mcast routing here, I simply want to
>> send
>> out mcast frames from a port that resides inside a vrf.
>>
>> Any idea what might be the issue?
>>
> 
> multicast with VRF works. I am not aware of any known issues

I set up a more controlled network to do some more testing.  I have eth2
on 192.168.100.x/24 network, and eth1 on 172.16.0.1/16.

I bind the mcast transmitter to eth1:

193 setsockopt(28, SOL_SOCKET, SO_BINDTODEVICE, "eth1\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0
194 setsockopt(28, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
195 bind(28, {sa_family=AF_INET, sin_port=htons(8888), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
196 fcntl(28, F_GETFL)                      = 0x2 (flags O_RDWR)
197 fcntl(28, F_SETFL, O_ACCMODE|O_NONBLOCK) = 0
198 setsockopt(28, SOL_SOCKET, SO_BROADCAST, [1], 4) = 0
199 setsockopt(28, SOL_SOCKET, SO_SNDBUF, [64000], 4) = 0
200 setsockopt(28, SOL_SOCKET, SO_RCVBUF, [128000], 4) = 0
201 getsockopt(28, SOL_SOCKET, SO_RCVBUF, [256000], [4]) = 0
202 getsockopt(28, SOL_SOCKET, SO_SNDBUF, [128000], [4]) = 0
203 write(3, "1646940176442:  BtbitsIpEndpoint"..., 69) = 69
204 setsockopt(28, SOL_IP, IP_TOS, [0], 4)  = 0
205 getsockopt(28, SOL_IP, IP_TOS, [0], [4]) = 0
206 setsockopt(28, SOL_SOCKET, SO_PRIORITY, [0], 4) = 0
207 getsockopt(28, SOL_SOCKET, SO_PRIORITY, [0], [4]) = 0
208 write(3, "1646940176442:  UdpEndpBase.cc 2"..., 148) = 148
209 setsockopt(28, SOL_IP, IP_MULTICAST_IF, [16781484], 4) = 0
210 setsockopt(28, SOL_IP, IP_MULTICAST_TTL, " ", 1) = 0

That IP_MULTICAST_IF ioctl should be assigning the IP address of
eth1.

But when I sniff, I see the mcast packets going out of eth2:

[root@ct522-63e7 lanforge]# tshark -n -i eth2
Running as user "root" and group "root". This could be dangerous.
Capturing on 'eth2'
     1 0.000000000 192.168.100.28 → 225.5.5.1    LANforge 1514 Seq: 474
     2 0.060868103 192.168.100.226 → 192.168.100.255 ADwin Config 94
     3 0.060900503 00:0d:b9:41:6a:90 → ff:ff:ff:ff:ff:ff 0x1111 92 Ethernet II
     4 0.209523669 192.168.100.28 → 225.5.5.1    LANforge 1514 Seq: 475

[root@ct522-63e7 lanforge]# ifconfig eth1
eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
         inet 172.16.0.1  netmask 255.255.0.0  broadcast 172.16.255.255
         inet6 fe80::230:18ff:fe01:63e8  prefixlen 64  scopeid 0x20<link>
         ether 00:30:18:01:63:e8  txqueuelen 1000  (Ethernet)
         RX packets 1972669  bytes 409744407 (390.7 MiB)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 5818525  bytes 7341747933 (6.8 GiB)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device memory 0xdf740000-df75ffff

[root@ct522-63e7 lanforge]# ifconfig eth2
eth2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
         inet 192.168.100.28  netmask 255.255.255.0  broadcast 192.168.100.255
         inet6 fe80::230:18ff:fe01:63e9  prefixlen 64  scopeid 0x20<link>
         ether 00:30:18:01:63:e9  txqueuelen 1000  (Ethernet)
         RX packets 24638831  bytes 8874820766 (8.2 GiB)
         RX errors 26712  dropped 6596663  overruns 0  frame 16757
         TX packets 1753211  bytes 370552564 (353.3 MiB)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device memory 0xdf720000-df73ffff

If I disable VRF and use routing-rules based approach, then it works
as I expect (mcast frames go out of eth1).

We tested back to quite-old kernels with same symptom, so I think it is not
a regression.

Any suggestions on where to start poking at this in the kernel?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

