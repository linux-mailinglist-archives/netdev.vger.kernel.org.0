Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7BB234F04
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 03:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHABDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 21:03:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:42910 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgHABDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 21:03:24 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1fvk-0001vq-5c; Sat, 01 Aug 2020 03:03:20 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1fvj-000Hg4-Vi; Sat, 01 Aug 2020 03:03:20 +0200
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
Date:   Sat, 1 Aug 2020 03:03:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25890/Fri Jul 31 17:04:57 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 2:03 AM, Maciej Fijalkowski wrote:
> v5->v6:
> - propagate only those poke descriptors that individual subprogram is
>    actually using (Daniel)
> - drop the cumbersome check if poke desc got filled in map_poke_run()
> - move poke->ip renaming in bpf_jit_add_poke_descriptor() from patch 4
>    to patch 3 to provide bisectability (Daniel)

I did a basic test with Cilium on K8s with this set, spawning a few Pods
and checking connectivity & whether we're not crashing since it has bit more
elaborate tail call use. So far so good. I was inclined to push the series
out, but there is one more issue I noticed and didn't notice earlier when
reviewing, and that is overall stack size:

What happens when you create a single program that has nested BPF to BPF
calls e.g. either up to the maximum nesting or one call that is using up
the max stack size which is then doing another BPF to BPF call that contains
the tail call. In the tail call map, you have the same program in there.
This means we create a worst case stack from BPF size of max_stack_size *
max_tail_call_size, that is, 512*32. So that adds 16k worst case. For x86
we have a stack of arch/x86/include/asm/page_64_types.h:

   #define THREAD_SIZE_ORDER       (2 + KASAN_STACK_ORDER)
  #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)

So we end up with 16k in a typical case. And this will cause kernel stack
overflow; I'm at least not seeing where we handle this situation in the
set. Hm, need to think more, but maybe this needs tracking of max stack
across tail calls to force an upper limit..

Thanks,
Daniel
