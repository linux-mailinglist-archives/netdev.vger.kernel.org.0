Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5FB6C769A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 05:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCXEhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 00:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCXEhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 00:37:47 -0400
Received: from out0-199.mail.aliyun.com (out0-199.mail.aliyun.com [140.205.0.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CB728236
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 21:37:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047205;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.Rypk6nD_1679632661;
Received: from 30.230.61.85(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.Rypk6nD_1679632661)
          by smtp.aliyun-inc.com;
          Fri, 24 Mar 2023 12:37:42 +0800
Message-ID: <6fc5ed03-5872-0d9f-ea5a-48857b5cc7c1@antgroup.com>
Date:   Fri, 24 Mar 2023 12:37:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v5] net/packet: support mergeable feature of virtio
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     <mst@redhat.com>, <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <20230317074304.275598-1-amy.saq@antgroup.com>
 <641474b7cf005_36045220894@willemb.c.googlers.com.notmuch>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <641474b7cf005_36045220894@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/17 下午10:09, Willem de Bruijn 写道:
> 沈安琪(凛玥) wrote:
>> From: Jianfeng Tan <henry.tjf@antgroup.com>
>>
>> Packet sockets, like tap, can be used as the backend for kernel vhost.
>> In packet sockets, virtio net header size is currently hardcoded to be
>> the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
>> always the case: some virtio features, such as mrg_rxbuf, need virtio
>> net header to be 12-byte long.
>>
>> Mergeable buffers, as a virtio feature, is worthy of supporting: packets
>> that are larger than one-mbuf size will be dropped in vhost worker's
>> handle_rx if mrg_rxbuf feature is not used, but large packets
>> cannot be avoided and increasing mbuf's size is not economical.
>>
>> With this virtio feature enabled by virtio-user, packet sockets with
>> hardcoded 10-byte virtio net header will parse mac head incorrectly in
>> packet_snd by taking the last two bytes of virtio net header as part of
>> mac header.
>> This incorrect mac header parsing will cause packet to be dropped due to
>> invalid ether head checking in later under-layer device packet receiving.
>>
>> By adding extra field vnet_hdr_sz with utilizing holes in struct
>> packet_sock to record currently used virtio net header size and supporting
>> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
>> sockets can know the exact length of virtio net header that virtio user
>> gives.
>> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
>> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from
>> corresponding packet_sock, and parse mac header correctly based on this
>> information to avoid the packets being mistakenly dropped.
>>
>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> Another patch set was just merged that this will have merge conflicts
> with. Please respin.
>
> https://lore.kernel.org/netdev/20230316011014.992179-4-edumazet@google.com/T/


Sure thing. We are going to rebase it. The recently-merged patch 
compacted all bit flags into one long flags field and getting the bit 
information through the helper function.

Since our patch removes has_vnet_hdr bit and uses vnet_hdr_sz, which 
cannot fit in one bit, to indicate whether the packet sock has vnet 
header or not, we plan to remove PACKET_SOCK_HAS_VNET_HDR from 
packet_sock_flags and keep the u8 field vnet_hdr_sz in struct 
packet_sock. After modification, the packet_sock struct will be following:

@@ -119,9 +119,9 @@ struct packet_sock {
  	unsigned long		flags;
  	int			ifindex;	/* bound device		*/
+	u8			vnet_hdr_sz;
  	__be16			num;


I wonder whether this rebase plan looks appropriate for you and am 
looking forward to your advice here.

If we are good on the rebasing plan, we will soon send out next version 
with conflicts resolved. :) Thanks a lot.


