Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4838D772
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfHNPvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:51:40 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39019 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNPvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:51:39 -0400
X-Originating-IP: 209.85.222.41
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
        (Authenticated sender: pshelar@ovn.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 23C7D1C0003
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 15:51:36 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id g11so16177991uak.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:51:36 -0700 (PDT)
X-Gm-Message-State: APjAAAVfLmq6S0il6FAqymy/UlaqWiKb6pg7e4jjOOUZJdNx5hC7yaE+
        BmrFfl8o3sv80w8FwmxrsLMmVkkkX6AZPRvBeLA=
X-Google-Smtp-Source: APXvYqwE0rg/wmwIlC6hBhzAD6znflLVuMBp5kRLEcJ8XVQwFjeiE4xmm3PmC7oinHjtGfxuZIIiG4NPgJd3XJnojPo=
X-Received: by 2002:ab0:699a:: with SMTP id t26mr341374uaq.70.1565797895779;
 Wed, 14 Aug 2019 08:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <1565179722-22488-1-git-send-email-paulb@mellanox.com>
 <CAOrHB_DhfiQy8RwTiwgn9ZXgsd5j2f0ynZPUP4wf-xzhjwo8kg@mail.gmail.com>
 <b5342e56-4baa-97ab-8694-2f48d012afca@mellanox.com> <CAOrHB_CDrau-jLycRYxRkn1tEXVrRhoSYSd8sAcGPiZ-bp+FEg@mail.gmail.com>
 <68e7a65c-162a-8bc5-4d80-f4f245944b9c@mellanox.com>
In-Reply-To: <68e7a65c-162a-8bc5-4d80-f4f245944b9c@mellanox.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 14 Aug 2019 08:53:07 -0700
X-Gmail-Original-Message-ID: <CAOrHB_Cn0Stx+Bc=Kvg55ZrOVNJhkn3Fz9rFjUNVOs8oRTgB9w@mail.gmail.com>
Message-ID: <CAOrHB_Cn0Stx+Bc=Kvg55ZrOVNJhkn3Fz9rFjUNVOs8oRTgB9w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain index
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 1:29 AM Paul Blakey <paulb@mellanox.com> wrote:
>
>
> On 8/12/2019 7:18 PM, Pravin Shelar wrote:
> > On Sun, Aug 11, 2019 at 3:46 AM Paul Blakey <paulb@mellanox.com> wrote:
> >>
> >> On 8/8/2019 11:53 PM, Pravin Shelar wrote:
> >>> On Wed, Aug 7, 2019 at 5:08 AM Paul Blakey <paulb@mellanox.com> wrote:
> >>>> Offloaded OvS datapath rules are translated one to one to tc rules,
> >>>> for example the following simplified OvS rule:
> >>>>
> >>>> recirc_id(0),in_port(dev1),eth_type(0x0800),ct_state(-trk) actions:ct(),recirc(2)
> >>>>
> >>>> Will be translated to the following tc rule:
> >>>>
> >>>> $ tc filter add dev dev1 ingress \
> >>>>               prio 1 chain 0 proto ip \
> >>>>                   flower tcp ct_state -trk \
> >>>>                   action ct pipe \
> >>>>                   action goto chain 2
> >>>>
> >>>> Received packets will first travel though tc, and if they aren't stolen
> >>>> by it, like in the above rule, they will continue to OvS datapath.
> >>>> Since we already did some actions (action ct in this case) which might
> >>>> modify the packets, and updated action stats, we would like to continue
> >>>> the proccessing with the correct recirc_id in OvS (here recirc_id(2))
> >>>> where we left off.
> >>>>
> >>>> To support this, introduce a new skb extension for tc, which
> >>>> will be used for translating tc chain to ovs recirc_id to
> >>>> handle these miss cases. Last tc chain index will be set
> >>>> by tc goto chain action and read by OvS datapath.
> >>>>
> >>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> >>>> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> >>>> Acked-by: Jiri Pirko <jiri@mellanox.com>
> >>>> ---
> >>>>    include/linux/skbuff.h    | 13 +++++++++++++
> >>>>    include/net/sch_generic.h |  5 ++++-
> >>>>    net/core/skbuff.c         |  6 ++++++
> >>>>    net/openvswitch/flow.c    |  9 +++++++++
> >>>>    net/sched/Kconfig         | 13 +++++++++++++
> >>>>    net/sched/act_api.c       |  1 +
> >>>>    net/sched/cls_api.c       | 12 ++++++++++++
> >>>>    7 files changed, 58 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >>>> index 3aef8d8..fb2a792 100644
> >>>> --- a/include/linux/skbuff.h
> >>>> +++ b/include/linux/skbuff.h
> >>>> @@ -279,6 +279,16 @@ struct nf_bridge_info {
> >>>>    };
> >>>>    #endif
> >>>>
> >>>> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> >>>> +/* Chain in tc_skb_ext will be used to share the tc chain with
> >>>> + * ovs recirc_id. It will be set to the current chain by tc
> >>>> + * and read by ovs to recirc_id.
> >>>> + */
> >>>> +struct tc_skb_ext {
> >>>> +       __u32 chain;
> >>>> +};
> >>>> +#endif
> >>>> +
> >>>>    struct sk_buff_head {
> >>>>           /* These two members must be first. */
> >>>>           struct sk_buff  *next;
> >>>> @@ -4050,6 +4060,9 @@ enum skb_ext_id {
> >>>>    #ifdef CONFIG_XFRM
> >>>>           SKB_EXT_SEC_PATH,
> >>>>    #endif
> >>>> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> >>>> +       TC_SKB_EXT,
> >>>> +#endif
> >>>>           SKB_EXT_NUM, /* must be last */
> >>>>    };
> >>>>
> >>>> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> >>>> index 6b6b012..871feea 100644
> >>>> --- a/include/net/sch_generic.h
> >>>> +++ b/include/net/sch_generic.h
> >>>> @@ -275,7 +275,10 @@ struct tcf_result {
> >>>>                           unsigned long   class;
> >>>>                           u32             classid;
> >>>>                   };
> >>>> -               const struct tcf_proto *goto_tp;
> >>>> +               struct {
> >>>> +                       const struct tcf_proto *goto_tp;
> >>>> +                       u32 goto_index;
> >>>> +               };
> >>>>
> >>>>                   /* used in the skb_tc_reinsert function */
> >>>>                   struct {
> >>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>>> index ea8e8d3..2b40b5a 100644
> >>>> --- a/net/core/skbuff.c
> >>>> +++ b/net/core/skbuff.c
> >>>> @@ -4087,6 +4087,9 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> >>>>    #ifdef CONFIG_XFRM
> >>>>           [SKB_EXT_SEC_PATH] = SKB_EXT_CHUNKSIZEOF(struct sec_path),
> >>>>    #endif
> >>>> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> >>>> +       [TC_SKB_EXT] = SKB_EXT_CHUNKSIZEOF(struct tc_skb_ext),
> >>>> +#endif
> >>>>    };
> >>>>
> >>>>    static __always_inline unsigned int skb_ext_total_length(void)
> >>>> @@ -4098,6 +4101,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
> >>>>    #ifdef CONFIG_XFRM
> >>>>                   skb_ext_type_len[SKB_EXT_SEC_PATH] +
> >>>>    #endif
> >>>> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> >>>> +               skb_ext_type_len[TC_SKB_EXT] +
> >>>> +#endif
> >>>>                   0;
> >>>>    }
> >>>>
> >>>> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> >>>> index bc89e16..0287ead 100644
> >>>> --- a/net/openvswitch/flow.c
> >>>> +++ b/net/openvswitch/flow.c
> >>>> @@ -816,6 +816,9 @@ static int key_extract_mac_proto(struct sk_buff *skb)
> >>>>    int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
> >>>>                            struct sk_buff *skb, struct sw_flow_key *key)
> >>>>    {
> >>>> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> >>>> +       struct tc_skb_ext *tc_ext;
> >>>> +#endif
> >>>>           int res, err;
> >>>>
> >>>>           /* Extract metadata from packet. */
> >>>> @@ -848,7 +851,13 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
> >>>>           if (res < 0)
> >>>>                   return res;
> >>>>           key->mac_proto = res;
> >>>> +
> >>>> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> >>>> +       tc_ext = skb_ext_find(skb, TC_SKB_EXT);
> >>>> +       key->recirc_id = tc_ext ? tc_ext->chain : 0;
> >>>> +#else
> >>>>           key->recirc_id = 0;
> >>>> +#endif
> >>>>
> >>> Most of cases the config would be turned on, so the ifdef is not that
> >>> useful. Can you add static key to avoid searching the skb-ext in non
> >>> offload cases.
> >> Hi,
> >>
> >> What do you mean by a static key?
> >>
> > https://www.kernel.org/doc/Documentation/static-keys.txt
> >
> > Static key can be enabled when a flow is added to the tc filter.
>
> Hi and thanks for the feedback,
>
> The skb_ext_find() just checks a single bit on the
> skb->active_extensions, and if so returns an offset. Do you think it
> will impact performance much?
>
I do not see much down side of adding static key here.

>
> But to your suggestion, do you mean that the first tc goto action
> instance with the relevant ifdef (CONFIG_NET_TC_SKB_EXT) it will enable
> the OvS static key that guards this skb_ext_find()?
>
> I guess calling it in tcf_action_set_ctrlact() if goto_chain != 0.
>
> This will expose some OvS helper function (or static key) to
> net/sched/act_api.c right?

Right, The patch adds this dependency anyways, so this symbol
definition in OVS would make it explicit to user.
