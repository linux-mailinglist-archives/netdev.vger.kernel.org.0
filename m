Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE613AD556
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhFRWor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:44:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:52446 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhFRWop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 18:44:45 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1luNC2-0003Ln-Uh; Sat, 19 Jun 2021 00:42:31 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1luNC2-000J0n-Ii; Sat, 19 Jun 2021 00:42:30 +0200
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo>
 <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
 <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net>
 <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
 <20210616153209.pejkgb3iieu6idqq@apollo>
 <05ec2836-7f0d-0393-e916-fd578d8f14ac@iogearbox.net>
 <f038645a-cb8a-dc59-e57e-2544a259bab1@mojatatu.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3e9bf85b-60a4-d5d2-0267-85bb76974339@iogearbox.net>
Date:   Sat, 19 Jun 2021 00:42:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f038645a-cb8a-dc59-e57e-2544a259bab1@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26205/Fri Jun 18 13:18:00 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/21 1:40 PM, Jamal Hadi Salim wrote:
> On 2021-06-16 12:00 p.m., Daniel Borkmann wrote:
>> On 6/16/21 5:32 PM, Kumar Kartikeya Dwivedi wrote:
>>> On Wed, Jun 16, 2021 at 08:10:55PM IST, Jamal Hadi Salim wrote:
>>>> On 2021-06-15 7:07 p.m., Daniel Borkmann wrote:
>>>>> On 6/13/21 11:10 PM, Jamal Hadi Salim wrote:
> 
> [..]
> 
>>>> In particular, here's a list from Kartikeya's implementation:
>>>>
>>>> 1) Direct action mode only
>>
>> (More below.)
>>
>>>> 2) Protocol ETH_P_ALL only
>>
>> The issue I see with this one is that it's not very valuable or useful from a BPF
>> point of view. Meaning, this kind of check can and typically is implemented from
>> BPF program anyway. For example, when you have direct packet access initially
>> parsing the eth header anyway (and from there having logic for the various eth
>> protos).
> 
> In that case make it optional to specify proto and default it to
> ETH_P_ALL. As far as i can see this flexibility doesnt
> complicate usability or add code complexity to the interfaces.

 From a user interface PoV it's odd since you need to go and parse that anyway, at
least the programs typically start out with a switch/case on either reading the
skb->protocol or getting it via eth->h_proto. But then once you extend that same
program to also cover IPv6, you don't need to do anything with the ETH_P_ALL
from the loader application, but now you'd also need to additionally remember to
downgrade ETH_P_IP to ETH_P_ALL and rebuild the loader to get v6 traffic. But even
if you were to split things in the main/entry program to separate v4/v6 processing
into two different ones, I expect this to be faster via tail calls (given direct
absolute jump) instead of walking a list of tcf_proto objects, comparing the
tp->protocol and going into a different cls_bpf instance.

[...]>> Could you elaborate on that or provide code examples? Since introduction of the
>> direct action mode I've never used anything else again, and we do have complex
>> BPF code blocks that we need to handle as well. Would be good if you could provide
>> more details on things you ran into, maybe they can be solved?
> 
> Main issue is code complexity in ebpf and not so much instruction
> count (which is complicated once you have bounded loops).
> Earlier, I tried to post on the ebpf list but i got no response.
> I moved on since. I would like to engage you at some point - and
> you are right there may be some clever tricks to achieve the goals
> we had. The challenge is in keeping up with the bag of tricks to make
> the verifier happy.
> Being able to run non-da mode and for example attach an action such
> as the policer (and others) has pragmatic uses. It would be quiet complex to implement the policer within an all-in-one-appliance
> da-mode ebpf code.

It may be more tricky but not impossible either, in recent years some (imho) very
interesting and exciting use cases have been implemented and talked about e.g. [0-2],
and with the recent linker work there could also be a [e.g. in-kernel] collection with
library code that can be pulled in by others aside from using them as BPF selftests
as one option. The gain you have with the flexibility [as you know] is that it allows
easy integration/orchestration into user space applications and thus suitable for
more dynamic envs as with old-style actions. The issue I have with the latter is
that they're not scalable enough from a SW datapath / tc fast-path perspective given
you then need to fallback to old-style list processing of cls+act combinations which
is also not covered / in scope for the libbpf API in terms of their setup, and
additionally not all of the BPF features can be used this way either, so it'll be very
hard for users to debug why their BPF programs don't work as they're expected to.

But also aside from those blockers, the case with this clean slate tc BPF API is that
we have a unique chance to overcome the cmdline usability struggles, and make it as
straight forward as possible for new generation of users.

   [0] https://linuxplumbersconf.org/event/7/contributions/677/
   [1] https://linuxplumbersconf.org/event/2/contributions/121/
   [2] https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF

Thanks,
Daniel
