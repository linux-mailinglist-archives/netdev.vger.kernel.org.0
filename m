Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DE43898CD
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 23:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhESVsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 17:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhESVsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 17:48:36 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2CAC061574
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 14:47:15 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id z1so7631670qvo.4
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 14:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ZM1ftN+Mr1ofx1mVxK8L5rY6eAiLZ1H0CwJqRztj4I=;
        b=qcWgc+bv5WJNjFhBtdcDc34SDY4xXCzHVD24Xu4Z7QmIsnzwDWNp7i2e4wmC3xMXpQ
         u6kwFRS7AScmtqlYDYIKPRFDLEGVV+OFaAfOtDeB4QX5JxG4ewtXVnSNBpoevJ2VAjbi
         0aJWOpxSmYFtsTUNAZCDw2i0ypP5bcoqV9kFc6yw/cX6Muzr8DvjtIL49m7TZnHhH9G3
         IOEZCpb6gvnInodlVT2H1Sg+caS/Sqd/jKfpbptr97ZE8Hm/Ys5SgmRHB52wmaQxLU8T
         9u/CEKiE/cpWUsEjLE4ZzoTL70XdFGJpmjKldZGKREmw5USvt5u/24urnE4MiDO6Mse/
         L/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ZM1ftN+Mr1ofx1mVxK8L5rY6eAiLZ1H0CwJqRztj4I=;
        b=ATXry75DzfiNvCSLIm4BWSMnM2K1xFHhgSTE958NRYFe6YCTFeeo8J9LYHNB9ODoiH
         e/tWMrneYA2YmQB3vtr2sFvhbnTksnzr90Ny6vD1x3tquPgrlVKkaGrptmi6FeK9Wg5I
         xyXuN1QtWnOyi+XSfB6qzz6RrBw6xkR01dmno2fzt5UEeYGP9q1xDh9Ll+eqjT8VyA27
         RFHrnmsQKwOE1d4gjjnGkFRvZJviWw7knTkzd1c78/VFBdvMxp4il5SlSerrlVGPt2iZ
         Hfj6MJwzmUC+H+3/Xd9o0jZLd9VZOQOYnLBB3FUcyUoOJYUYmc0dyYsStIrAwn/WCs66
         amcg==
X-Gm-Message-State: AOAM530kHDhu0u51ODfOODeEYuHHJ2DHGNz93veAWLGZWNocQlafwrsf
        k+0vxTT/yINPsr/1gUfDELdRv0d7O8eVTU6KyJXpwZFr1cc=
X-Google-Smtp-Source: ABdhPJwHcMEWSpzUd0L7Sjcnuh7ObnrcIWCebk+AqZWfTfpFFtFQPOHL3hCWsVWyaCIc5TDdBsJoXbqNy2wKT8ZaFs0=
X-Received: by 2002:a0c:8d0b:: with SMTP id r11mr1918278qvb.22.1621460834940;
 Wed, 19 May 2021 14:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210430153325.28322-1-mark.d.gray@redhat.com>
