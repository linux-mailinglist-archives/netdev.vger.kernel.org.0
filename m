Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4655E7AD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347026AbiF1Pbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347567AbiF1Pb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:31:27 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2CF21E0A
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:31:25 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-318889e6a2cso120875427b3.1
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5eeKotz6eGeCI1YxIW9trPH4mFKWjim3qbqc9Hvl3zI=;
        b=aIM8YyooAgVra4y7uafBRbjNQ/KEFbHeoY7pr/0fXwF+CD18rQ7fICaGTQIlSdmPSk
         gZ9E3VdYusVNdzhdNT5M7hOB7fKsPwCRk/snOzM5OVBW+MEHIELQtf7Kgu/9gTS3NYdd
         zETH2ySNl6DE5NgvSliARdBGtD9ZK5ZP+it6jh1D+7dHObZ94d3JkBat/ahkfxwm0ZMT
         l0CYC1AOjJZpjm7XngdM71YBUowb//QPLcZ/MME1ECXZkg3w/mKw/seZV9Zw79RHvwv2
         Sp+A0L2+1MPCpvttzZ49/izct11bFS8JCeYWaZDKYjxCDgRev1nxcISlx9mG04iS9/qN
         yi3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5eeKotz6eGeCI1YxIW9trPH4mFKWjim3qbqc9Hvl3zI=;
        b=JYqmYC4p3t6Ja+fGIM189G8o5tir+aD8W4UiI1MOlYntc4CE7GwPSJhtzxcWb5/k2A
         tVt1AWViE0ugZRcjL+aeWreVTzt/TSrjeL1OijuWhOEPNjFnlxqMy/GUKw9iE5mo67ye
         ijLsX9IHhObonxzF2nqEdEnhsLDYUiAs75N1P3st8qupjrp//yIFHj8X+Am3nBs62PSM
         Xk+Z83nxu08GaY53Zj95aMYyE23csSmZgFT1W8a7wQCVU4D+nnEQK8u73fv4+rscLAur
         rZEao+DKb8MIbwFFriL38s4lu+ReL6z33t8Y1UHWYD2vdrSOiM5r1EcrPU14IP8Smg01
         Y1eQ==
X-Gm-Message-State: AJIora8ryA3hnPo531UofVEoLVDL/8RZU58wjRqyPDiHCKZu2D9Uek81
        klRr6AZvcZtobNXWgyU28z1k6DYnQbdF2/mmdXQ58g==
X-Google-Smtp-Source: AGRyM1uPO2qoWjIXSbMgLVpj2nRAUX5H/G3bJy0k/gOAgJLXZxtn35E6l/yVBk54/wJq7FsCQAHluLpPoK9Te9Y+TQU=
X-Received: by 2002:a81:3a81:0:b0:317:7dcf:81d4 with SMTP id
 h123-20020a813a81000000b003177dcf81d4mr21666441ywa.47.1656430284745; Tue, 28
 Jun 2022 08:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220628140044.65068-1-huangjie.albert@bytedance.com>
In-Reply-To: <20220628140044.65068-1-huangjie.albert@bytedance.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Jun 2022 17:31:12 +0200
Message-ID: <CANn89iKfW8_OLN3veCaMDDLLPU1EP_eAcf03PJZJnLD+6Pv3vw@mail.gmail.com>
Subject: Re: [PATCH] net : rps : supoort a single flow to use rps
To:     Albert Huang <huangjie.albert@bytedance.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <atenart@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 4:01 PM Albert Huang
<huangjie.albert@bytedance.com> wrote:
>
> From: "huangjie.albert" <huangjie.albert@bytedance.com>
>
> In some scenarios(ipsec) or products(VPN gateway),
> we need to enable a single network stream to support RPS.
> but In the current rps implementation, there is no support
> for a single stream to utilize rps.
>
> Introduce a hashtable to record flows that need to use rps.
> For these flows, use round robin to put them on different CPUs
> for further processing
>
> how to use:
> echo xxx > /sys/class/net/xxx/queues/rx-x/rps_cpus
> echo 1 > /sys/class/net/xxx/queues/rx-x/rps_single_flow
> and create a flow node with the function:
> rps_flow_node_create

Which part calls rps_flow_node_create() exactly ?

This seems to be very specialized to IPSEC.

