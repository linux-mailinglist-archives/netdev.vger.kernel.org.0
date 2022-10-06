Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1CD5F705B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 23:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiJFV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 17:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiJFV3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 17:29:03 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB87CBA26A;
        Thu,  6 Oct 2022 14:29:02 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogYQO-000EAq-W0; Thu, 06 Oct 2022 23:29:01 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogYQO-000NRW-Lu; Thu, 06 Oct 2022 23:29:00 +0200
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
Date:   Thu, 6 Oct 2022 23:29:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26681/Thu Oct  6 09:58:02 2022)
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 7:00 AM, Alexei Starovoitov wrote:
> On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
[...]
> 
> I cannot help but feel that prio logic copy-paste from old tc, netfilter and friends
> is done because "that's how things were done in the past".
> imo it was a well intentioned mistake and all networking things (tc, netfilter, etc)
> copy-pasted that cumbersome and hard to use concept.
> Let's throw away that baggage?
> In good set of cases the bpf prog inserter cares whether the prog is first or not.
> Since the first prog returning anything but TC_NEXT will be final.
> I think prog insertion flags: 'I want to run first' vs 'I don't care about order'
> is good enough in practice. Any complex scheme should probably be programmable
> as any policy should. For example in Meta we have 'xdp chainer' logic that is similar
> to libxdp chaining, but we added a feature that allows a prog to jump over another
> prog and continue the chain. Priority concept cannot express that.
> Since we'd have to add some "policy program" anyway for use cases like this
> let's keep things as simple as possible?
> Then maybe we can adopt this "as-simple-as-possible" to XDP hooks ?
> And allow bpf progs chaining in the kernel with "run_me_first" vs "run_me_anywhere"
> in both tcx and xdp ?
> Naturally "run_me_first" prog will be the only one. No need for F_REPLACE flags, etc.
> The owner of "run_me_first" will update its prog through bpf_link_update.
> "run_me_anywhere" will add to the end of the chain.
> In XDP for compatibility reasons "run_me_first" will be the default.
> Since only one prog can be enqueued with such flag it will match existing single prog behavior.
> Well behaving progs will use (like xdp-tcpdump or monitoring progs) will use "run_me_anywhere".
> I know it's far from covering plenty of cases that we've discussed for long time,
> but prio concept isn't really covering them either.
> We've struggled enough with single xdp prog, so certainly not advocating for that.
> Another alternative is to do: "queue_at_head" vs "queue_at_tail". Just as simple.
> Both simple versions have their pros and cons and don't cover everything,
> but imo both are better than prio.

Yeah, it's kind of tricky, imho. The 'run_me_first' vs 'run_me_anywhere' are two
use cases that should be covered (and actually we kind of do this in this set, too,
with the prios via prio=x vs prio=0). Given users will only be consuming the APIs
via libs like libbpf, this can also be abstracted this way w/o users having to be
aware of prios. Anyway, where it gets tricky would be when things depend on ordering,
e.g. you have BPF progs doing: policy, monitoring, lb, monitoring, encryption, which
would be sth you can build today via tc BPF: so policy one acts as a prefilter for
various cidr ranges that should be blocked no matter what, then monitoring to sample
what goes into the lb, then lb itself which does snat/dnat, then monitoring to see what
the corresponding pkt looks that goes to backend, and maybe encryption to e.g. send
the result to wireguard dev, so it's encrypted from lb node to backend. For such
example, you'd need prios as the 'run_me_anywhere' doesn't guarantee order, so there's
a case for both scenarios (concrete layout vs loose one), and for latter we could
start off with and internal prio around x (e.g. 16k), so there's room to attach in
front via fixed prio, but also append to end for 'don't care', and that could be
from lib pov the default/main API whereas prio would be some kind of extended one.
Thoughts?

Thanks,
Daniel
