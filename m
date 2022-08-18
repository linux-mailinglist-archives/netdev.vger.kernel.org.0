Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2785981F3
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbiHRLHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244275AbiHRLHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:07:04 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC01A0617
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:07:02 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id C2602E0007;
        Thu, 18 Aug 2022 11:06:53 +0000 (UTC)
Message-ID: <f18e2734-ddf6-fbbc-d2ac-a2acb65fd073@ovn.org>
Date:   Thu, 18 Aug 2022 13:06:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Cc:     i.maximets@ovn.org, dev@openvswitch.org, brauner@kernel.org,
        edumazet@google.com, avagin@google.com,
        alexander.mikhalitsyn@virtuozzo.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, ptikhomirov@virtuozzo.com,
        Aaron Conole <aconole@redhat.com>
Content-Language: en-US
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
References: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
 <38c9c698-6304-dfa8-7b79-a1cb1e00860b@ovn.org>
 <bc6f197b-37a5-89ea-1311-16f93b5cefed@virtuozzo.com>
 <495de273-9679-5186-3d6c-41f44e9280e4@ovn.org>
 <7365e0a6-a82b-c92a-137e-f28111a9c148@virtuozzo.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next 0/1] openvswitch: allow specifying
 ifindex of new interfaces
In-Reply-To: <7365e0a6-a82b-c92a-137e-f28111a9c148@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 01:11, Andrey Zhadchenko wrote:
> 
> 
> On 8/18/22 01:15, Ilya Maximets wrote:
>> On 8/17/22 22:35, Andrey Zhadchenko wrote:
>>>
>>>
>>> On 8/17/22 21:19, Ilya Maximets wrote:
>>>> On 8/17/22 14:49, Andrey Zhadchenko via dev wrote:
>>>>> Hi!
>>>>>
>>>>> CRIU currently do not support checkpoint/restore of OVS configurations, but
>>>>> there was several requests for it. For example,
>>>>> https://github.com/lxc/lxc/issues/2909
>>>>>
>>>>> The main problem is ifindexes of newly created interfaces. We realy need to
>>>>> preserve them after restore. Current openvswitch API does not allow to
>>>>> specify ifindex. Most of the time we can just create an interface via
>>>>> generic netlink requests and plug it into ovs but datapaths (generally any
>>>>> OVS_VPORT_TYPE_INTERNAL) can only be created via openvswitch requests which
>>>>> do not support selecting ifindex.
>>>>
>>>> Hmm.  Assuming you restored network interfaces by re-creating them
>>>> on a target system, but I'm curious how do you restore the upcall PID?
>>>> Are you somehow re-creating the netlink socket with the same PID?
>>>> If that will not be done, no traffic will be able to flow through OVS
>>>> anyway until you remove/re-add the port in userspace or re-start OVS.
>>>> Or am I missing something?
>>>>
>>>> Best regards, Ilya Maximets.
>>>
>>> Yes, CRIU is able to restore socket nl_pid. We get it via NDIAG_PROTO_ALL
>>> netlink protocol requests (see net/netlink/diag.c)  Upcall pid is exported
>>> by get requests via OVS_VPORT_ATTR_UPCALL_PID.
>>> So everything is fine here.
>>
>> I didn't dig deep into how that works, but sounds interesting.
>> Thanks for the pointers!
>>
>>>
>>> I should note that I did not test *complicated* setups with ovs-vswitchd,
>>> mostly basic ones like veth plugging and several containers in network. We
>>> mainly supported Weave Net k8s SDN  which is based on ovs but do not use its
>>> daemon.
>>>
>>> Maybe if this is merged and people start use this we will find more problems
>>> with checkpoint/restore, but for now the only problem is volatile ifindex.
>>
>> Current implementation even with ifindexes sorted out will not work for
>> at least one reason for recent versions of OVS.  Since last year OVS doesn't
>> use OVS_VPORT_ATTR_UPCALL_PID if kernel supports OVS_DP_ATTR_PER_CPU_PIDS
>> instead.  It's a datapath-wide CPU ID to PID mapping for per-CPU upcall
>> dispatch mode.  It is used by default starting with OVS 2.16. >
>> So, you need to make sure you're correctly restoring 'user_features' and
>> the OVS_DP_ATTR_PER_CPU_PIDS.  Problem here is that OVS_DP_ATTR_PER_CPU_PIDS
>> currently not dumped to userpsace via GET request, simply because ovs-vswitchd
>> has no use for it.  So, you'll need to add that as well.
> Thanks, this is very important! I will make v2 soon.
> 
>>
>> And there could be some issues when starting OVS from a checkpoint created
>> on a system with different number of CPU cores.  Traffic will not be broken,
>> but performance may be affected, and there might be some kernel warnings.
> Migrating to another type of CPU is a challenge usually due to different CPUID
> and some other problems (do we handle cpu cgroup values if ncpus changed? no
> idea honestly). Anyway thanks for pointing that out.

