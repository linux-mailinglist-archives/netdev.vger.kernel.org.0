Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3BE6BB8BF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjCOP5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCOP4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:56:49 -0400
Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB0984F50
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:56:19 -0700 (PDT)
Message-ID: <7f95eede-888e-9e81-eedf-7664d91e2e16@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678895768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8KfvwxghdgZFeQU86X27BxIgB3vaKUY97DITgzT1gwI=;
        b=su8nVaHOwcNLk7E4eyPIJe4W1x8pOLjgeYcyRb35kU5s3TP2XAeei9T75N0TjHhnp6JIEQ
        JxOP2jtgQ+Zf1UK1ImMfsF6iXZSllx3JMtVBHB61ymEJa04gDA859BOVIVPDzDlebiXs8T
        vXK6c0n3WeYqYiledYUVB/Z1gLbM4D0=
Date:   Wed, 15 Mar 2023 15:56:05 +0000
MIME-Version: 1.0
Subject: Re: ioctl SIOCSHWTSTAMP failed on a vlan interface within non-default
 network namespace
Content-Language: en-US
To:     Yan Jiang <Yan.Jiang@viavisolutions.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <BYAPR18MB240835B708FA3A5B489656738DBF9@BYAPR18MB2408.namprd18.prod.outlook.com>
 <7e78cd84-17ef-1830-4084-a360d991a619@linux.dev>
 <BYAPR18MB2408F4FEDD31152C3C15D5648DBF9@BYAPR18MB2408.namprd18.prod.outlook.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <BYAPR18MB2408F4FEDD31152C3C15D5648DBF9@BYAPR18MB2408.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 15:17, Yan Jiang wrote:
> HI Vadim,
> 
> Thank you for your reply. This explains why ioctl failed on vlan interface.
> 
> I am ignorant here, but in my example below both base interface and vlan 
> interface are in same namespace,  and I feel that the defense you 
> pointed to me is not protecting anything.
> We can even take the default namespace as example: why we allow ioctl 
> SIOCSHWTSTAMP to work on a VLAN interface in default namespace?
> 
> I think it is common to assign a sriov VF to a container. In this case, 
> both base interface and VLAN interface created on top of the VF, are in 
> same network namespace.

I've just proposed the patch to address the situation, hope it will find 
some support :)

