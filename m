Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1625540C2EB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhIOJrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:47:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:50992 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237103AbhIOJrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 05:47:00 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mQRU1-0000qI-Dy; Wed, 15 Sep 2021 11:45:37 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mQRU1-000FGT-4P; Wed, 15 Sep 2021 11:45:37 +0200
Subject: Re: [PATCH nf-next v4 4/5] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <cover.1611304190.git.lukas@wunner.de>
 <979835dc887d3affc4e76464aa21da0e298fd638.1611304190.git.lukas@wunner.de>
 <4b36df57-ee60-78da-cc6a-fb443226c978@iogearbox.net>
 <20210911212650.GA17551@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <11584665-e3b5-3afe-d72c-ef92ad0b9313@iogearbox.net>
Date:   Wed, 15 Sep 2021 11:45:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210911212650.GA17551@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26295/Wed Sep 15 10:22:57 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On 9/11/21 11:26 PM, Lukas Wunner wrote:
> On Tue, Jan 26, 2021 at 08:13:19PM +0100, Daniel Borkmann wrote:
>> On 1/22/21 9:47 AM, Lukas Wunner wrote:
[...]
>> Wrt above objection, what needs to be done for the minimum case is to
>> i) fix the asymmetry problem from here, and
>> ii) add a flag for tc layer-redirected skbs to skip the nf egress hook *;
>> with that in place this concern should be resolved. Thanks!
> 
> Daniel, your reply above has left me utterly confused.  After thinking
> about it for a while, I'm requesting clarification what you really want.
> We do want the netfilter egress hook in mainline and we're happy to
> accommodate to your requirements, but we need you to specify them clearly.
> 
> Regarding the data path for packets which are going out from a container,
> I think you've erroneously mixed up the last two elements above:
> If the nf egress hook is placed after tc egress (as is done in the present
> patch), the data path is actually as follows:
> 
>    [tc egress (veth,podns)] -> [tc ingress (veth,hostns)] ->
>    [tc egress (phys,hostns)] -> [nf egress (phys,hostns)*]
> 
> By contrast, if nf egress is put in front of tc egress (as you're
> requesting above), the data path becomes:
> 
>    [nf egress (veth,podns)] -> [tc egress (veth,podns)] ->
>    [tc ingress (veth,hostns)] ->
>    [nf egress (phys,hostns)*] -> [tc egress (phys,hostns)]
> 
> So this order results in an *additional* nf egress hook in the data path,
> which may cost performance.  Previously you voiced concerns that the
> nf egress hook may degrade performance.  To address that concern,
> we ordered nf egress *after* tc egress, thereby avoiding any performance
> impact as much as possible.
> 
> I agree with your argument that an inverse order vis-a-vis ingress is
> more logical because it avoids NAT incongruencies etc.  So I'll be happy
> to reorder nf egress before tc egress.  I'm just confused that you're now
> requesting an order which may be *more* detrimental to performance.

Right, the issue is that placing it either in front or after the existing tc
egress hook just as-is results in layering violations given both tc/nf subsystems
will inevitably step on each other when both dataplanes are used by different
components where things break. To provide a walk-through on what I think would
work w/o breaking layers:

1) Packet going up hostns stack. Here, we'll end up with:

    [tc ingress (phys,hostns)] -> [nf ingress (phys,hostns)] ->
      upper stack ->
        [nf egress (phys,hostns)] -> [tc egress (phys,hostns)]

2) Packet going up podns stack. Here, if the forwarding happens entirely in tc
    layer, then the datapath (as-is today) operates _below_ nf and must look like:

    [tc ingress (phys,hostns)] -> [tc egress (veth,hostns)] ->
      netns switch -> (*) -> netns switch ->
        [tc ingress (veth,hostns)] -> [tc egress (phys,hostns)]

    For simplicity, I left out (*), but it's essentially the same as case 1)
    just for the Pod's/container's stack PoV.

3) Packet is locally forwarded between Pods. Same as 2) for the case where the
    forwarding happens entirely in tc (as-is today) which operates _below_ nf and
    must look like:

    (+) -> [tc ingress (veth,hostns)] -> [tc egress (veth,hostns)] ->
      netns switch -> (*) -> netns switch ->
        [tc ingress (veth,hostns)] -> [tc egress (veth,hostns)] -> (+)

    The (+) denotes the src/sink where we enter/exit the hostns after netns switch.

The skb bit marker would be that tc [& BPF]-related redirect functions are internally
setting that bit, so that nf egress hook is skipped for cases like 2)/3).

Walking through a similar 1/2/3) scenario from nf side one layer higher if you were
to do an equivalent, things would look like:

1) Packet going up hostns stack. Same as above:

    [tc ingress (phys,hostns)] -> [nf ingress (phys,hostns)] ->
      upper stack ->
        [nf egress (phys,hostns)] -> [tc egress (phys,hostns)]

2) Packet going up podns stack with forwarding from nf side:

    [tc ingress (phys,hostns)] -> [nf ingress (phys,hostns)] ->
      [nf egress (veth,hostns)] -> [tc egress (veth,hostns)] ->
        netns switch -> (*) -> netns switch ->
          [tc ingress (veth,hostns)] -> [nf ingress (veth,hostns)] ->
            [nf egress (phys,hostns)] -> [tc egress (phys,hostns)]

3) Packet is locally forwarded between Pods with forwarding from nf side:

    (+) -> [tc ingress (veth,hostns)] -> [nf ingress (veth,hostns)] ->
      [nf egress (veth,hostns)] -> [tc egress (veth,hostns)] ->
        netns switch -> (*) -> netns switch ->
          [tc ingress (veth,hostns)] -> [nf ingress (veth,hostns)] ->
            [nf egress (veth,hostns)] -> [tc egress (veth,hostns)] -> (+)

Thanks,
Daniel