TBH, it is a challenge to just figure out CPU IDs on a system you're running at,
migration to a different CPU topology will be indeed a major pain if you want to
preserve performance characteristics on a new setup.  It's probably much easier
to re-start ovs-vswitchd after you migrated the kernel bits.  Though it doesn't
seem like something that CRIU would like to do and I understand that.  Current
ovs-vswitchd will not react to sudden changes in CPU topology/affinity.  Reacting
to changes in CPU affinity though is something we're exploring, because it can
happen in k8s-like environments with different performance monitoring/tweaking
tools involved.

Regarding more "complex" scenarios, I should also mention qdisc's that OVS creates
and attaches to interfaces it manages.  These could be for the purpose of QoS,
ingress policing or offloading to TC flower.  OVS may be confused if these
qdisc's will suddenly disappear.  This may cause some traffic to stop flowing
or be directed to where it shouldn't be.  Don't know if CRIU covers that part.

There are also basic XDP programs that could be attached to interfaces along with
registered umem blocks if users are running userspace datapath with AF_XDP ports.
Is AF_XDP sockets or io_uring something that CRIU is able to migrate?  Just curious.

>> If you won't restore OVS_DP_ATTR_PER_CPU_PIDS, traffic will not work on
>> recent versions of OVS, including 2.17 LTS, on more or less recent kernels.
>>
>> Another fairly recent addition is OVS_DP_ATTR_MASKS_CACHE_SIZE, which is
>> not critical, but would be nice to restore as well, if you're not doing
>> that already.
> Looks like ovs_dp_cmd_fill_info() already fills it so no need to additionally
> patch kernel part. Current CRIU implementation does not care about it, but it
> is not hard to include.
> 
>>
>>>
>>> Best regards, Andrey Zhadchenko
>>>>
>>>>>
>>>>> This patch allows to do so.
>>>>> For new datapaths I decided to use dp_infindex in header as infindex
>>>>> because it control ifindex for other requests too.
>>>>> For internal vports I reused OVS_VPORT_ATTR_IFINDEX.
>>>>>
>>>>> The only concern I have is that previously dp_ifindex was not used for
>>>>> OVS_DP_VMD_NEW requests and some software may not set it to zero. However
>>>>> we have been running this patch at Virtuozzo for 2 years and have not
>>>>> encountered this problem. Not sure if it is worth to add new
>>>>> ovs_datapath_attr instead.
>>>>>
>>>>>
>>>>> As a broader solution, another generic approach is possible: modify
>>>>> __dev_change_net_namespace() to allow changing ifindexes within the same
>>>>> netns. Yet we will still need to ignore NETIF_F_NETNS_LOCAL and I am not
>>>>> sure that all its users are ready for ifindex change.
>>>>> This will be indeed better for CRIU so we won't need to change every SDN
>>>>> module to be able to checkpoint/restore it. And probably avoid some bloat.
>>>>> What do you think of this?
>>>>>
>>>>> Andrey Zhadchenko (1):
>>>>>     openvswitch: allow specifying ifindex of new interfaces
>>>>>
>>>>>    include/uapi/linux/openvswitch.h     |  4 ++++
>>>>>    net/openvswitch/datapath.c           | 16 ++++++++++++++--
>>>>>    net/openvswitch/vport-internal_dev.c |  1 +
>>>>>    net/openvswitch/vport.h              |  2 ++
>>>>>    4 files changed, 21 insertions(+), 2 deletions(-)
>>>>>
>>>>
>>

