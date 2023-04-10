Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00A46DC648
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 13:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjDJLfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 07:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjDJLfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 07:35:51 -0400
Received: from out0-220.mail.aliyun.com (out0-220.mail.aliyun.com [140.205.0.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199EA44BE;
        Mon, 10 Apr 2023 04:35:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047203;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---.SC19wEc_1681126544;
Received: from 30.177.20.28(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.SC19wEc_1681126544)
          by smtp.aliyun-inc.com;
          Mon, 10 Apr 2023 19:35:45 +0800
Message-ID: <ecf41420-fc4f-dc12-d927-9c2b9730f505@antgroup.com>
Date:   Mon, 10 Apr 2023 19:35:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v7] net/packet: support mergeable feature of virtio
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230407115454.178143-1-amy.saq@antgroup.com>
 <6430dd96dcbad_1363629454@willemb.c.googlers.com.notmuch>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <6430dd96dcbad_1363629454@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/4/8 上午11:20, Willem de Bruijn 写道:
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
>> ---
>>
>> V6 -> V7:
>> * addresses coding style comments.
>>
>> V5 -> V6:
>> * rebase patch based on 6.3-rc2.
>>
>> V4 -> V5:
>> * add READ_ONCE() macro when initializing local vnet_hdr_sz variable;
>> * fix some nits.
>>
>> V3 -> V4:
>> * read po->vnet_hdr_sz once during vnet_hdr_sz and use vnet_hdr_sz locally
>> to avoid race condition;
>> * modify how to check non-zero po->vnet_hdr_sz;
>> * separate vnet_hdr_sz as a u8 field in struct packet_sock instead of 8-bit
>> in an int field.
>>
>> V2 -> V3:
>> * remove has_vnet_hdr field and use vnet_hdr_sz to indicate whether
>> there is a vnet header;
>> * refactor PACKET_VNET_HDR and PACKET_VNET_HDR_SZ sockopt to remove
>> redundant code.
>>
>> V1 -> V2:
>> * refactor the implementation of PACKET_VNET_HDR and PACKET_VNET_HDR_SZ
>> socketopts to get rid of redundate code;
>> * amend packet_rcv_vnet in af_packet.c to avoid extra function invocation.
>>
>>   include/uapi/linux/if_packet.h |  1 +
>>   net/packet/af_packet.c         | 89 ++++++++++++++++++++++------------
>>   net/packet/diag.c              |  2 +-
>>   net/packet/internal.h          |  2 +-
>>   4 files changed, 60 insertions(+), 34 deletions(-)
>>
>> diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
>> index 78c981d6a9d4..9efc42382fdb 100644
>> --- a/include/uapi/linux/if_packet.h
>> +++ b/include/uapi/linux/if_packet.h
>> @@ -59,6 +59,7 @@ struct sockaddr_ll {
>>   #define PACKET_ROLLOVER_STATS		21
>>   #define PACKET_FANOUT_DATA		22
>>   #define PACKET_IGNORE_OUTGOING		23
>> +#define PACKET_VNET_HDR_SZ		24
>>   
>>   #define PACKET_FANOUT_HASH		0
>>   #define PACKET_FANOUT_LB		1
>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>> index 497193f73030..69044341fb8c 100644
>> --- a/net/packet/af_packet.c
>> +++ b/net/packet/af_packet.c
>> @@ -2090,18 +2090,18 @@ static unsigned int run_filter(struct sk_buff *skb,
>>   }
>>   
>>   static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
>> -			   size_t *len)
>> +			   size_t *len, int vnet_hdr_sz)
>>   {
>> -	struct virtio_net_hdr vnet_hdr;
>> +	struct virtio_net_hdr_mrg_rxbuf vnet_hdr = { .num_buffers = 0 };
>>   
>> -	if (*len < sizeof(vnet_hdr))
>> +	if (*len < vnet_hdr_sz)
>>   		return -EINVAL;
>> -	*len -= sizeof(vnet_hdr);
>> +	*len -= vnet_hdr_sz;
>>   
>> -	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0))
>> +	if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)&vnet_hdr, vio_le(), true, 0))
>>   		return -EINVAL;
>>   
>> -	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
>> +	return memcpy_to_msg(msg, (void *)&vnet_hdr, vnet_hdr_sz);
>>   }
>>   
>>   /*
>> @@ -2251,6 +2251,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   	bool is_drop_n_account = false;
>>   	unsigned int slot_id = 0;
>>   	bool do_vnet = false;
>> +	int vnet_hdr_sz;
> I had missed this earlier, but do_vnet is now redundant.
> Akin to has_vnet_hdr in packet_snd.
>
> More importantly, there is a path with do_vnet that hardcodes the
> assumed header length:
>
>          if (do_vnet &&
>              virtio_net_hdr_from_skb(skb, h.raw + macoff -
>                                      sizeof(struct virtio_net_hdr),
>                                      vio_le(), true, 0)) {
>
> This needs to use vnet_hdr_sz.
>
> Please also review the entire af_packet.c if there are other
> remaining hardcoded values that should be replaced with
> vnet_hdr_sz.


Thanks for pointing out. We will review it throughoutly to avoid the 
redundant do_vnet using.


>
>>   
>>   	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNMENT.
>>   	 * We may add members to them until current aligned size without forcing
>> @@ -2308,8 +2309,9 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   		netoff = TPACKET_ALIGN(po->tp_hdrlen +
>>   				       (maclen < 16 ? 16 : maclen)) +
>>   				       po->tp_reserve;
>> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
>> -			netoff += sizeof(struct virtio_net_hdr);
>> +		vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
>> +		if (vnet_hdr_sz) {
>> +			netoff += vnet_hdr_sz;
>>   			do_vnet = true;
>>   		}
>>   		macoff = netoff - maclen;
>> @@ -2551,16 +2553,26 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
>>   }
>>   
>>   static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
>> -				 struct virtio_net_hdr *vnet_hdr)
>> +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
>>   {
>> -	if (*len < sizeof(*vnet_hdr))
>> +	int ret;
>> +
>> +	if (*len < vnet_hdr_sz)
>>   		return -EINVAL;
>> -	*len -= sizeof(*vnet_hdr);
>> +	*len -= vnet_hdr_sz;
>>   
>>   	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter))
>>   		return -EFAULT;
>>   
>> -	return __packet_snd_vnet_parse(vnet_hdr, *len);
>> +	ret = __packet_snd_vnet_parse(vnet_hdr, *len);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* move iter to point to the start of mac header */
>> +	if (vnet_hdr_sz != sizeof(struct virtio_net_hdr))
>> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
>> +
>> +	return 0;
>>   }
>>   
>>   static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
>> @@ -2722,6 +2734,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   	void *ph;
>>   	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
>>   	bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
>> +	int vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
>>   	unsigned char *addr = NULL;
>>   	int tp_len, size_max;
>>   	void *data;
>> @@ -2779,8 +2792,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   	size_max = po->tx_ring.frame_size
>>   		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
>>   
>> -	if ((size_max > dev->mtu + reserve + VLAN_HLEN) &&
>> -	    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
>> +	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !vnet_hdr_sz)
>>   		size_max = dev->mtu + reserve + VLAN_HLEN;
>>   
>>   	reinit_completion(&po->skb_completion);
>> @@ -2809,10 +2821,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   		status = TP_STATUS_SEND_REQUEST;
>>   		hlen = LL_RESERVED_SPACE(dev);
>>   		tlen = dev->needed_tailroom;
>> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
>> +
>> +		if (vnet_hdr_sz) {
>>   			vnet_hdr = data;
>> -			data += sizeof(*vnet_hdr);
>> -			tp_len -= sizeof(*vnet_hdr);
>> +			data += vnet_hdr_sz;
>> +			tp_len -= vnet_hdr_sz;
>>   			if (tp_len < 0 ||
>>   			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
>>   				tp_len = -EINVAL;
>> @@ -2837,7 +2850,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   					  addr, hlen, copylen, &sockc);
>>   		if (likely(tp_len >= 0) &&
>>   		    tp_len > dev->mtu + reserve &&
>> -		    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR) &&
>> +		    !vnet_hdr_sz &&
>>   		    !packet_extra_vlan_len_allowed(dev, skb))
>>   			tp_len = -EMSGSIZE;
>>   
>> @@ -2856,7 +2869,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   			}
>>   		}
>>   
>> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
>> +		if (vnet_hdr_sz) {
>>   			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
>>   				tp_len = -EINVAL;
>>   				goto tpacket_error;
>> @@ -2946,7 +2959,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   	struct virtio_net_hdr vnet_hdr = { 0 };
>>   	int offset = 0;
>>   	struct packet_sock *po = pkt_sk(sk);
>> -	bool has_vnet_hdr = false;
>> +	int vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
>>   	int hlen, tlen, linear;
>>   	int extra_len = 0;
>>   
>> @@ -2990,11 +3003,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   
>>   	if (sock->type == SOCK_RAW)
>>   		reserve = dev->hard_header_len;
>> -	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
>> -		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
>> +
>> +	if (vnet_hdr_sz) {
>> +		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>>   		if (err)
>>   			goto out_unlock;
>> -		has_vnet_hdr = true;
>>   	}
>>   
>>   	if (unlikely(sock_flag(sk, SOCK_NOFCS))) {
>> @@ -3064,11 +3077,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   
>>   	packet_parse_headers(skb, sock);
>>   
>> -	if (has_vnet_hdr) {
>> +	if (vnet_hdr_sz) {
>>   		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>>   		if (err)
>>   			goto out_free;
>> -		len += sizeof(vnet_hdr);
>> +		len += vnet_hdr_sz;
>>   		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>>   	}
>>   
>> @@ -3408,7 +3421,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>   	struct sock *sk = sock->sk;
>>   	struct sk_buff *skb;
>>   	int copied, err;
>> -	int vnet_hdr_len = 0;
>> +	int vnet_hdr_len = READ_ONCE(pkt_sk(sk)->vnet_hdr_sz);
>>   	unsigned int origlen = 0;
>>   
>>   	err = -EINVAL;
>> @@ -3449,11 +3462,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>   
>>   	packet_rcv_try_clear_pressure(pkt_sk(sk));
>>   
>> -	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_HAS_VNET_HDR)) {
>> -		err = packet_rcv_vnet(msg, skb, &len);
>> +	if (vnet_hdr_len) {
>> +		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>>   		if (err)
>>   			goto out_free;
>> -		vnet_hdr_len = sizeof(struct virtio_net_hdr);
>>   	}
>>   
>>   	/* You lose any data beyond the buffer you gave. If it worries
>> @@ -3915,8 +3927,9 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
>>   		return 0;
>>   	}
>>   	case PACKET_VNET_HDR:
>> +	case PACKET_VNET_HDR_SZ:
>>   	{
>> -		int val;
>> +		int val, hdr_len;
>>   
>>   		if (sock->type != SOCK_RAW)
>>   			return -EINVAL;
>> @@ -3925,11 +3938,20 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
>>   		if (copy_from_sockptr(&val, optval, sizeof(val)))
>>   			return -EFAULT;
>>   
>> +		if (optname == PACKET_VNET_HDR_SZ) {
>> +			if (val && val != sizeof(struct virtio_net_hdr) &&
>> +			    val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
>> +				return -EINVAL;
>> +			hdr_len = val;
>> +		} else {
>> +			hdr_len = val ? sizeof(struct virtio_net_hdr) : 0;
>> +		}
>> +
>>   		lock_sock(sk);
>>   		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>>   			ret = -EBUSY;
>>   		} else {
>> -			packet_sock_flag_set(po, PACKET_SOCK_HAS_VNET_HDR, val);
>> +			WRITE_ONCE(po->vnet_hdr_sz, hdr_len);
>>   			ret = 0;
>>   		}
>>   		release_sock(sk);
>> @@ -4062,7 +4084,10 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
>>   		val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
>>   		break;
>>   	case PACKET_VNET_HDR:
>> -		val = packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR);
>> +		val = !!po->vnet_hdr_sz;
>> +		break;
>> +	case PACKET_VNET_HDR_SZ:
>> +		val = po->vnet_hdr_sz;
>>   		break;
>>   	case PACKET_VERSION:
>>   		val = po->tp_version;
>> diff --git a/net/packet/diag.c b/net/packet/diag.c
>> index de4ced5cf3e8..5cf13cf0b862 100644
>> --- a/net/packet/diag.c
>> +++ b/net/packet/diag.c
>> @@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
>>   		pinfo.pdi_flags |= PDI_AUXDATA;
>>   	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
>>   		pinfo.pdi_flags |= PDI_ORIGDEV;
>> -	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
>> +	if (po->vnet_hdr_sz)
>>   		pinfo.pdi_flags |= PDI_VNETHDR;
> always read with READ_ONCE to avoid KCSAN warnings
>
> This also applies to the getsockopt


Thanks for pointing out. We will enable CONFIG_KCSAN to make sure all 
these issues has been covered.


>>   	if (packet_sock_flag(po, PACKET_SOCK_TP_LOSS))
>>   		pinfo.pdi_flags |= PDI_LOSS;
>> diff --git a/net/packet/internal.h b/net/packet/internal.h
>> index 27930f69f368..63f4865202c1 100644
>> --- a/net/packet/internal.h
>> +++ b/net/packet/internal.h
>> @@ -118,6 +118,7 @@ struct packet_sock {
>>   	struct mutex		pg_vec_lock;
>>   	unsigned long		flags;
>>   	int			ifindex;	/* bound device		*/
>> +	u8			vnet_hdr_sz;
>>   	__be16			num;
>>   	struct packet_rollover	*rollover;
>>   	struct packet_mclist	*mclist;
>> @@ -139,7 +140,6 @@ enum packet_sock_flags {
>>   	PACKET_SOCK_AUXDATA,
>>   	PACKET_SOCK_TX_HAS_OFF,
>>   	PACKET_SOCK_TP_LOSS,
>> -	PACKET_SOCK_HAS_VNET_HDR,
>>   	PACKET_SOCK_RUNNING,
>>   	PACKET_SOCK_PRESSURE,
>>   	PACKET_SOCK_QDISC_BYPASS,
>> -- 
>> 2.19.1.6.gb485710b
>>
