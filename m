Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFA3109705
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKYXnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:43:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:44712 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYXnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:43:19 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZO0e-0001rZ-CG; Tue, 26 Nov 2019 00:43:12 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iZO0d-0007fK-T3; Tue, 26 Nov 2019 00:43:11 +0100
Subject: Re: [PATCH] bpf: fix a no-mmu build failure by providing a stub
 allocator
To:     John Hubbard <jhubbard@nvidia.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
References: <20191125234103.1699950-1-jhubbard@nvidia.com>
 <20191125234103.1699950-2-jhubbard@nvidia.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8c4d892a-73b5-b4d5-be15-bc81e8297de9@iogearbox.net>
Date:   Tue, 26 Nov 2019 00:43:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191125234103.1699950-2-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25644/Mon Nov 25 10:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/19 12:41 AM, John Hubbard wrote:
> Commit fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> added code that calls vmalloc_user_node_flags() and therefore requires
> mm/vmalloc.c. However, that file is not built for the !CONFIG_MMU case.
> This leads to a build failure when using ARM with the config provided
> by at least one particular kbuild test robot report [1].
> 
> [1] https://lore/kernel.org/r/201911251639.UWS3hE3Y%lkp@intel.com
> 
> Fix the build by providing a stub function for __bpf_map_area_alloc().
> 
> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> Reported-by: kbuild test robot <lkp@intel.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Thanks for the patch, already fixed via:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=ed81745a4c96841937f1da35c0eb66ac312e1480
