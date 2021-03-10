Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2262A333B09
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhCJLHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:07:04 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54387 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhCJLG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:06:56 -0500
X-Originating-IP: 78.45.89.65
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 9539860010;
        Wed, 10 Mar 2021 11:06:53 +0000 (UTC)
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>, i.maximets@ovn.org
Subject: Re: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
To:     Louis Peens <louis.peens@corigine.com>,
        "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>,
        Marcelo Leitner <mleitner@redhat.com>,
        Paul Blakey <paulb@nvidia.com>
References: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
Date:   Wed, 10 Mar 2021 12:06:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Louis.  Thanks for your report!

Marcelo, Paul, could you, please, take a look?

Best regards, Ilya Maximets.

On 3/10/21 8:51 AM, Louis Peens wrote:
> Hi all
> 
> We've recently encountered an interesting situation with OVS conntrack
> when offloading to the TC datapath, and would like some feedback. Sorry
> about the longish wall of text, but I'm trying to explain the problem
> as clearly as possible. The very short summary is that there is a mismatch
> in behaviour between the OVS datapath and OVS+TC datapath, and we're
> not sure how to resolve this. Here goes:
> 
> We have a set of rules looking like this:
> ovs-ofctl add-flow br0 "table=0,in_port=p1,ct_state=-trk,ipv6,actions=ct(table=1)"
> ovs-ofctl add-flow br0 "table=0,in_port=p2,ct_state=-trk,ipv6,actions=ct(table=1)"
> #post_ct flows"
> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+new,ipv6,actions=ct(commit),output:p2"
> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+new,ipv6,actions=ct(commit),output:p1"
> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+est,ipv6,actions=output:p2"
> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+est,ipv6,actions=output:p1"
> 
> p1/p2 are the endpoints of two different veth pairs, just to keep this simple.
> The rules above work well enough with UDP/TCP traffic, however ICMPv6 packets
> (08:56:39.984375 IP6 2001:db8:0:f101::1 > ff02::1:ff00:2: ICMP6, neighbor solicitation, who has 2001:db8:0:f101::2, length 32)
> breaks this somewhat. With TC offload disabled:
> 
> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=false
> 
> we get the following datapath rules:
> 
> ovs-appctl dpctl/dump-flows --names
> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:drop
> recirc_id(0),in_port(p1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:ct,recirc(0x1)
> 
> This part is still fine, we do not have a rule for just matching +trk, so the
> the drop rule is to be expected. The problem however is when we enable TC
> offload:
> 
> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=true
> 
> This is the result in the datapath:
> 
> ovs-appctl dpctl/dump-flows --names
> ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:144, used:0.920s, actions:ct,recirc(0x1)
> recirc_id(0x1),in_port(p1),ct_state(-new-est-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:1, bytes:86, used:0.928s, actions:drop
> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:0, bytes:0, used:never, actions:drop
> 
> Notice the installation of the two recirc rules, one with -trk and one with +trk,
> with the -trk one being the rule that handles all the next packets. Further
> investigation reveals that something like the following is happening:
> 
> 1) The first packet arrives and is handled by the OVS datapath,
>    triggering the installation of the two rules like in the non-offloaded
>    case. So the recirc_id(0) rule gets installed into tc, and recirc_id(0x1)
>    gets installed into the ovs datapath. This bit of code in the OVS module
>    makes sure that +trk is set.
> 
>     /* Update 'key' based on skb->_nfct.  If 'post_ct' is true, then OVS has
>      * previously sent the packet to conntrack via the ct action.....
>      * /
>    static void ovs_ct_update_key(const struct sk_buff *skb,
>                               const struct ovs_conntrack_info *info,
>                               struct sw_flow_key *key, bool post_ct,
>                               bool keep_nat_flags)
>     {
>             ...
>             ct = nf_ct_get(skb, &ctinfo);
>             if (ct) {//tracked
>                     ...
>             } else if (post_ct) {
>                     state = OVS_CS_F_TRACKED | OVS_CS_F_INVALID;
>                     if (info)
>                             zone = &info->zone;
>             }
>             __ovs_ct_update_key(key, state, zone, ct);
> 
>     }
>     Obviously this is not the case when the packet was sent to conntrack
>     via tc.
> 
> 2) The second packet arrives, and now hits the rule installed in
>    TC. However, TC does not handle ICMPv6 (Neighbor Solicitation), and explicitely
>    clears the tracked bit (net/netfilter/nf_conntrack_proto_icmpv6.c):
> 
>     int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
>                                   struct sk_buff *skb,
>                                   unsigned int dataoff,
>                                   const struct nf_hook_state *state)
> 
>     {
>     ...
>             type = icmp6h->icmp6_type - 130;
>             if (type >= 0 && type < sizeof(noct_valid_new) &&
>                 noct_valid_new[type]) {
>                     nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>                     return NF_ACCEPT;
>             }
>     ...
>     }
>     (The above code gets triggered a few function calls down from act_ct.c)
> 
> 3) So now the packet does not hit the +trk rule after the recirc, and leads
>    to the installation of the "recirc_id(0x1),..-trk" rule, since +trk wasn't
>    set by TC.
> 
> This is now the point where we're a bit stuck and is hoping for some ideas
> on how to best resolve this. A workaround is of course just to modify the
> userspace rules to not send the icmp packets to conntrack and that should
> work, but it is a workaround. I think this inconsistency between TC
> offload and non-TC is quite undesirable, and could lead to some interesting
> results, for instance this was first detected by the observation of packets
> getting stuck in a loop in the datapath:
> 
> recirc_id(0xe),...ct_state(0/0x20),....,in_port(eth9),eth_type(0x86dd),... ,dp:tc, actions:ct,recirc(0xe)
> 
> Where the userspace rule was doing ct to the same table instead of moving to the next table:
> 
> ovs-ofctl add-flow br0 "table=0,in_port=eth9,ct_state=-trk,ipv6,actions=ct(table=0)"
> 
> So far we've not managed to think of a good way to resolve this in the code.
> I don't think changing the kernel behaviour would be desirable, at least
> not in that specific function as that is common conntrack code. I suspect
> that ideally this is something we can try and address from the OVS side,
> but at this moment I have no idea how this will be achieved, hence this
> email.
> 
> Looking forward to get some suggestions on this
> 
> Regards
> Louis Peens
> 
> PS: Tested on:
> net-next kernel:
>     d310ec03a34e Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> OVS:
>     "cdaa7e0fd dpif-netdev: Fix crash when add dp flow without in_port field."
>         +
>     "[ovs-dev] [PATCH v3 0/3] Add offload support for ct_state rpl and inv flags"
>     (The behaviour before and after the patch series in terms of the problem
>      above is the same. Whether the recirc rules end up in the ovs datapath or tc
>      datapath doesn't really matter)
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 