> 
> Possibly there are some situations that I am not aware. Hope to have 
> your thoughts. Thank you!
> 
> 
> ------------------------------------------------------------------------
> *From:* Vadim Fedorenko <vadim.fedorenko@linux.dev>
> *Sent:* Wednesday, March 15, 2023 10:38 PM
> *To:* Yan Jiang <Yan.Jiang@viavisolutions.com>; davem@davemloft.net 
> <davem@davemloft.net>; edumazet@google.com <edumazet@google.com>; 
> kuba@kernel.org <kuba@kernel.org>; pabeni@redhat.com 
> <pabeni@redhat.com>; richardcochran@gmail.com <richardcochran@gmail.com>
> *Cc:* netdev@vger.kernel.org <netdev@vger.kernel.org>
> *Subject:* Re: ioctl SIOCSHWTSTAMP failed on a vlan interface within 
> non-default network namespace
> EXTERNAL EMAIL: Do not click links or open attachments unless you know 
> and trust the sender.
> 
> 
> On 15/03/2023 05:35, Yan Jiang wrote:
>> Hi all,
>>
>> I'd like to report an issue, which I suspect it's related to kernel network namespace handling.
>> It's my first report so please bear with me if I missed something. Feel free to ask for more information please.
>>
>> What's the issue:
>> Ptp4l works perfectly on a VLAN interface in default network namespace. But it doesn't work if the VLAN interface is in non-default network namespace: ioctl(fd, SIOCSHWTSTAMP, &ifreq) failed due to error "Operation not supported".
>> "ethtool -T" shows that the VLAN interface has all required capabilities. And ptp4l works fine on the base interface in that network namespace.
> 
> 
> That was explicitly forbidden in
> https://urldefense.com/v3/__https://lore.kernel.org/netdev/20190509065507.23991-1-liuhangbin@gmail.com/__;!!Niha4SQ!_NTn9qN2nCq-QapNeIln9DvJwmpQWK7Y4EJOdXjbOq6w7Bhh-ZQp-vJu8TPyI9QMigOIDPeN2IuZSJamNFZI4DAfQvMIWyjqEMj9$ <https://urldefense.com/v3/__https://lore.kernel.org/netdev/20190509065507.23991-1-liuhangbin@gmail.com/__;!!Niha4SQ!_NTn9qN2nCq-QapNeIln9DvJwmpQWK7Y4EJOdXjbOq6w7Bhh-ZQp-vJu8TPyI9QMigOIDPeN2IuZSJamNFZI4DAfQvMIWyjqEMj9$>
> 
> 
>> How to reproduce this issue:
>> # create a new network namespace for test purpose
>> root@viavi-PowerEdge-R740:~# ip netns add mytest
>>
>> # move eno4 into the namespace
>> root@viavi-PowerEdge-R740:~# ip link set eno4 netns mytest
>>
>> # add vlan interface and turn interfaces up
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ifconfig eno4 up
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ip link add link eno4 name eno4.4000 type vlan id 4000
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ifconfig eno4.4000 up
>>
>> # ptp4l runs ok on eno4
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ptp4l -2 -m -i eno4
>> ptp4l[1670814.457]: selected /dev/ptp1 as PTP clock
>> ptp4l[1670814.491]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
>> ptp4l[1670814.492]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
>>
>> #ptp4l cannot run on eno4.4000
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ptp4l -2 -m -i eno4.4000
>> ptp4l[1670819.969]: selected /dev/ptp1 as PTP clock
>> ptp4l[1670820.003]: driver rejected most general HWTSTAMP filter
>> ptp4l[1670820.003]: ioctl SIOCSHWTSTAMP failed: Operation not supported
>> ptp4l[1670820.039]: port 1: INITIALIZING to FAULTY on FAULT_DETECTED (FT_UNSPECIFIED)
>> ptp4l[1670820.039]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
>>
>> #ethtool -T shows that eno4.4000 has same capability as eno4:
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ethtool -T eno4.4000
>> Time stamping parameters for eno4.4000:
>> Capabilities:
>>          hardware-transmit     (SOF_TIMESTAMPING_TX_HARDWARE)
>>          software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
>>          hardware-receive      (SOF_TIMESTAMPING_RX_HARDWARE)
>>          software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
>>          software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
>>          hardware-raw-clock    (SOF_TIMESTAMPING_RAW_HARDWARE)
>> PTP Hardware Clock: 1
>> Hardware Transmit Timestamp Modes:
>>          off                   (HWTSTAMP_TX_OFF)
>>          on                    (HWTSTAMP_TX_ON)
>> Hardware Receive Filter Modes:
>>          none                  (HWTSTAMP_FILTER_NONE)
>>          ptpv1-l4-event        (HWTSTAMP_FILTER_PTP_V1_L4_EVENT)
>>          ptpv2-l4-event        (HWTSTAMP_FILTER_PTP_V2_L4_EVENT)
>>          ptpv2-l2-event        (HWTSTAMP_FILTER_PTP_V2_L2_EVENT)
>>
>> #OS/kernel version
>> root@viavi-PowerEdge-R740:~# uname -a
>> Linux viavi-PowerEdge-R740 5.15.0-60-generic #66~20.04.1-Ubuntu SMP Wed Jan 25 09:41:30 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
>>
>> #driver info:
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ethtool -i eno4
>> driver: tg3
>> version: 5.15.0-60-generic
>> firmware-version: FFV21.40.21 bc 5720-v1.39
>> expansion-rom-version:
>> bus-info: 0000:01:00.1
>> supports-statistics: yes
>> supports-test: yes
>> supports-eeprom-access: yes
>> supports-register-dump: yes
>> supports-priv-flags: no
>> root@viavi-PowerEdge-R740:~# ip netns exec mytest ethtool -i eno4.4000
>> driver: 802.1Q VLAN Support
>> version: 1.8
>> firmware-version: N/A
>> expansion-rom-version:
>> bus-info:
>> supports-statistics: no
>> supports-test: no
>> supports-eeprom-access: no
>> supports-register-dump: no
>> supports-priv-flags: no
>>
>> #(PS: can reproduce same issue with a Mellanox NIC, so I guess it's not caused by a specific NIC model)
>>
>> Could you kindly take a look at this and see if this is a kernel issue? This blocks linuxptp running in cloud environment, if VLAN is required.
>> Hope to get feedback from you soon, thanks!
>>
>> /Yan
> 