Can IPSEC  use multiple threads for decryption ?

>
> This patch can improve the performance of a single stream,
> for example: On my virtual machine (4 vcpu + 8g), a single
> ipsec stream (3des encryption) can improve throughput by 3-4 times:
> before           after
> 212 Mbits/sec    698 Mbits/sec
>
> Signed-off-by: huangjie.albert <huangjie.albert@bytedance.com>
> ---
>  include/linux/netdevice.h |  15 +++
>  net/core/dev.c            | 187 ++++++++++++++++++++++++++++++++++++++
>  net/core/net-sysfs.c      |  36 ++++++++
>  3 files changed, 238 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index f615a66c89e9..36412d0e0255 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -743,6 +743,7 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index, u32 flow_id,
>  struct netdev_rx_queue {
>         struct xdp_rxq_info             xdp_rxq;
>  #ifdef CONFIG_RPS
> +       bool   rps_single_flow_enable;
>         struct rps_map __rcu            *rps_map;
>         struct rps_dev_flow_table __rcu *rps_flow_table;
>  #endif
> @@ -811,6 +812,20 @@ struct xps_dev_maps {
>  #define XPS_RXQ_DEV_MAPS_SIZE(_tcs, _rxqs) (sizeof(struct xps_dev_maps) +\
>         (_rxqs * (_tcs) * sizeof(struct xps_map *)))
>
> +
> +/* define for rps_single_flow */
> +struct rps_flow_info_node {
> +       __be32 saddr;
> +       __be32 daddr;
> +       __u8 protocol;
> +       u64  jiffies; /* keep the time update entry */
> +       struct hlist_node node;
> +};
> +#define MAX_MAINTENANCE_TIME (2000)
> +#define PERIODIC_AGEING_TIME (10000)
> +bool rps_flow_node_create(__be32 saddr, __be32 daddr, __u8 protocol);
> +void rps_single_flow_set(bool enable);
> +
>  #endif /* CONFIG_XPS */
>
>  #define TC_MAX_QUEUE   16
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 08ce317fcec8..da3eb184fca1 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4433,6 +4433,142 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>   * CPU from the RPS map of the receiving queue for a given skb.
>   * rcu_read_lock must be held on entry.
>   */
> +#define DEFAULT_HASH_BUKET_BIT (3)
> +#define DEFAULT_QUOTA_PER_CPU (64)
> +static unsigned int  quota_per_cpu = DEFAULT_QUOTA_PER_CPU;
> +static atomic_t rps_flow_queue_enable_count = ATOMIC_INIT(0);
> +static u64 last_aging_jiffies;
> +static DEFINE_HASHTABLE(rps_flow_info_htable, DEFAULT_HASH_BUKET_BIT);

So you have a single hashtable, used by all NIC and all network namespaces ?

{saddr,daddr,protocol} is not unique

> +static DEFINE_RWLOCK(rps_flow_rwlock);

New rwlocks in networking are absolutely forbidden.

We are (painfully) removing them, we do not want new ones.

> +
> +/* create rps flow node if not exist.
> + * update Timestamp for rps flow node if exist
> + */
> +bool rps_flow_node_create(__be32 saddr, __be32 daddr, __u8 protocol)
> +{
> +       /* hash key */
> +       u32 hash_key = saddr ^ daddr ^ protocol;
> +       struct rps_flow_info_node *p_rps_flow_info = NULL;
> +
> +       /* no rps_single_flow_enable */
> +       if (!atomic_read(&rps_flow_queue_enable_count))
> +               return false;
> +
> +       /* find if the node already  exist */
> +       read_lock(&rps_flow_rwlock);
> +       hash_for_each_possible(rps_flow_info_htable, p_rps_flow_info, node, hash_key) {
> +               if ((saddr == p_rps_flow_info->saddr) && (daddr == p_rps_flow_info->daddr)
> +                       && (protocol == p_rps_flow_info->protocol)) {
> +                       p_rps_flow_info->jiffies = jiffies;
> +                       read_unlock(&rps_flow_rwlock);
> +                       return true;
> +               }
> +       }
> +       read_unlock(&rps_flow_rwlock);
> +
> +       /*if not exist. get a new one */
> +       p_rps_flow_info = kmalloc(sizeof(*p_rps_flow_info), GFP_KERNEL);
> +       if (!p_rps_flow_info)
> +               return false;
> +
> +       memset(p_rps_flow_info, 0, sizeof(struct rps_flow_info_node));
> +       p_rps_flow_info->saddr = saddr;
> +       p_rps_flow_info->daddr = daddr;
> +       p_rps_flow_info->protocol = protocol;
> +       p_rps_flow_info->jiffies = jiffies;
> +
> +       /*add the hash nodee*/
> +       write_lock(&rps_flow_rwlock);
> +       hash_add(rps_flow_info_htable, &p_rps_flow_info->node, hash_key);
> +       write_unlock(&rps_flow_rwlock);
> +       return true;
> +}
> +EXPORT_SYMBOL(rps_flow_node_create);
> +
> +static void rps_flow_node_clear(void)
> +{
> +       u32 bkt = 0;
> +       struct rps_flow_info_node *p_rps_flow_entry = NULL;
> +       struct hlist_node *tmp;
> +
> +       write_lock(&rps_flow_rwlock);
> +       hash_for_each_safe(rps_flow_info_htable, bkt, tmp, p_rps_flow_entry, node) {
> +               hash_del(&p_rps_flow_entry->node);
> +               kfree(p_rps_flow_entry);
> +       }
> +       write_unlock(&rps_flow_rwlock);
> +}
> +
> +void rps_single_flow_set(bool enable)
> +{
> +       if (enable) {
> +               atomic_inc(&rps_flow_queue_enable_count);
> +       } else {
> +               atomic_dec(&rps_flow_queue_enable_count);
> +               if (!atomic_read(&rps_flow_queue_enable_count))
> +                       rps_flow_node_clear();
> +       }
> +}
> +EXPORT_SYMBOL(rps_single_flow_set);
> +
> +/* compute hash */
> +static inline u32 rps_flow_hash_update(void)
> +{
> +       static u32 packet_count;
> +       static u32 hash_count;
> +
> +       packet_count++;
> +       if (packet_count % quota_per_cpu) {
> +               packet_count = 0;
> +               hash_count++;
> +               if (hash_count == U32_MAX)
> +                       hash_count = 0;
> +       }
> +       return hash_count;
> +}
> +
> +/* delete aging rps_flow  */
> +static inline bool rps_flow_node_aging_period(void)
> +{
> +       u32 bkt = 0;
> +       struct rps_flow_info_node *p_rps_flow_entry = NULL;
> +       struct hlist_node *tmp;
> +
> +       if (jiffies_to_msecs(jiffies - last_aging_jiffies) < PERIODIC_AGEING_TIME)
> +               return false;
> +
> +       last_aging_jiffies = jiffies;
> +       write_lock(&rps_flow_rwlock);
> +       hash_for_each_safe(rps_flow_info_htable, bkt, tmp, p_rps_flow_entry, node) {
> +               if (jiffies_to_msecs(jiffies - p_rps_flow_entry->jiffies) >= MAX_MAINTENANCE_TIME) {
> +                       hash_del(&p_rps_flow_entry->node);
> +                       kfree(p_rps_flow_entry);
> +               }
> +       }
> +       write_unlock(&rps_flow_rwlock);
> +       return true;
> +}
> +
> +/*  find vailed rps_flow */

What is the meaning of vailed ?

> +static inline struct rps_flow_info_node *rps_flow_find_vailed_node(__be32 saddr,
> +               __be32 daddr, __u8 protocol)
> +{
> +       struct rps_flow_info_node *p_rps_flow_info = NULL;
> +       u32 hash_key = saddr ^ daddr ^ protocol;

Hash function is copy/pasted ?

> +
> +       read_lock(&rps_flow_rwlock);
> +       hash_for_each_possible(rps_flow_info_htable, p_rps_flow_info, node, hash_key) {
> +               if ((saddr == p_rps_flow_info->saddr) && (daddr == p_rps_flow_info->daddr)
> +               && (protocol == p_rps_flow_info->protocol)
> +               && (jiffies_to_msecs(jiffies - p_rps_flow_info->jiffies) < MAX_MAINTENANCE_TIME)) {
> +                       read_unlock(&rps_flow_rwlock);
> +                       return p_rps_flow_info;
> +               }
> +       }
> +       read_unlock(&rps_flow_rwlock);
> +       return NULL;
> +}
> +
>  static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>                        struct rps_dev_flow **rflowp)
>  {
> @@ -4465,6 +4601,57 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
>                 goto done;
>
>         skb_reset_network_header(skb);
> +       /* this is to set rps for single flow */
> +       if (unlikely(rxqueue->rps_single_flow_enable)) {
> +               /* clean the old node */
> +               rps_flow_node_aging_period();
> +
> +               /* no rps ,skip it*/
> +               if (!map)
> +                       goto orgin_rps;
> +
> +               /* skip vlan first  */
> +               if (skb_vlan_tag_present(skb))
> +                       goto done;
> +
> +               switch (skb->protocol) {
> +               /*  ipv4  */
> +               case htons(ETH_P_IP): {

IPv4 only ?


> +                       const struct iphdr *iph;
> +                       struct rps_flow_info_node *p_flow;
> +
> +                       iph = (struct iphdr *)skb_network_header(skb);
> +                       /* hash map to match the src and dest ipaddr */
> +                       p_flow = rps_flow_find_vailed_node(iph->saddr, iph->daddr, iph->protocol);
> +                       /* check if vailed */
> +                       if (p_flow) {
> +                               pr_debug("single flow rps,flow info: saddr = %pI4, daddr =%pI4, proto=%d\n",
> +                                               &p_flow->saddr,
> +                                               &p_flow->daddr,
> +                                               p_flow->protocol);
> +                       } else {
> +                               goto orgin_rps;
> +                       }
> +               }
> +               break;
> +               /* to do, ipv6 */
> +               default:
> +                       goto orgin_rps;
> +
> +               }
> +
> +               /* get the target cpu */
> +               u32 hash_single_flow = rps_flow_hash_update();
> +
> +               tcpu = map->cpus[hash_single_flow % map->len];
> +               if (cpu_online(tcpu)) {
> +                       cpu = tcpu;
> +                       pr_debug("single flow rps, target cpuid = %d\n", cpu);
> +                       return cpu;
> +               }
> +       }
> +
> +orgin_rps:
>         hash = skb_get_hash(skb);
>         if (!hash)
>                 goto done;
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index e319e242dddf..c72ce20081e8 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -978,6 +978,41 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
>         return len;
>  }
>
> +static ssize_t show_rps_single_flow(struct netdev_rx_queue *queue, char *buf)
> +{
> +       unsigned long val = 0;
> +
> +       val = queue->rps_single_flow_enable;
> +       return sprintf(buf, "%lu\n", val);
> +}
> +
> +static ssize_t store_rps_single_flow(struct netdev_rx_queue *queue, const char *buf, size_t len)
> +{
> +       int rc;
> +       unsigned long enable;
> +       bool rps_single_flow_enable = false;
> +
> +       if (!capable(CAP_NET_ADMIN))
> +               return -EPERM;
> +
> +       rc = kstrtoul(buf, 0, &enable);
> +       if (rc < 0)
> +               return rc;
> +
> +       rps_single_flow_enable = !!enable;
> +
> +       /* if changed, store the new one */
> +       if (rps_single_flow_enable != queue->rps_single_flow_enable) {
> +               queue->rps_single_flow_enable = rps_single_flow_enable;
> +               rps_single_flow_set(rps_single_flow_enable);
> +       }
> +
> +       return len;
> +}
> +
> +static struct rx_queue_attribute rps_single_flow_attribute  __ro_after_init
> +       = __ATTR(rps_single_flow, 0644, show_rps_single_flow, store_rps_single_flow);
> +
>  static struct rx_queue_attribute rps_cpus_attribute __ro_after_init
>         = __ATTR(rps_cpus, 0644, show_rps_map, store_rps_map);
>
> @@ -988,6 +1023,7 @@ static struct rx_queue_attribute rps_dev_flow_table_cnt_attribute __ro_after_ini
>
>  static struct attribute *rx_queue_default_attrs[] __ro_after_init = {
>  #ifdef CONFIG_RPS
> +       &rps_single_flow_attribute.attr,
>         &rps_cpus_attribute.attr,
>         &rps_dev_flow_table_cnt_attribute.attr,
>  #endif
> --
> 2.31.1
>
