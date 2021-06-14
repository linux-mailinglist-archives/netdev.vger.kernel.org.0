Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E92C3A67D8
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhFNNbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:31:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233770AbhFNNbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623677338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U91bz5iYdN72V13NRGc2a3aU/6lkiKGPM+3vmxyqFhc=;
        b=FRXLU1qcc0ayKf6u68J5XEFWXwPMG8sI/OO9MyL12VfJdAzPPX7p9WBzuhO7c8U41JmH3x
        ElKNeHY7xFJ2vR6erXAf+iJekk4bWFXs586WCM2UEBMMzPcYRmcwHhftuWHLnnVGpiPOwr
        qxQzJrzJREMdjmEc48B6+tLNmP/MCjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-ClAIuA7sMGOlKqEzuySF2g-1; Mon, 14 Jun 2021 09:28:54 -0400
X-MC-Unique: ClAIuA7sMGOlKqEzuySF2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6E8310C1ADC;
        Mon, 14 Jun 2021 13:28:52 +0000 (UTC)
Received: from RHTPC1VM0NT (ovpn-115-17.rdu2.redhat.com [10.10.115.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5089F5D6A8;
        Mon, 14 Jun 2021 13:28:51 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [RFC net-next] openvswitch: add trace points
References: <20210527191532.376414-1-aconole@redhat.com>
        <3CFA963C-F587-4EA2-AC2D-B68E06A44D87@redhat.com>
Date:   Mon, 14 Jun 2021 09:28:50 -0400
In-Reply-To: <3CFA963C-F587-4EA2-AC2D-B68E06A44D87@redhat.com> (Eelco
        Chaudron's message of "Fri, 04 Jun 2021 15:31:36 +0200")
Message-ID: <f7twnqwy3ql.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> writes:

> On 27 May 2021, at 21:15, Aaron Conole wrote:
>
>  This makes openvswitch module use the event tracing framework=20
>  to log the upcall interface and action execution pipeline. When=20
>  using openvswitch as the packet forwarding engine, some types of=20
>  debugging are made possible simply by using the ovs-vswitchd's=20
>  ofproto/trace command. However, such a command has some=20
>  limitations:
>
>  1. When trying to trace packets that go through the CT action,=20
>  the state of the packet can't be determined, and probably=20
>  would be potentially wrong.
>
>  2. Deducing problem packets can sometimes be difficult as well=20
>  even if many of the flows are known
>
>  3. It's possible to use the openvswitch module even without=20
>  the ovs-vswitchd (although, not common use).
>
>  Introduce the event tracing points here to make it possible for=20
>  working through these problems in kernel space. The style is=20
>  copied from the mac80211 driver-trace / trace code for=20
>  consistency.
>
> Thanks for doing this Aaron, it will definitely help when trying to debug=
 some customer issues.

Thanks for the review!

> Just to be sure, I did some tests to make sure these changes do not impac=
t performance, and it looks fine! See some
> small nits/comments below, but other than that I would say please re-send=
 as an official patch.
>
> Cheers,
>
> Eelco
>
>  Signed-off-by: Aaron Conole <aconole@redhat.com>=20
>  ---=20
>  net/openvswitch/Makefile | 3 +=20
>  net/openvswitch/actions.c | 4 +=20
>  net/openvswitch/datapath.c | 7 ++=20
>  net/openvswitch/openvswitch_trace.c | 10 ++=20
>  net/openvswitch/openvswitch_trace.h | 152 ++++++++++++++++++++++++++++=20
>  5 files changed, 176 insertions(+)=20
>  create mode 100644 net/openvswitch/openvswitch_trace.c=20
>  create mode 100644 net/openvswitch/openvswitch_trace.h
>
>  diff --git a/net/openvswitch/Makefile b/net/openvswitch/Makefile=20
>  index 41109c326f3a..28982630bef3 100644=20
>  --- a/net/openvswitch/Makefile=20
>  +++ b/net/openvswitch/Makefile=20
>  @@ -13,6 +13,7 @@ openvswitch-y :=3D \=20
>  flow_netlink.o \=20
>  flow_table.o \=20
>  meter.o \=20
>  + openvswitch_trace.o \=20
>  vport.o \=20
>  vport-internal_dev.o \=20
>  vport-netdev.o=20
>  @@ -24,3 +25,5 @@ endif=20
>  obj-$(CONFIG_OPENVSWITCH_VXLAN)+=3D vport-vxlan.o=20
>  obj-$(CONFIG_OPENVSWITCH_GENEVE)+=3D vport-geneve.o=20
>  obj-$(CONFIG_OPENVSWITCH_GRE) +=3D vport-gre.o=20
>  +=20
>  +CFLAGS_openvswitch_trace.o =3D -I$(src)=20
>  diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c=20
>  index d858ea580e43..62285453ca79 100644=20
>  --- a/net/openvswitch/actions.c=20
>  +++ b/net/openvswitch/actions.c=20
>  @@ -30,6 +30,7 @@=20
>  #include "conntrack.h"=20
>  #include "vport.h"=20
>  #include "flow_netlink.h"=20
>  +#include "openvswitch_trace.h"
>
>  struct deferred_action {=20
>  struct sk_buff *skb;=20
>  @@ -1242,6 +1243,9 @@ static int do_execute_actions(struct datapath *dp,=
 struct sk_buff *skb,=20
>  a =3D nla_next(a, &rem)) {=20
>  int err =3D 0;
>
>  + if (trace_openvswitch_probe_action_enabled())=20
>  + trace_openvswitch_probe_action(dp, skb, key, a, rem);=20
>  +=20
>  switch (nla_type(a)) {=20
>  case OVS_ACTION_ATTR_OUTPUT: {=20
>  int port =3D nla_get_u32(a);=20
>  diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c=20
>  index 9d6ef6cb9b26..63f19a6ed472 100644=20
>  --- a/net/openvswitch/datapath.c=20
>  +++ b/net/openvswitch/datapath.c=20
>  @@ -43,6 +43,7 @@=20
>  #include "flow_table.h"=20
>  #include "flow_netlink.h"=20
>  #include "meter.h"=20
>  +#include "openvswitch_trace.h"=20
>  #include "vport-internal_dev.h"=20
>  #include "vport-netdev.h"
>
>  @@ -275,6 +276,12 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_bu=
ff *skb,=20
>  struct dp_stats_percpu *stats;=20
>  int err;
>
>  + if (trace_openvswitch_probe_userspace_enabled()) {=20
>  + struct sw_flow_key ukey =3D *key;=20
>  +=20
>  + trace_openvswitch_probe_userspace(dp, skb, &ukey, upcall_info);=20
>  + }
>
> Rather than work around the const here, can we not fix this in the trace =
include?

Done.

>     TP_PROTO(struct datapath *dp, struct sk_buff *skb,
>
> *            struct sw_flow_key *key,
>
> *            const struct sw_flow_key *key,
>            const struct dp_upcall_info *upcall_info),
>
> @@ -97,7 +97,7 @@ TRACE_EVENT(openvswitch_probe_userspace,
> __field( u16, gso_type )
> __field( u32, ovs_flow_hash )
> __field( u32, recirc_id )
>
> *           __field(        void *,         keyaddr                 )
>
> *           __field(        const void *,   keyaddr                 )
>           __field(        u16,            key_eth_type            )
>
>  +=20
>  if (upcall_info->portid =3D=3D 0) {=20
>  err =3D -ENOTCONN;=20
>  goto err;=20
>  diff --git a/net/openvswitch/openvswitch_trace.c b/net/openvswitch/openv=
switch_trace.c=20
>  new file mode 100644=20
>  index 000000000000..62c5f7d6f023=20
>  --- /dev/null=20
>  +++ b/net/openvswitch/openvswitch_trace.c=20
>  @@ -0,0 +1,10 @@=20
>  +// SPDX-License-Identifier: GPL-2.0=20
>  +/* bug in tracepoint.h, it should include this */=20
>  +#include <linux/module.h>=20
>  +=20
>  +/* sparse isn't too happy with all macros... */=20
>  +#ifndef __CHECKER__=20
>  +#define CREATE_TRACE_POINTS=20
>  +#include "openvswitch_trace.h"=20
>  +=20
>  +#endif=20
>  diff --git a/net/openvswitch/openvswitch_trace.h b/net/openvswitch/openv=
switch_trace.h=20
>  new file mode 100644=20
>  index 000000000000..1b350306f622=20
>  --- /dev/null=20
>  +++ b/net/openvswitch/openvswitch_trace.h=20
>  @@ -0,0 +1,152 @@=20
>  +/* SPDX-License-Identifier: GPL-2.0 */=20
>  +#undef TRACE_SYSTEM=20
>  +#define TRACE_SYSTEM openvswitch=20
>  +=20
>  +#if !defined(_TRACE_OPENVSWITCH_H) || defined(TRACE_HEADER_MULTI_READ)=
=20
>  +#define _TRACE_OPENVSWITCH_H=20
>  +=20
>  +#include <linux/tracepoint.h>=20
>  +=20
>  +#include "datapath.h"=20
>  +
>
> I guess the naming of the events can be a long debate :) But I think just=
 adding the word =E2=80=9Cprobe=E2=80=9D doesn=E2=80=99t help much.
>
> Maybe for just for function entry/exit, we could do something like <subsy=
s>_<function_name>_entry/exit. I=E2=80=99ve seen
> this used in other components. For example:
>
> openvswitch_probe_userspace -> openvswitch_ovs_dp_upcall_entry
>
> For none entry/exit trace macros, we could either use a specific name, as=
 we have:
>
> openvswitch_probe_action -> openvswitch_execute_action
>
> Or maybe even prepended by the function name to easily locate it. For exa=
mple:
>
> openvswitch_probe_action -> openvswitch_do_execute_actions__execute_action
>
> I like the double underscore to differentiate, so it might even be nice f=
or the __entry, so
> openvswitch_ovs_dp_upcall__entry.
>
> Maybe we should also change openvswitch to ovs for both system and events=
? Or is this too short and might cause
> confusion?

I agree that we can make these more descriptive, and that 'probe'
doesn't add much.  OTOH, if I use
"openvswitch_do_execute_actions__execute_action" or the corresponding
upcall trace point name, the line lengths balloon.  I don't see that
it's as useful to say both 'do_execute_actions' and '__execute_action' -
I don't think there will ever be a reason to add an additional
tracepoint here since the bulk of processing happens during the action
loop.  But maybe something like:

  'openvswitch_execute_action'

and

  'openvswitch_dp_upcall'

?

Just want to get this part right.

>  +TRACE_EVENT(openvswitch_probe_action,=20
>  +=20
>  + TP_PROTO(struct datapath *dp, struct sk_buff *skb,=20
>  + struct sw_flow_key *key, const struct nlattr *a, int rem),=20
>  +=20
>  + TP_ARGS(dp, skb, key, a, rem),=20
>  +=20
>  + TP_STRUCT__entry(=20
>  + __field( void *, dpaddr )=20
>  + __string( dp_name, ovs_dp_name(dp) )=20
>  + __string( dev_name, skb->dev->name )=20
>  + __field( void *, skbaddr )=20
>  + __field( unsigned int, len )=20
>  + __field( unsigned int, data_len )=20
>  + __field( unsigned int, truesize )=20
>  + __field( u8, nr_frags )=20
>  + __field( u16, gso_size )=20
>  + __field( u16, gso_type )=20
>  + __field( u32, ovs_flow_hash )=20
>  + __field( u32, recirc_id )=20
>  + __field( void *, keyaddr )=20
>  + __field( u16, key_eth_type )=20
>  + __field( u8, key_ct_state )=20
>  + __field( u8, key_ct_orig_proto )=20
>  + __field( unsigned int, flow_key_valid )=20
>  + __field( u8, action_type )=20
>  + __field( unsigned int, action_len )=20
>  + __field( void *, action_data )=20
>  + __field( u8, is_last )=20
>  + ),=20
>  +=20
>  + TP_fast_assign(=20
>  + __entry->dpaddr =3D dp;=20
>  + __assign_str(dp_name, ovs_dp_name(dp));=20
>  + __assign_str(dev_name, skb->dev->name);=20
>  + __entry->skbaddr =3D skb;=20
>  + __entry->len =3D skb->len;=20
>  + __entry->data_len =3D skb->data_len;=20
>  + __entry->truesize =3D skb->truesize;=20
>  + __entry->nr_frags =3D skb_shinfo(skb)->nr_frags;=20
>  + __entry->gso_size =3D skb_shinfo(skb)->gso_size;=20
>  + __entry->gso_type =3D skb_shinfo(skb)->gso_type;=20
>  + __entry->ovs_flow_hash =3D key->ovs_flow_hash;=20
>  + __entry->recirc_id =3D key->recirc_id;=20
>  + __entry->keyaddr =3D key;=20
>  + __entry->key_eth_type =3D key->eth.type;=20
>  + __entry->key_ct_state =3D key->ct_state;=20
>  + __entry->key_ct_orig_proto =3D key->ct_orig_proto;=20
>  + __entry->flow_key_valid =3D !(key->mac_proto & SW_FLOW_KEY_INVALID);=20
>  + __entry->action_type =3D nla_type(a);=20
>  + __entry->action_len =3D nla_len(a);=20
>  + __entry->action_data =3D nla_data(a);=20
>  + __entry->is_last =3D nla_is_last(a, rem);=20
>  + ),=20
>  +=20
>  + TP_printk("dpaddr=3D%p dp_name=3D%s dev=3D%s skbaddr=3D%p len=3D%u dat=
a_len=3D%u truesize=3D%u nr_frags=3D%d
>  gso_size=3D%d gso_type=3D%#x ovs_flow_hash=3D0x%08x recirc_id=3D0x%08x k=
eyaddr=3D%p eth_type=3D0x%04x
>  ct_state=3D%02x ct_orig_proto=3D%02x flow_key_valid=3D%d action_type=3D%=
u action_len=3D%u action_data=3D%p
>  is_last=3D%d",
>
> I guess %p will be good enough here, as I see no other trace modules use =
%px. But I guess, for some of the values
> %*ph might be useful, as it will dump the bytes, i.e., action_data.

The issue with using %*ph for action_data is in the cases where a
netlink attribute doesn't have data.  In that case, we don't have any
bytes to print, and I think the behavior would be undefined (see
ct_clear action, or pop_eth action, etc).

>  + __entry->dpaddr, __get_str(dp_name), __get_str(dev_name),=20
>  + __entry->skbaddr, __entry->len, __entry->data_len,=20
>  + __entry->truesize, __entry->nr_frags, __entry->gso_size,=20
>  + __entry->gso_type, __entry->ovs_flow_hash,=20
>  + __entry->recirc_id, __entry->keyaddr, __entry->key_eth_type,=20
>  + __entry->key_ct_state, __entry->key_ct_orig_proto,=20
>  + __entry->flow_key_valid,=20
>  + __entry->action_type, __entry->action_len,=20
>  + __entry->action_data, __entry->is_last)=20
>  +);=20
>  +=20
>  +TRACE_EVENT(openvswitch_probe_userspace,=20
>  +=20
>  + TP_PROTO(struct datapath *dp, struct sk_buff *skb,=20
>  + struct sw_flow_key *key,=20
>  + const struct dp_upcall_info *upcall_info),=20
>  +=20
>  + TP_ARGS(dp, skb, key, upcall_info),=20
>  +=20
>  + TP_STRUCT__entry(=20
>  + __field( void *, dpaddr )=20
>  + __string( dp_name, ovs_dp_name(dp) )=20
>  + __string( dev_name, skb->dev->name )=20
>  + __field( void *, skbaddr )=20
>  + __field( unsigned int, len )=20
>  + __field( unsigned int, data_len )=20
>  + __field( unsigned int, truesize )=20
>  + __field( u8, nr_frags )=20
>  + __field( u16, gso_size )=20
>  + __field( u16, gso_type )=20
>  + __field( u32, ovs_flow_hash )=20
>  + __field( u32, recirc_id )=20
>  + __field( void *, keyaddr )=20
>  + __field( u16, key_eth_type )=20
>  + __field( u8, key_ct_state )=20
>  + __field( u8, key_ct_orig_proto )=20
>  + __field( unsigned int, flow_key_valid )=20
>  + __field( u8, upcall_cmd )=20
>  + __field( u32, upcall_port )=20
>  + __field( u16, upcall_mru )=20
>  + ),=20
>  +=20
>  + TP_fast_assign(=20
>  + __entry->dpaddr =3D dp;=20
>  + __assign_str(dp_name, ovs_dp_name(dp));=20
>  + __assign_str(dev_name, skb->dev->name);=20
>  + __entry->skbaddr =3D skb;=20
>  + __entry->len =3D skb->len;=20
>  + __entry->data_len =3D skb->data_len;=20
>  + __entry->truesize =3D skb->truesize;=20
>  + __entry->nr_frags =3D skb_shinfo(skb)->nr_frags;=20
>  + __entry->gso_size =3D skb_shinfo(skb)->gso_size;=20
>  + __entry->gso_type =3D skb_shinfo(skb)->gso_type;=20
>  + __entry->ovs_flow_hash =3D key->ovs_flow_hash;=20
>  + __entry->recirc_id =3D key->recirc_id;=20
>  + __entry->keyaddr =3D key;=20
>  + __entry->key_eth_type =3D key->eth.type;=20
>  + __entry->key_ct_state =3D key->ct_state;=20
>  + __entry->key_ct_orig_proto =3D key->ct_orig_proto;=20
>  + __entry->flow_key_valid =3D !(key->mac_proto & SW_FLOW_KEY_INVALID);=20
>  + __entry->upcall_cmd =3D upcall_info->cmd;=20
>  + __entry->upcall_port =3D upcall_info->portid;=20
>  + __entry->upcall_mru =3D upcall_info->mru;=20
>  + ),=20
>  +=20
>  + TP_printk("dpaddr=3D%p dp_name=3D%s dev=3D%s skbaddr=3D%p len=3D%u dat=
a_len=3D%u truesize=3D%u nr_frags=3D%d
>  gso_size=3D%d gso_type=3D%#x ovs_flow_hash=3D0x%08x recirc_id=3D0x%08x k=
eyaddr=3D%p eth_type=3D0x%04x
>  ct_state=3D%02x ct_orig_proto=3D%02x flow_key_valid=3D%d upcall_cmd=3D%u=
 upcall_port=3D%u upcall_mru=3D%u",
>
> See %p comment above.

Same applies.

>  + __entry->dpaddr, __get_str(dp_name), __get_str(dev_name),=20
>  + __entry->skbaddr, __entry->len, __entry->data_len,=20
>  + __entry->truesize, __entry->nr_frags, __entry->gso_size,=20
>  + __entry->gso_type, __entry->ovs_flow_hash,=20
>  + __entry->recirc_id, __entry->keyaddr, __entry->key_eth_type,=20
>  + __entry->key_ct_state, __entry->key_ct_orig_proto,=20
>  + __entry->flow_key_valid,=20
>  + __entry->upcall_cmd, __entry->upcall_port,=20
>  + __entry->upcall_mru)=20
>  +);=20
>  +=20
>  +#endif /* _TRACE_OPENVSWITCH_H */=20
>  +=20
>  +/* This part must be outside protection */=20
>  +#undef TRACE_INCLUDE_PATH=20
>  +#define TRACE_INCLUDE_PATH .=20
>  +#undef TRACE_INCLUDE_FILE=20
>  +#define TRACE_INCLUDE_FILE openvswitch_trace=20
>  +#include <trace/define_trace.h>=20
>  --=20
>  2.31.1

