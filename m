Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E829F630F5B
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 17:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiKSQXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 11:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKSQXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 11:23:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A6786FDF
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 08:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668874938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LgNHIrrxNYdqI6hge/fkGQ/cEA9W6a79hPB9hAK734o=;
        b=aLczdSzl33r5HXD1CGSY/9FO1xTlC2uHSVLLm4tcN2hHCL7B2x9H4kJKdrwFd6lQsN68xM
        CkPGMu6j+dIaxZFnAcmtyy51ouCasaw2ewFvhYBycVFwr6JH1yegy7hrMaQ6rCPUZlgmpg
        qUYQtazlr2bnb6fuUvUu0XRlleFw17w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-aTJayG3XNZukpPDce7zWag-1; Sat, 19 Nov 2022 11:22:14 -0500
X-MC-Unique: aTJayG3XNZukpPDce7zWag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AF9D1C04B76;
        Sat, 19 Nov 2022 16:22:13 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.19.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D498914152F9;
        Sat, 19 Nov 2022 16:22:10 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH net-next 5/5] net: move the nat function to nf_nat_core
 for ovs and tc
References: <cover.1668527318.git.lucien.xin@gmail.com>
        <488fbfa082eb8a0ab81622a7c13c26b6fd8a0602.1668527318.git.lucien.xin@gmail.com>
        <f7tfsei4nkn.fsf@redhat.com>
        <CADvbK_cwEznpOpjmeaVeFs2f9W7AsC-+VRnUHj1NO2AffFfSnQ@mail.gmail.com>
