Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FEE5F6FC8
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiJFUyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJFUyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:54:09 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD02DD9;
        Thu,  6 Oct 2022 13:54:07 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogXsc-0004TJ-7Q; Thu, 06 Oct 2022 22:54:06 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogXsb-000Qbv-SA; Thu, 06 Oct 2022 22:54:05 +0200
Subject: Re: [PATCH bpf-next 02/10] bpf: Implement BPF link handling for tc
 BPF programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-3-daniel@iogearbox.net>
 <CAEf4Bzak_v01v5Y6dNT_1KAcax_hvVqZM4o+d_w5OJSWeLJz2g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5451abc2-3364-80bd-f7ae-9cff2052bad9@iogearbox.net>
Date:   Thu, 6 Oct 2022 22:54:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzak_v01v5Y6dNT_1KAcax_hvVqZM4o+d_w5OJSWeLJz2g@mail.gmail.com>
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

On 10/6/22 5:19 AM, Andrii Nakryiko wrote:
> On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> This work adds BPF links for tc. As a recap, a BPF link represents the attachment
>> of a BPF program to a BPF hook point. The BPF link holds a single reference to
>> keep BPF program alive. Moreover, hook points do not reference a BPF link, only
>> the application's fd or pinning does. A BPF link holds meta-data specific to
>> attachment and implements operations for link creation, (atomic) BPF program
>> update, detachment and introspection.
>>
>> The motivation for BPF links for tc BPF programs is multi-fold, for example:
>>
>> - "It's especially important for applications that are deployed fleet-wide
>>     and that don't "control" hosts they are deployed to. If such application
>>     crashes and no one notices and does anything about that, BPF program will
>>     keep running draining resources or even just, say, dropping packets. We
>>     at FB had outages due to such permanent BPF attachment semantics. With
>>     fd-based BPF link we are getting a framework, which allows safe, auto-
>>     detachable behavior by default, unless application explicitly opts in by
>>     pinning the BPF link." [0]
>>
>> -  From Cilium-side the tc BPF programs we attach to host-facing veth devices
>>     and phys devices build the core datapath for Kubernetes Pods, and they
>>     implement forwarding, load-balancing, policy, EDT-management, etc, within
>>     BPF. Currently there is no concept of 'safe' ownership, e.g. we've recently
>>     experienced hard-to-debug issues in a user's staging environment where
>>     another Kubernetes application using tc BPF attached to the same prio/handle
>>     of cls_bpf, wiping all Cilium-based BPF programs from underneath it. The
>>     goal is to establish a clear/safe ownership model via links which cannot
>>     accidentally be overridden. [1]
>>
>> BPF links for tc can co-exist with non-link attachments, and the semantics are
>> in line also with XDP links: BPF links cannot replace other BPF links, BPF
>> links cannot replace non-BPF links, non-BPF links cannot replace BPF links and
>> lastly only non-BPF links can replace non-BPF links. In case of Cilium, this
>> would solve mentioned issue of safe ownership model as 3rd party applications
>> would not be able to accidentally wipe Cilium programs, even if they are not
>> BPF link aware.
>>
>> Earlier attempts [2] have tried to integrate BPF links into core tc machinery
>> to solve cls_bpf, which has been intrusive to the generic tc kernel API with
>> extensions only specific to cls_bpf and suboptimal/complex since cls_bpf could
>> be wiped from the qdisc also. Locking a tc BPF program in place this way, is
>> getting into layering hacks given the two object models are vastly different.
>> We chose to implement a prerequisite of the fd-based tc BPF attach API, so
>> that the BPF link implementation fits in naturally similar to other link types
>> which are fd-based and without the need for changing core tc internal APIs.
>>
>> BPF programs for tc can then be successively migrated from cls_bpf to the new
>> tc BPF link without needing to change the program's source code, just the BPF
>> loader mechanics for attaching.
>>
>>    [0] https://lore.kernel.org/bpf/CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com/
>>    [1] https://lpc.events/event/16/contributions/1353/
>>    [2] https://lore.kernel.org/bpf/20210604063116.234316-1-memxor@gmail.com/
>>
>> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
> 
> have you considered supporting BPF cookie from the outset? It should
> be trivial if you remove union from bpf_prog_array_item. If not, then
> we should reject LINK_CREATE if bpf_cookie is non-zero.

Haven't considered it yet at this point, but we can add this in subsequent step,
agree, thus we should reject for now upon create.

>>   include/linux/bpf.h            |   5 +-
>>   include/net/xtc.h              |  14 ++++
>>   include/uapi/linux/bpf.h       |   5 ++
>>   kernel/bpf/net.c               | 116 ++++++++++++++++++++++++++++++---
>>   kernel/bpf/syscall.c           |   3 +
>>   tools/include/uapi/linux/bpf.h |   5 ++
>>   6 files changed, 139 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 71e5f43db378..226a74f65704 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1473,7 +1473,10 @@ struct bpf_prog_array_item {
>>          union {
>>                  struct bpf_cgroup_storage *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
>>                  u64 bpf_cookie;
>> -               u32 bpf_priority;
>> +               struct {
>> +                       u32 bpf_priority;
>> +                       u32 bpf_id;
> 
> this is link_id, is that right? should we name it as such?

Ack, will rename, thanks also for all your other suggestions inthe various patches,
all make sense to me & will address them!

>> +               };
>>          };
>>   };
>>
> 
> [...]
