Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9464021B90C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 17:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGJPCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 11:02:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:49596 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGJPCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 11:02:37 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtuXr-0006PL-Io; Fri, 10 Jul 2020 17:02:35 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtuXr-000N9r-7x; Fri, 10 Jul 2020 17:02:35 +0200
Subject: Re: [PATCHv6 bpf-next 0/3] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <7c80ca4b-4c7d-0322-9483-f6f0465d6370@iogearbox.net>
 <20200710073652.GC2531@dhcp-12-153.nay.redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9a04393c-f924-5aaf-4644-d7f33350004f@iogearbox.net>
Date:   Fri, 10 Jul 2020 17:02:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200710073652.GC2531@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25869/Fri Jul 10 16:01:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 9:36 AM, Hangbin Liu wrote:
> On Fri, Jul 10, 2020 at 12:37:59AM +0200, Daniel Borkmann wrote:
>> On 7/9/20 3:30 AM, Hangbin Liu wrote:
>>> This patch is for xdp multicast support. which has been discussed before[0],
>>> The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
>>> a software switch that can forward XDP frames to multiple ports.
>>>
>>> To achieve this, an application needs to specify a group of interfaces
>>> to forward a packet to. It is also common to want to exclude one or more
>>> physical interfaces from the forwarding operation - e.g., to forward a
>>> packet to all interfaces in the multicast group except the interface it
>>> arrived on. While this could be done simply by adding more groups, this
>>> quickly leads to a combinatorial explosion in the number of groups an
>>> application has to maintain.
>>>
>>> To avoid the combinatorial explosion, we propose to include the ability
>>> to specify an "exclude group" as part of the forwarding operation. This
>>> needs to be a group (instead of just a single port index), because a
>>> physical interface can be part of a logical grouping, such as a bond
>>> device.
>>>
>>> Thus, the logical forwarding operation becomes a "set difference"
>>> operation, i.e. "forward to all ports in group A that are not also in
>>> group B". This series implements such an operation using device maps to
>>> represent the groups. This means that the XDP program specifies two
>>> device maps, one containing the list of netdevs to redirect to, and the
>>> other containing the exclude list.
>>
>> Could you move this description as part of patch 1/3 instead of cover
>> letter? Mostly given this helps understanding the rationale wrt exclusion
>> map which is otherwise lacking from just looking at the patch itself.
> 
> OK, I will
> 
>> Assuming you have a bond, how does this look in practice for your mentioned
>> ovs-like data plane in XDP? The map for 'group A' is shared among all XDP
>> progs and the map for 'group B' is managed per prog? The BPF_F_EXCLUDE_INGRESS
> 
> Yes, kind of. Since we have two maps as parameter. The 'group A map'(include map)
> will be shared between the interfaces in same group/vlan. The 'group B map'
> (exclude map) is interface specific. Each interface will hold it's own exclude map.
> 
> As most time each interface only exclude itself, a null map + BPF_F_EXCLUDE_INGRESS
> should be enough.
> 
> For bond situation. e.g. A active-backup bond0 with eth1 + eth2 as slaves.
> If eth1 is active interface, we can add eth2 to the exclude map.

Right, but what about the other direction where one device forwards to a bond,
presumably eth1 + eth2 are in the include map and shared also between other
ifaces? Given the logic for the bond mode is on bond0, so one layer higher, how
do you determine which of eth1 + eth2 to send to in the BPF prog? Daemon listening
for link events via arp or mii monitor and then update include map? Ideally would
be nice to have some sort of a bond0 pass-through for the XDP buffer so it ends
up eventually at one of the two through the native logic, e.g. what do you do when
it's configured in xor mode or when slave dev is selected via hash or some other
user logic (e.g. via team driver); how would this be modeled via inclusion map? I
guess the issue can be regarded independently to this set, but given you mention
explicitly bond here as a use case for the exclusion map, I was wondering how you
solve the inclusion one for bond devices for your data plane?

>> is clear, but how would this look wrt forwarding from a phys dev /to/ the
>> bond iface w/ XDP?
> 
> As bond interface doesn't support native XDP, This forwarding only works for
> physical slave interfaces.
> 
> For generic xdp, maybe we can forward to bond interface directly, but I
> haven't tried.
> 
>> Also, what about tc BPF helper support for the case where not every device
>> might have native XDP (but they could still share the maps)?
> 
> I haven't tried tc BPF. This helper works for both generic and native xdp
> forwarding. I think it should also works if we load the prog with native
> xdp mode in one interface and generic xdp mode in another interface, couldn't
> we?

Yes, that would work though generic XDP comes with its own set of issues, but
presumably this sort of traffic could be considered slow-path anyway.

Thanks,
Daniel