Date:   Sat, 19 Nov 2022 11:22:07 -0500
In-Reply-To: <CADvbK_cwEznpOpjmeaVeFs2f9W7AsC-+VRnUHj1NO2AffFfSnQ@mail.gmail.com>
        (Xin Long's message of "Wed, 16 Nov 2022 19:36:45 -0500")
Message-ID: <f7tfseezzgw.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> writes:

> On Wed, Nov 16, 2022 at 4:05 PM Aaron Conole <aconole@redhat.com> wrote:
>>
>> Hi Xin,
>>
>> Xin Long <lucien.xin@gmail.com> writes:
>>
>> > There are two nat functions are nearly the same in both OVS and
>> > TC code, (ovs_)ct_nat_execute() and ovs_ct_nat/tcf_ct_act_nat().
>> >
>> > This patch is to move them to netfilter nf_nat_core and export
>> > nf_ct_nat() so that it can be shared by both OVS and TC, and
>> > keep the nat (type) check and nat flag update in OVS and TC's
>> > own place, as these parts are different between OVS and TC.
>> >
>> > Note that in OVS nat function it was using skb->protocol to get
>> > the proto as it already skips vlans in key_extract(), while it
>> > doesn't in TC, and TC has to call skb_protocol() to get proto.
>> > So in nf_ct_nat_execute(), we keep using skb_protocol() which
>> > works for both OVS and TC.
>> >
>> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> > ---
>> >  include/net/netfilter/nf_nat.h |   4 +
>> >  net/netfilter/nf_nat_core.c    | 131 +++++++++++++++++++++++++++++++
>> >  net/openvswitch/conntrack.c    | 137 +++------------------------------
>> >  net/sched/act_ct.c             | 136 +++-----------------------------
>> >  4 files changed, 156 insertions(+), 252 deletions(-)
>> >
>> > diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
>> > index e9eb01e99d2f..9877f064548a 100644
>> > --- a/include/net/netfilter/nf_nat.h
>> > +++ b/include/net/netfilter/nf_nat.h
>> > @@ -104,6 +104,10 @@ unsigned int
>> >  nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>> >              const struct nf_hook_state *state);
>> >
>> > +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
>> > +           enum ip_conntrack_info ctinfo, int *action,
>> > +           const struct nf_nat_range2 *range, bool commit);
>> > +
>> >  static inline int nf_nat_initialized(const struct nf_conn *ct,
>> >                                    enum nf_nat_manip_type manip)
>> >  {
>> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
>> > index e29e4ccb5c5a..1c72b8caa24e 100644
>> > --- a/net/netfilter/nf_nat_core.c
>> > +++ b/net/netfilter/nf_nat_core.c
>> > @@ -784,6 +784,137 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>> >  }
>> >  EXPORT_SYMBOL_GPL(nf_nat_inet_fn);
>> >
>> > +/* Modelled after nf_nat_ipv[46]_fn().
>> > + * range is only used for new, uninitialized NAT state.
>> > + * Returns either NF_ACCEPT or NF_DROP.
>> > + */
>> > +static int nf_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
>> > +                          enum ip_conntrack_info ctinfo, int *action,
>> > +                          const struct nf_nat_range2 *range,
>> > +                          enum nf_nat_manip_type maniptype)
>> > +{
>> > +     __be16 proto = skb_protocol(skb, true);
>> > +     int hooknum, err = NF_ACCEPT;
>> > +
>> > +     /* See HOOK2MANIP(). */
>> > +     if (maniptype == NF_NAT_MANIP_SRC)
>> > +             hooknum = NF_INET_LOCAL_IN; /* Source NAT */
>> > +     else
>> > +             hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
>> > +
>> > +     switch (ctinfo) {
>> > +     case IP_CT_RELATED:
>> > +     case IP_CT_RELATED_REPLY:
>> > +             if (proto == htons(ETH_P_IP) &&
>> > +                 ip_hdr(skb)->protocol == IPPROTO_ICMP) {
>> > +                     if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
>> > +                                                        hooknum))
>> > +                             err = NF_DROP;
>> > +                     goto out;
>> > +             } else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
>> > +                     __be16 frag_off;
>> > +                     u8 nexthdr = ipv6_hdr(skb)->nexthdr;
>> > +                     int hdrlen = ipv6_skip_exthdr(skb,
>> > +                                                   sizeof(struct ipv6hdr),
>> > +                                                   &nexthdr, &frag_off);
>> > +
>> > +                     if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
>> > +                             if (!nf_nat_icmpv6_reply_translation(skb, ct,
>> > +                                                                  ctinfo,
>> > +                                                                  hooknum,
>> > +                                                                  hdrlen))
>> > +                                     err = NF_DROP;
>> > +                             goto out;
>> > +                     }
>> > +             }
>> > +             /* Non-ICMP, fall thru to initialize if needed. */
>> > +             fallthrough;
>> > +     case IP_CT_NEW:
>> > +             /* Seen it before?  This can happen for loopback, retrans,
>> > +              * or local packets.
>> > +              */
>> > +             if (!nf_nat_initialized(ct, maniptype)) {
>> > +                     /* Initialize according to the NAT action. */
>> > +                     err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
>> > +                             /* Action is set up to establish a new
>> > +                              * mapping.
>> > +                              */
>> > +                             ? nf_nat_setup_info(ct, range, maniptype)
>> > +                             : nf_nat_alloc_null_binding(ct, hooknum);
>> > +                     if (err != NF_ACCEPT)
>> > +                             goto out;
>> > +             }
>> > +             break;
>> > +
>> > +     case IP_CT_ESTABLISHED:
>> > +     case IP_CT_ESTABLISHED_REPLY:
>> > +             break;
>> > +
>> > +     default:
>> > +             err = NF_DROP;
>> > +             goto out;
>> > +     }
>> > +
>> > +     err = nf_nat_packet(ct, ctinfo, hooknum, skb);
>> > +     if (err == NF_ACCEPT)
>> > +             *action |= (1 << maniptype);
>> > +out:
>> > +     return err;
>> > +}
>> > +
>> > +int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
>> > +           enum ip_conntrack_info ctinfo, int *action,
>> > +           const struct nf_nat_range2 *range, bool commit)
>> > +{
>> > +     enum nf_nat_manip_type maniptype;
>> > +     int err, ct_action = *action;
>> > +
>> > +     *action = 0;
>> > +
>> > +     /* Add NAT extension if not confirmed yet. */
>> > +     if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
>> > +             return NF_ACCEPT;   /* Can't NAT. */
>> > +
>> > +     if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
>> > +         (ctinfo != IP_CT_RELATED || commit)) {
>> > +             /* NAT an established or related connection like before. */
>> > +             if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
>> > +                     /* This is the REPLY direction for a connection
>> > +                      * for which NAT was applied in the forward
>> > +                      * direction.  Do the reverse NAT.
>> > +                      */
>> > +                     maniptype = ct->status & IPS_SRC_NAT
>> > +                             ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
>> > +             else
>> > +                     maniptype = ct->status & IPS_SRC_NAT
>> > +                             ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
>> > +     } else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
>> > +             maniptype = NF_NAT_MANIP_SRC;
>> > +     } else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
>> > +             maniptype = NF_NAT_MANIP_DST;
>> > +     } else {
>> > +             return NF_ACCEPT;
>> > +     }
>> > +
>> > +     err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
>> > +     if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
>> > +             if (ct->status & IPS_SRC_NAT) {
>> > +                     if (maniptype == NF_NAT_MANIP_SRC)
>> > +                             maniptype = NF_NAT_MANIP_DST;
>> > +                     else
>> > +                             maniptype = NF_NAT_MANIP_SRC;
>> > +
>> > +                     err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
>> > +                                             maniptype);
>> > +             } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
>> > +                     err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
>> > +                                             NF_NAT_MANIP_SRC);
>> > +             }
>> > +     }
>> > +     return err;
>> > +}
>> > +EXPORT_SYMBOL_GPL(nf_ct_nat);
>> > +
>> >  struct nf_nat_proto_clean {
>> >       u8      l3proto;
>> >       u8      l4proto;
>> > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
>> > index cc643a556ea1..d03c75165663 100644
>> > --- a/net/openvswitch/conntrack.c
>> > +++ b/net/openvswitch/conntrack.c
>> > @@ -726,144 +726,27 @@ static void ovs_nat_update_key(struct sw_flow_key *key,
>> >       }
>> >  }
>> >
>> > -/* Modelled after nf_nat_ipv[46]_fn().
>> > - * range is only used for new, uninitialized NAT state.
>> > - * Returns either NF_ACCEPT or NF_DROP.
>> > - */
>> > -static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
>> > -                           enum ip_conntrack_info ctinfo,
>> > -                           const struct nf_nat_range2 *range,
>> > -                           enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
>> > -{
>> > -     int hooknum, err = NF_ACCEPT;
>> > -
>> > -     /* See HOOK2MANIP(). */
>> > -     if (maniptype == NF_NAT_MANIP_SRC)
>> > -             hooknum = NF_INET_LOCAL_IN; /* Source NAT */
>> > -     else
>> > -             hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
>> > -
>> > -     switch (ctinfo) {
>> > -     case IP_CT_RELATED:
>> > -     case IP_CT_RELATED_REPLY:
>> > -             if (IS_ENABLED(CONFIG_NF_NAT) &&
>> > -                 skb->protocol == htons(ETH_P_IP) &&
>> > -                 ip_hdr(skb)->protocol == IPPROTO_ICMP) {
>> > -                     if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
>> > -                                                        hooknum))
>> > -                             err = NF_DROP;
>> > -                     goto out;
>> > -             } else if (IS_ENABLED(CONFIG_IPV6) &&
>> > -                        skb->protocol == htons(ETH_P_IPV6)) {
>> > -                     __be16 frag_off;
>> > -                     u8 nexthdr = ipv6_hdr(skb)->nexthdr;
>> > -                     int hdrlen = ipv6_skip_exthdr(skb,
>> > -                                                   sizeof(struct ipv6hdr),
>> > -                                                   &nexthdr, &frag_off);
>> > -
>> > -                     if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
>> > -                             if (!nf_nat_icmpv6_reply_translation(skb, ct,
>> > -                                                                  ctinfo,
>> > -                                                                  hooknum,
>> > -                                                                  hdrlen))
>> > -                                     err = NF_DROP;
>> > -                             goto out;
>> > -                     }
>> > -             }
>> > -             /* Non-ICMP, fall thru to initialize if needed. */
>> > -             fallthrough;
>> > -     case IP_CT_NEW:
>> > -             /* Seen it before?  This can happen for loopback, retrans,
>> > -              * or local packets.
>> > -              */
>> > -             if (!nf_nat_initialized(ct, maniptype)) {
>> > -                     /* Initialize according to the NAT action. */
>> > -                     err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
>> > -                             /* Action is set up to establish a new
>> > -                              * mapping.
>> > -                              */
>> > -                             ? nf_nat_setup_info(ct, range, maniptype)
>> > -                             : nf_nat_alloc_null_binding(ct, hooknum);
>> > -                     if (err != NF_ACCEPT)
>> > -                             goto out;
>> > -             }
>> > -             break;
>> > -
>> > -     case IP_CT_ESTABLISHED:
>> > -     case IP_CT_ESTABLISHED_REPLY:
>> > -             break;
>> > -
>> > -     default:
>> > -             err = NF_DROP;
>> > -             goto out;
>> > -     }
>> > -
>> > -     err = nf_nat_packet(ct, ctinfo, hooknum, skb);
>> > -out:
>> > -     /* Update the flow key if NAT successful. */
>> > -     if (err == NF_ACCEPT)
>> > -             ovs_nat_update_key(key, skb, maniptype);
>> > -
>> > -     return err;
>> > -}
>> > -
>> >  /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
>> >  static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
>> >                     const struct ovs_conntrack_info *info,
>> >                     struct sk_buff *skb, struct nf_conn *ct,
>> >                     enum ip_conntrack_info ctinfo)
>> >  {
>> > -     enum nf_nat_manip_type maniptype;
>> > -     int err;
>> > +     int err, action = 0;
>> >
>> >       if (!(info->nat & OVS_CT_NAT))
>> >               return NF_ACCEPT;
>> > +     if (info->nat & OVS_CT_SRC_NAT)
>> > +             action |= (1 << NF_NAT_MANIP_SRC);
>> > +     if (info->nat & OVS_CT_DST_NAT)
>> > +             action |= (1 << NF_NAT_MANIP_DST);
>> >
>> > -     /* Add NAT extension if not confirmed yet. */
>> > -     if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
>> > -             return NF_ACCEPT;   /* Can't NAT. */
>> > +     err = nf_ct_nat(skb, ct, ctinfo, &action, &info->range, info->commit);
>> >
>> > -     /* Determine NAT type.
>> > -      * Check if the NAT type can be deduced from the tracked connection.
>> > -      * Make sure new expected connections (IP_CT_RELATED) are NATted only
>> > -      * when committing.
>> > -      */
>> > -     if (ctinfo != IP_CT_NEW && ct->status & IPS_NAT_MASK &&
>> > -         (ctinfo != IP_CT_RELATED || info->commit)) {
>> > -             /* NAT an established or related connection like before. */
>> > -             if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
>> > -                     /* This is the REPLY direction for a connection
>> > -                      * for which NAT was applied in the forward
>> > -                      * direction.  Do the reverse NAT.
>> > -                      */
>> > -                     maniptype = ct->status & IPS_SRC_NAT
>> > -                             ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
>> > -             else
>> > -                     maniptype = ct->status & IPS_SRC_NAT
>> > -                             ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
>> > -     } else if (info->nat & OVS_CT_SRC_NAT) {
>> > -             maniptype = NF_NAT_MANIP_SRC;
>> > -     } else if (info->nat & OVS_CT_DST_NAT) {
>> > -             maniptype = NF_NAT_MANIP_DST;
>> > -     } else {
>> > -             return NF_ACCEPT; /* Connection is not NATed. */
>> > -     }
>> > -     err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, key);
>> > -
>> > -     if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
>> > -             if (ct->status & IPS_SRC_NAT) {
>> > -                     if (maniptype == NF_NAT_MANIP_SRC)
>> > -                             maniptype = NF_NAT_MANIP_DST;
>> > -                     else
>> > -                             maniptype = NF_NAT_MANIP_SRC;
>> > -
>> > -                     err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
>> > -                                              maniptype, key);
>> > -             } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
>> > -                     err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
>> > -                                              NF_NAT_MANIP_SRC, key);
>> > -             }
>> > -     }
>> > +     if (action & (1 << NF_NAT_MANIP_SRC))
>> > +             ovs_nat_update_key(key, skb, NF_NAT_MANIP_SRC);
>> > +     if (action & (1 << NF_NAT_MANIP_DST))
>> > +             ovs_nat_update_key(key, skb, NF_NAT_MANIP_DST);
>>
>> I haven't tested this yet with tuple collision, but if I'm reading the
>> code right, info->nat will only be from the parsed actions (which will
>> have a single src/dst manipulation).  But, this code was previously
>> always updated based on ct->status information, which isn't quite the
>> same.  Maybe I'm missing something.  I plan to run this testing
>> tomorrow, but maybe you have already tested for it?
> Hi, Aaron,
>
> Note "&action" is passed into nf_ct_nat() then nf_ct_nat_execute(), and
> its value might be changed in nf_ct_nat_execute():
>
> +       err = nf_nat_packet(ct, ctinfo, hooknum, skb);
> +       if (err == NF_ACCEPT)
> +               *action |= (1 << maniptype);
>
> so it's possible to have multiple (src and dst) manipulations, and
> the code is eventually the same as before.

