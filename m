Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099AFF877E
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 05:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfKLEfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 23:35:34 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60871 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLEfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 23:35:34 -0500
X-Originating-IP: 209.85.221.174
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 3B1041C0003
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:35:31 +0000 (UTC)
Received: by mail-vk1-f174.google.com with SMTP id p68so4149038vkd.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 20:35:30 -0800 (PST)
X-Gm-Message-State: APjAAAWt2+/Qu5t9M6K2K1W/hjVWYhuB1AvugOCfZhXyn3kcqiD2ayx9
        kpyz+TxVrfE8A15HRCsnEaGSw6/IItJI6covS3s=
X-Google-Smtp-Source: APXvYqzB3B7T7mu+MyrGXnS9tG5ZBd7fODZ2ULGj95QRc2Q50aGesA8wivx1fSY9107a0Gvj5DqqFybuOU3ewUQzCpo=
X-Received: by 2002:ac5:c284:: with SMTP id h4mr19858094vkk.82.1573533329598;
 Mon, 11 Nov 2019 20:35:29 -0800 (PST)
MIME-Version: 1.0
References: <1573386258-35040-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1573386258-35040-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Mon, 11 Nov 2019 20:35:18 -0800
X-Gmail-Original-Message-ID: <CAOrHB_CmtDnqpuEtiBSJvS5tDjP8A+6a4ynYGWahF8k3heezUw@mail.gmail.com>
Message-ID: <CAOrHB_CmtDnqpuEtiBSJvS5tDjP8A+6a4ynYGWahF8k3heezUw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: add hash info to upcall
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Ben Pfaff <blp@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, ychen103103@163.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 3:44 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When using the kernel datapath, the upcall don't
> add skb hash info relatived. That will introduce
> some problem, because the hash of skb is very
> important (e.g. vxlan module uses it for udp src port,
> tx queue selection on tx path.).
>
> For example, there will be one upcall, without information
> skb hash, to ovs-vswitchd, for the first packet of one tcp
> session. When kernel sents the tcp packets, the hash is
> random for a tcp socket:
>
> tcp_v4_connect
>   -> sk_set_txhash (is random)
>
> __tcp_transmit_skb
>   -> skb_set_hash_from_sk
>
> Then the udp src port of first tcp packet is different
> from rest packets. The topo is shown.
>
> $ ovs-vsctl add-br br-int
> $ ovs-vsctl add-port br-int vxl0 -- \
>                 set Interface vxl0 type=vxlan options:key=100 options:remote_ip=1.1.1.200
>
> $ __tap is internal type on host
> $ or tap net device for VM/Dockers
> $ ovs-vsctl add-port br-int __tap
>
> +---------------+          +-------------------------+
> |   Docker/VMs  |          |     ovs-vswitchd        |
> +----+----------+          +-------------------------+
>      |                       ^                    |
>      |                       |                    |
>      |                       |  upcall            v recalculate packet hash
>      |                     +-+--------------------+--+
>      |  tap netdev         |                         |   vxlan modules
>      +--------------->     +-->  Open vSwitch ko   --+--->
>        internal type       |                         |
>                            +-------------------------+
>
> Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  include/uapi/linux/openvswitch.h |  2 ++
>  net/openvswitch/datapath.c       | 31 ++++++++++++++++++++++++++++++-
>  net/openvswitch/datapath.h       |  3 +++
>  3 files changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 1887a451c388..1c58e019438e 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -170,6 +170,7 @@ enum ovs_packet_cmd {
>   * output port is actually a tunnel port. Contains the output tunnel key
>   * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.
>   * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
> + * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb)
>   * @OVS_PACKET_ATTR_LEN: Packet size before truncation.
>   * %OVS_PACKET_ATTR_USERSPACE action specify the Maximum received fragment
>   * size.
> @@ -190,6 +191,7 @@ enum ovs_packet_attr {
>         OVS_PACKET_ATTR_PROBE,      /* Packet operation is a feature probe,
>                                        error logging should be suppressed. */
>         OVS_PACKET_ATTR_MRU,        /* Maximum received IP fragment size. */
> +       OVS_PACKET_ATTR_HASH,       /* Packet hash. */
>         OVS_PACKET_ATTR_LEN,            /* Packet size before truncation. */
>         __OVS_PACKET_ATTR_MAX
>  };
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 2088619c03f0..f938c43e3085 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -350,7 +350,8 @@ static size_t upcall_msg_size(const struct dp_upcall_info *upcall_info,
>         size_t size = NLMSG_ALIGN(sizeof(struct ovs_header))
>                 + nla_total_size(hdrlen) /* OVS_PACKET_ATTR_PACKET */
>                 + nla_total_size(ovs_key_attr_size()) /* OVS_PACKET_ATTR_KEY */
> -               + nla_total_size(sizeof(unsigned int)); /* OVS_PACKET_ATTR_LEN */
> +               + nla_total_size(sizeof(unsigned int)) /* OVS_PACKET_ATTR_LEN */
> +               + nla_total_size(sizeof(u64)); /* OVS_PACKET_ATTR_HASH */
>
>         /* OVS_PACKET_ATTR_USERDATA */
>         if (upcall_info->userdata)
> @@ -393,6 +394,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>         size_t len;
>         unsigned int hlen;
>         int err, dp_ifindex;
> +       u64 hash;
>
>         dp_ifindex = get_dpifindex(dp);
>         if (!dp_ifindex)
> @@ -504,6 +506,24 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>                 pad_packet(dp, user_skb);
>         }
>
> +       if (skb_get_hash_raw(skb)) {
skb_get_hash_raw() never fails to return hash, so I do not see point
of checking hash value.

> +               hash = skb_get_hash_raw(skb);
> +
> +               if (skb->sw_hash)
> +                       hash |= OVS_PACKET_HASH_SW;
> +
> +               if (skb->l4_hash)
> +                       hash |= OVS_PACKET_HASH_L4;
> +
> +               if (nla_put(user_skb, OVS_PACKET_ATTR_HASH,
> +                           sizeof (u64), &hash)) {
> +                       err = -ENOBUFS;
> +                       goto out;
> +               }
> +
> +               pad_packet(dp, user_skb);
> +       }
> +
>         /* Only reserve room for attribute header, packet data is added
>          * in skb_zerocopy() */
>         if (!(nla = nla_reserve(user_skb, OVS_PACKET_ATTR_PACKET, 0))) {
> @@ -543,6 +563,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>         struct datapath *dp;
>         struct vport *input_vport;
>         u16 mru = 0;
> +       u64 hash;
>         int len;
>         int err;
>         bool log = !a[OVS_PACKET_ATTR_PROBE];
> @@ -568,6 +589,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>         }
>         OVS_CB(packet)->mru = mru;
>
> +       if (a[OVS_PACKET_ATTR_HASH]) {
> +               hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
> +
> +               __skb_set_hash(packet, hash & 0xFFFFFFFFUL,
> +                              !!(hash & OVS_PACKET_HASH_SW),
> +                              !!(hash & OVS_PACKET_HASH_L4));
> +       }
> +
>         /* Build an sw_flow for sending this packet. */
>         flow = ovs_flow_alloc();
>         err = PTR_ERR(flow);
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 81e85dde8217..ba89a08647ac 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -248,3 +248,6 @@ do {                                                                \
>                 pr_info("netlink: " fmt "\n", ##__VA_ARGS__);   \
>  } while (0)
>  #endif /* datapath.h */
> +
> +#define OVS_PACKET_HASH_SW     (1ULL << 32)
> +#define OVS_PACKET_HASH_L4     (1ULL << 33)

We could define these using enum pkt_hash_types values, rather than
constant values.
