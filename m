Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775EC3C97A9
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 06:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbhGOEsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 00:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhGOEsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 00:48:22 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4868BC06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:45:29 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id r125so4008193qkf.1
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 21:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=baslqh2hhPRE/3vVpwJtvFdxX5gKGMTprD5QfwTTaQ0=;
        b=EJd/lIDQb+EZzFOPNOsPGarAyWMeD3Fkzia7yUzYBwSAvR2yzJMJGh2f3+8MAWTgHn
         EuAwQaemGfvrtfEtYZVBqYTWjrRSq41KgJlFvi5JK1a9St6niY2+KbJAl4WU39MMuGp0
         kX7ptriyDrUrt/06A2DJmfKbLNGmMlng7YhaNTuwFA/+z/QCzMgBsLlMg0uqluh3QW7M
         pFe9XsEnWxv44V34OtZxd9HsT1rMskNDgMJSwZiY+5n7iIj/hzvSAwxpJj8XRHX2XNSv
         3wMgtQ00BqV873otiRyjor9pe85RfofdMYq8PHjsrn1CmVLrFR3EdUNE3+PxqZ4ZB26+
         9thA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=baslqh2hhPRE/3vVpwJtvFdxX5gKGMTprD5QfwTTaQ0=;
        b=qtgaX+byjkV4NHbCBfFyr1L4CHfLIdrXSf48RTRtmmJ84TFmgJ9s/hnwYHpNFKOZrX
         Y4MP1eCeO5//Id+tKhAaxQtB3R6tlO6JNE8KJsFndgC/rOfwvh3nV51LjvofyK14S4Wz
         5iU3wQRYebb+ldPFFH7keLkQz40hu74xEkoGH0BZ8w+gheQ2IplY3xGKMLOSzwAKM2fC
         dCoIag1Pe9RgY/hHuhnjAQZaK0ZKMhdt++g/dnOeC0gGJc+CSnTSn1AsfI5IcdAlvkki
         FNp16Tm8KHAG4izF8t3xvFepdIFInb3t4dCYyGvEgvLjuP6eHqqt6TfQJW+dyq56wDRB
         mTcw==
X-Gm-Message-State: AOAM531ikNtjPWu2Qpijqf7GSVkRfasTCyMsoI9q5ZTOiZkteKEblzKW
        N8dvJRGEsGZXQR+mO4j1CX3CaaSKrvKVJM/g1Js=
X-Google-Smtp-Source: ABdhPJx2TpBtEEk77B5aeaadHH2HRHDpEcztNSDIyey/a6sTFFdtsddC9YIDqkjHLqCcjkMwtclcuDgh82OvDZAwu0U=
X-Received: by 2002:a37:468b:: with SMTP id t133mr1932370qka.244.1626324328522;
 Wed, 14 Jul 2021 21:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210630095350.817785-1-mark.d.gray@redhat.com>
In-Reply-To: <20210630095350.817785-1-mark.d.gray@redhat.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 14 Jul 2021 21:45:17 -0700
Message-ID: <CAOrHB_A0BcA0OOGmceYFyS2V72858tW-WWX_i9WSEhz63O7Scg@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: Introduce per-cpu upcall dispatch
To:     Mark Gray <mark.d.gray@redhat.com>
Cc:     ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Flavio Leitner <fbl@sysclose.org>, dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 2:53 AM Mark Gray <mark.d.gray@redhat.com> wrote:
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
>
> Notes:
>     v1 - Reworked based on Flavio's comments:
>          * Fixed handling of userspace action case
>          * Renamed 'struct dp_portids'
>          * Fixed handling of return from kmalloc()
>          * Removed check for dispatch type from ovs_dp_get_upcall_portid()
>        - Reworked based on Dan's comments:
>          * Fixed handling of return from kmalloc()
>        - Reworked based on Pravin's comments:
>          * Fixed handling of userspace action case
>        - Added kfree() in destroy_dp_rcu() to cleanup netlink port ids
>
Patch looks good to me. I have the following minor comments.

>  include/uapi/linux/openvswitch.h |  8 ++++
>  net/openvswitch/actions.c        |  6 ++-
>  net/openvswitch/datapath.c       | 70 +++++++++++++++++++++++++++++++-
>  net/openvswitch/datapath.h       | 20 +++++++++
>  4 files changed, 101 insertions(+), 3 deletions(-)
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
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index ef15d9eb4774..f79679746c62 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -924,7 +924,11 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
>                         break;
>
>                 case OVS_USERSPACE_ATTR_PID:
> -                       upcall.portid = nla_get_u32(a);
> +                       if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
> +                               upcall.portid =
> +                                  ovs_dp_get_upcall_portid(dp, smp_processor_id());
> +                       else
> +                               upcall.portid = nla_get_u32(a);
>                         break;
>
>                 case OVS_USERSPACE_ATTR_EGRESS_TUN_PORT: {
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index bc164b35e67d..8d54fa323543 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -166,6 +166,7 @@ static void destroy_dp_rcu(struct rcu_head *rcu)
>         free_percpu(dp->stats_percpu);
>         kfree(dp->ports);
>         ovs_meters_exit(dp);
> +       kfree(dp->upcall_portids);
>         kfree(dp);
>  }
>
> @@ -239,7 +240,12 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
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
> @@ -1594,16 +1600,67 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
>
>  DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
>
> +int ovs_dp_set_upcall_portids(struct datapath *dp,
> +                             const struct nlattr *ids)
this can be static function.

> +{
> +       struct dp_nlsk_pids *old, *dp_nlsk_pids;
> +
> +       if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
> +               return -EINVAL;
> +
> +       old = ovsl_dereference(dp->upcall_portids);
> +
> +       dp_nlsk_pids = kmalloc(sizeof(*dp_nlsk_pids) + nla_len(ids),
> +                              GFP_KERNEL);
> +       if (!dp_nlsk_pids)
> +               return -ENOMEM;
> +
> +       dp_nlsk_pids->n_pids = nla_len(ids) / sizeof(u32);
> +       nla_memcpy(dp_nlsk_pids->pids, ids, nla_len(ids));
> +
> +       rcu_assign_pointer(dp->upcall_portids, dp_nlsk_pids);
> +
> +       kfree_rcu(old, rcu);
> +
> +       return 0;
> +}
> +
> +u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
same here, it can be static.

> +{
> +       struct dp_nlsk_pids *dp_nlsk_pids;
> +
> +       dp_nlsk_pids = rcu_dereference_ovsl(dp->upcall_portids);
I dont think this function is only called under ovs-lock, so we can
change it to rcu_dereference().

> +
> +       if (dp_nlsk_pids) {
> +               if (cpu_id < dp_nlsk_pids->n_pids) {
> +                       return dp_nlsk_pids->pids[cpu_id];
> +               } else if (dp_nlsk_pids->n_pids > 0 && cpu_id >= dp_nlsk_pids->n_pids) {
> +                       /* If the number of netlink PIDs is mismatched with the number of
> +                        * CPUs as seen by the kernel, log this and send the upcall to an
> +                        * arbitrary socket (0) in order to not drop packets
> +                        */
> +                       pr_info_ratelimited("cpu_id mismatch with handler threads");
> +                       return dp_nlsk_pids->pids[cpu_id % dp_nlsk_pids->n_pids];
> +               } else {
> +                       return 0;
> +               }
> +       } else {
> +               return 0;
> +       }
> +}
> +
