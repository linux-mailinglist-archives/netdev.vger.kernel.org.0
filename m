Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B1FFA936
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfKMEyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:54:20 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52259 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfKMEyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:54:19 -0500
X-Originating-IP: 209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id DCC2A1C0006
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 04:54:15 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id y23so523653vso.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 20:54:15 -0800 (PST)
X-Gm-Message-State: APjAAAWnyMA5ZWl11xyN5RhIhDFbQqeAZXhUpqpKgW2G11u1ykr/0XQ9
        asUfVtO2cj3rBcvMtYrAZ0IqzMJazbddQkPRB0U=
X-Google-Smtp-Source: APXvYqzmU8hifeCspEMOBfWiK+1U4XzLTlvtq2PClaCDzNtEvhMfP8FVRfCKfRk5Xwy+C9vQPlA8PUEqBA8YggfbNJA=
X-Received: by 2002:a67:d904:: with SMTP id t4mr795352vsj.93.1573620854266;
 Tue, 12 Nov 2019 20:54:14 -0800 (PST)
MIME-Version: 1.0
References: <1573571327-6906-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1573571327-6906-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 12 Nov 2019 20:54:04 -0800
X-Gmail-Original-Message-ID: <CAOrHB_Cp_KOyU80SezEq7QKNTTmoidmLZ-GR-fuXSyD0MHrO-w@mail.gmail.com>
Message-ID: <CAOrHB_Cp_KOyU80SezEq7QKNTTmoidmLZ-GR-fuXSyD0MHrO-w@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: openvswitch: add hash info to upcall
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Ben Pfaff <blp@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, ychen103103@163.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 7:09 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When using the kernel datapath, the upcall don't
> include skb hash info relatived. That will introduce
> some problem, because the hash of skb is important
> in kernel stack. For example, VXLAN module uses
> it to select UDP src port. The tx queue selection
> may also use the hash in stack.
>
> Hash is computed in different ways. Hash is random
> for a TCP socket, and hash may be computed in hardware,
> or software stack. Recalculation hash is not easy.
>
> Hash of TCP socket is computed:
>   tcp_v4_connect
>     -> sk_set_txhash (is random)
>
>   __tcp_transmit_skb
>     -> skb_set_hash_from_sk
>
> There will be one upcall, without information of skb
> hash, to ovs-vswitchd, for the first packet of a TCP
> session. The rest packets will be processed in Open vSwitch
> modules, hash kept. If this tcp session is forward to
> VXLAN module, then the UDP src port of first tcp packet
> is different from rest packets.
>
> TCP packets may come from the host or dockers, to Open vSwitch.
> To fix it, we store the hash info to upcall, and restore hash
> when packets sent back.
>
> +---------------+          +-------------------------+
> |   Docker/VMs  |          |     ovs-vswitchd        |
> +----+----------+          +-+--------------------+--+
>      |                       ^                    |
>      |                       |                    |
>      |                       |  upcall            v restore packet hash (not recalculate)
>      |                     +-+--------------------+--+
>      |  tap netdev         |                         |   vxlan module
>      +--------------->     +-->  Open vSwitch ko     +-->
>        or internal type    |                         |
>                            +-------------------------+
>
> Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v3:
> * add enum ovs_pkt_hash_types
> * avoid duplicate call the skb_get_hash_raw.
> * explain why we should fix this problem.
> ---
>  include/uapi/linux/openvswitch.h |  2 ++
>  net/openvswitch/datapath.c       | 30 +++++++++++++++++++++++++++++-
>  net/openvswitch/datapath.h       | 12 ++++++++++++
>  3 files changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 1887a451c388..e65407c1f366 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -170,6 +170,7 @@ enum ovs_packet_cmd {
>   * output port is actually a tunnel port. Contains the output tunnel key
>   * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.
>   * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
> + * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb).
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
I agree with Greg, value of existing enums can not be changed in UAPI.

> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 2088619c03f0..b556cf62b77c 100644
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
> @@ -504,6 +506,23 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>                 pad_packet(dp, user_skb);
>         }
>
> +       hash = skb_get_hash_raw(skb);
> +       if (hash) {
Zero hash is valid hash of skb. due to this check packets with zero
hash would not get same vxlan source port number. This patch should
solve the issue for all values of skb hash.




> +               if (skb->sw_hash)
> +                       hash |= OVS_PACKET_HASH_SW_BIT;
> +
> +               if (skb->l4_hash)
> +                       hash |= OVS_PACKET_HASH_L4_BIT;
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
> @@ -543,6 +562,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>         struct datapath *dp;
>         struct vport *input_vport;
>         u16 mru = 0;
> +       u64 hash;
>         int len;
>         int err;
>         bool log = !a[OVS_PACKET_ATTR_PROBE];
> @@ -568,6 +588,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>         }
>         OVS_CB(packet)->mru = mru;
>
> +       if (a[OVS_PACKET_ATTR_HASH]) {
> +               hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
> +
> +               __skb_set_hash(packet, hash & 0xFFFFFFFFULL,
> +                              !!(hash & OVS_PACKET_HASH_SW_BIT),
> +                              !!(hash & OVS_PACKET_HASH_L4_BIT));
> +       }
> +
>         /* Build an sw_flow for sending this packet. */
>         flow = ovs_flow_alloc();
>         err = PTR_ERR(flow);
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 81e85dde8217..e239a46c2f94 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -139,6 +139,18 @@ struct ovs_net {
>         bool xt_label;
>  };
>
> +/**
> + * enum ovs_pkt_hash_types - hash info to include with a packet
> + * to send to userspace.
> + * @OVS_PACKET_HASH_SW_BIT: indicates hash was computed in software stack.
> + * @OVS_PACKET_HASH_L4_BIT: indicates hash is a canonical 4-tuple hash
> + * over transport ports.
> + */
> +enum ovs_pkt_hash_types {
> +       OVS_PACKET_HASH_SW_BIT = (1ULL << 32),
> +       OVS_PACKET_HASH_L4_BIT = (1ULL << 33),
> +};
> +


>  extern unsigned int ovs_net_id;
>  void ovs_lock(void);
>  void ovs_unlock(void);
> --
> 2.23.0
>
