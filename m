Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD16D3BAF
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 04:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjDCCLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 22:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDCCLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 22:11:44 -0400
Received: from out0-199.mail.aliyun.com (out0-199.mail.aliyun.com [140.205.0.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94604769B
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 19:11:41 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047211;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.S5m42VY_1680487891;
Received: from 30.177.19.195(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.S5m42VY_1680487891)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 10:11:34 +0800
Message-ID: <2d62826d-d107-8438-5294-1fc19b4ef8a3@antgroup.com>
Date:   Mon, 03 Apr 2023 10:11:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v6] net/packet: support mergeable feature of virtio
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     <mst@redhat.com>, <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <20230327153641.204660-1-amy.saq@antgroup.com>
 <6423160f46e56_1bf1c92089e@willemb.c.googlers.com.notmuch>
 <f2fa7c95-1884-94aa-49e7-c82f47bf82cd@antgroup.com>
In-Reply-To: <f2fa7c95-1884-94aa-49e7-c82f47bf82cd@antgroup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/29 下午8:14, Anqi Shen 写道:


We will soon send out the next version of patch that addresses the 
following comments.

Before we doing that, I wonder whether there is any other 
comment/discussion on this version of patch.

Again, thanks for all the comments and discussion on this patch so far.


> 在 2023/3/29 上午12:30, Willem de Bruijn 写道:
>> 沈安琪(凛玥) wrote:
>>> From: Jianfeng Tan <henry.tjf@antgroup.com>
>>>
>>> Packet sockets, like tap, can be used as the backend for kernel vhost.
>>> In packet sockets, virtio net header size is currently hardcoded to be
>>> the size of struct virtio_net_hdr, which is 10 bytes; however, it is 
>>> not
>>> always the case: some virtio features, such as mrg_rxbuf, need virtio
>>> net header to be 12-byte long.
>>>
>>> Mergeable buffers, as a virtio feature, is worthy of supporting: 
>>> packets
>>> that are larger than one-mbuf size will be dropped in vhost worker's
>>> handle_rx if mrg_rxbuf feature is not used, but large packets
>>> cannot be avoided and increasing mbuf's size is not economical.
>>>
>>> With this virtio feature enabled by virtio-user, packet sockets with
>>> hardcoded 10-byte virtio net header will parse mac head incorrectly in
>>> packet_snd by taking the last two bytes of virtio net header as part of
>>> mac header.
>>> This incorrect mac header parsing will cause packet to be dropped 
>>> due to
>>> invalid ether head checking in later under-layer device packet 
>>> receiving.
>>>
>>> By adding extra field vnet_hdr_sz with utilizing holes in struct
>>> packet_sock to record currently used virtio net header size and 
>>> supporting
>>> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
>>> sockets can know the exact length of virtio net header that virtio user
>>> gives.
>>> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
>>> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from
>>> corresponding packet_sock, and parse mac header correctly based on this
>>> information to avoid the packets being mistakenly dropped.
>>>
>>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
>>> ---
>>>
>>> V5 -> V6:
>>> * rebase patch based on 6.3-rc2
>>>
>>>   include/uapi/linux/if_packet.h |  1 +
>>>   net/packet/af_packet.c         | 88 
>>> +++++++++++++++++++++-------------
>>>   net/packet/diag.c              |  2 +-
>>>   net/packet/internal.h          |  2 +-
>>>   4 files changed, 59 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/if_packet.h 
>>> b/include/uapi/linux/if_packet.h
>>> index 78c981d6a9d4..9efc42382fdb 100644
>>> --- a/include/uapi/linux/if_packet.h
>>> +++ b/include/uapi/linux/if_packet.h
>>> @@ -59,6 +59,7 @@ struct sockaddr_ll {
>>>   #define PACKET_ROLLOVER_STATS        21
>>>   #define PACKET_FANOUT_DATA        22
>>>   #define PACKET_IGNORE_OUTGOING        23
>>> +#define PACKET_VNET_HDR_SZ        24
>>>     #define PACKET_FANOUT_HASH        0
>>>   #define PACKET_FANOUT_LB        1
>>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>>> index 497193f73030..b13536767cbe 100644
>>> --- a/net/packet/af_packet.c
>>> +++ b/net/packet/af_packet.c
>>> @@ -2090,18 +2090,18 @@ static unsigned int run_filter(struct 
>>> sk_buff *skb,
>>>   }
>>>   @@ -3925,11 +3938,19 @@ packet_setsockopt(struct socket *sock, int 
>>> level, int optname, sockptr_t optval,
>>>           if (copy_from_sockptr(&val, optval, sizeof(val)))
>>>               return -EFAULT;
>>>   +        hdr_len = val ? sizeof(struct virtio_net_hdr) : 0;
>>> +        if (optname == PACKET_VNET_HDR_SZ) {
>>> +            if (val && val != sizeof(struct virtio_net_hdr) &&
>>> +                val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
>>> +                return -EINVAL;
>>> +            hdr_len = val;
>>> +        }
>>> +
>> Since the below requires a change, I'd prefer
>>
>>      if (optname == PACKET_VNET_HDR_SZ) {
>>              ...
>>      } else {
>>              hdr_len = val ? sizeof(struct virtio_net_hdr) : 0;
>>      }
>>
>> Rather than first doing that and then modifying val in the case of
>> PACKET_VNET_HDR_SZ.
>
>
> Good point. We will address this comment in the next version of patch.
>
>
>>>           lock_sock(sk);
>>>           if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>>>               ret = -EBUSY;
>>>           } else {
>>> -            packet_sock_flag_set(po, PACKET_SOCK_HAS_VNET_HDR, val);
>>> +            po->vnet_hdr_sz = hdr_len;
>> Needs to use WRITE_ONCE to match the READ_ONCE elsewhere
>
>
> Thanks for pointing out. We will fix this in the next version of patch.
>
>
>>
>>>               ret = 0;
>>>           }
>>>           release_sock(sk);
>>> @@ -4062,7 +4083,10 @@ static int packet_getsockopt(struct socket 
>>> *sock, int level, int optname,
>>>           val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
>>>           break;
>>>       case PACKET_VNET_HDR:
>>> -        val = packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR);
>>> +        val = !!po->vnet_hdr_sz;
>>> +        break;
>>> +    case PACKET_VNET_HDR_SZ:
>>> +        val = po->vnet_hdr_sz;
>>>           break;
>>>       case PACKET_VERSION:
>>>           val = po->tp_version;
>>> diff --git a/net/packet/diag.c b/net/packet/diag.c
>>> index de4ced5cf3e8..5cf13cf0b862 100644
>>> --- a/net/packet/diag.c
>>> +++ b/net/packet/diag.c
>>> @@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock 
>>> *po, struct sk_buff *nlskb)
>>>           pinfo.pdi_flags |= PDI_AUXDATA;
>>>       if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
>>>           pinfo.pdi_flags |= PDI_ORIGDEV;
>>> -    if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
>>> +    if (po->vnet_hdr_sz)
>>>           pinfo.pdi_flags |= PDI_VNETHDR;
>>>       if (packet_sock_flag(po, PACKET_SOCK_TP_LOSS))
>>>           pinfo.pdi_flags |= PDI_LOSS;
>>> diff --git a/net/packet/internal.h b/net/packet/internal.h
>>> index 27930f69f368..63f4865202c1 100644
>>> --- a/net/packet/internal.h
>>> +++ b/net/packet/internal.h
>>> @@ -118,6 +118,7 @@ struct packet_sock {
>>>       struct mutex        pg_vec_lock;
>>>       unsigned long        flags;
>>>       int            ifindex;    /* bound device        */
>>> +    u8            vnet_hdr_sz;
>> Did you use pahole to find a spot that is currently padding?
>>
>> This looks good in principle, an int followed by __be16.
>
>
> Yes, we have checked this spot with pahole to make sure it is a right 
> place to add vnet_hdr_sz.
>
> Here's the result:
>
> struct packet_sock {
>     struct sock                sk;                   /*     0 776 */
>     /* --- cacheline 12 boundary (768 bytes) was 8 bytes ago --- */
>     struct packet_fanout *     fanout;               /*   776 8 */
>     union tpacket_stats_u      stats;                /*   784 12 */
>
>     /* XXX 4 bytes hole, try to pack */
>
>     struct packet_ring_buffer  rx_ring;              /*   800 200 */
>     /* --- cacheline 15 boundary (960 bytes) was 40 bytes ago --- */
>     struct packet_ring_buffer  tx_ring;              /*  1000 200 */
>     /* --- cacheline 18 boundary (1152 bytes) was 48 bytes ago --- */
>     int                        copy_thresh;          /*  1200 4 */
>     spinlock_t                 bind_lock;            /*  1204 4 */
>     struct mutex               pg_vec_lock;          /*  1208 32 */
>     /* --- cacheline 19 boundary (1216 bytes) was 24 bytes ago --- */
>     long unsigned int          flags;                /*  1240 8 */
>     int                        ifindex;              /*  1248 4 */
>     u8                         vnet_hdr_sz;          /*  1252 1 */
>
>     /* XXX 1 byte hole, try to pack */
>
>     __be16                     num;                  /*  1254 2 */
>     struct packet_rollover *   rollover;             /*  1256 8 */
>     struct packet_mclist *     mclist;               /*  1264 8 */
>     atomic_t                   mapped;               /*  1272 4 */
>     enum tpacket_versions      tp_version;           /*  1276 4 */
>     /* --- cacheline 20 boundary (1280 bytes) --- */
>     unsigned int               tp_hdrlen;            /*  1280 4 */
>     unsigned int               tp_reserve;           /*  1284 4 */
>     unsigned int               tp_tstamp;            /*  1288 4 */
>
>     /* XXX 4 bytes hole, try to pack */
>
>     struct completion          skb_completion;       /*  1296 32 */
>     struct net_device *        cached_dev;           /*  1328 8 */
>
>     /* XXX 8 bytes hole, try to pack */
>
>     /* --- cacheline 21 boundary (1344 bytes) --- */
>     struct packet_type         prot_hook;            /*  1344 72 */
>
>     /* XXX 56 bytes hole, try to pack */
>
>     /* --- cacheline 23 boundary (1472 bytes) --- */
>     atomic_t                   tp_drops;             /*  1472 4 */
>
>     /* Force padding: */
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>     atomic_t                   :32;
>
>     /* size: 1536, cachelines: 24, members: 23 */
>     /* sum members: 1403, holes: 5, sum holes: 73 */
>     /* padding: 60 */
> };
>
>
>>>       __be16            num;
>>>       struct packet_rollover    *rollover;
>>>       struct packet_mclist    *mclist;
>>> @@ -139,7 +140,6 @@ enum packet_sock_flags {
>>>       PACKET_SOCK_AUXDATA,
>>>       PACKET_SOCK_TX_HAS_OFF,
>>>       PACKET_SOCK_TP_LOSS,
>>> -    PACKET_SOCK_HAS_VNET_HDR,
>>>       PACKET_SOCK_RUNNING,
>>>       PACKET_SOCK_PRESSURE,
>>>       PACKET_SOCK_QDISC_BYPASS,
>>> -- 
>>> 2.19.1.6.gb485710b
>>>
>>>
