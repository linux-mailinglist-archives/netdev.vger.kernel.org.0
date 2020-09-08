Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC32615D1
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbgIHQ4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731807AbgIHQWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:22:41 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23F0C0611E1;
        Tue,  8 Sep 2020 06:33:35 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFd9t-0003Q5-MN; Tue, 08 Sep 2020 14:55:37 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFd9t-000LSc-Cs; Tue, 08 Sep 2020 14:55:37 +0200
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
Date:   Tue, 8 Sep 2020 14:55:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200905052403.GA10306@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25923/Mon Sep  7 15:37:02 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On 9/5/20 7:24 AM, Lukas Wunner wrote:
> On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
>> On 9/4/20 6:21 PM, Lukas Wunner wrote:
[...]
>> The tc queueing layer which is below is not the tc egress hook; the
>> latter is for filtering/mangling/forwarding or helping the lower tc
>> queueing layer to classify.
> 
> People want to apply netfilter rules on egress, so either we need an
> egress hook in the xmit path or we'd have to teach tc to filter and
> mangle based on netfilter rules.  The former seemed more straight-forward
> to me but I'm happy to pursue other directions.

I would strongly prefer something where nf integrates into existing tc hook,
not only due to the hook reuse which would be better, but also to allow for a
more flexible interaction between tc/BPF use cases and nf, to name one
example... consider two different entities in the system setting up the two, that
is, one adding rules for nf ingress/egress on the phys device for host fw and
the other one for routing traffic into/from containers at the tc layer,
then traffic going into host ns will hit nf ingress and on egress side the
nf egress part; however, traffic going to containers via existing tc redirect
will not see the nf ingress as expected but would on reverse path incorrectly
hit the nf egress one which is /not/ the case for dev_queue_xmit() today. So
there would need to be more flexible coordination between the two so these
subsystems don't step on each other and the orchestration system can flexibly
arrange those needs depending on the use case. Conceptually the tc/nf
ingress/egress hook would be the same anyway in the sense that we have
some sort of a list or array with callbacks performing actions on the skb,
passing on, dropping or forwarding, so this should be consolidated where
both can register into an array of callbacks as processing pipeline that
can be atomically swapped at runtime, and then similar as with tc or LSMs
allow to delegate or terminate the processing in a generic way.

[...]
>> the case is rather if distros start adding DHCP
>> filtering rules by default there as per your main motivation then
>> everyone needs to pay this price, which is completely unreasonable
>> to perform in __dev_queue_xmit().
> 
> So first you're saying that the patches are unnecessary and everything
> they do can be achieved with tc... and then you're saying distros are
> going to use the nft hook to filter DHCP by default, which will cost
> performance.  That seems contradictory.  Why aren't distros using tc
> today to filter DHCP?

Again, I'm not sure why you ask me, you guys brought up lack of DHCP filtering
as why this hook is needed. My gut feeling why it is not there today, because the
use case was not strong enough to do it on nf or tc layer that anyone cared to fix
it over the last few decades (!). And if you check a typical DHCP client that is
present on major modern distros like systemd-networkd's DHCP client then they
already implement filtering of malicious packets via BPF at socket layer including
checking for cookies in the DHCP header that are set by the application itself to
prevent spoofing [0].

Thanks,
Daniel

   [0] https://github.com/systemd/systemd/blob/master/src/libsystemd-network/dhcp-network.c#L28
