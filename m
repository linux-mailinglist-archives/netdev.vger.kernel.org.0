Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9E2591690
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 23:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiHLVEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 17:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiHLVEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 17:04:32 -0400
Received: from smtp78.ord1c.emailsrvr.com (smtp78.ord1c.emailsrvr.com [108.166.43.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE1BB4409
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 14:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1660338268;
        bh=nvsKZCHD7EetCBtpMcHjTKQKcpeA8GNCL/yUkhydj54=;
        h=Date:To:From:Subject:From;
        b=qhhaS+H7RI0qGQEsTCxT1mhoCv5fner9OUArElrtUIjFCEzcx2imVsop4d1yJHaTS
         7mnt5CnmrHxW9Lm3s8ny4Y3LvtH3GI8xsOYejWu72PSypyawjfc4m9PpLIKqjgNDEA
         JDfGMhAHMukPyajrlTamrV27OsEvXcVhmGKztq7A=
X-Auth-ID: antonio@openvpn.net
Received: by smtp26.relay.ord1c.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 7A374E0495;
        Fri, 12 Aug 2022 17:04:27 -0400 (EDT)
Message-ID: <1eb71408-c79d-1097-6841-829bc8e272d1@openvpn.net>
Date:   Fri, 12 Aug 2022 23:05:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220719014704.21346-2-antonio@openvpn.net>
 <20220803153152.11189-1-antonio@openvpn.net>
 <CAHNKnsQnHAdxC-XhC9RP-cFp0d-E4YGb+7ie3WymXVL9N-QS6A@mail.gmail.com>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
Subject: Re: [RFC v2] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
In-Reply-To: <CAHNKnsQnHAdxC-XhC9RP-cFp0d-E4YGb+7ie3WymXVL9N-QS6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 294d18e6-3c99-40b2-88b7-1b3708c81335-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sergey,

Thank you VERY much for your feedback!

Please, see my comments inline

On 12/08/2022 20:34, Sergey Ryazanov wrote:
> Hello Antonio,
> 
> first of all, I would like to say thank you for taking care of this.
> Such useful software as OpenVPN deserves a kernel accelerated rate,
> and probably a lot of users, including me, are waiting for such
> feature.
> 
> On Wed, Aug 3, 2022 at 6:37 PM Antonio Quartulli <antonio@openvpn.net> wrote:
>> OpenVPN is a userspace software existing since around 2005 that allows
>> users to create secure tunnels.
>>
>> So far OpenVPN has implemented all operations in userspace, which
>> implies several back and forth between kernel and user land in order to
>> process packets (encapsulate/decapsulate, encrypt/decrypt, rerouting..).
>>
>> With ovpn-dco, we intend to move the fast path (data channel) entirely
>> in kernel space and thus improve user measured throughput over the
>> tunnel.
>>
>> ovpn-dco is implemented as a simple virtual network device driver, that
>> can be manipulated by means of the standard RTNL APIs. A device of kind
>> 'ovpn-dco' allows only IPv4/6 traffic and can be of type:
>> * P2P (peer-to-peer): any packet sent over the interface will be
>>    encapsulated and transmitted to the other side (typical OpenVPN
>>    client behaviour);
>> * P2MP (point-to-multipoint): packets sent over the interface are
>>    transmitted to peers based on existing routes (typical OpenVPN
>>    server behaviour).
>>
>> After the interface has been created, OpenVPN in userspace can
>> configure it using a new Netlink API. Specifically it is possible
>> to manage peers, configure per-peer keys and exchange packets with
>> userspace.
>>
>> The OpenVPN control channel is multiplexed over the same transport
>> socket by means of OP codes. Anything that is not DATA_V2 (OpenVPN
>> OP code for data traffic) is sent to userspace and handled there.
>> This way the ovpn-dco codebase is kept as compact as possible while
>> focusing on handling data traffic only.
>>
>> Any OpenVPN control feature (like cipher negotiation, TLS handshake,
>> rekeying, etc.) is still fully handled by the userspace process.
>>
>> When userspace establishes a new connection with a peer, it first
>> performs the handshake and then passes the socket to ovpn-dco, which
>> takes ownership. From this moment on ovpn-dco will handle data traffic
>> for the new peer. When control packets are received on the link, they
>> are forwarded to userspace via Netlink.
>>
>> (this approach is somewhat inspired by hostapd+mac80211)
>>
>> Some events (like peer deletion) are sent to a Netlink multicast group.
>>
>> Although it wasn't easy to convince the community, ovpn-dco implements
>> only a limited number of the data-channel features supported by the
>> userspace program.
>>
>> Each feature that made it to ovpn-dco was attentively vetted to
>> avoid carrying too much legacy along with us (and to give a clear cut to
>> old and probalby-not-so-useful features).
>>
>> Notably, only encryption using AEAD ciphers (specifically
>> ChaCha20Poly1305 and AES-GCM) was implemented. Supporting any other
>> cipher out there was not deemed useful.
>>
>> As explained above, in case of P2MP mode, OpenVPN will use the main system
>> routing table to decide which packet goes to which peer. This implies
>> that no routing table was re-implemented in ovpn-dco.
>>
>> This kernel module can be enabled by selecting the CONFIG_OVPN_DCO entry
>> in the networking drivers section.
>>
>> Cc: David Miller <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
>> ---
>>
>> Changes from v1:
>> * use net/netdev print helpers when possible
>> * properly set min/max_mtu
>> * get rid of ndo_change_mtu
>> * don't set version in ethtool output
>> * ensure can be compiled also when no IPv6 support exists
>>
>> ---
>>   MAINTAINERS                        |    8 +
>>   drivers/net/Kconfig                |   19 +
>>   drivers/net/Makefile               |    1 +
>>   drivers/net/ovpn-dco/Makefile      |   21 +
>>   drivers/net/ovpn-dco/addr.h        |   41 +
>>   drivers/net/ovpn-dco/bind.c        |   62 ++
>>   drivers/net/ovpn-dco/bind.h        |   67 ++
>>   drivers/net/ovpn-dco/crypto.c      |  154 ++++
>>   drivers/net/ovpn-dco/crypto.h      |  144 ++++
>>   drivers/net/ovpn-dco/crypto_aead.c |  367 +++++++++
>>   drivers/net/ovpn-dco/crypto_aead.h |   27 +
>>   drivers/net/ovpn-dco/main.c        |  271 +++++++
>>   drivers/net/ovpn-dco/main.h        |   32 +
>>   drivers/net/ovpn-dco/netlink.c     | 1143 ++++++++++++++++++++++++++++
>>   drivers/net/ovpn-dco/netlink.h     |   22 +
>>   drivers/net/ovpn-dco/ovpn.c        |  600 +++++++++++++++
>>   drivers/net/ovpn-dco/ovpn.h        |   43 ++
>>   drivers/net/ovpn-dco/ovpnstruct.h  |   59 ++
>>   drivers/net/ovpn-dco/peer.c        |  906 ++++++++++++++++++++++
>>   drivers/net/ovpn-dco/peer.h        |  168 ++++
>>   drivers/net/ovpn-dco/pktid.c       |  127 ++++
>>   drivers/net/ovpn-dco/pktid.h       |  116 +++
>>   drivers/net/ovpn-dco/proto.h       |  101 +++
>>   drivers/net/ovpn-dco/rcu.h         |   21 +
>>   drivers/net/ovpn-dco/skb.h         |   54 ++
>>   drivers/net/ovpn-dco/sock.c        |  134 ++++
>>   drivers/net/ovpn-dco/sock.h        |   54 ++
>>   drivers/net/ovpn-dco/stats.c       |   20 +
>>   drivers/net/ovpn-dco/stats.h       |   67 ++
>>   drivers/net/ovpn-dco/tcp.c         |  326 ++++++++
>>   drivers/net/ovpn-dco/tcp.h         |   38 +
>>   drivers/net/ovpn-dco/udp.c         |  343 +++++++++
>>   drivers/net/ovpn-dco/udp.h         |   25 +
>>   include/net/netlink.h              |    1 +
>>   include/uapi/linux/ovpn_dco.h      |  265 +++++++
>>   include/uapi/linux/udp.h           |    1 +
>>   36 files changed, 5848 insertions(+)
> 
> It is very hard to review almost 6 thousand lines of code at once.
> Some issues may be overlooked. I would like to ask you to do the
> following submission as a series of patches. It is easier to review
> the code separated into patches by logically completed functional
> blocks. E.g., module skeleton, management API framework, crypto
> framework, minimal data handling utils, UDP transport support, TCP
> transport support, other supplementary features like ethtools API,
> statistics, etc. This was just an example, you better know internal
> code dependencies and a best way to introduce the functionality.

You are right about the review being a bit harder, but I did not know 
what was the preferred approach.

It seemed that other modules are also introduced in one commit, so I 
just did the same.

But if it's accepted to have "compiling" commits that do not really 
deliver a working driver, I am fine with splitting this up.

> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1920d82db83e..7cb16007dd5c 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15103,6 +15103,14 @@ T:     git git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
>>   F:     Documentation/filesystems/overlayfs.rst
>>   F:     fs/overlayfs/
>>
>> +OVPN-DCO NETWORK DRIVER
>> +M:     Antonio Quartulli <antonio@openvpn.net>
>> +L:     openvpn-devel@lists.sourceforge.net (moderated for non-subscribers)
>> +L:     netdev@vger.kernel.org
>> +S:     Maintained
>> +F:     drivers/net/ovpn-dco/
>> +F:     include/uapi/linux/ovpn_dco.h
>> +
>>   P54 WIRELESS DRIVER
>>   M:     Christian Lamparter <chunkeey@googlemail.com>
>>   L:     linux-wireless@vger.kernel.org
>> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
>> index 94c889802566..349866bd4448 100644
>> --- a/drivers/net/Kconfig
>> +++ b/drivers/net/Kconfig
>> @@ -116,6 +116,25 @@ config WIREGUARD_DEBUG
>>
>>            Say N here unless you know what you're doing.
>>
>> +config OVPN_DCO
>> +       tristate "OpenVPN data channel offload"
> 
> Just curious, why do you need this "DCO" suffix? It is not some
> commonly recognized abbreviation. Why not just call this module
> "OpenVPN"? Or are you planning to move some other components into the
> kernel and reserve some naming space?

This device driver just implements data channel offloading and it is not 
a fully fledged OpenVPN impementation, so I thought it was meaningful to 
make this explicit.

Calling the driver just openvpn/ovpn may give the false impression that 
this is a reimplementation of the whole OpenVPN protocol in kernelspace.

Does it make sense?

The "DCO" acronym may not be so common in other areas, but in the 
OpenVPN community we have been talking about DCO (Data Channel Offload) 
since a while, so it was pretty natural for us to use this suffix.

> 
>> +       depends on NET && INET
>> +       select NET_UDP_TUNNEL
>> +       select DST_CACHE
>> +       select CRYPTO
>> +       select CRYPTO_AES
>> +       select CRYPTO_GCM
>> +       select CRYPTO_CHACHA20POLY1305
>> +       help
>> +         This module enhances the performance of an OpenVPN connection by
>> +         allowing the user to offload the data channel processing to
>> +         kernelspace.
>> +         Connection handshake, parameters negotiation and other non-data
>> +         related mechanisms are still performed in userspace.
>> +
>> +         The OpenVPN userspace software at version 2.6 or higher is required
>> +         to use this functionality.
>> +
>>   config EQUALIZER
>>          tristate "EQL (serial line load balancing) support"
>>          help
> 
> [skipped]
> 
>> +/**
>> + * ovpn_num_queues - define number of queues to allocate per device
>> + *
>> + * The value returned by this function is used to decide how many RX and TX
>> + * queues to allocate when creating the netdev object
>> + *
>> + * Return the number of queues to allocate
>> + */
>> +static unsigned int ovpn_num_queues(void)
>> +{
>> +       return num_online_cpus();
>> +}
>> +
>> +static struct rtnl_link_ops ovpn_link_ops __read_mostly = {
>> +       .kind                   = DRV_NAME,
>> +       .priv_size              = sizeof(struct ovpn_struct),
>> +       .setup                  = ovpn_setup,
>> +       .policy                 = ovpn_policy,
>> +       .maxtype                = IFLA_OVPN_MAX,
>> +       .newlink                = ovpn_newlink,
>> +       .dellink                = ovpn_dellink,
> 
> What is the purpose of creating and destroying interfaces via RTNL,
> but performing all other operations using the dedicated netlink
> protocol?
> 
> RTNL interface usually implemented for some standalone interface
> types, e.g. VLAN, GRE, etc. Here we need a userspace application
> anyway to be able to use the network device to forward traffic, and
> the module implements the dedicated GENL protocol. So why not just
> introduce OVPN_CMD_NEW_IFACE and OVPN_CMD_DEL_IFACE commands to the
> GENL interface? It looks like this will simplify the userspace part by
> using the single GENL interface for any management operations.

As Stephen also said in his reply, I tried to stick to the standard 
approach of creating interface via RTNL (which is also netlink).

With this implementation you can already create an interface as:

ip link add vpn0 type ovpn-dco

Eventually I will patch iproute2 to support some options as well (we 
have one only for now).


> 
>> +       .get_num_tx_queues      = ovpn_num_queues,
>> +       .get_num_rx_queues      = ovpn_num_queues,
> 
> What is the benefit of requesting multiple queues if the xmit callback
> places all packets from those kernel queues into the single internal
> queue anyway?

Good point. This is one of those aspects where I was hoping to get some 
guidance.
In any case, I will double check if having more than one queue is really 
what we want or not.

> 
>> +};
>> +
>> +static int __init ovpn_init(void)
>> +{
>> +       int err = 0;
>> +
>> +       pr_info("%s %s -- %s\n", DRV_DESCRIPTION, DRV_VERSION, DRV_COPYRIGHT);
> 
> Is this log line really necessary for the regular module usage?

Well, it's a reasonable way to give users feedback about the module 
loading successfully. I see it's pretty common across drivers, so I 
thought to use the same approach.

> 
>> +
>> +       /* init RTNL link ops */
>> +       err = rtnl_link_register(&ovpn_link_ops);
>> +       if (err) {
>> +               pr_err("ovpn: can't register RTNL link ops\n");
>> +               goto err;
>> +       }
>> +
>> +       err = ovpn_netlink_register();
>> +       if (err) {
>> +               pr_err("ovpn: can't register netlink family\n");
>> +               goto err_rtnl_unregister;
>> +       }
>> +
>> +       return 0;
>> +
>> +err_rtnl_unregister:
>> +       rtnl_link_unregister(&ovpn_link_ops);
>> +err:
>> +       pr_err("ovpn: initialization failed, error status=%d\n", err);
>> +       return err;
>> +}
> 
> [skipped]
> 
>> +static const struct genl_ops ovpn_netlink_ops[] = {
>> +       {
>> +               .cmd = OVPN_CMD_NEW_PEER,
>> +               .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> 
> AFAIK, the "don't validate strict" flag is for compatibility with old
> users of earlier existing subsystems. For new GENL families, it is
> better to avoid using this flag and strictly implement the netlink
> protocol.

Good point. I can probably just get rid of this flag then.

> 
>> +               .flags = GENL_ADMIN_PERM,
>> +               .doit = ovpn_netlink_new_peer,
>> +       },
>>
>>          ...
>>
>> +};
> 
> [skipped]
> 
>> +static int ovpn_transport_to_userspace(struct ovpn_struct *ovpn, const struct ovpn_peer *peer,
>> +                                      struct sk_buff *skb)
>> +{
>> +       int ret;
>> +
>> +       ret = skb_linearize(skb);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       ret = ovpn_netlink_send_packet(ovpn, peer, skb->data, skb->len);
>> +       if (ret < 0)
>> +               return ret;
> 
> Another interesting decision. Why are you transporting the control
> messages via Netlink? Why not just pass them to userspace via an
> already existing TCP/UDP socket, like the LT2P module do, for example?
> Such design usually requires less changes to the userspace application
> since it is still able to process control messages as earlier by
> reading them from the socket.

As far as I understand the L2TP module implementes its own protocol 
(IPPROTO_L2TP).

In the ovpn-dco case userspace simply opens a normal UDP or TCP socket 
(as it always used to do), which is later passed to the kernel.

In ovpn-dco (kernel) we then use udp_tunnel to take over the UDP socket, 
while we change the socket ops in case of TCP.

While in the UDP case it would be possible to still use the socket to 
send control packets, in the TCP case this would not work and we would 
need another method (which is netlink) to send/receive packets from 
userspace.

At this point we did not want to treat TCP and UDP sockets differently, 
so we decided to always use netlink to send control packets to/from 
userspace.

> 
>> +       consume_skb(skb);
>> +       return 0;
>> +}
> 
> [skipped]
> 
>> +/* Net device start xmit
>> + */
>> +netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +       struct ovpn_struct *ovpn = netdev_priv(dev);
>> +       struct sk_buff *segments, *tmp, *curr, *next;
>> +       struct sk_buff_head skb_list;
>> +       __be16 proto;
>> +       int ret;
>> +
>> +       /* reset netfilter state */
>> +       nf_reset_ct(skb);
>> +
>> +       /* verify IP header size in network packet */
>> +       proto = ovpn_ip_check_protocol(skb);
>> +       if (unlikely(!proto || skb->protocol != proto)) {
>> +               net_dbg_ratelimited("%s: dropping malformed payload packet\n",
>> +                                   dev->name);
>> +               goto drop;
>> +       }
>> +
>> +       if (skb_is_gso(skb)) {
>> +               segments = skb_gso_segment(skb, 0);
>> +               if (IS_ERR(segments)) {
>> +                       ret = PTR_ERR(segments);
>> +                       net_dbg_ratelimited("%s: cannot segment packet: %d\n", dev->name, ret);
>> +                       goto drop;
>> +               }
>> +
>> +               consume_skb(skb);
>> +               skb = segments;
>> +       }
>> +
>> +       /* from this moment on, "skb" might be a list */
>> +
>> +       __skb_queue_head_init(&skb_list);
>> +       skb_list_walk_safe(skb, curr, next) {
>> +               skb_mark_not_on_list(curr);
>> +
>> +               tmp = skb_share_check(curr, GFP_ATOMIC);
>> +               if (unlikely(!tmp)) {
>> +                       kfree_skb_list(next);
>> +                       net_dbg_ratelimited("%s: skb_share_check failed\n", dev->name);
>> +                       goto drop_list;
>> +               }
>> +
>> +               __skb_queue_tail(&skb_list, tmp);
>> +       }
>> +       skb_list.prev->next = NULL;
>> +
>> +       ovpn_queue_skb(ovpn, skb_list.next, NULL);
>> +
>> +       return NETDEV_TX_OK;
>> +
>> +drop_list:
>> +       skb_queue_walk_safe(&skb_list, curr, next)
>> +               kfree_skb(curr);
>> +drop:
>> +       skb_tx_error(skb);
>> +       kfree_skb_list(skb);
>> +       return NET_XMIT_DROP;
>> +}
> 
> [skipped]
> 
>> diff --git a/include/uapi/linux/ovpn_dco.h b/include/uapi/linux/ovpn_dco.h
>> new file mode 100644
>> index 000000000000..6afee8b3fedd
>> --- /dev/null
>> +++ b/include/uapi/linux/ovpn_dco.h
>> @@ -0,0 +1,265 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + *  OpenVPN data channel accelerator
>> + *
>> + *  Copyright (C) 2019-2022 OpenVPN, Inc.
>> + *
>> + *  Author:    James Yonan <james@openvpn.net>
>> + *             Antonio Quartulli <antonio@openvpn.net>
>> + */
>> +
>> +#ifndef _UAPI_LINUX_OVPN_DCO_H_
>> +#define _UAPI_LINUX_OVPN_DCO_H_
>> +
>> +#define OVPN_NL_NAME "ovpn-dco"
>> +
>> +#define OVPN_NL_MULTICAST_GROUP_PEERS "peers"
>> +
>> +/**
>> + * enum ovpn_nl_commands - supported netlink commands
>> + */
>> +enum ovpn_nl_commands {
>> +       /**
>> +        * @OVPN_CMD_UNSPEC: unspecified command to catch errors
>> +        */
>> +       OVPN_CMD_UNSPEC = 0,
>> +
>> +       /**
>> +        * @OVPN_CMD_NEW_PEER: Configure peer with its crypto keys
>> +        */
>> +       OVPN_CMD_NEW_PEER,
>> +
>> +       /**
>> +        * @OVPN_CMD_SET_PEER: Tweak parameters for an existing peer
>> +        */
>> +       OVPN_CMD_SET_PEER,
>> +
>> +       /**
>> +        * @OVPN_CMD_DEL_PEER: Remove peer from internal table
>> +        */
>> +       OVPN_CMD_DEL_PEER,
>> +
>> +       OVPN_CMD_NEW_KEY,
>> +
>> +       OVPN_CMD_SWAP_KEYS,
>> +
>> +       OVPN_CMD_DEL_KEY,
>> +
>> +       /**
>> +        * @OVPN_CMD_REGISTER_PACKET: Register for specific packet types to be
>> +        * forwarded to userspace
>> +        */
>> +       OVPN_CMD_REGISTER_PACKET,
>> +
>> +       /**
>> +        * @OVPN_CMD_PACKET: Send a packet from userspace to kernelspace. Also
>> +        * used to send to userspace packets for which a process had registered
>> +        * with OVPN_CMD_REGISTER_PACKET
>> +        */
>> +       OVPN_CMD_PACKET,
>> +
>> +       /**
>> +        * @OVPN_CMD_GET_PEER: Retrieve the status of a peer or all peers
>> +        */
>> +       OVPN_CMD_GET_PEER,
>> +};
>> +
>> +enum ovpn_cipher_alg {
>> +       /**
>> +        * @OVPN_CIPHER_ALG_NONE: No encryption - reserved for debugging only
>> +        */
>> +       OVPN_CIPHER_ALG_NONE = 0,
>> +       /**
>> +        * @OVPN_CIPHER_ALG_AES_GCM: AES-GCM AEAD cipher with any allowed key size
>> +        */
>> +       OVPN_CIPHER_ALG_AES_GCM,
>> +       /**
>> +        * @OVPN_CIPHER_ALG_CHACHA20_POLY1305: ChaCha20Poly1305 AEAD cipher
>> +        */
>> +       OVPN_CIPHER_ALG_CHACHA20_POLY1305,
>> +};
>> +
>> +enum ovpn_del_peer_reason {
>> +       __OVPN_DEL_PEER_REASON_FIRST,
>> +       OVPN_DEL_PEER_REASON_TEARDOWN = __OVPN_DEL_PEER_REASON_FIRST,
>> +       OVPN_DEL_PEER_REASON_USERSPACE,
>> +       OVPN_DEL_PEER_REASON_EXPIRED,
>> +       OVPN_DEL_PEER_REASON_TRANSPORT_ERROR,
>> +       __OVPN_DEL_PEER_REASON_AFTER_LAST
>> +};
>> +
>> +enum ovpn_key_slot {
>> +       __OVPN_KEY_SLOT_FIRST,
>> +       OVPN_KEY_SLOT_PRIMARY = __OVPN_KEY_SLOT_FIRST,
>> +       OVPN_KEY_SLOT_SECONDARY,
>> +       __OVPN_KEY_SLOT_AFTER_LAST,
>> +};
>> +
>> +enum ovpn_netlink_attrs {
>> +       OVPN_ATTR_UNSPEC = 0,
>> +       OVPN_ATTR_IFINDEX,
>> +       OVPN_ATTR_NEW_PEER,
>> +       OVPN_ATTR_SET_PEER,
>> +       OVPN_ATTR_DEL_PEER,
> 
> What is the purpose of introducing separate attributes for each
> NEW/SET/GET/DEL operation? Why not just use a single OVPN_ATTR_PEER
> attribute?

The idea is to have a subobject for each operation. Each specific 
subobject would then contain only the specific attributes allowed for 
that object. This way attributes from different operations are not mixed.

> 
> BTW, generic netlink for some time allows you to have a dedicated set
> of attributes (and corresponding policies) for each message. So, if
> you have different object types (e.g. peers, interfaces, keys) you can
> avoid creating a common set of attributes to cover them all at once,
> but just create several attribute sets, one set per each object type
> with corresponding policies (see policy field of the genl_ops struct).

mh interesting. Any module I could look at that implements this approach?

> 
>> +       OVPN_ATTR_NEW_KEY,
>> +       OVPN_ATTR_SWAP_KEYS,
>> +       OVPN_ATTR_DEL_KEY,
>> +       OVPN_ATTR_PACKET,
>> +       OVPN_ATTR_GET_PEER,
>> +
>> +       __OVPN_ATTR_AFTER_LAST,
>> +       OVPN_ATTR_MAX = __OVPN_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_key_dir_attrs {
>> +       OVPN_KEY_DIR_ATTR_UNSPEC = 0,
>> +       OVPN_KEY_DIR_ATTR_CIPHER_KEY,
>> +       OVPN_KEY_DIR_ATTR_NONCE_TAIL,
>> +
>> +       __OVPN_KEY_DIR_ATTR_AFTER_LAST,
>> +       OVPN_KEY_DIR_ATTR_MAX = __OVPN_KEY_DIR_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_new_key_attrs {
>> +       OVPN_NEW_KEY_ATTR_UNSPEC = 0,
>> +       OVPN_NEW_KEY_ATTR_PEER_ID,
>> +       OVPN_NEW_KEY_ATTR_KEY_SLOT,
>> +       OVPN_NEW_KEY_ATTR_KEY_ID,
>> +       OVPN_NEW_KEY_ATTR_CIPHER_ALG,
>> +       OVPN_NEW_KEY_ATTR_ENCRYPT_KEY,
>> +       OVPN_NEW_KEY_ATTR_DECRYPT_KEY,
>> +
>> +       __OVPN_NEW_KEY_ATTR_AFTER_LAST,
>> +       OVPN_NEW_KEY_ATTR_MAX = __OVPN_NEW_KEY_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_del_key_attrs {
>> +       OVPN_DEL_KEY_ATTR_UNSPEC = 0,
>> +       OVPN_DEL_KEY_ATTR_PEER_ID,
>> +       OVPN_DEL_KEY_ATTR_KEY_SLOT,
>> +
>> +       __OVPN_DEL_KEY_ATTR_AFTER_LAST,
>> +       OVPN_DEL_KEY_ATTR_MAX = __OVPN_DEL_KEY_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_swap_keys_attrs {
>> +       OVPN_SWAP_KEYS_ATTR_UNSPEC = 0,
>> +       OVPN_SWAP_KEYS_ATTR_PEER_ID,
>> +
>> +       __OVPN_SWAP_KEYS_ATTR_AFTER_LAST,
>> +       OVPN_SWAP_KEYS_ATTR_MAX = __OVPN_SWAP_KEYS_ATTR_AFTER_LAST - 1,
>> +
>> +};
>> +
>> +enum ovpn_netlink_new_peer_attrs {
>> +       OVPN_NEW_PEER_ATTR_UNSPEC = 0,
>> +       OVPN_NEW_PEER_ATTR_PEER_ID,
>> +       OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE,
>> +       OVPN_NEW_PEER_ATTR_SOCKET,
>> +       OVPN_NEW_PEER_ATTR_IPV4,
>> +       OVPN_NEW_PEER_ATTR_IPV6,
>> +       OVPN_NEW_PEER_ATTR_LOCAL_IP,
>> +
>> +       __OVPN_NEW_PEER_ATTR_AFTER_LAST,
>> +       OVPN_NEW_PEER_ATTR_MAX = __OVPN_NEW_PEER_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_set_peer_attrs {
>> +       OVPN_SET_PEER_ATTR_UNSPEC = 0,
>> +       OVPN_SET_PEER_ATTR_PEER_ID,
>> +       OVPN_SET_PEER_ATTR_KEEPALIVE_INTERVAL,
>> +       OVPN_SET_PEER_ATTR_KEEPALIVE_TIMEOUT,
>> +
>> +       __OVPN_SET_PEER_ATTR_AFTER_LAST,
>> +       OVPN_SET_PEER_ATTR_MAX = __OVPN_SET_PEER_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_del_peer_attrs {
>> +       OVPN_DEL_PEER_ATTR_UNSPEC = 0,
>> +       OVPN_DEL_PEER_ATTR_REASON,
>> +       OVPN_DEL_PEER_ATTR_PEER_ID,
>> +
>> +       __OVPN_DEL_PEER_ATTR_AFTER_LAST,
>> +       OVPN_DEL_PEER_ATTR_MAX = __OVPN_DEL_PEER_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_get_peer_attrs {
>> +       OVPN_GET_PEER_ATTR_UNSPEC = 0,
>> +       OVPN_GET_PEER_ATTR_PEER_ID,
>> +
>> +       __OVPN_GET_PEER_ATTR_AFTER_LAST,
>> +       OVPN_GET_PEER_ATTR_MAX = __OVPN_GET_PEER_ATTR_AFTER_LAST - 1,
>> +};
> 
> What is the reason to create a separate set of attributes per each
> operation? In my experience, it is easier to use a common set of
> attributes for all operations on the same object type. At least it is
> easier to manage one enum instead of four. And you are always sure
> that attributes with the same semantics (e.g. remote IP) have the same
> id in any GET/SET message.

The reason is mostly documentation.

In my experience (which is mostly wifi related), when using a single set 
of attributes is (almost) impossible to understand which attributes have 
to be sent along with a specific command.
I always had to look at the actual netlink handlers implementation.

With this approach, instead, I can point out immediately what attributes 
are related to which command.

Maybe this is not the best approach, but I wanted a way that allows a 
developer to immediately understand the ovpn-dco API without having to 
read the code in ovpn-dco/netlink.c

What do you think?

> 
>> +enum ovpn_netlink_get_peer_response_attrs {
>> +       OVPN_GET_PEER_RESP_ATTR_UNSPEC = 0,
>> +       OVPN_GET_PEER_RESP_ATTR_PEER_ID,
>> +       OVPN_GET_PEER_RESP_ATTR_SOCKADDR_REMOTE,
>> +       OVPN_GET_PEER_RESP_ATTR_IPV4,
>> +       OVPN_GET_PEER_RESP_ATTR_IPV6,
>> +       OVPN_GET_PEER_RESP_ATTR_LOCAL_IP,
>> +       OVPN_GET_PEER_RESP_ATTR_LOCAL_PORT,
>> +       OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_INTERVAL,
>> +       OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_TIMEOUT,
>> +       OVPN_GET_PEER_RESP_ATTR_RX_BYTES,
>> +       OVPN_GET_PEER_RESP_ATTR_TX_BYTES,
>> +       OVPN_GET_PEER_RESP_ATTR_RX_PACKETS,
>> +       OVPN_GET_PEER_RESP_ATTR_TX_PACKETS,
>> +
>> +       __OVPN_GET_PEER_RESP_ATTR_AFTER_LAST,
>> +       OVPN_GET_PEER_RESP_ATTR_MAX = __OVPN_GET_PEER_RESP_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_peer_stats_attrs {
>> +       OVPN_PEER_STATS_ATTR_UNSPEC = 0,
>> +       OVPN_PEER_STATS_BYTES,
>> +       OVPN_PEER_STATS_PACKETS,
>> +
>> +       __OVPN_PEER_STATS_ATTR_AFTER_LAST,
>> +       OVPN_PEER_STATS_ATTR_MAX = __OVPN_PEER_STATS_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_peer_attrs {
>> +       OVPN_PEER_ATTR_UNSPEC = 0,
>> +       OVPN_PEER_ATTR_PEER_ID,
>> +       OVPN_PEER_ATTR_SOCKADDR_REMOTE,
>> +       OVPN_PEER_ATTR_IPV4,
>> +       OVPN_PEER_ATTR_IPV6,
>> +       OVPN_PEER_ATTR_LOCAL_IP,
>> +       OVPN_PEER_ATTR_KEEPALIVE_INTERVAL,
>> +       OVPN_PEER_ATTR_KEEPALIVE_TIMEOUT,
>> +       OVPN_PEER_ATTR_ENCRYPT_KEY,
>> +       OVPN_PEER_ATTR_DECRYPT_KEY,
>> +       OVPN_PEER_ATTR_RX_STATS,
>> +       OVPN_PEER_ATTR_TX_STATS,
>> +
>> +       __OVPN_PEER_ATTR_AFTER_LAST,
>> +       OVPN_PEER_ATTR_MAX = __OVPN_PEER_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_netlink_packet_attrs {
>> +       OVPN_PACKET_ATTR_UNSPEC = 0,
>> +       OVPN_PACKET_ATTR_PACKET,
>> +       OVPN_PACKET_ATTR_PEER_ID,
>> +
>> +       __OVPN_PACKET_ATTR_AFTER_LAST,
>> +       OVPN_PACKET_ATTR_MAX = __OVPN_PACKET_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_ifla_attrs {
>> +       IFLA_OVPN_UNSPEC = 0,
>> +       IFLA_OVPN_MODE,
>> +
>> +       __IFLA_OVPN_AFTER_LAST,
>> +       IFLA_OVPN_MAX = __IFLA_OVPN_AFTER_LAST - 1,
>> +};
>> +
>> +enum ovpn_mode {
>> +       __OVPN_MODE_FIRST = 0,
>> +       OVPN_MODE_P2P = __OVPN_MODE_FIRST,
>> +       OVPN_MODE_MP,
>> +
>> +       __OVPN_MODE_AFTER_LAST,
>> +};
>> +
>> +#endif /* _UAPI_LINUX_OVPN_DCO_H_ */
> 
> --
> BR,
> Sergey

Thanks again!

Best Regards,


-- 
Antonio Quartulli
OpenVPN Inc.
