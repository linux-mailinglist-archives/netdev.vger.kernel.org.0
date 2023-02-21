Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D10369DD0C
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjBUJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbjBUJkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:40:21 -0500
Received: from out0-204.mail.aliyun.com (out0-204.mail.aliyun.com [140.205.0.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0B52310D
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:40:18 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047199;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.RScARwH_1676972415;
Received: from 30.46.243.131(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RScARwH_1676972415)
          by smtp.aliyun-inc.com;
          Tue, 21 Feb 2023 17:40:15 +0800
Message-ID: <a737c617-6722-7002-1ead-4c5bed452595@antgroup.com>
Date:   Tue, 21 Feb 2023 17:40:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
 <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
 <20230210030710-mutt-send-email-mst@kernel.org>
 <63e665348b566_1b03a820873@willemb.c.googlers.com.notmuch>
 <d759d787-4d76-c8e1-a5e2-233a097679b1@antgroup.com>
 <63eb9a7fe973e_310218208b4@willemb.c.googlers.com.notmuch>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <63eb9a7fe973e_310218208b4@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/14 下午10:28, Willem de Bruijn 写道:
> 沈安琪(凛玥) wrote:
>> 在 2023/2/10 下午11:39, Willem de Bruijn 写道:
>>> Michael S. Tsirkin wrote:
>>>> On Fri, Feb 10, 2023 at 12:01:03PM +0800, 沈安琪(凛玥) wrote:
>>>>> 在 2023/2/9 下午9:07, Michael S. Tsirkin 写道:
>>>>>> On Thu, Feb 09, 2023 at 08:43:15PM +0800, 沈安琪(凛玥) wrote:
>>>>>>> From: "Jianfeng Tan" <henry.tjf@antgroup.com>
>>>>>>>
>>>>>>> When raw socket is used as the backend for kernel vhost, currently it
>>>>>>> will regard the virtio net header as 10-byte, which is not always the
>>>>>>> case since some virtio features need virtio net header other than
>>>>>>> 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte virtio
>>>>>>> net header.
>>>>>>>
>>>>>>> Instead of hardcoding virtio net header length to 10 bytes, tpacket_snd,
>>>>>>> tpacket_rcv, packet_snd and packet_recvmsg now get the virtio net header
>>>>>>> size that is recorded in packet_sock to indicate the exact virtio net
>>>>>>> header size that virtio user actually prepares in the packets. By doing
>>>>>>> so, it can fix the issue of incorrect mac header parsing when these
>>>>>>> virtio features that need virtio net header other than 10-byte are
>>>>>>> enable.
>>>>>>>
>>>>>>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>>>>>>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>>>>>>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
>>>>>> Does it handle VERSION_1 though? That one is also LE.
>>>>>> Would it be better to pass a features bitmap instead?
>>>>> Thanks for quick reply!
>>>>>
>>>>> I am a little confused abot what "LE" presents here?
>>>> LE == little_endian.
>>>> Little endian format.
>>>>
>>>>> For passing a features bitmap to af_packet here, our consideration is
>>>>> whether it will be too complicated for af_packet to understand the virtio
>>>>> features bitmap in order to get the vnet header size. For now, all the
>>>>> virtio features stuff is handled by vhost worker and af_packet actually does
>>>>> not need to know much about virtio features. Would it be better if we keep
>>>>> the virtio feature stuff in user-level and let user-level tell af_packet how
>>>>> much space it should reserve?
>>>> Presumably, we'd add an API in include/linux/virtio_net.h ?
>>> Better leave this opaque to packet sockets if they won't act on this
>>> type info.
>>>    
>>> This patch series probably should be a single patch btw. As else the
>>> socket option introduced in the first is broken at that commit, since
>>> the behavior is only introduced in patch 2.
>>
>> Good point, will merge this patch series into one patch.
>>
>>
>> Thanks for Michael's enlightening advice, we plan to modify current UAPI
>> change of adding an extra socketopt from only setting vnet header size
>> only to setting a bit-map of virtio features, and implement another
>> helper function in include/linux/virtio_net.h to parse the feature
>> bit-map. In this case, packet sockets have no need to understand the
>> feature bit-map but only pass this bit-map to virtio_net helper and get
>> back the information, such as vnet header size, it needs.
>>
>> This change will make the new UAPI more general and avoid further
>> modification if there are more virtio features to support in the future.
>>
> Please also comment how these UAPI extension are intended to be used.
> As that use is not included in this initial patch series.
>
> If the only intended user is vhost-net, we can consider not exposing
> outside the kernel at all. That makes it easier to iterate if
> necessary (no stable ABI) and avoids accidentally opening up new
> avenues for bugs and exploits (syzkaller has a history with
> virtio_net_header options).


Our concern is, it seems there is no other solution than uapi to let 
packet sockets know the vnet header size they should use.

Receiving packets in vhost driver, implemented in drivers/vhost/net.c: 
1109 handle_rx(), will abstract the backend device it uses and directly 
invoke the corresponding socket ops with no extra information indicating 
it is invoked by vhost worker. Vhost worker actually does not know the 
type of backend device it is using; only virito-user knows what type of 
backend device it uses. Therefore, it seems impossible to let vhost set 
the vnet header information to the target backend device.

Tap, another kind of backend device vhost may use, lets virtio-user set 
whether it needs vnet header and how long the vnet header is through 
ioctl. (implemented in drivers/net/tap.c:1066)

In this case, we wonder whether we should align with what tap does and 
set vnet hdr size through setsockopt for packet_sockets.

We really appreciate suggestions on if any, potential approachs to pass 
this vnet header size information from virtio-user to packet-socket.


