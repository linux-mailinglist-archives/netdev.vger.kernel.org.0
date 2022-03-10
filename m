Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949CB4D3F9F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbiCJDVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237642AbiCJDVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:21:24 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54278120EB8;
        Wed,  9 Mar 2022 19:20:24 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KDZ2D2Tlzz1GCLX;
        Thu, 10 Mar 2022 11:15:32 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 11:20:21 +0800
Subject: Re: IPv4 saddr do not match with selected output device in double
 default gateways scene
To:     David Ahern <dsahern@kernel.org>,
        David Miller <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, <ja@ssi.bg>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <58c15089-f1c7-675e-db4b-b6dfdad4b497@huawei.com>
 <0f97539a-439f-d584-9ba3-f4bd5a302bc0@kernel.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <86c61138-c82c-a403-664c-a61d651008b0@huawei.com>
Date:   Thu, 10 Mar 2022 11:20:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0f97539a-439f-d584-9ba3-f4bd5a302bc0@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 3/7/22 11:41 PM, Ziyang Xuan (William) wrote:
>> Create VLAN devices and add default gateways with following commands:
>>
>> # ip link add link eth2 dev eth2.71 type vlan id 71
>> # ip link add link eth2 dev eth2.72 type vlan id 72
>> # ip addr add 192.168.71.41/24 dev eth2.71
>> # ip addr add 192.168.72.41/24 dev eth2.72
>> # ip link set eth2.71 up
>> # ip link set eth2.72 up
>> # route add -net default gw 192.168.71.1 dev eth2.71
>> # route add -net default gw 192.168.72.1 dev eth2.72
>>
> 
> ...
> 
>> We can find that IPv4 saddr "192.168.72.41" do not match with selected VLAN device "eth2.71".
>>
>> I tracked the related processes, and found that user space program uses connect() firstly, then sends UDP packet.
>>
> 
> ...
> 
>> Deep tracking, it because fa->fa_default has changed in fib_select_default() after first __ip_route_output_key() process,
>> and a new fib_nh is selected in fib_select_default() within the second __ip_route_output_key() process but not update flowi4.
>> So the phenomenon described at the beginning happens.
>>
>> Does it a kernel bug or a user problem? If it is a kernel bug, is there any good solution?
> 
> That is a known problem with multipath routes.
> .
> 

Does the community have a plan to address it?
