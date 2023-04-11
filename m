Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D856DDCD1
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjDKNu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjDKNuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:50:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15CB5270;
        Tue, 11 Apr 2023 06:50:40 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PwnGn3slLzKy2w;
        Tue, 11 Apr 2023 21:48:01 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 21:50:34 +0800
Subject: Re: [PATCH net] net: Add check for csum_start in
 skb_partial_csum_set()
To:     Eric Dumazet <edumazet@google.com>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <asml.silence@gmail.com>, <imagedong@tencent.com>,
        <brouer@redhat.com>, <keescook@chromium.org>, <jbenc@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230410022152.4049060-1-luwei32@huawei.com>
 <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
 <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch>
 <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
 <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <95d0f4dd-3350-be65-27a8-2b41aee9df3d@huawei.com>
Date:   Tue, 11 Apr 2023 21:50:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/4/11 4:13 PM, Eric Dumazet 写道:
> On Tue, Apr 11, 2023 at 4:33 AM luwei (O) <luwei32@huawei.com> wrote:
>>
>> 在 2023/4/11 1:30 AM, Willem de Bruijn 写道:
>>
>> Eric Dumazet wrote:
>>
>> On Mon, Apr 10, 2023 at 4:22 AM Lu Wei <luwei32@huawei.com> wrote:
>>
>> If an AF_PACKET socket is used to send packets through a L3 mode ipvlan
>> and a vnet header is set via setsockopt() with the option name of
>> PACKET_VNET_HDR, the value of offset will be nagetive in function
>> skb_checksum_help() and trigger the following warning:
>>
>> WARNING: CPU: 3 PID: 2023 at net/core/dev.c:3262
>> skb_checksum_help+0x2dc/0x390
>> ......
>> Call Trace:
>>   <TASK>
>>   ip_do_fragment+0x63d/0xd00
>>   ip_fragment.constprop.0+0xd2/0x150
>>   __ip_finish_output+0x154/0x1e0
>>   ip_finish_output+0x36/0x1b0
>>   ip_output+0x134/0x240
>>   ip_local_out+0xba/0xe0
>>   ipvlan_process_v4_outbound+0x26d/0x2b0
>>   ipvlan_xmit_mode_l3+0x44b/0x480
>>   ipvlan_queue_xmit+0xd6/0x1d0
>>   ipvlan_start_xmit+0x32/0xa0
>>   dev_hard_start_xmit+0xdf/0x3f0
>>   packet_snd+0xa7d/0x1130
>>   packet_sendmsg+0x7b/0xa0
>>   sock_sendmsg+0x14f/0x160
>>   __sys_sendto+0x209/0x2e0
>>   __x64_sys_sendto+0x7d/0x90
>>
>> The root cause is:
>> 1. skb->csum_start is set in packet_snd() according vnet_hdr:
>>     skb->csum_start = skb_headroom(skb) + (u32)start;
>>
>>     'start' is the offset from skb->data, and mac header has been
>>     set at this moment.
>>
>> 2. when this skb arrives ipvlan_process_outbound(), the mac header
>>     is unset and skb_pull is called to expand the skb headroom.
>>
>> 3. In function skb_checksum_help(), the variable offset is calculated
>>     as:
>>        offset = skb->csum_start - skb_headroom(skb);
>>
>>     since skb headroom is expanded in step2, offset is nagetive, and it
>>     is converted to an unsigned integer when compared with skb_headlen
>>     and trigger the warning.
>>
>> Not sure why it is negative ? This seems like the real problem...
>>
>> csum_start is relative to skb->head, regardless of pull operations.
>>
>> whatever set csum_start to a too small value should be tracked and fixed.
>>
>> Right. The only way I could see it go negative is if something does
>> the equivalent of pskb_expand_head with positive nhead, and without
>> calling skb_headers_offset_update.
>>
>> Perhaps the cause can be found by instrumenting all the above
>> functions in the trace to report skb_headroom and csum_start.
>> And also virtio_net_hdr_to_skb.
>> .
>>
>> Hi, Eric  and Willem,  sorry for not describing this issue clearly enough. Here is the detailed data path:
>>
>> 1.  Users call sendmsg() to send message with a AF_PACKET domain and SOCK_RAW type socket. Since vnet_hdr
>>
>> is set,  csum_start is calculated as:
>>
>>                        skb->csum_start = skb_headroom(skb) + (u32)start;     // see the following code.
>>
>> the varible "start" it passed from user data, in my case it is 5 and skb_headroom is 2, so skb->csum_start is 7.
>>
> I think you are rephrasing, but you did not address my feedback.
>
> Namely, "csum_start < skb->network_header" does not look sensical to me.
>
> csum_start should be related to the transport header, not network header.
>
> If you fix a bug, please fix it completely, instead of leaving room
> for future syzbot reports.
>
> Also, your reference to ipvlan pulling a mac header is irrelevant to
> this bug, and adds confusion.
>
> That is  because csum_start is relative to skb->head, not skb->data.
> So ipvlan business does not change csum_start or skb->head.

Hi, Eric, I have no doubt that skb->csum_start is relative to skb->head, 
not skb->data.

The problem is not skb->csum_start but variable "offset" in 
skb_checksum_help() which triggers the warning.

skb_checksum_help()
     ...
     offset = skb_checksum_start_offset(skb);      // offset is nagetive 
here
     ret = -EINVAL;
     if (WARN_ON_ONCE(offset >= skb_headlen(skb)))
         goto out;
     ...

"offset" here  means the offset from skb->data, it will change as 
skb->data changes and can be nagetive.

if "offset" is nagetive it will convert to a large unsigned int number 
and trigger the warning and the root

cause is csum_start is too small as I described previously.

Besides, the raw socket may not have a transport header so the transport 
header should not be used.

> .

-- 
Best Regards,
Lu Wei

