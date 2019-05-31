Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC66316E1
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfEaWBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfEaWBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 18:01:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B26619FFF6;
        Fri, 31 May 2019 22:01:24 +0000 (UTC)
Received: from ovpn-204-40.brq.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC605C7B3;
        Fri, 31 May 2019 22:01:22 +0000 (UTC)
Message-ID: <e2e02404af5aea5663877db8f9d2e23501e818b8.camel@redhat.com>
Subject: Re: [PATCH net v3 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
In-Reply-To: <CAM_iQpW68XR3Y6gyb0zyd3qooCwPHBM1Fm+THcS=migSNsHMzA@mail.gmail.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
         <a773fd1d70707d03861be674f7692a0148f6bb40.1559322531.git.dcaratti@redhat.com>
         <CAM_iQpW68XR3Y6gyb0zyd3qooCwPHBM1Fm+THcS=migSNsHMzA@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Sat, 01 Jun 2019 00:01:20 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 31 May 2019 22:01:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 11:38 -0700, Cong Wang wrote:
> On Fri, May 31, 2019 at 10:26 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
> > index 14bb525e355e..e8308ddcae9d 100644
> > --- a/net/sched/act_csum.c
> > +++ b/net/sched/act_csum.c
> > @@ -574,7 +574,6 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
> >                         struct tcf_result *res)
> >  {
> >         struct tcf_csum *p = to_tcf_csum(a);
> > -       bool orig_vlan_tag_present = false;
> >         unsigned int vlan_hdr_count = 0;
> >         struct tcf_csum_params *params;
> >         u32 update_flags;
> > @@ -604,17 +603,8 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
> >                 break;
> >         case cpu_to_be16(ETH_P_8021AD): /* fall through */
> >         case cpu_to_be16(ETH_P_8021Q):
> > -               if (skb_vlan_tag_present(skb) && !orig_vlan_tag_present) {
> > -                       protocol = skb->protocol;
> > -                       orig_vlan_tag_present = true;
> > -               } else {
> > -                       struct vlan_hdr *vlan = (struct vlan_hdr *)skb->data;
> > -
> > -                       protocol = vlan->h_vlan_encapsulated_proto;
> > -                       skb_pull(skb, VLAN_HLEN);
> > -                       skb_reset_network_header(skb);
> > -                       vlan_hdr_count++;
> > -               }
> > +               if (tc_skb_pull_vlans(skb, &vlan_hdr_count, &protocol))
> > +                       goto drop;
> >                 goto again;

Please note: this loop was here also before this patch (the 'goto again;'
line is only patch context). It has been introduced with commit
2ecba2d1e45b ("net: sched: act_csum: Fix csum calc for tagged packets").

> Why do you still need to loop here? tc_skb_pull_vlans() already
> contains a loop to pop all vlan tags?

The reason why the loop is here is:
1) in case there is a stripped vlan tag, it replaces tc_skb_protocol(skb)
with the inner ethertype (i.e. skb->protocol)

2) in case there is one or more unstripped VLAN tags, it pulls them. At
the last iteration, when it does:

goto again;

'protocol' contains the innermost ethertype, read from
'h_vlan_encapsulated_proto'. 

If that value is 0x0800 (IPv4) or 0x86dd (IPv6), 'act_csum' will go on
computing the internet checksum for the IPv4 header or for (some of the)
IPv6 'nexthdrs'.

(yes, we could move the call to tc_skb_pull_vlans() before the switch
statement to make this code more understandable, also in the other 2
actions. Please let me know if you think it's better).  

> 
> >         }
> > 
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > index d4699156974a..382ee69fb1a5 100644
> > --- a/net/sched/cls_api.c
> > +++ b/net/sched/cls_api.c
> > @@ -3300,6 +3300,28 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
> >  }
> >  EXPORT_SYMBOL(tcf_exts_num_actions);
> > 
> > +int tc_skb_pull_vlans(struct sk_buff *skb, unsigned int *hdr_count,
> > +                     __be16 *proto)
> 
> It looks like this function fits better in net/core/skbuff.c, because
> I don't see anything TC specific.

Ok, I don't know if other parts of the kernel really need it. Its use
should be combined with tc_skb_protocol(), which is in pkt_sched.h.

But i can move it to skbuff, or elsewhwere, unless somebody disagrees.

> 
> > +{
> > +       if (skb_vlan_tag_present(skb))
> > +               *proto = skb->protocol;
> > +
> > +       while (eth_type_vlan(*proto)) {
> > +               struct vlan_hdr *vlan;
> > +
> > +               if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
> > +                       return -ENOMEM;
> > +
> > +               vlan = (struct vlan_hdr *)skb->data;
> > +               *proto = vlan->h_vlan_encapsulated_proto;
> > +               skb_pull(skb, VLAN_HLEN);
> > +               skb_reset_network_header(skb);

Again, this code was in act_csum.c also before. The only intention of this
patch is to ensure that pskb_may_pull() is called before skb_pull(), as
per Eric suggestion, and move this code out of act_csum to use it with
other TC actions.

> Any reason not to call __skb_vlan_pop() directly?

I think we can't use __skb_vlan_pop(), because 'act_csum' needs to read
the innermost ethertype in the packet to understand if it's IPv4, IPv6 or
else (ARP, EAPOL, ...).

If I well read __skb_vlan_pop(), it returns the VLAN ID, which is useless
here. 

> 
> > +               (*hdr_count)++;
> > +       }
> > +       return 0;
> > +}
> 
> Thanks.

Thanks for reviewing, looking forward to read more comments from you!