In-Reply-To: <20210430153325.28322-1-mark.d.gray@redhat.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 19 May 2021 14:47:03 -0700
Message-ID: <CAOrHB_BUr9Zk3M5mwQ-v-Oo4xRas-=ZOtQHb1KHDS+i8kyZBog@mail.gmail.com>
Subject: Re: [RFC net-next] openvswitch: Introduce per-cpu upcall dispatch
To:     Mark Gray <mark.d.gray@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 8:33 AM Mark Gray <mark.d.gray@redhat.com> wrote:
>
> The Open vSwitch kernel module uses the upcall mechanism to send
> packets from kernel space to user space when it misses in the kernel
> space flow table. The upcall sends packets via a Netlink socket.
> Currently, a Netlink socket is created for every vport. In this way,
> there is a 1:1 mapping between a vport and a Netlink socket.
> When a packet is received by a vport, if it needs to be sent to
> user space, it is sent via the corresponding Netlink socket.
>
> This mechanism, with various iterations of the corresponding user
> space code, has seen some limitations and issues:
>
> * On systems with a large number of vports, there is a correspondingly
> large number of Netlink sockets which can limit scaling.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
> * Packet reordering on upcalls.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
> * A thundering herd issue.
> (https://bugzilla.redhat.com/show_bug.cgi?id=1834444)
>
> This patch introduces an alternative, feature-negotiated, upcall
> mode using a per-cpu dispatch rather than a per-vport dispatch.
>
> In this mode, the Netlink socket to be used for the upcall is
> selected based on the CPU of the thread that is executing the upcall.
> In this way, it resolves the issues above as:
>
> a) The number of Netlink sockets scales with the number of CPUs
> rather than the number of vports.
> b) Ordering per-flow is maintained as packets are distributed to
> CPUs based on mechanisms such as RSS and flows are distributed
> to a single user space thread.
> c) Packets from a flow can only wake up one user space thread.
>
> The corresponding user space code can be found at:
> https://mail.openvswitch.org/pipermail/ovs-dev/2021-April/382618.html
>
> Bugzilla: https://bugzilla.redhat.com/1844576
> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
> ---
>  include/uapi/linux/openvswitch.h |  8 ++++
>  net/openvswitch/datapath.c       | 70 +++++++++++++++++++++++++++++++-
>  net/openvswitch/datapath.h       | 18 ++++++++
>  net/openvswitch/flow_netlink.c   |  4 --
>  4 files changed, 94 insertions(+), 6 deletions(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 8d16744edc31..6571b57b2268 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -70,6 +70,8 @@ enum ovs_datapath_cmd {
>   * set on the datapath port (for OVS_ACTION_ATTR_MISS).  Only valid on
>   * %OVS_DP_CMD_NEW requests. A value of zero indicates that upcalls should
>   * not be sent.
> + * OVS_DP_ATTR_PER_CPU_PIDS: Per-cpu array of PIDs for upcalls when
> + * OVS_DP_F_DISPATCH_UPCALL_PER_CPU feature is set.
>   * @OVS_DP_ATTR_STATS: Statistics about packets that have passed through the
>   * datapath.  Always present in notifications.
>   * @OVS_DP_ATTR_MEGAFLOW_STATS: Statistics about mega flow masks usage for the
> @@ -87,6 +89,9 @@ enum ovs_datapath_attr {
>         OVS_DP_ATTR_USER_FEATURES,      /* OVS_DP_F_*  */
>         OVS_DP_ATTR_PAD,
>         OVS_DP_ATTR_MASKS_CACHE_SIZE,
> +       OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in per-cpu
> +                                    * dispatch mode
> +                                    */
>         __OVS_DP_ATTR_MAX
>  };
>
> @@ -127,6 +132,9 @@ struct ovs_vport_stats {
>  /* Allow tc offload recirc sharing */
>  #define OVS_DP_F_TC_RECIRC_SHARING     (1 << 2)
>
> +/* Allow per-cpu dispatch of upcalls */
> +#define OVS_DP_F_DISPATCH_UPCALL_PER_CPU       (1 << 3)
> +
>  /* Fixed logical ports. */
>  #define OVSP_LOCAL      ((__u32)0)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 9d6ef6cb9b26..98d54f41fdaa 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -121,6 +121,8 @@ int lockdep_ovsl_is_held(void)
>  #endif
>
>  static struct vport *new_vport(const struct vport_parms *);
> +static u32 ovs_dp_get_upcall_portid(const struct datapath *, uint32_t);
> +static int ovs_dp_set_upcall_portids(struct datapath *, const struct nlattr *);
>  static int queue_gso_packets(struct datapath *dp, struct sk_buff *,
>                              const struct sw_flow_key *,
>                              const struct dp_upcall_info *,
> @@ -238,7 +240,12 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>
>                 memset(&upcall, 0, sizeof(upcall));
>                 upcall.cmd = OVS_PACKET_CMD_MISS;
> -               upcall.portid = ovs_vport_find_upcall_portid(p, skb);
> +
> +               if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
> +                       upcall.portid = ovs_dp_get_upcall_portid(dp, smp_processor_id());
> +               else
> +                       upcall.portid = ovs_vport_find_upcall_portid(p, skb);
> +
>                 upcall.mru = OVS_CB(skb)->mru;
>                 error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
>                 if (unlikely(error))
> @@ -1590,16 +1597,67 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
>
>  DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
>
> +static int ovs_dp_set_upcall_portids(struct datapath *dp,
> +                                    const struct nlattr *ids)
> +{
> +       struct dp_portids *old, *dp_portids;
> +
> +       if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
> +               return -EINVAL;
> +
> +       old = ovsl_dereference(dp->upcall_portids);
> +
> +       dp_portids = kmalloc(sizeof(*dp_portids) + nla_len(ids),
> +                            GFP_KERNEL);
> +       if (!dp)
> +               return -ENOMEM;
> +
> +       dp_portids->n_ids = nla_len(ids) / sizeof(u32);
> +       nla_memcpy(dp_portids->ids, ids, nla_len(ids));
> +
> +       rcu_assign_pointer(dp->upcall_portids, dp_portids);
> +
> +       if (old)
> +               kfree_rcu(old, rcu);
> +       return 0;
> +}
> +
> +static u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
> +{
> +       struct dp_portids *dp_portids;
> +
> +       dp_portids = rcu_dereference_ovsl(dp->upcall_portids);
> +
> +       if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && dp_portids) {
> +               if (cpu_id < dp_portids->n_ids) {
> +                       return dp_portids->ids[cpu_id];
Have you considered more than one port per CPU?

> +               } else if (dp_portids->n_ids > 0 && cpu_id >= dp_portids->n_ids) {
> +                       /* If the number of netlink PIDs is mismatched with the number of
> +                        * CPUs as seen by the kernel, log this and send the upcall to an
> +                        * arbitrary socket (0) in order to not drop packets
> +                        */
> +                       pr_info_ratelimited("cpu_id mismatch with handler threads");
> +                       return dp_portids->ids[0];
> +               } else {
> +                       return 0;
> +               }
> +       } else {
> +               return 0;
> +       }
> +}
> +
>  static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>  {
>         u32 user_features = 0;
> +       int err;
>
>         if (a[OVS_DP_ATTR_USER_FEATURES]) {
>                 user_features = nla_get_u32(a[OVS_DP_ATTR_USER_FEATURES]);
>
>                 if (user_features & ~(OVS_DP_F_VPORT_PIDS |
>                                       OVS_DP_F_UNALIGNED |
> -                                     OVS_DP_F_TC_RECIRC_SHARING))
> +                                     OVS_DP_F_TC_RECIRC_SHARING |
> +                                     OVS_DP_F_DISPATCH_UPCALL_PER_CPU))
>                         return -EOPNOTSUPP;
>
>  #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> @@ -1620,6 +1678,14 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>
>         dp->user_features = user_features;
>
> +       if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU &&
> +           a[OVS_DP_ATTR_PER_CPU_PIDS]) {
> +               /* Upcall Netlink Port IDs have been updated */
> +               err = ovs_dp_set_upcall_portids(dp, a[OVS_DP_ATTR_PER_CPU_PIDS]);
> +               if (err)
> +                       return err;
> +       }
> +
Since this takes precedence over OVS_DP_F_VPORT_PIDS, can we reject
datapath with both options.

>         if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
>                 static_branch_enable(&tc_recirc_sharing_support);
>         else
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index 38f7d3e66ca6..6003eba81958 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -50,6 +50,21 @@ struct dp_stats_percpu {
>         struct u64_stats_sync syncp;
>  };
>
> +/**
> + * struct dp_portids - array of netlink portids of for a datapath.
> + *                     This is used when OVS_DP_F_DISPATCH_UPCALL_PER_CPU
> + *                     is enabled and must be protected by rcu.
> + * @rcu: RCU callback head for deferred destruction.
> + * @n_ids: Size of @ids array.
> + * @ids: Array storing the Netlink socket PIDs indexed by CPU ID for packets
> + *       that miss the flow table.
> + */
> +struct dp_portids {
> +       struct rcu_head rcu;
> +       u32 n_ids;
> +       u32 ids[];
> +};
> +
>  /**
>   * struct datapath - datapath for flow-based packet switching
>   * @rcu: RCU callback head for deferred destruction.
> @@ -61,6 +76,7 @@ struct dp_stats_percpu {
>   * @net: Reference to net namespace.
>   * @max_headroom: the maximum headroom of all vports in this datapath; it will
>   * be used by all the internal vports in this dp.
> + * @upcall_portids: RCU protected 'struct dp_portids'.
>   *
>   * Context: See the comment on locking at the top of datapath.c for additional
>   * locking information.
> @@ -87,6 +103,8 @@ struct datapath {
>
>         /* Switch meters. */
>         struct dp_meter_table meter_tbl;
> +
> +       struct dp_portids __rcu *upcall_portids;
>  };
>
>  /**
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index fd1f809e9bc1..97242bc1d960 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -2928,10 +2928,6 @@ static int validate_userspace(const struct nlattr *attr)
>         if (error)
>                 return error;
>
> -       if (!a[OVS_USERSPACE_ATTR_PID] ||
> -           !nla_get_u32(a[OVS_USERSPACE_ATTR_PID]))
> -               return -EINVAL;
> -
We need to keep this check for compatibility reasons.

>         return 0;
>  }

>
> --
> 2.27.0
>
