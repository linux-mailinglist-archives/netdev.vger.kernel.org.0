Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195F22C0BC3
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389275AbgKWNac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:30:32 -0500
Received: from www62.your-server.de ([213.133.104.62]:56794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389068AbgKWNaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:30:30 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khBv0-0006CV-6y; Mon, 23 Nov 2020 14:30:10 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khBuz-000NhL-VQ; Mon, 23 Nov 2020 14:30:10 +0100
Subject: Re: [PATCH bpf-next v7 00/34] bpf: switch to memcg-based memory
 accounting
To:     Roman Gushchin <guro@fb.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, netdev@vger.kernel.org, andrii@kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20201119173754.4125257-1-guro@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9134a408-e26c-a7f2-23a7-5fc221bafdde@iogearbox.net>
Date:   Mon, 23 Nov 2020 14:30:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25996/Sun Nov 22 14:25:48 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/20 6:37 PM, Roman Gushchin wrote:
> Currently bpf is using the memlock rlimit for the memory accounting.
> This approach has its downsides and over time has created a significant
> amount of problems:
> 
> 1) The limit is per-user, but because most bpf operations are performed
>     as root, the limit has a little value.
> 
> 2) It's hard to come up with a specific maximum value. Especially because
>     the counter is shared with non-bpf users (e.g. memlock() users).
>     Any specific value is either too low and creates false failures
>     or too high and useless.
> 
> 3) Charging is not connected to the actual memory allocation. Bpf code
>     should manually calculate the estimated cost and precharge the counter,
>     and then take care of uncharging, including all fail paths.
>     It adds to the code complexity and makes it easy to leak a charge.
> 
> 4) There is no simple way of getting the current value of the counter.
>     We've used drgn for it, but it's far from being convenient.
> 
> 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
>     a function to "explain" this case for users.
> 
> In order to overcome these problems let's switch to the memcg-based
> memory accounting of bpf objects. With the recent addition of the percpu
> memory accounting, now it's possible to provide a comprehensive accounting
> of the memory used by bpf programs and maps.
> 
> This approach has the following advantages:
> 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
>     a better control over memory usage by different workloads. Of course, it
>     requires enabled cgroups and kernel memory accounting and properly configured
>     cgroup tree, but it's a default configuration for a modern Linux system.
> 
> 2) The actual memory consumption is taken into account. It happens automatically
>     on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
>     performed automatically on releasing the memory. So the code on the bpf side
>     becomes simpler and safer.
> 
> 3) There is a simple way to get the current value and statistics.
> 
> In general, if a process performs a bpf operation (e.g. creates or updates
> a map), it's memory cgroup is charged. However map updates performed from
> an interrupt context are charged to the memory cgroup which contained
> the process, which created the map.
> 
> Providing a 1:1 replacement for the rlimit-based memory accounting is
> a non-goal of this patchset. Users and memory cgroups are completely
> orthogonal, so it's not possible even in theory.
> Memcg-based memory accounting requires a properly configured cgroup tree
> to be actually useful. However, it's the way how the memory is managed
> on a modern Linux system.

The cover letter here only describes the advantages of this series, but leaves
out discussion of the disadvantages. They definitely must be part of the series
to provide a clear description of the semantic changes to readers. Last time we
discussed them, they were i) no mem limits in general on unprivileged users when
memory cgroups was not configured in the kernel, and ii) no mem limits by default
if not configured in the cgroup specifically. Did we made any progress on these
in the meantime? How do we want to address them? What is the concrete justification
to not address them?

Also I wonder what are the risk of regressions here, for example, if an existing
orchestrator has configured memory cgroup limits that are tailored to the application's
needs.. now, with kernel upgrade BPF will start to interfere, e.g. if a BPF program
attached to cgroups (e.g. connect/sendmsg/recvmsg or general cgroup skb egress hook)
starts charging to the process' memcg due to map updates?

   [0] https://lore.kernel.org/bpf/20200803190639.GD1020566@carbon.DHCP.thefacebook.com/

> The patchset consists of the following parts:
> 1) 4 mm patches, which are already in the mm tree, but are required
>     to avoid a regression (otherwise vmallocs cannot be mapped to userspace).
> 2) memcg-based accounting for various bpf objects: progs and maps
> 3) removal of the rlimit-based accounting
> 4) removal of rlimit adjustments in userspace samples
> 
> First 4 patches are not supposed to be merged via the bpf tree. I'm including
> them to make sure bpf tests will pass.
> 
> v7:
>    - introduced bpf_map_kmalloc_node() and bpf_map_alloc_percpu(), by Alexei
>    - switched allocations made from an interrupt context to new helpers,
>      by Daniel
>    - rebase and minor fixes
