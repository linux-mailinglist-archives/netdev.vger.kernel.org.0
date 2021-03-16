Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2F933CE4E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 08:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCPHA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 03:00:58 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:47366 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhCPHAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 03:00:43 -0400
Received: from [192.168.188.110] (unknown [106.75.220.2])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 94FDEE02427;
        Tue, 16 Mar 2021 15:00:38 +0800 (CST)
Subject: Re: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
To:     Louis Peens <louis.peens@corigine.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>,
        Paul Blakey <paulb@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
References: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
 <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
 <YEvlysueK+eiMc1b@horizon.localdomain>
 <58820355-7337-d51b-32dd-be944600832d@corigine.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <fc269566-9652-ed80-cea4-016c069fa104@ucloud.cn>
Date:   Tue, 16 Mar 2021 15:00:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <58820355-7337-d51b-32dd-be944600832d@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGUkdTE5NT04fSxpDVkpNSk5DTENLSEJOTElVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0JITVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NUk6Vhw5MD08DywCHRUYCkoI
        Li1PCSNVSlVKTUpOQ0xDS0hCQ0NPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFKT0NMTzcG
X-HM-Tid: 0a7839d627ba20bdkuqy94fdee02427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/2021 11:29 PM, Louis Peens wrote:
> Hi Marcelo
>
> Thanks for taking time to take a look. I've replied inline - and also found
> a bit more info, although I'm not sure if it clears things up much. I do think
> that the main problem is the different upcall behaviour, I have not figured
> out what to do about it yet.
>
> On 2021/03/13 00:06, Marcelo Leitner wrote:
>> Hi there,
>>
>> On Wed, Mar 10, 2021 at 12:06:52PM +0100, Ilya Maximets wrote:
>>> Hi, Louis.  Thanks for your report!
>>>
>>> Marcelo, Paul, could you, please, take a look?
>> Thanks for the ping.
>> +wenxu
>>
>>> Best regards, Ilya Maximets.
>>>
>>> On 3/10/21 8:51 AM, Louis Peens wrote:
>>>> Hi all
>>>>
>>>> We've recently encountered an interesting situation with OVS conntrack
>>>> when offloading to the TC datapath, and would like some feedback. Sorry
>>>> about the longish wall of text, but I'm trying to explain the problem
>>>> as clearly as possible. The very short summary is that there is a mismatch
>> Details are very welcomed, thanks for them.
>>
>>>> in behaviour between the OVS datapath and OVS+TC datapath, and we're
>>>> not sure how to resolve this. Here goes:
>>>>
>>>> We have a set of rules looking like this:
>>>> ovs-ofctl add-flow br0 "table=0,in_port=p1,ct_state=-trk,ipv6,actions=ct(table=1)"
>>>> ovs-ofctl add-flow br0 "table=0,in_port=p2,ct_state=-trk,ipv6,actions=ct(table=1)"
>>>> #post_ct flows"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+new,ipv6,actions=ct(commit),output:p2"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+new,ipv6,actions=ct(commit),output:p1"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+est,ipv6,actions=output:p2"
>>>> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+est,ipv6,actions=output:p1"
>>>>
>>>> p1/p2 are the endpoints of two different veth pairs, just to keep this simple.
>>>> The rules above work well enough with UDP/TCP traffic, however ICMPv6 packets
>>>> (08:56:39.984375 IP6 2001:db8:0:f101::1 > ff02::1:ff00:2: ICMP6, neighbor solicitation, who has 2001:db8:0:f101::2, length 32)
>>>> breaks this somewhat. With TC offload disabled:
>>>>
>>>> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=false
>>>>
>>>> we get the following datapath rules:
>>>>
>>>> ovs-appctl dpctl/dump-flows --names
>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:drop
>>>> recirc_id(0),in_port(p1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:ct,recirc(0x1)
>>>>
>>>> This part is still fine, we do not have a rule for just matching +trk, so the
>>>> the drop rule is to be expected. The problem however is when we enable TC
>>>> offload:
>>>>
>>>> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=true
>>>>
>>>> This is the result in the datapath:
>>>>
>>>> ovs-appctl dpctl/dump-flows --names
>>>> ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:144, used:0.920s, actions:ct,recirc(0x1)
>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:1, bytes:86, used:0.928s, actions:drop
>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:0, bytes:0, used:never, actions:drop
>>>>
>>>> Notice the installation of the two recirc rules, one with -trk and one with +trk,
>>>> with the -trk one being the rule that handles all the next packets. Further
>>>> investigation reveals that something like the following is happening:
>>>>
>>>> 1) The first packet arrives and is handled by the OVS datapath,
>> Hmm. This shouldn't happen if hw-offload=true, because the first rule
>> should be installed on tc datapath already. Or maybe you mean OVS
>> vswitchd when you referred to OVS datapath?
>>
>> What does  dpctl/dump-flows --names -m  gives in this situation, are
>> all flows installed on dp:tc?
>
> Yes, packet would be handled by vswitchd here, triggering the installation of datapath
> flow rules. I think I may have mixed up packet handling and flow rule installation a bit.
> These are the expanded flows:
> ovs-appctl dpctl/dump-flows --more
> ufid:65c93f06-9f09-4b62-b309-951c36d3d98a, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:2.080s, dp:tc, actions:ct,recirc(0x1)
> ufid:30fd8977-0bcc-41b1-8800-1262cea71005, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
> ufid:c176bac4-a42d-4e8b-99d9-bce386c1be4f, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
>
> The pre-recirc rule is in tc, but the post-recirc rules are in OVS.
>
>> triggering the installation of the two rules like in the non-offloaded
>>>>     case. So the recirc_id(0) rule gets installed into tc, and recirc_id(0x1)
>>>>     gets installed into the ovs datapath. This bit of code in the OVS module
>>>>     makes sure that +trk is set.
>>>>
>>>>      /* Update 'key' based on skb->_nfct.  If 'post_ct' is true, then OVS has
>>>>       * previously sent the packet to conntrack via the ct action.....
>>>>       * /
>>>>     static void ovs_ct_update_key(const struct sk_buff *skb,
>>>>                                const struct ovs_conntrack_info *info,
>>>>                                struct sw_flow_key *key, bool post_ct,
>>>>                                bool keep_nat_flags)
>>>>      {
>>>>              ...
>>>>              ct = nf_ct_get(skb, &ctinfo);
>>>>              if (ct) {//tracked
>>>>                      ...
>>>>              } else if (post_ct) {
>>>>                      state = OVS_CS_F_TRACKED | OVS_CS_F_INVALID;
>>>>                      if (info)
>>>>                              zone = &info->zone;
>>>>              }
>>>>              __ovs_ct_update_key(key, state, zone, ct);
>>>>
>>>>      }
>>>>      Obviously this is not the case when the packet was sent to conntrack
>>>>      via tc.
>>>>
>>>> 2) The second packet arrives, and now hits the rule installed in
>>>>     TC. However, TC does not handle ICMPv6 (Neighbor Solicitation), and explicitely
>>>>     clears the tracked bit (net/netfilter/nf_conntrack_proto_icmpv6.c):
>>>>
>>>>      int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
>>>>                                    struct sk_buff *skb,
>>>>                                    unsigned int dataoff,
>>>>                                    const struct nf_hook_state *state)
>>>>
>>>>      {
>>>>      ...
>>>>              type = icmp6h->icmp6_type - 130;
>>>>              if (type >= 0 && type < sizeof(noct_valid_new) &&
>>>>                  noct_valid_new[type]) {
>>>>                      nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>>>>                      return NF_ACCEPT;
>>>>              }
>>>>      ...
>>>>      }
>>>>      (The above code gets triggered a few function calls down from act_ct.c)
>> I don't follow this part, and it seems it would affect ovs kernel
>> dp as well. Can you please elaborate on the call chain you're focusing
>> here?
> The chain I was referring to is:
> tcf_ct_act->nf_conntrack_in->nf_conntrack_handle_icmp->nf_conntrack_icmpv6_error
> However I'm not so sure anymore that this is relevant, and yes, would probably affect
> ovs as well.
>>>> 3) So now the packet does not hit the +trk rule after the recirc, and leads
>>>>     to the installation of the "recirc_id(0x1),..-trk" rule, since +trk wasn't
>>>>     set by TC.
>> If you meant vswitchd above, this can be the problem, yes.
>> ovs_ct_update_key() is updating the key, and AFAICT that's reflected
>> on the upcall. Which, then, it's fair to assume (I didn't check)
>> vswitchd does the same.
>>
>> But for tc, +trk+inv is synthetsized when tc is trying to match again
>> on this packet, when skb_flow_dissect_ct() in it will:
>>
>>         if (!ct) {
>>                 key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
>>                                 TCA_FLOWER_KEY_CT_FLAGS_INVALID;
>>                 return;
>>         }
>>
>> Note that 'key' here is not part of the packet in any way. The only
>> information that is stored within the packet, is
>> qdisc_skb_cb(skb)->post_ct, which ovs kernel doesn't know about. So
>> this wouldn't be reflected on an upcall, causing vswitchd to not see
>> these flags.
>>
>> IOW, an upcall right after this flow:
>> ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), actions:ct,recirc(0x1)
>> can be different if it's from tc datapath or ovs kernel/vswitchd
>> regarding these flags in this case.
>>
>> Makes sense? I think we're mostly on the same page on this part,
>> actually.
> I think this is what it boils down to in the end yes. I did do some bisecting of the kernel tree in the mean time:
> Just before "7baf2429a1a9 net/sched: cls_flower add CT_FLAGS_INVALID flag support" all the rules end up in
> in dp:tc, but we have have -trk and +trk as explained. Then after the commit does look to be working as expected,
> rules get's installed in tc, and only +trk set:
> ovs-appctl dpctl/dump-flows --more
> ufid:e476d5a2-3133-405c-9826-ab911c2c3240, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.890s, dp:tc, actions:ct,recirc(0x2)
> ufid:b8369209-3069-4280-9914-820d98a3a536, skb_priority(0/0),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0x2),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.890s, dp:tc, actions:drop
>
> Then things go south again with this commit:
> "1bcc51ac0731 net/sched: cls_flower: Reject invalid ct_state flags rules"
> This is the point where the recirc rule is rejected by tc, and leads to the installation
> of the two ovs rules as in the dump at the start of the email.


I think there are some problem in the commit 1bcc51ac0731, The dp flow

with est and new in the mask, This flow will be reject by in the fl_validate_ct_state.

We will fix it.  This validate should not only based on flags in the mask.


And in this case the dp flow does't contain inv flags?

What about the detail dp flows for tc-offload=false case?



>
> Also, not everything is good at this commit:
> "7baf2429a1a9 net/sched: cls_flower add CT_FLAGS_INVALID flag support"
> If I add userspace rules to also match on +inv so that it isn't wildcarded I
> (with the ovs patches for tc +inv support removed) I get the same two-recirc-rule
> behaviour. I do think that it matches the current theory on the upcall behaviour.
> We will keep on digging on our side as well, this did give some more avenues
> of thought, thanks.
>
You means the ovs with userspace flow +inv? And the dp flow doesn't contain the inv flags?

Or the flow not be hit anymore?



BR

wenxu



