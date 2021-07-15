Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287113C9E0B
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhGOL6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhGOL6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 07:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626350160;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATtvEJLSeypD9mxZO4KAPy28S/NQB9dMQaMSu4O94QU=;
        b=Epqtwqz6K0mBmIJyagGYqc4KyXo71S6Q/JcOFtJjd0aHOTUXKPLzXQVwHl4hHjMuZKw/kl
        CmpGNKdsN/u2CxS8+zJDGan+rOimlAcKfSiGqNQMA8l+0IGWNb7rdGSR6iFuJofy8vWx9M
        sZgp09d6nD4Du4amnJPNQ2ySqRuXLiU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-obE06iVdNpKCkowIRxsEiw-1; Thu, 15 Jul 2021 07:55:59 -0400
X-MC-Unique: obE06iVdNpKCkowIRxsEiw-1
Received: by mail-wr1-f69.google.com with SMTP id a4-20020a0560001884b02901401e436a18so3202291wri.21
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 04:55:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ATtvEJLSeypD9mxZO4KAPy28S/NQB9dMQaMSu4O94QU=;
        b=opxwClQUl58bP0i/h/zFmF1Fy0zhnKHNXfs9JdIhGroguTE+bMx5B338eEWjUoNqjU
         C5ol1QALgJydun/Kun/UG73ZvnI5NDl07bJ+EzS+R5YkD58BPn/Q4M8BZql2fy+mW3A7
         Y69bbWeFSRm+4F9x54m7C0hRxHOlrGST6Wb4mgDAt2DHu77hwS7MTgs4L684OddvGils
         a8sgV1HvgztXzSAEVNY1wWvGoJdY1ca5FfXXyMhHRkqI9eY1WzF+LV53uhvqiFVeHWT0
         PxBxW1H8hOlvUGrrQQpVl0ntAsXeeyJ/uYeW0a1kaIDVYCwWxGJapIXKHoJMXtVMzHJG
         iJtg==
X-Gm-Message-State: AOAM5335mQS68XxY/2zRQGY3ApDbd/1MLPwFx2SHk519WS6uMKRcJ/jL
        9qFHqkR2YYA0FFDEMNSii4+k3APwVb1XW/ewee1xrwQFf33XgYJGuED1qG99MIrsIZMrNGxtsqr
        RY2Iooc222cDksroy
X-Received: by 2002:a05:600c:214a:: with SMTP id v10mr9698100wml.17.1626350158049;
        Thu, 15 Jul 2021 04:55:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG/t3RDmdawxCIkbu9Fg6XRWngV0B9xDy1sGHz7tuzAfePU5r+hSy+u+v0zF+e5CjzmSkpRg==
X-Received: by 2002:a05:600c:214a:: with SMTP id v10mr9698074wml.17.1626350157707;
        Thu, 15 Jul 2021 04:55:57 -0700 (PDT)
Received: from magray.users.ipa.redhat.com ([109.78.103.97])
        by smtp.gmail.com with ESMTPSA id l39sm4935566wms.1.2021.07.15.04.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 04:55:57 -0700 (PDT)
Reply-To: Mark Gray <mark.d.gray@redhat.com>
Subject: Re: [PATCH net-next] openvswitch: Introduce per-cpu upcall dispatch
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Flavio Leitner <fbl@sysclose.org>, dan.carpenter@oracle.com
References: <20210630095350.817785-1-mark.d.gray@redhat.com>
 <CAOrHB_A0BcA0OOGmceYFyS2V72858tW-WWX_i9WSEhz63O7Scg@mail.gmail.com>
