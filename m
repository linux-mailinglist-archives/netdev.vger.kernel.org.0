Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896FD6B9646
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCNNcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCNNbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:31:44 -0400
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fa8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8403231D7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:28:20 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PbZ8y4gnKzMqPGB;
        Tue, 14 Mar 2023 14:28:18 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4PbZ8x6dHGzMshZT;
        Tue, 14 Mar 2023 14:28:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1678800498;
        bh=kMnRX6G29tPfDpk+qyvZppMEcfd3tSVe79+PIqcL0xI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=yXd5obTSfcGn8kT7e+yNxMc50vGs6GlODFVt6pcv2AaVAxjPZYy3h/pRzeMDjcxud
         y8xf/oE4H2hQ43focpP0bbmRqhi+ECyqnDi/0DQHDYIvWwQiyDBZRo1YXtxz23ryZB
         7eVQ3c4E8rgsQ4sB+7DAWOYcP51SHVqYPy8HL2Cg=
Message-ID: <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net>
Date:   Tue, 14 Mar 2023 14:28:17 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 00/12] Network support for Landlock
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/03/2023 18:16, Konstantin Meskhidze (A) wrote:
> 
> 
> 2/24/2023 1:17 AM, Günther Noack пишет:
>> Hello Konstantin!
>>
>> Sorry for asking such fundamental questions again so late in the review.
>>
>> After playing with patch V9 with the Go-Landlock library, I'm still
>> having trouble understanding these questions -- they probably have
>> good answers, but I also did not see them explained in the
>> documentation. Maybe it would help to clarify it there?
>>
>> * What is the use case for permitting processes to connect to a given
>>     TCP port, but leaving unspecified what the IP address is?
>>
>>     Example: If a Landlock ruleset permits connecting to TCP port 53,
>>     that makes it possible to talk to any IP address on the internet (at
>>     least if the process runs on a normal Linux desktop machine), and we
>>     can't really control whether that is the system's proper (TCP-)DNS
>>     server or whether that is an attacker-controlled service for
>>     accepting leaked secrets from the process...?
>>
>>     Is the plan that IP address support should be added in a follow-up
>>     patch?  Will it become part of the landlock_net_service_attr struct?
> 
>        In the beginning I introduced the idea with IP address to
> Mickaël but he suggested to use port-based granularity. So with ports
> it's worth using Landlock in containerized applications working within
> one IP address. Anyway it's possible to use netfilter to control
> incoming traffic. It's a good question - we should discuss it carefuly.

Limiting access rule definition to TCP ports is because of two reasons:
- practical one: start with something small and improve it. All new 
features should be covered by tests, and it takes time to write and 
review them, especially to cover IPv4, IPv6 and any other type of 
address to identify a server. Being able to control TCP connect and bind 
is useful and brings the scaffolding for other non-kernel-object 
restrictions.
- semantic one: ports are tied to well-known (or configured) services, 
whatever the network where a process is (e.g. Internet, LAN, container's 
network namespace, VM). However, IP addresses are not well-known but 
(most of the time) tied to names/DNS, which is not handled by the kernel 
but user space. Moreover, I think it makes sense for app/service 
developers to think about reachable services, but much less about 
servers, which depend on the local network and a system-wide configuration.

For some use cases, there is definitely a need to restrict access to a 
set of servers though. I think a new dedicated attr struct would be 
easier to handle and it would make more sense to compose them (ANDing 
all network rule types to make a final decision). This new struct could 
define different kind of subnets (IPv4, IPv6, ethernet, bluetooth…). One 
of this type could be the local link, and especially if the server is 
local to the system or not (i.e. loopback interface), and if the server 
is in a specified network namespace (e.g. specific container/pod).

Anyway, this should indeed be documented.


>>
>> * Given the list of obscure network protocols listed in the socket(2)
>>     man page, I find it slightly weird to have rules for the use of TCP,
>>     but to leave less prominent protocols unrestricted.
>>
>>     For example, a process with an enabled Landlock network ruleset may
>>     connect only to certain TCP ports, but at the same time it can
>>     happily use Bluetooth/CAN bus/DECnet/IPX or other protocols?
> 
>        We also have started a discussion about UDP protocol, but it's
> more complicated since UDP sockets does not establish connections
> between each other. There is a performance problem on the first place here.
> 
> I'm not familiar with Bluetooth/CAN bus/DECnet/IPX but let's discuss it.
> Any ideas here?

All these protocols should be handled one way or another someday. ;)


> 
>>
>>     I'm mentioning these more obscure protocols, because I doubt that
>>     Landlock will grow more sophisticated support for them anytime soon,
>>     so maybe the best option would be to just make it possible to
>>     disable these?  Is that also part of the plan?
>>
>>     (I think there would be a lot of value in restricting network
>>     access, even when it's done very broadly.  There are many programs
>>     that don't need network at all, and among those that do need
>>     network, most only require IP networking.

Indeed, protocols that nobody care to make Landlock supports them will 
probably not have fine-grained control. We could extend the ruleset 
attributes to disable the use (i.e. not only the creation of new related 
sockets/resources) of network protocol families, in a way that would 
make sandboxes simulate a kernel without such protocol support. In this 
case, this should be an allowed list of protocols, and everything not in 
that list should be denied. This approach could be used for other kernel 
features (unrelated to network).


>>
>>     Btw, the argument for more broad disabling of network access was
>>     already made at https://cr.yp.to/unix/disablenetwork.html in the
>>     past.)

