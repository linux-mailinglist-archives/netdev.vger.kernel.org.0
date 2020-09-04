Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A118125E336
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgIDVOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:14:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:49688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbgIDVOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:14:53 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kEJ2c-0001b0-J3; Fri, 04 Sep 2020 23:14:38 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kEJ2c-000Gd0-AJ; Fri, 04 Sep 2020 23:14:38 +0200
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
Date:   Fri, 4 Sep 2020 23:14:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200904162154.GA24295@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25920/Fri Sep  4 15:46:46 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 6:21 PM, Lukas Wunner wrote:
> On Wed, Sep 02, 2020 at 10:00:32PM -0700, John Fastabend wrote:
>> Lukas Wunner wrote:
[...]
>> Do you have plans to address the performance degradation? Otherwise
>> if I was building some new components its unclear why we would
>> choose the slower option over the tc hook. The two suggested
>> use cases security policy and DSR sound like new features, any
>> reason to not just use existing infrastructure?
>>
>> Is the use case primarily legacy things already running in
>> nft infrastructure? I guess if you have code running now
>> moving it to this hook is faster and even if its 10% slower
>> than it could be that may be better than a rewrite?
> 
> nft and tc are orthogonal, i.e. filtering/mangling versus queueing.
> However tc has gained the ability to filter packets as well, hence
> there's some overlap in functionality.  Naturally tc does not allow
> the full glory of nft filtering/mangling options as Laura has stated,
> hence the need to add nft in the egress path.

Heh, really!? It sounds to me that you never looked serious enough into what
tc/BPF is actually doing. Please check your facts before making any such claim
since it's false.

Lets do a reality check for your original motivation of adding this hook and
see whether that matches your claim ... quote [0]:

   The module I need this for is out-of-tree:

   https://github.com/RevolutionPi/piControl/commit/da199ccd2099

   In my experience the argument that a feature is needed for an out-of-tree
   module holds zero value upstream.  If there's no in-tree user, the feature
   isn't merged, I've seen this more than enough.  Which is why I didn't mention
   it in the first place.

So in essence what you had in that commit is:

   static unsigned int revpi_gate_nf_hook(void *priv, struct sk_buff *skb,
				         const struct nf_hook_state *state)
   {
	u16 eth_proto = ntohs(eth_hdr(skb)->h_proto);

	return likely(eth_proto == ETH_P_KUNBUSGW) ? NF_ACCEPT : NF_DROP;
   }

   static const struct nf_hook_ops revpi_gate_nf_hook_ops = {
	.hook	  = revpi_gate_nf_hook,
	.pf	  = NFPROTO_NETDEV,
	.hooknum  = NF_NETDEV_EGRESS,
	.priority = INT_MAX,
   };

Its trivial to achieve with tc/BPF on the existing egress hook today. Probably
takes less time than to write up this mail ...

root@x:~/x# cat foo.c

#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <arpa/inet.h>

#ifndef __section
# define __section(NAME)		\
    __attribute__((section(NAME), used))
#endif

#define ETH_P_KUNBUSGW	0x419C

#define PASS	0
#define DROP	2

int foo(struct __sk_buff *skb)
{
	void *data_end = (void *)(long)skb->data_end;
	void *data = (void *)(long)skb->data;
	struct ethhdr *eth = data;

	if (data + sizeof(*eth) > data_end)
		return DROP;

	return eth->h_proto == htons(ETH_P_KUNBUSGW) ? PASS : DROP;
}

char __license[] __section("license") = "";

root@x:~/x# clang -target bpf -Wall -O2 -c foo.c -o foo.o
root@x:~/x# ip link add dev foo type dummy
root@x:~/x# ip link set up dev foo
root@x:~/x# tc qdisc add dev foo clsact
root@x:~/x# tc filter add dev foo egress bpf da obj foo.o sec .text

There we go, attached to the device on existing egress. Double checking it
does what we want:

root@x:~/x# cat foo.t
{
    0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
    0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0xbb,
    0x41, 0x9c
}
root@x:~/x# trafgen -i foo.t -o foo -n 1 -q
root@x:~/x# tcpdump -i foo
[...]
22:43:42.981112 bb:bb:bb:bb:bb:bb (oui Unknown) > aa:aa:aa:aa:aa:aa (oui Unknown), ethertype Unknown (0x419c), length 14:

root@x:~/x# cat bar.t
{
    0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
    0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0xbb,
    0xee, 0xee
}
root@x:~/x# trafgen -i bar.t -o foo -n 1 -q
root@x:~/x# tcpdump -i foo
[... nothing/filtered ...]

Done, and this is exactly intended for exotic stuff like this. It also mangles packets
and whatnot, I guess I don't need to list all of this here (catching up on docs is
easy enough). The tc queueing layer which is below is not the tc egress hook; the
latter is for filtering/mangling/forwarding or helping the lower tc queueing layer to
classify.

Now given you've stated that you're not mentioning your out of tree stuff in the
commit message in the first place, you bring up "This allows filtering locally
generated traffic such as DHCP, or outbound AF_PACKETs in general. It will also
allow introducing in-kernel NAT64 and NAT46."

I haven't seen any NAT64/NAT46 in this set and I guess it's some sort of future
work (fwiw, you can also already do this today with tc/BPF), and filtering AF_PACKET
is currently broken with your approach as elaborated earlier so needs another hook...
also slow-path DHCP filtering should rather be moved into AF_PACKET itself. Why paying
the performance hit going into the nft interpreter for this hook for *every* other
*unrelated* packet in the fast-path... the case is rather if distros start adding DHCP
filtering rules by default there as per your main motivation then everyone needs to
pay this price, which is completely unreasonable to perform in __dev_queue_xmit().

Thanks,
Daniel

   [0] https://lore.kernel.org/netdev/20191123142305.g2kkaudhhyui22fq@wunner.de/
