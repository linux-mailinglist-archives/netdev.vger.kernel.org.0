Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C640691770
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 05:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjBJEAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 23:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjBJEAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 23:00:15 -0500
Received: from out0-212.mail.aliyun.com (out0-212.mail.aliyun.com [140.205.0.212])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E168A6F224
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 20:00:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047199;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---.RHcbD4T_1676001610;
Received: from 30.46.243.134(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RHcbD4T_1676001610)
          by smtp.aliyun-inc.com;
          Fri, 10 Feb 2023 12:00:11 +0800
Message-ID: <d4ff2572-6fbf-cedd-9255-7411aadc09ad@antgroup.com>
Date:   Fri, 10 Feb 2023 12:00:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] net/packet: add socketopt to set/get vnet_hdr_sz
To:     Willem de Bruijn <willemb@google.com>
Cc:     <netdev@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <mst@redhat.com>, <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-2-git-send-email-amy.saq@antgroup.com>
 <CA+FuTSdDxsJs4n+6EsKuRyikiomRoqu5uo3dUj3zd4oY5maUBw@mail.gmail.com>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <CA+FuTSdDxsJs4n+6EsKuRyikiomRoqu5uo3dUj3zd4oY5maUBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/9 下午10:45, Willem de Bruijn 写道:
> On Thu, Feb 9, 2023 at 7:43 AM 沈安琪(凛玥) <amy.saq@antgroup.com> wrote:
>> From: "Jianfeng Tan" <henry.tjf@antgroup.com>
>>
>> Raw socket can be used as the backend for kernel vhost, like tap.
> Please refer to PF_PACKET sockets as packet sockets.
>
> "raw" sockets is ambiguous: it is also used to refer to type SOCK_RAW
> of other socket families.
>
>> However, in current raw socket implementation, it use hardcoded virtio
>> net header length, which will cause error mac header parsing when some
>> virtio features that need virtio net header other than 10-byte are used.
> This series only adds support for skipping past two extra bytes.
>
> The 2-byte field num_buffers in virtio_net_hdr_mrg_rxbuf is used for
> coalesced buffers. That is not a feature packet sockets support.
>
> How do you intend to use this? Only ever with num_buffers == 1?


This 2-byte field will later be used to record how many buffers it can 
use when virtio mergeable is enable in drivers/vhost/net.c:1231.

Here we need to skip this 2-byte field in af_packet since otherwise, the 
number of buffers info will overwrite the mac header info.


