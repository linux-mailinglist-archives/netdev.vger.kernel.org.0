Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54E7270718
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIRUbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgIRUbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:31:25 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19EFC0613CE;
        Fri, 18 Sep 2020 13:31:24 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kJN2G-0000yb-0R; Fri, 18 Sep 2020 22:31:12 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kJN2F-000HJ5-Mb; Fri, 18 Sep 2020 22:31:11 +0200
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     =?UTF-8?Q?Laura_Garc=c3=ada_Li=c3=a9bana?= <nevola@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
 <CAF90-Wiof1aut-KoA=uA-T=UGmUpQvZx_ckwY7KnBbYB8Y3+PA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b0989f93-e708-4a68-1622-ab3de629be77@iogearbox.net>
Date:   Fri, 18 Sep 2020 22:31:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAF90-Wiof1aut-KoA=uA-T=UGmUpQvZx_ckwY7KnBbYB8Y3+PA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25932/Fri Sep 18 15:48:08 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 12:28 PM, Laura García Liébana wrote:
> On Tue, Sep 15, 2020 at 12:02 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 9/14/20 1:29 PM, Laura García Liébana wrote:
>>> On Fri, Sep 11, 2020 at 6:28 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 9/11/20 9:42 AM, Laura García Liébana wrote:
>>>>> On Tue, Sep 8, 2020 at 2:55 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>>> On 9/5/20 7:24 AM, Lukas Wunner wrote:
>>>>>>> On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
>>>>>>>> On 9/4/20 6:21 PM, Lukas Wunner wrote:
>>>>>> [...]
>>>>>>>> The tc queueing layer which is below is not the tc egress hook; the
>>>>>>>> latter is for filtering/mangling/forwarding or helping the lower tc
>>>>>>>> queueing layer to classify.
>>>>>>>
>>>>>>> People want to apply netfilter rules on egress, so either we need an
>>>>>>> egress hook in the xmit path or we'd have to teach tc to filter and
>>>>>>> mangle based on netfilter rules.  The former seemed more straight-forward
>>>>>>> to me but I'm happy to pursue other directions.
>>>>>>
>>>>>> I would strongly prefer something where nf integrates into existing tc hook,
>>>>>> not only due to the hook reuse which would be better, but also to allow for a
>>>>>> more flexible interaction between tc/BPF use cases and nf, to name one
>>>>>
>>>>> That sounds good but I'm afraid that it would take too much back and
>>>>> forth discussions. We'll really appreciate it if this small patch can
>>>>> be unblocked and then rethink the refactoring of ingress/egress hooks
>>>>> that you commented in another thread.
>>>>
>>>> I'm not sure whether your comment was serious or not, but nope, this needs
>>>> to be addressed as mentioned as otherwise this use case would regress. It
>>>
>>> This patch doesn't break anything. The tc redirect use case that you
>>> just commented on is the expected behavior and the same will happen
>>> with ingress. To be consistent, in the case that someone requires both
>>> hooks, another tc redirect would be needed in the egress path. If you
>>> mean to bypass the nf egress if tc redirect in ingress is used, that
>>> would lead in a huge security concern.
>>
>> I'm not sure I parse what you're saying above ... today it is possible and
>> perfectly fine to e.g. redirect to a host-facing veth from tc ingress which
>> then goes into container. Only traffic that goes up the host stack is seen
>> by nf ingress hook in that case. Likewise, reply traffic can be redirected
>> from host-facing veth to phys dev for xmit w/o any netfilter interference.
>> This means netfilter in host ns really only sees traffic to/from host as
>> intended. This is fine today, however, if 3rd party entities (e.g. distro
>> side) start pushing down rules on the two nf hooks, then these use cases will
>> break on the egress one due to this asymmetric layering violation. Hence my
>> ask that this needs to be configurable from a control plane perspective so
>> that both use cases can live next to each other w/o breakage. Most trivial
> 
> Why does it should be symmetric? Fast-paths create "asymmetric
> layering" continuously, see: packet hit XDP to user space bypassing
> ingress, but in the response will hit egress. So the "breakage" is
> already there.

Not quite sure what you mean exactly here or into which issue you ran. Either
you push the xdp buffer back out from XDP layer for load balancer case so upper
stack never sees it, or you push it to upper stack, and it goes through the
ingress/egress hooks e.g. from tc side. AF_XDP will bypass either. If you mean
the redirect from XDP layer to the veth devs where they have XDP support, then
the reply path also needs to operate /below/ netfilter on tc layer exactly for
the reason /not/ to break, as otherwise we get potentially hard to debug skb
drops on netfilter side when CT is involved and it figures it must drop due to
invalid CT state to name one example. That is if there is an opt-in to such data
path being used, then it also needs to continue to work, which gets me back to
the earlier mentioned example with the interaction on the egress side with that
hook that it needs to /interoperate/ with tc to avoid breakage of existing use
cases in the wild. Reuse of skb flag could be one option to move forward, or as
mentioned in earlier mails overall rework of ingress/egress side to be a more
flexible pipeline (think of cont/ok actions as with tc filters or stackable LSMs
to process & delegate).

Thanks,
Daniel