From:   Mark Gray <mark.d.gray@redhat.com>
Message-ID: <f14e1e3d-5908-dfc8-dcb1-3fe5903dbf19@redhat.com>
Date:   Thu, 15 Jul 2021 12:55:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_A0BcA0OOGmceYFyS2V72858tW-WWX_i9WSEhz63O7Scg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2021 05:45, Pravin Shelar wrote:
> On Wed, Jun 30, 2021 at 2:53 AM Mark Gray <mark.d.gray@redhat.com> wrote:
>>
>> The Open vSwitch kernel module uses the upcall mechanism to send
>> packets from kernel space to user space when it misses in the kernel
>> space flow table. The upcall sends packets via a Netlink socket.
>> Currently, a Netlink socket is created for every vport. In this way,
>> there is a 1:1 mapping between a vport and a Netlink socket.
>> When a packet is received by a vport, if it needs to be sent to
>> user space, it is sent via the corresponding Netlink socket.
>>
>> This mechanism, with various iterations of the corresponding user
>> space code, has seen some limitations and issues:
>>
>> * On systems with a large number of vports, there is a correspondingly
>> large number of Netlink sockets which can limit scaling.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
>> * Packet reordering on upcalls.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
>> * A thundering herd issue.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1834444)
>>
>> This patch introduces an alternative, feature-negotiated, upcall
>> mode using a per-cpu dispatch rather than a per-vport dispatch.
>>
>> In this mode, the Netlink socket to be used for the upcall is
>> selected based on the CPU of the thread that is executing the upcall.
>> In this way, it resolves the issues above as:
>>
>> a) The number of Netlink sockets scales with the number of CPUs
>> rather than the number of vports.
>> b) Ordering per-flow is maintained as packets are distributed to
>> CPUs based on mechanisms such as RSS and flows are distributed
>> to a single user space thread.
>> c) Packets from a flow can only wake up one user space thread.
>>
>> The corresponding user space code can be found at:
>> https://mail.openvswitch.org/pipermail/ovs-dev/2021-April/382618.html
>>
>> Bugzilla: https://bugzilla.redhat.com/1844576
>> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
>> ---
>>
>> Notes:
>>     v1 - Reworked based on Flavio's comments:
>>          * Fixed handling of userspace action case
>>          * Renamed 'struct dp_portids'
>>          * Fixed handling of return from kmalloc()
>>          * Removed check for dispatch type from ovs_dp_get_upcall_portid()
>>        - Reworked based on Dan's comments:
>>          * Fixed handling of return from kmalloc()
>>        - Reworked based on Pravin's comments:
>>          * Fixed handling of userspace action case
>>        - Added kfree() in destroy_dp_rcu() to cleanup netlink port ids
>>
> Patch looks good to me. I have the following minor comments.
>
>>  include/uapi/linux/openvswitch.h |  8 ++++
>>  net/openvswitch/actions.c        |  6 ++-
>>  net/openvswitch/datapath.c       | 70 +++++++++++++++++++++++++++++++-
>>  net/openvswitch/datapath.h       | 20 +++++++++
>>  4 files changed, 101 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>> index 8d16744edc31..6571b57b2268 100644
>> --- a/include/uapi/linux/openvswitch.h
>> +++ b/include/uapi/linux/openvswitch.h
>> @@ -70,6 +70,8 @@ enum ovs_datapath_cmd {
>>   * set on the datapath port (for OVS_ACTION_ATTR_MISS).  Only valid on
>>   * %OVS_DP_CMD_NEW requests. A value of zero indicates that upcalls should
>>   * not be sent.
>> + * OVS_DP_ATTR_PER_CPU_PIDS: Per-cpu array of PIDs for upcalls when
>> + * OVS_DP_F_DISPATCH_UPCALL_PER_CPU feature is set.
>>   * @OVS_DP_ATTR_STATS: Statistics about packets that have passed through the
>>   * datapath.  Always present in notifications.
>>   * @OVS_DP_ATTR_MEGAFLOW_STATS: Statistics about mega flow masks usage for the
>> @@ -87,6 +89,9 @@ enum ovs_datapath_attr {
>>         OVS_DP_ATTR_USER_FEATURES,      /* OVS_DP_F_*  */
>>         OVS_DP_ATTR_PAD,
>>         OVS_DP_ATTR_MASKS_CACHE_SIZE,
>> +       OVS_DP_ATTR_PER_CPU_PIDS,   /* Netlink PIDS to receive upcalls in per-cpu
>> +                                    * dispatch mode
>> +                                    */
>>         __OVS_DP_ATTR_MAX
>>  };
>>
>> @@ -127,6 +132,9 @@ struct ovs_vport_stats {
>>  /* Allow tc offload recirc sharing */
>>  #define OVS_DP_F_TC_RECIRC_SHARING     (1 << 2)
>>
>> +/* Allow per-cpu dispatch of upcalls */
>> +#define OVS_DP_F_DISPATCH_UPCALL_PER_CPU       (1 << 3)
>> +
>>  /* Fixed logical ports. */
>>  #define OVSP_LOCAL      ((__u32)0)
>>
>> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
>> index ef15d9eb4774..f79679746c62 100644
>> --- a/net/openvswitch/actions.c
>> +++ b/net/openvswitch/actions.c
>> @@ -924,7 +924,11 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
>>                         break;
>>
>>                 case OVS_USERSPACE_ATTR_PID:
>> -                       upcall.portid = nla_get_u32(a);
>> +                       if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
>> +                               upcall.portid =
>> +                                  ovs_dp_get_upcall_portid(dp, smp_processor_id());
>> +                       else
>> +                               upcall.portid = nla_get_u32(a);
>>                         break;
>>
>>                 case OVS_USERSPACE_ATTR_EGRESS_TUN_PORT: {
>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
>> index bc164b35e67d..8d54fa323543 100644
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -166,6 +166,7 @@ static void destroy_dp_rcu(struct rcu_head *rcu)
>>         free_percpu(dp->stats_percpu);
>>         kfree(dp->ports);
>>         ovs_meters_exit(dp);
>> +       kfree(dp->upcall_portids);
>>         kfree(dp);
>>  }
>>
>> @@ -239,7 +240,12 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
>>
>>                 memset(&upcall, 0, sizeof(upcall));
>>                 upcall.cmd = OVS_PACKET_CMD_MISS;
>> -               upcall.portid = ovs_vport_find_upcall_portid(p, skb);
>> +
>> +               if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU)
>> +                       upcall.portid = ovs_dp_get_upcall_portid(dp, smp_processor_id());
>> +               else
>> +                       upcall.portid = ovs_vport_find_upcall_portid(p, skb);
>> +
>>                 upcall.mru = OVS_CB(skb)->mru;
>>                 error = ovs_dp_upcall(dp, skb, key, &upcall, 0);
>>                 if (unlikely(error))
>> @@ -1594,16 +1600,67 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
>>
>>  DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
>>
>> +int ovs_dp_set_upcall_portids(struct datapath *dp,
>> +                             const struct nlattr *ids)
> this can be static function.

Yes

> 
>> +{
>> +       struct dp_nlsk_pids *old, *dp_nlsk_pids;
>> +
>> +       if (!nla_len(ids) || nla_len(ids) % sizeof(u32))
>> +               return -EINVAL;
>> +
>> +       old = ovsl_dereference(dp->upcall_portids);
>> +
>> +       dp_nlsk_pids = kmalloc(sizeof(*dp_nlsk_pids) + nla_len(ids),
>> +                              GFP_KERNEL);
>> +       if (!dp_nlsk_pids)
>> +               return -ENOMEM;
>> +
>> +       dp_nlsk_pids->n_pids = nla_len(ids) / sizeof(u32);
>> +       nla_memcpy(dp_nlsk_pids->pids, ids, nla_len(ids));
>> +
>> +       rcu_assign_pointer(dp->upcall_portids, dp_nlsk_pids);
>> +
>> +       kfree_rcu(old, rcu);
>> +
>> +       return 0;
>> +}
>> +
>> +u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
> same here, it can be static.

This cannot as it gets called in actions.c
> 
>> +{
>> +       struct dp_nlsk_pids *dp_nlsk_pids;
>> +
>> +       dp_nlsk_pids = rcu_dereference_ovsl(dp->upcall_portids);
> I dont think this function is only called under ovs-lock, so we can
> change it to rcu_dereference().

I had a quick look through the code and I think you are right so I will
change it.

> 
>> +
>> +       if (dp_nlsk_pids) {
>> +               if (cpu_id < dp_nlsk_pids->n_pids) {
>> +                       return dp_nlsk_pids->pids[cpu_id];
>> +               } else if (dp_nlsk_pids->n_pids > 0 && cpu_id >= dp_nlsk_pids->n_pids) {
>> +                       /* If the number of netlink PIDs is mismatched with the number of
>> +                        * CPUs as seen by the kernel, log this and send the upcall to an
>> +                        * arbitrary socket (0) in order to not drop packets
>> +                        */
>> +                       pr_info_ratelimited("cpu_id mismatch with handler threads");
>> +                       return dp_nlsk_pids->pids[cpu_id % dp_nlsk_pids->n_pids];
>> +               } else {
>> +                       return 0;
>> +               }
>> +       } else {
>> +               return 0;
>> +       }
>> +}
>> +
> 

