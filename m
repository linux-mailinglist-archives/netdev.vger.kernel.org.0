Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DB41272A2
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLTBGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:06:11 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:52615 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfLTBGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:06:11 -0500
X-Originating-IP: 209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
        (Authenticated sender: pshelar@ovn.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 23E5320007;
        Fri, 20 Dec 2019 01:06:07 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id v12so5022825vsv.5;
        Thu, 19 Dec 2019 17:06:07 -0800 (PST)
X-Gm-Message-State: APjAAAWLf8zDhUE4M3HDckqbNsLjAMB55AeOP5FOPCE/anwOP9VUGkVK
        MRFBCrVuxg3jSJLTMUeYOOI+NEQsinBE4QBTLgU=
X-Google-Smtp-Source: APXvYqzdAdOolKAsiA39U4G+O/Wg9/TOx9O5RpmRYAxyWgnx+q7PQmxCFZSk/izM5zYNJt5TXfdAN/d0EOrILv6HigA=
X-Received: by 2002:a67:d007:: with SMTP id r7mr6912927vsi.93.1576803966767;
 Thu, 19 Dec 2019 17:06:06 -0800 (PST)
MIME-Version: 1.0
References: <20191217155102.46039-1-mcroce@redhat.com> <CAOrHB_BVf8mXuCUehMy0_Sbq=pgfg7Zu1ivPFT8Y9Zatdj1yPw@mail.gmail.com>
 <CAGnkfhyojPg9ZxrR=NcNdsndxZpdpjgArzO+HHsVWnCKTBg1Tg@mail.gmail.com>
In-Reply-To: <CAGnkfhyojPg9ZxrR=NcNdsndxZpdpjgArzO+HHsVWnCKTBg1Tg@mail.gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 19 Dec 2019 17:05:55 -0800
X-Gmail-Original-Message-ID: <CAOrHB_BnE=pZY-ciAA-vWw0fY0T-u-BCCQyhqNZYK+MOC1C5pA@mail.gmail.com>
Message-ID: <CAOrHB_BnE=pZY-ciAA-vWw0fY0T-u-BCCQyhqNZYK+MOC1C5pA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] openvswitch: add TTL decrement action
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Ben Pfaff <blp@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 8:36 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Wed, Dec 18, 2019 at 4:06 AM Pravin Shelar <pshelar@ovn.org> wrote:
> >
> > On Tue, Dec 17, 2019 at 7:51 AM Matteo Croce <mcroce@redhat.com> wrote:
> > >
> > > New action to decrement TTL instead of setting it to a fixed value.
> > > This action will decrement the TTL and, in case of expired TTL, drop it
> > > or execute an action passed via a nested attribute.
> > > The default TTL expired action is to drop the packet.
> > >
> > > Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> > >
> > > Tested with a corresponding change in the userspace:
> > >
> > >     # ovs-dpctl dump-flows
> > >     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,1
> > >     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,2
> > >     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
> > >     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
> > >
> > >     # ping -c1 192.168.0.2 -t 42
> > >     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
> > >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
> > >     # ping -c1 192.168.0.2 -t 120
> > >     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
> > >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
> > >     # ping -c1 192.168.0.2 -t 1
> > >     #
> > >
> > > Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
> > > Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > ---
> > >  include/uapi/linux/openvswitch.h |  22 +++++++
> > >  net/openvswitch/actions.c        |  71 +++++++++++++++++++++
> > >  net/openvswitch/flow_netlink.c   | 105 +++++++++++++++++++++++++++++++
> > >  3 files changed, 198 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > > index a87b44cd5590..b6684bc04883 100644
> > > --- a/include/uapi/linux/openvswitch.h
> > > +++ b/include/uapi/linux/openvswitch.h
> > > @@ -927,6 +927,7 @@ enum ovs_action_attr {
> > >         OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
> > >         OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
> > >         OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
> > > +       OVS_ACTION_ATTR_DEC_TTL,       /* Nested OVS_DEC_TTL_ATTR_*. */
> > >
> > >         __OVS_ACTION_ATTR_MAX,        /* Nothing past this will be accepted
> > >                                        * from userspace. */
> > > @@ -939,6 +940,23 @@ enum ovs_action_attr {
> > >  };
> > >
> > >  #define OVS_ACTION_ATTR_MAX (__OVS_ACTION_ATTR_MAX - 1)
> > > +enum ovs_dec_ttl_attr {
> > > +       OVS_DEC_TTL_ATTR_UNSPEC,
> > > +       OVS_DEC_TTL_ATTR_ACTION_TYPE,    /* Action Type u32 */
> > > +       OVS_DEC_TTL_ATTR_ACTION,         /* nested action */
> > > +       __OVS_DEC_TTL_ATTR_MAX,
> > > +#ifdef __KERNEL__
> > > +       OVS_DEC_TTL_ATTR_ARG          /* struct sample_arg  */
> > > +#endif
> > > +};
> > > +
> >
> > I do not see need for type or OVS_DEC_TTL_ACTION_DROP, if there are no
> > nested action the datapath can drop the packet.
> >
> > > +#ifdef __KERNEL__
> > > +struct dec_ttl_arg {
> > > +       u32 action_type;            /* dec_ttl action type.*/
> > > +};
> > > +#endif
> > > +
> > > +#define OVS_DEC_TTL_ATTR_MAX (__OVS_DEC_TTL_ATTR_MAX - 1)
> > >
> > >  /* Meters. */
> > >  #define OVS_METER_FAMILY  "ovs_meter"
> > > @@ -1009,6 +1027,10 @@ enum ovs_ct_limit_attr {
> > >         __OVS_CT_LIMIT_ATTR_MAX
> > >  };
> > >
> > > +enum ovs_dec_ttl_action {            /*Actions supported by dec_ttl */
> > > +       OVS_DEC_TTL_ACTION_DROP,
> > > +       OVS_DEC_TTL_ACTION_USER_SPACE
> > > +};
> > >  #define OVS_CT_LIMIT_ATTR_MAX (__OVS_CT_LIMIT_ATTR_MAX - 1)
> > >
> > >  #define OVS_ZONE_LIMIT_DEFAULT_ZONE -1
> > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > index 4c8395462303..5329668732b1 100644
> > > --- a/net/openvswitch/actions.c
> > > +++ b/net/openvswitch/actions.c
> > > @@ -960,6 +960,31 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
> > >         return ovs_dp_upcall(dp, skb, key, &upcall, cutlen);
> > >  }
> > >
> > > +static int dec_ttl(struct datapath *dp, struct sk_buff *skb,
> > > +                  struct sw_flow_key *fk, const struct nlattr *attr, bool last)
> > > +{
> > > +       struct nlattr *actions;
> > > +       struct nlattr *dec_ttl_arg;
> > > +       int rem = nla_len(attr);
> > > +       const struct dec_ttl_arg *arg;
> > > +
> > > +       /* The first action is always OVS_DEC_TTL_ATTR_ARG. */
> > > +       dec_ttl_arg = nla_data(attr);
> > > +       arg = nla_data(dec_ttl_arg);
> > > +       actions = nla_next(dec_ttl_arg, &rem);
> > > +
> > > +       switch (arg->action_type) {
> > > +       case OVS_DEC_TTL_ACTION_DROP:
> > > +               consume_skb(skb);
> > > +               break;
> > > +
> > > +       case OVS_DEC_TTL_ACTION_USER_SPACE:
> > > +               return clone_execute(dp, skb, fk, 0, actions, rem, last, false);
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  /* When 'last' is true, sample() should always consume the 'skb'.
> > >   * Otherwise, sample() should keep 'skb' intact regardless what
> > >   * actions are executed within sample().
> > > @@ -1176,6 +1201,44 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
> > >                              nla_len(actions), last, clone_flow_key);
> > >  }
> > >
> > > +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
> > > +{
> > > +       int err;
> > > +
> > > +       if (skb->protocol == htons(ETH_P_IPV6)) {
> > > +               struct ipv6hdr *nh = ipv6_hdr(skb);
> > > +
> > > +               err = skb_ensure_writable(skb, skb_network_offset(skb) +
> > > +                                         sizeof(*nh));
> > There is no need to initialize 'nh', just use 'struct ipv6hdr' to get the size.
>
> But I have to set it later to have nh->hop_limit.
> Do you mean to assign it before the skb_ensure_writable check?
> What differs sizeof(*nh) and sizeof(struct ipv6hdr)? The former will
> work also after a refactor.
>
I meant you can initialize it after skb_ensure_writable() call to
avoid refreshing the pointer after this call.