I missed the assignment from '*action' on the line above '*action = 0'.

> I tested with:
> ovs-ofctl add-flow br-ovs "...nw_dst=7.7.16.3 actions=ct(commit,
> nat(dst=7.7.16.2), alg=ftp), normal"
> ovs-ofctl add-flow br-ovs "...nw_dst=7.7.16.4 actions=ct(commit,
> nat(dst=7.7.16.2), alg=ftp), normal"
> and could see actions=3 (NF_NAT_MANIP_SRC|DST).
>
> It will be good if you have more tests to be done.

Will do - I will also work on adding a tuple collision test in the
selftests after the next round of updates I do.

> Thanks.
>
>>
>> >       return err;
>> >  }
>> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> > index c7782c9a6ab6..0c410220239f 100644
>> > --- a/net/sched/act_ct.c
>> > +++ b/net/sched/act_ct.c
>> > @@ -863,90 +863,6 @@ static void tcf_ct_params_free_rcu(struct rcu_head *head)
>> >       tcf_ct_params_free(params);
>> >  }
>> >
>> > -#if IS_ENABLED(CONFIG_NF_NAT)
>> > -/* Modelled after nf_nat_ipv[46]_fn().
>> > - * range is only used for new, uninitialized NAT state.
>> > - * Returns either NF_ACCEPT or NF_DROP.
>> > - */
>> > -static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
>> > -                       enum ip_conntrack_info ctinfo,
>> > -                       const struct nf_nat_range2 *range,
>> > -                       enum nf_nat_manip_type maniptype)
>> > -{
>> > -     __be16 proto = skb_protocol(skb, true);
>> > -     int hooknum, err = NF_ACCEPT;
>> > -
>> > -     /* See HOOK2MANIP(). */
>> > -     if (maniptype == NF_NAT_MANIP_SRC)
>> > -             hooknum = NF_INET_LOCAL_IN; /* Source NAT */
>> > -     else
>> > -             hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
>> > -
>> > -     switch (ctinfo) {
>> > -     case IP_CT_RELATED:
>> > -     case IP_CT_RELATED_REPLY:
>> > -             if (proto == htons(ETH_P_IP) &&
>> > -                 ip_hdr(skb)->protocol == IPPROTO_ICMP) {
>> > -                     if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
>> > -                                                        hooknum))
>> > -                             err = NF_DROP;
>> > -                     goto out;
>> > -             } else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
>> > -                     __be16 frag_off;
>> > -                     u8 nexthdr = ipv6_hdr(skb)->nexthdr;
>> > -                     int hdrlen = ipv6_skip_exthdr(skb,
>> > -                                                   sizeof(struct ipv6hdr),
>> > -                                                   &nexthdr, &frag_off);
>> > -
>> > -                     if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
>> > -                             if (!nf_nat_icmpv6_reply_translation(skb, ct,
>> > -                                                                  ctinfo,
>> > -                                                                  hooknum,
>> > -                                                                  hdrlen))
>> > -                                     err = NF_DROP;
>> > -                             goto out;
>> > -                     }
>> > -             }
>> > -             /* Non-ICMP, fall thru to initialize if needed. */
>> > -             fallthrough;
>> > -     case IP_CT_NEW:
>> > -             /* Seen it before?  This can happen for loopback, retrans,
>> > -              * or local packets.
>> > -              */
>> > -             if (!nf_nat_initialized(ct, maniptype)) {
>> > -                     /* Initialize according to the NAT action. */
>> > -                     err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
>> > -                             /* Action is set up to establish a new
>> > -                              * mapping.
>> > -                              */
>> > -                             ? nf_nat_setup_info(ct, range, maniptype)
>> > -                             : nf_nat_alloc_null_binding(ct, hooknum);
>> > -                     if (err != NF_ACCEPT)
>> > -                             goto out;
>> > -             }
>> > -             break;
>> > -
>> > -     case IP_CT_ESTABLISHED:
>> > -     case IP_CT_ESTABLISHED_REPLY:
>> > -             break;
>> > -
>> > -     default:
>> > -             err = NF_DROP;
>> > -             goto out;
>> > -     }
>> > -
>> > -     err = nf_nat_packet(ct, ctinfo, hooknum, skb);
>> > -out:
>> > -     if (err == NF_ACCEPT) {
>> > -             if (maniptype == NF_NAT_MANIP_SRC)
>> > -                     tc_skb_cb(skb)->post_ct_snat = 1;
>> > -             if (maniptype == NF_NAT_MANIP_DST)
>> > -                     tc_skb_cb(skb)->post_ct_dnat = 1;
>> > -     }
>> > -     return err;
>> > -}
>> > -#endif /* CONFIG_NF_NAT */
>> > -
>> >  static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
>> >  {
>> >  #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
>> > @@ -986,52 +902,22 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>> >                         bool commit)
>> >  {
>> >  #if IS_ENABLED(CONFIG_NF_NAT)
>> > -     int err;
>> > -     enum nf_nat_manip_type maniptype;
>> > +     int err, action = 0;
>> >
>> >       if (!(ct_action & TCA_CT_ACT_NAT))
>> >               return NF_ACCEPT;
>> > +     if (ct_action & TCA_CT_ACT_NAT_SRC)
>> > +             action |= (1 << NF_NAT_MANIP_SRC);
>> > +     if (ct_action & TCA_CT_ACT_NAT_DST)
>> > +             action |= (1 << NF_NAT_MANIP_DST);
>> >
>> > -     /* Add NAT extension if not confirmed yet. */
>> > -     if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
>> > -             return NF_ACCEPT;   /* Can't NAT. */
>> > -
>> > -     if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
>> > -         (ctinfo != IP_CT_RELATED || commit)) {
>> > -             /* NAT an established or related connection like before. */
>> > -             if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
>> > -                     /* This is the REPLY direction for a connection
>> > -                      * for which NAT was applied in the forward
>> > -                      * direction.  Do the reverse NAT.
>> > -                      */
>> > -                     maniptype = ct->status & IPS_SRC_NAT
>> > -                             ? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
>> > -             else
>> > -                     maniptype = ct->status & IPS_SRC_NAT
>> > -                             ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
>> > -     } else if (ct_action & TCA_CT_ACT_NAT_SRC) {
>> > -             maniptype = NF_NAT_MANIP_SRC;
>> > -     } else if (ct_action & TCA_CT_ACT_NAT_DST) {
>> > -             maniptype = NF_NAT_MANIP_DST;
>> > -     } else {
>> > -             return NF_ACCEPT;
>> > -     }
>> > +     err = nf_ct_nat(skb, ct, ctinfo, &action, range, commit);
>> > +
>> > +     if (action & (1 << NF_NAT_MANIP_SRC))
>> > +             tc_skb_cb(skb)->post_ct_snat = 1;
>> > +     if (action & (1 << NF_NAT_MANIP_DST))
>> > +             tc_skb_cb(skb)->post_ct_dnat = 1;
>> >
>> > -     err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> > -     if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
>> > -             if (ct->status & IPS_SRC_NAT) {
>> > -                     if (maniptype == NF_NAT_MANIP_SRC)
>> > -                             maniptype = NF_NAT_MANIP_DST;
>> > -                     else
>> > -                             maniptype = NF_NAT_MANIP_SRC;
>> > -
>> > -                     err = ct_nat_execute(skb, ct, ctinfo, range,
>> > -                                          maniptype);
>> > -             } else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
>> > -                     err = ct_nat_execute(skb, ct, ctinfo, NULL,
>> > -                                          NF_NAT_MANIP_SRC);
>> > -             }
>> > -     }
>> >       return err;
>> >  #else
>> >       return NF_ACCEPT;
>>

