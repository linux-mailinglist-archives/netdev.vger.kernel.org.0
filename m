Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA57B3A35D2
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFJV0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:26:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:49214 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFJV0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:26:20 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lrSA1-000DDB-Jh; Thu, 10 Jun 2021 23:24:21 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lrSA1-000KRX-DY; Thu, 10 Jun 2021 23:24:21 +0200
Subject: Re: [PATCH bpf-next 02/17] bpf: allow RCU-protected lookups to happen
 from bh context
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-3-toke@redhat.com>
 <CAADnVQJrETg1NsqBv2HE06tra=q5K8f1US8tGuHqc_FDMKR6XQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c5192ab3-1c05-8679-79f2-59d98299095b@iogearbox.net>
Date:   Thu, 10 Jun 2021 23:24:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQJrETg1NsqBv2HE06tra=q5K8f1US8tGuHqc_FDMKR6XQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26197/Thu Jun 10 13:10:09 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On 6/10/21 8:38 PM, Alexei Starovoitov wrote:
> On Wed, Jun 9, 2021 at 7:24 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> XDP programs are called from a NAPI poll context, which means the RCU
>> reference liveness is ensured by local_bh_disable(). Add
>> rcu_read_lock_bh_held() as a condition to the RCU checks for map lookups so
>> lockdep understands that the dereferences are safe from inside *either* an
>> rcu_read_lock() section *or* a local_bh_disable() section. This is done in
>> preparation for removing the redundant rcu_read_lock()s from the drivers.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>   kernel/bpf/hashtab.c  | 21 ++++++++++++++-------
>>   kernel/bpf/helpers.c  |  6 +++---
>>   kernel/bpf/lpm_trie.c |  6 ++++--
>>   3 files changed, 21 insertions(+), 12 deletions(-)
>>
>> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
>> index 6f6681b07364..72c58cc516a3 100644
>> --- a/kernel/bpf/hashtab.c
>> +++ b/kernel/bpf/hashtab.c
>> @@ -596,7 +596,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
>>          struct htab_elem *l;
>>          u32 hash, key_size;
>>
>> -       WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
>> +       WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
>> +                    !rcu_read_lock_bh_held());
> 
> It's not clear to me whether rcu_read_lock_held() is still needed.
> All comments sound like rcu_read_lock_bh_held() is a superset of rcu
> that includes bh.
> But reading rcu source code it looks like RCU_BH is its own rcu flavor...
> which is confusing.

The series is a bit confusing to me as well. I recall we had a discussion with
Paul, but it was back in 2016 aka very early days of XDP to get some clarifications
about RCU vs RCU-bh flavour on this. Paul, given the series in here, I assume the
below is not true anymore, and in this case (since we're removing rcu_read_lock()
from drivers), the RCU-bh acts as a real superset?

Back then from your clarifications this was not the case:

   On Mon, Jul 25, 2016 at 11:26:02AM -0700, Alexei Starovoitov wrote:
   > On Mon, Jul 25, 2016 at 11:03 AM, Paul E. McKenney
   > <paulmck@linux.vnet.ibm.com> wrote:
   [...]
   >>> The crux of the question is whether a particular driver rx handler, when
   >>> called from __do_softirq, needs to add an additional rcu_read_lock or
   >>> whether it can rely on the mechanics of softirq.
   >>
   >> If it was rcu_read_lock_bh(), you could.
   >>
   >> But you didn't say rcu_read_lock_bh(), you instead said rcu_read_lock(),
   >> which means that you absolutely cannot rely on softirq semantics.
   >>
   >> In particular, in CONFIG_PREEMPT=y kernels, rcu_preempt_check_callbacks()
   >> will notice that there is no rcu_read_lock() in effect and report
   >> a quiescent state for that CPU.  Because rcu_preempt_check_callbacks()
   >> is invoked from the scheduling-clock interrupt, it absolutely can
   >> execute during do_softirq(), and therefore being in softirq context
   >> in no way provides rcu_read_lock()-style protection.
   >>
   >> Now, Alexei's question was for CONFIG_PREEMPT=n kernels.  However, in
   >> that case, rcu_read_lock() and rcu_read_unlock() generate no code
   >> in recent production kernels, so there is no performance penalty for
   >> using them.  (In older kernels, they implied a barrier().)
   >>
   >> So either way, with or without CONFIG_PREEMPT, you should use
   >> rcu_read_lock() to get RCU protection.
   >>
   >> One alternative might be to switch to rcu_read_lock_bh(), but that
   >> will add local_disable_bh() overhead to your read paths.
   >>
   >> Does that help, or am I missing the point of the question?
   >
   > thanks a lot for explanation.

   Glad you liked it!

   > I mistakenly assumed that _bh variants are 'stronger' and
   > act as inclusive, but sounds like they're completely orthogonal
   > especially with preempt_rcu=y.

   Yes, they are pretty much orthogonal.

   > With preempt_rcu=n and preempt=y, it would be the case, since
   > bh disables preemption and rcu_read_lock does the same as well,
   > right? Of course, the code shouldn't be relying on that, so we
   > have to fix our stuff.

   Indeed, especially given that the kernel currently won't allow you
   to configure CONFIG_PREEMPT_RCU=n and CONFIG_PREEMPT=y.  If it does,
   please let me know, as that would be a bug that needs to be fixed.
   (For one thing, I do not test that combination.)

							Thanx, Paul

And now, fast-forward again to 2021 ... :)

Thanks,
Daniel