This is interesting but scoped to a single use case. As specified at the 
beginning of this linked page, there must be exceptions, not only with 
AF_UNIX but also for (the newer) AF_VSOCK, and probably future ones. 
This is why I don't think a binary approach is a good one for Linux. 
Users should be able to specify what they need, and block the rest.


>        Thanks for the link. I will read it.
>>
>> * This one is more of an implementation question: I don't understand
>>     why we are storing the networking rules in the same RB tree as the
>>     file system rules. - It looks a bit like "YAGNI" to me...?
> 
>        Actually network rules are stored in a different RB tree.
>        You can check it in struct landlock_ruleset (ruleset.h):
>        - struct rb_root root_inodeis for fs rules
> 
>        - struct rb_root root_net_port is for network rules;
>>
>>     Would it be more efficient to keep the file system rules in the
>>     existing RB tree, and store the networking rules *separately* next
>>     to it in a different RB tree, or even in a more optimized data
>>     structure? In pseudocode:
>>
>>       struct fast_lookup_int_set bind_tcp_ports;
>>       struct fast_lookup_int_set connect_tcp_ports;
>>       struct landlock_rb_tree fs_rules;
>>
>>     It seems that there should be a data structure that supports this
>>     well and which uses the fact that we only need to store small
>>     integers?
> 
>        Thnaks for the question. From my point of view it depends on a
> real scenario - how many ports we want to allow by Landlock for a
> proccess - thousands, hundreds or less. If it's just 10 ports - do we
> really need some optimized data structure? Do we get some performance
> gain here?
> What do you think?

As Konstantin explained, there are two different red-black trees. This 
data structure may not be optimal but it is much easier to start with that.

Using one tree per right would increase the size, especially for each 
new access right, but it is worth thinking about a new data structure 
dealing with sets (and ranges) of numbers.

Talking about performance optimization, the first step would be to use a 
hash table for domain's inode identification.


>>
>> Thanks,
>> –Günther
>>
>> P.S.: Apologies if some of it was discussed previously. I did my best
>> to catch up on previous threads, but it's long, and it's possible that
>> I missed parts of the discussion.
>>
>> On Mon, Jan 16, 2023 at 04:58:06PM +0800, Konstantin Meskhidze wrote:
>>> Hi,
>>> This is a new V9 patch related to Landlock LSM network confinement.
>>> It is based on the landlock's -next branch on top of v6.2-rc3 kernel version:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next
>>>
>>> It brings refactoring of previous patch version V8.
>>> Mostly there are fixes of logic and typos, adding new tests.
>>>
>>> All test were run in QEMU evironment and compiled with
>>>   -static flag.
>>>   1. network_test: 32/32 tests passed.
>>>   2. base_test: 7/7 tests passed.
>>>   3. fs_test: 78/78 tests passed.
>>>   4. ptrace_test: 8/8 tests passed.
>>>
>>> Previous versions:
>>> v8: https://lore.kernel.org/linux-security-module/20221021152644.155136-1-konstantin.meskhidze@huawei.com/
>>> v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
>>> v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
>>> v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
>>> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
>>> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
>>> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
>>> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
>>>
>>> Konstantin Meskhidze (11):
>>>    landlock: Make ruleset's access masks more generic
>>>    landlock: Refactor landlock_find_rule/insert_rule
>>>    landlock: Refactor merge/inherit_ruleset functions
>>>    landlock: Move and rename umask_layers() and init_layer_masks()
>>>    landlock: Refactor _unmask_layers() and _init_layer_masks()
>>>    landlock: Refactor landlock_add_rule() syscall
>>>    landlock: Add network rules and TCP hooks support
>>>    selftests/landlock: Share enforce_ruleset()
>>>    selftests/landlock: Add 10 new test suites dedicated to network
>>>    samples/landlock: Add network demo
>>>    landlock: Document Landlock's network support
>>>
>>> Mickaël Salaün (1):
>>>    landlock: Allow filesystem layout changes for domains without such
>>>      rule type
>>>
>>>   Documentation/userspace-api/landlock.rst     |   72 +-
>>>   include/uapi/linux/landlock.h                |   49 +
>>>   samples/landlock/sandboxer.c                 |  131 +-
>>>   security/landlock/Kconfig                    |    1 +
>>>   security/landlock/Makefile                   |    2 +
>>>   security/landlock/fs.c                       |  255 ++--
>>>   security/landlock/limits.h                   |    7 +-
>>>   security/landlock/net.c                      |  200 +++
>>>   security/landlock/net.h                      |   26 +
>>>   security/landlock/ruleset.c                  |  409 +++++--
>>>   security/landlock/ruleset.h                  |  185 ++-
>>>   security/landlock/setup.c                    |    2 +
>>>   security/landlock/syscalls.c                 |  165 ++-
>>>   tools/testing/selftests/landlock/base_test.c |    2 +-
>>>   tools/testing/selftests/landlock/common.h    |   10 +
>>>   tools/testing/selftests/landlock/config      |    4 +
>>>   tools/testing/selftests/landlock/fs_test.c   |   75 +-
>>>   tools/testing/selftests/landlock/net_test.c  | 1157 ++++++++++++++++++
>>>   18 files changed, 2398 insertions(+), 354 deletions(-)
>>>   create mode 100644 security/landlock/net.c
>>>   create mode 100644 security/landlock/net.h
>>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
>>>
>>> -- 
>>> 2.25.1
>>>
>> .
