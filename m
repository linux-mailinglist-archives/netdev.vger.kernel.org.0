Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611AD23A3D0
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 14:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHCMG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 08:06:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:43598 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgHCMGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 08:06:18 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2ZDd-0003L5-Tm; Mon, 03 Aug 2020 14:05:29 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2ZDd-000WOD-Mr; Mon, 03 Aug 2020 14:05:29 +0200
Subject: Re: [PATCH bpf-next v3 00/29] bpf: switch to memcg-based memory
 accounting
To:     Roman Gushchin <guro@fb.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        kernel-team@fb.com, linux-kernel@vger.kernel.org
References: <20200730212310.2609108-1-guro@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6b1777ac-cae1-fa1f-db53-f6061d9ae675@iogearbox.net>
Date:   Mon, 3 Aug 2020 14:05:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200730212310.2609108-1-guro@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25892/Sun Aug  2 17:01:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 11:22 PM, Roman Gushchin wrote:
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
> of memory used by bpf programs and maps.
> 
> This approach has the following advantages:
> 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
>     a better control over memory usage by different workloads.
> 
> 2) The actual memory consumption is taken into account. It happens automatically
>     on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
>     performed automatically on releasing the memory. So the code on the bpf side
>     becomes simpler and safer.
> 
> 3) There is a simple way to get the current value and statistics.
> 
> The patchset consists of the following parts:
> 1) memcg-based accounting for various bpf objects: progs and maps
> 2) removal of the rlimit-based accounting
> 3) removal of rlimit adjustments in userspace samples

The diff stat looks nice & agree that rlimit sucks, but I'm missing how this is set
is supposed to work reliably, at least I currently fail to see it. Elaborating on this
in more depth especially for the case of unprivileged users should be a /fundamental/
part of the commit message.

Lets take an example: unprivileged user adds a max sized hashtable to one of its
programs, and configures the map that it will perform runtime allocation. The load
succeeds as it doesn't surpass the limits set for the current memcg. Kernel then
processes packets from softirq. Given the runtime allocations, we end up mischarging
to whoever ended up triggering __do_softirq(). If, for example, ksoftirq thread, then
it's probably reasonable to assume that this might not be accounted e.g. limits are
not imposed on the root cgroup. If so we would probably need to drag the context of
/where/ this must be charged to __memcg_kmem_charge_page() to do it reliably. Otherwise
how do you protect unprivileged users to OOM the machine?

Similarly, what happens to unprivileged users if kmemcg was not configured into the
kernel or has been disabled?

Thanks,
Daniel