>
> We have to make ABI changes sparingly. It would take another setsockopt
> to signal actual use of this feature.
>
> If adding an extended struct, then this also needs to be documented in
> the UAPI headers.
>
>> By adding extra field vnet_hdr_sz in packet_sock to record virtio net
>> header size that current raw socket should use and supporting extra
>> sockopt PACKET_VNET_HDR_SZ to allow user level set specified vnet header
>> size to current socket, raw socket will know the exact virtio net header
>> size it should use instead of hardcoding to avoid incorrect header
>> parsing.
>>
>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
>> ---
>>   include/uapi/linux/if_packet.h |  1 +
>>   net/packet/af_packet.c         | 34 ++++++++++++++++++++++++++++++++++
>>   net/packet/internal.h          |  3 ++-
>>   3 files changed, 37 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
>> index 78c981d..9efc423 100644
>> --- a/include/uapi/linux/if_packet.h
>> +++ b/include/uapi/linux/if_packet.h
>> @@ -59,6 +59,7 @@ struct sockaddr_ll {
>>   #define PACKET_ROLLOVER_STATS          21
>>   #define PACKET_FANOUT_DATA             22
>>   #define PACKET_IGNORE_OUTGOING         23
>> +#define PACKET_VNET_HDR_SZ             24
>>
>>   #define PACKET_FANOUT_HASH             0
>>   #define PACKET_FANOUT_LB               1
>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>> index 8ffb19c..8389f18 100644
>> --- a/net/packet/af_packet.c
>> +++ b/net/packet/af_packet.c
>> @@ -3936,11 +3936,42 @@ static void packet_flush_mclist(struct sock *sk)
>>                          ret = -EBUSY;
>>                  } else {
>>                          po->has_vnet_hdr = !!val;
>> +                       /* set vnet_hdr_sz to default value */
>> +                       if (po->has_vnet_hdr)
>> +                               po->vnet_hdr_sz = sizeof(struct virtio_net_hdr);
>> +                       else
>> +                               po->vnet_hdr_sz = 0;
>>                          ret = 0;
>>                  }
>>                  release_sock(sk);
>>                  return ret;
>>          }
>> +       case PACKET_VNET_HDR_SZ:
>> +       {
>> +               int val;
>> +
>> +               if (sock->type != SOCK_RAW)
>> +                       return -EINVAL;
>> +               if (optlen < sizeof(val))
>> +                       return -EINVAL;
>> +               if (copy_from_user(&val, optval, sizeof(val)))
>> +                       return -EFAULT;
> This duplicates the code in PACKET_VNET_HR. I'd prefer:
>
>          case PACKET_VNET_HDR:
>          case PACKET_VNET_HDR_SZ:
>
>          .. sanity checks and copy from user ..
>
>          if (optname = PACKET_VNET_HDR)
>                  val = sizeof(struct virtio_net_hdr);
>
> And move the check for valid lengths before taking the lock.


Thanks for pointing out. It makes sense and we will address in the next 
version of patch.


>
>> +
>> +               lock_sock(sk);
>> +               if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>> +                       ret = -EBUSY;
>> +               } else {
>> +                       if (val == sizeof(struct virtio_net_hdr) ||
>> +                           val == sizeof(struct virtio_net_hdr_mrg_rxbuf)) {
>> +                               po->vnet_hdr_sz = val;
>> +                               ret = 0;
>> +                       } else {
>> +                               ret = -EINVAL;
>> +                       }
>> +               }
>> +               release_sock(sk);
>> +               return ret;
>> +       }
>>          case PACKET_TIMESTAMP:
>>          {
>>                  int val;
>> @@ -4070,6 +4101,9 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
>>          case PACKET_VNET_HDR:
>>                  val = po->has_vnet_hdr;
>>                  break;
>> +       case PACKET_VNET_HDR_SZ:
>> +               val = po->vnet_hdr_sz;
>> +               break;
>>          case PACKET_VERSION:
>>                  val = po->tp_version;
>>                  break;
>> diff --git a/net/packet/internal.h b/net/packet/internal.h
>> index 48af35b..e27b47d 100644
>> --- a/net/packet/internal.h
>> +++ b/net/packet/internal.h
>> @@ -121,7 +121,8 @@ struct packet_sock {
>>                                  origdev:1,
>>                                  has_vnet_hdr:1,
>>                                  tp_loss:1,
>> -                               tp_tx_has_off:1;
>> +                               tp_tx_has_off:1,
>> +                               vnet_hdr_sz:8;  /* vnet header size should use */
> This location looks fine from the point of view of using holes in the
> struct:
>
>
>          /* --- cacheline 12 boundary (768 bytes) --- */
>          struct packet_ring_buffer  rx_ring;              /*   768   200 */
>          /* --- cacheline 15 boundary (960 bytes) was 8 bytes ago --- */
>          struct packet_ring_buffer  tx_ring;              /*   968   200 */
>          /* --- cacheline 18 boundary (1152 bytes) was 16 bytes ago --- */
>          int                        copy_thresh;          /*  1168     4 */
>          spinlock_t                 bind_lock;            /*  1172     4 */
>          struct mutex               pg_vec_lock;          /*  1176    32 */
>          unsigned int               running;              /*  1208     4 */
>          unsigned int               auxdata:1;            /*  1212: 0  4 */
>          unsigned int               origdev:1;            /*  1212: 1  4 */
>          unsigned int               has_vnet_hdr:1;       /*  1212: 2  4 */
>          unsigned int               tp_loss:1;            /*  1212: 3  4 */
>          unsigned int               tp_tx_has_off:1;      /*  1212: 4  4 */
>
>          /* XXX 27 bits hole, try to pack */
>
>          /* --- cacheline 19 boundary (1216 bytes) --- */
>
>>          int                     pressure;
>>          int                     ifindex;        /* bound device         */
>>          __be16                  num;
>> --
>> 1.8.3.1
>>
