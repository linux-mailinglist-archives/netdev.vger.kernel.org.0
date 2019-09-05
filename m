Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDDFAA422
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbfIENPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:15:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:56088 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731758AbfIENPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 09:15:13 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5rbJ-0007g9-Kk; Thu, 05 Sep 2019 15:15:01 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5rbJ-0007sg-BH; Thu, 05 Sep 2019 15:15:01 +0200
Subject: Re: [PATCH bpf] bpf: fix precision tracking of stack slots
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20190903221617.635375-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f48e1484-08f4-ab3e-4b5e-98410e0c9a7a@iogearbox.net>
Date:   Thu, 5 Sep 2019 15:15:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190903221617.635375-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25563/Thu Sep  5 10:24:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 12:16 AM, Alexei Starovoitov wrote:
> The problem can be seen in the following two tests:
> 0: (bf) r3 = r10
> 1: (55) if r3 != 0x7b goto pc+0
> 2: (7a) *(u64 *)(r3 -8) = 0
> 3: (79) r4 = *(u64 *)(r10 -8)
> ..
> 0: (85) call bpf_get_prandom_u32#7
> 1: (bf) r3 = r10
> 2: (55) if r3 != 0x7b goto pc+0
> 3: (7b) *(u64 *)(r3 -8) = r0
> 4: (79) r4 = *(u64 *)(r10 -8)
> 
> When backtracking need to mark R4 it will mark slot fp-8.
> But ST or STX into fp-8 could belong to the same block of instructions.
> When backtracing is done the parent state may have fp-8 slot
> as "unallocated stack". Which will cause verifier to warn
> and incorrectly reject such programs.
> 
> Writes into stack via non-R10 register are rare. llvm always
> generates canonical stack spill/fill.
> For such pathological case fall back to conservative precision
> tracking instead of rejecting.
> 
> Reported-by: syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com
> Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
