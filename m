Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DDC339973
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 23:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbhCLWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 17:06:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235456AbhCLWGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 17:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615586771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HDRZ/SjXR3X36N7j7WtxklN4hJ9iSG4HH0dfH6JWHKY=;
        b=OKJUDVxP/MAFvh2IdFG4YzNegKKje1TtBMnAUK+aX0KKlhJq1LIr/VQewNKG/niqlZmwHk
        tiTbZaj8YJXrotloZvHFJID+pLznU25WZrz830WFobl/qIBcuCwYOpKLhV4A4wQhR8UvcH
        wykz9Z5MUQ6JQE6vp3RZU79NfQIJLZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-zeTYqU-iNZGeEutv_-MYbQ-1; Fri, 12 Mar 2021 17:06:07 -0500
X-MC-Unique: zeTYqU-iNZGeEutv_-MYbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4D7519057DC;
        Fri, 12 Mar 2021 22:06:05 +0000 (UTC)
Received: from horizon.localdomain (ovpn-115-153.rdu2.redhat.com [10.10.115.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5D8560CDE;
        Fri, 12 Mar 2021 22:06:04 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id AA64EC0E88; Fri, 12 Mar 2021 19:06:02 -0300 (-03)
Date:   Fri, 12 Mar 2021 19:06:02 -0300
From:   Marcelo Leitner <mleitner@redhat.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Louis Peens <louis.peens@corigine.com>,
        "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>,
        Paul Blakey <paulb@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>, wenxu@ucloud.cn
Subject: Re: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
Message-ID: <YEvlysueK+eiMc1b@horizon.localdomain>
References: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
 <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

On Wed, Mar 10, 2021 at 12:06:52PM +0100, Ilya Maximets wrote:
> Hi, Louis.  Thanks for your report!
> 
> Marcelo, Paul, could you, please, take a look?

Thanks for the ping.
+wenxu

> 
> Best regards, Ilya Maximets.
> 
> On 3/10/21 8:51 AM, Louis Peens wrote:
> > Hi all
> > 
> > We've recently encountered an interesting situation with OVS conntrack
> > when offloading to the TC datapath, and would like some feedback. Sorry
> > about the longish wall of text, but I'm trying to explain the problem
> > as clearly as possible. The very short summary is that there is a mismatch

Details are very welcomed, thanks for them.

> > in behaviour between the OVS datapath and OVS+TC datapath, and we're
> > not sure how to resolve this. Here goes:
> > 
> > We have a set of rules looking like this:
> > ovs-ofctl add-flow br0 "table=0,in_port=p1,ct_state=-trk,ipv6,actions=ct(table=1)"
> > ovs-ofctl add-flow br0 "table=0,in_port=p2,ct_state=-trk,ipv6,actions=ct(table=1)"
> > #post_ct flows"
> > ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+new,ipv6,actions=ct(commit),output:p2"
> > ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+new,ipv6,actions=ct(commit),output:p1"
> > ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+est,ipv6,actions=output:p2"
> > ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+est,ipv6,actions=output:p1"
> > 
> > p1/p2 are the endpoints of two different veth pairs, just to keep this simple.
> > The rules above work well enough with UDP/TCP traffic, however ICMPv6 packets
> > (08:56:39.984375 IP6 2001:db8:0:f101::1 > ff02::1:ff00:2: ICMP6, neighbor solicitation, who has 2001:db8:0:f101::2, length 32)
> > breaks this somewhat. With TC offload disabled:
> > 
> > ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=false
> > 
> > we get the following datapath rules:
> > 
> > ovs-appctl dpctl/dump-flows --names
> > recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:drop
> > recirc_id(0),in_port(p1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:ct,recirc(0x1)
> > 
> > This part is still fine, we do not have a rule for just matching +trk, so the
> > the drop rule is to be expected. The problem however is when we enable TC
> > offload:
> > 
> > ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=true
> > 
> > This is the result in the datapath:
> > 
> > ovs-appctl dpctl/dump-flows --names
> > ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:144, used:0.920s, actions:ct,recirc(0x1)
> > recirc_id(0x1),in_port(p1),ct_state(-new-est-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:1, bytes:86, used:0.928s, actions:drop
> > recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:0, bytes:0, used:never, actions:drop
> > 
> > Notice the installation of the two recirc rules, one with -trk and one with +trk,
> > with the -trk one being the rule that handles all the next packets. Further
> > investigation reveals that something like the following is happening:
> > 
> > 1) The first packet arrives and is handled by the OVS datapath,

Hmm. This shouldn't happen if hw-offload=true, because the first rule
should be installed on tc datapath already. Or maybe you mean OVS
vswitchd when you referred to OVS datapath?

What does  dpctl/dump-flows --names -m  gives in this situation, are
all flows installed on dp:tc?

> >    triggering the installation of the two rules like in the non-offloaded
> >    case. So the recirc_id(0) rule gets installed into tc, and recirc_id(0x1)
> >    gets installed into the ovs datapath. This bit of code in the OVS module
> >    makes sure that +trk is set.
> > 
> >     /* Update 'key' based on skb->_nfct.  If 'post_ct' is true, then OVS has
> >      * previously sent the packet to conntrack via the ct action.....
> >      * /
> >    static void ovs_ct_update_key(const struct sk_buff *skb,
> >                               const struct ovs_conntrack_info *info,
> >                               struct sw_flow_key *key, bool post_ct,
> >                               bool keep_nat_flags)
> >     {
> >             ...
> >             ct = nf_ct_get(skb, &ctinfo);
> >             if (ct) {//tracked
> >                     ...
> >             } else if (post_ct) {
> >                     state = OVS_CS_F_TRACKED | OVS_CS_F_INVALID;
> >                     if (info)
> >                             zone = &info->zone;
> >             }
> >             __ovs_ct_update_key(key, state, zone, ct);
> > 
> >     }
> >     Obviously this is not the case when the packet was sent to conntrack
> >     via tc.
> > 
> > 2) The second packet arrives, and now hits the rule installed in
> >    TC. However, TC does not handle ICMPv6 (Neighbor Solicitation), and explicitely
> >    clears the tracked bit (net/netfilter/nf_conntrack_proto_icmpv6.c):
> > 
> >     int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
> >                                   struct sk_buff *skb,
> >                                   unsigned int dataoff,
> >                                   const struct nf_hook_state *state)
> > 
> >     {
> >     ...
> >             type = icmp6h->icmp6_type - 130;
> >             if (type >= 0 && type < sizeof(noct_valid_new) &&
> >                 noct_valid_new[type]) {
> >                     nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
> >                     return NF_ACCEPT;
> >             }
> >     ...
> >     }
> >     (The above code gets triggered a few function calls down from act_ct.c)

I don't follow this part, and it seems it would affect ovs kernel
dp as well. Can you please elaborate on the call chain you're focusing
here?

> > 
> > 3) So now the packet does not hit the +trk rule after the recirc, and leads
> >    to the installation of the "recirc_id(0x1),..-trk" rule, since +trk wasn't
> >    set by TC.

If you meant vswitchd above, this can be the problem, yes.
ovs_ct_update_key() is updating the key, and AFAICT that's reflected
on the upcall. Which, then, it's fair to assume (I didn't check)
vswitchd does the same.

But for tc, +trk+inv is synthetsized when tc is trying to match again
on this packet, when skb_flow_dissect_ct() in it will:

       if (!ct) {
               key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
                               TCA_FLOWER_KEY_CT_FLAGS_INVALID;
               return;
       }

Note that 'key' here is not part of the packet in any way. The only
information that is stored within the packet, is
qdisc_skb_cb(skb)->post_ct, which ovs kernel doesn't know about. So
this wouldn't be reflected on an upcall, causing vswitchd to not see
these flags.

IOW, an upcall right after this flow:
ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), actions:ct,recirc(0x1)
can be different if it's from tc datapath or ovs kernel/vswitchd
regarding these flags in this case.

Makes sense? I think we're mostly on the same page on this part,
actually.

Thanks,
Marcelo

> > 
> > This is now the point where we're a bit stuck and is hoping for some ideas
> > on how to best resolve this. A workaround is of course just to modify the
> > userspace rules to not send the icmp packets to conntrack and that should
> > work, but it is a workaround. I think this inconsistency between TC
> > offload and non-TC is quite undesirable, and could lead to some interesting
> > results, for instance this was first detected by the observation of packets
> > getting stuck in a loop in the datapath:
> > 
> > recirc_id(0xe),...ct_state(0/0x20),....,in_port(eth9),eth_type(0x86dd),... ,dp:tc, actions:ct,recirc(0xe)
> > 
> > Where the userspace rule was doing ct to the same table instead of moving to the next table:
> > 
> > ovs-ofctl add-flow br0 "table=0,in_port=eth9,ct_state=-trk,ipv6,actions=ct(table=0)"
> > 
> > So far we've not managed to think of a good way to resolve this in the code.
> > I don't think changing the kernel behaviour would be desirable, at least
> > not in that specific function as that is common conntrack code. I suspect
> > that ideally this is something we can try and address from the OVS side,
> > but at this moment I have no idea how this will be achieved, hence this
> > email.
> > 
> > Looking forward to get some suggestions on this
> > 
> > Regards
> > Louis Peens
> > 
> > PS: Tested on:
> > net-next kernel:
> >     d310ec03a34e Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> > OVS:
> >     "cdaa7e0fd dpif-netdev: Fix crash when add dp flow without in_port field."
> >         +
> >     "[ovs-dev] [PATCH v3 0/3] Add offload support for ct_state rpl and inv flags"
> >     (The behaviour before and after the patch series in terms of the problem
> >      above is the same. Whether the recirc rules end up in the ovs datapath or tc
> >      datapath doesn't really matter)
> > _______________________________________________
> > dev mailing list
> > dev@openvswitch.org
> > https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> > 
> 

