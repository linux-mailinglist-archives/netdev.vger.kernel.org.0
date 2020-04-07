Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B5B1A18BE
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 01:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDGXoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 19:44:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:57580 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgDGXoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 19:44:13 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLxt0-0001PO-3o; Wed, 08 Apr 2020 01:44:06 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLxsz-0008rw-Hi; Wed, 08 Apr 2020 01:44:05 +0200
Subject: Re: [PATCH bpf] riscv, bpf: Fix offset range checking for auipc+jalr
 on RV64
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
Cc:     Xi Wang <xi.wang@gmail.com>, Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20200406221604.18547-1-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bdea1a61-53d6-dc03-7cdb-4b6b0710be2e@iogearbox.net>
Date:   Wed, 8 Apr 2020 01:44:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200406221604.18547-1-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25775/Tue Apr  7 14:53:51 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/20 12:16 AM, Luke Nelson wrote:
> The existing code in emit_call on RV64 checks that the PC-relative offset
> to the function fits in 32 bits before calling emit_jump_and_link to emit
> an auipc+jalr pair. However, this check is incorrect because offsets in
> the range [2^31 - 2^11, 2^31 - 1] cannot be encoded using auipc+jalr on
> RV64 (see discussion [1]). The RISC-V spec has recently been updated
> to reflect this fact [2, 3].
> 
> This patch fixes the problem by moving the check on the offset into
> emit_jump_and_link and modifying it to the correct range of encodable
> offsets, which is [-2^31 - 2^11, 2^31 - 2^11). This also enforces the
> check on the offset to other uses of emit_jump_and_link (e.g., BPF_JA)
> as well.
> 
> Currently, this bug is unlikely to be triggered, because the memory
> region from which JITed images are allocated is close enough to kernel
> text for the offsets to not become too large; and because the bounds on
> BPF program size are small enough. This patch prevents this problem from
> becoming an issue if either of these change.
> 
> [1]: https://groups.google.com/a/groups.riscv.org/forum/#!topic/isa-dev/bwWFhBnnZFQ
> [2]: https://github.com/riscv/riscv-isa-manual/commit/b1e42e09ac55116dbf9de5e4fb326a5a90e4a993
> [3]: https://github.com/riscv/riscv-isa-manual/commit/4c1b2066ebd2965a422e41eb262d0a208a7fea07
> 
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Applied, thanks!
