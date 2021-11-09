Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D92F44ACB4
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhKILhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:37:03 -0500
Received: from www62.your-server.de ([213.133.104.62]:41502 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhKILhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:37:02 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mkPOG-000C7K-9O; Tue, 09 Nov 2021 12:34:12 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mkPOG-000U0z-3M; Tue, 09 Nov 2021 12:34:12 +0100
Subject: Re: 4-year old off-by-two bug in the BPF verifier's boundary checks?
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <279b0a91-506d-e657-022d-aad52c17dfc6@nvidia.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fd6296d6-154c-814a-f088-e0567a566a21@iogearbox.net>
Date:   Tue, 9 Nov 2021 12:34:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <279b0a91-506d-e657-022d-aad52c17dfc6@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26348/Tue Nov  9 10:18:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

On 11/2/21 4:12 PM, Maxim Mikityanskiy wrote:
> Hi guys,
> 
> I think I found cases where the BPF verifier mistakenly rejects valid BPF programs when doing pkt_end boundary checks, and the selftests for these cases test wrong things as well.
> 
> Daniel's commit fb2a311a31d3 ("bpf: fix off by one for range markings with L{T, E} patterns") [1] attempts to fix an off-by-one bug in boundary checks, but I think it shifts the index by 1 in a wrong direction, so instead of fixing, the bug becomes off-by-two.
> 
> A following commit b37242c773b2 ("bpf: add test cases to bpf selftests to cover all access tests") [2] adds unit tests to check the new behavior, but the tests look also wrong to me.
> 
> Let me analyze these two tests:
> 
> {
>          "XDP pkt read, pkt_data' > pkt_end, good access",
>          .insns = {
>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>                      offsetof(struct xdp_md, data_end)),
>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>          BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1),
>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>          BPF_MOV64_IMM(BPF_REG_0, 0),
>          BPF_EXIT_INSN(),
>          },
>          .result = ACCEPT,
>          .prog_type = BPF_PROG_TYPE_XDP,
>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
> },
> 
> {
>          "XDP pkt read, pkt_data' >= pkt_end, bad access 1",
>          .insns = {
>          BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, data)),
>          BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>                      offsetof(struct xdp_md, data_end)),
>          BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
>          BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
>          BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
>          BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
>          BPF_MOV64_IMM(BPF_REG_0, 0),
>          BPF_EXIT_INSN(),
>          },
>          .errstr = "R1 offset is outside of the packet",
>          .result = REJECT,
>          .prog_type = BPF_PROG_TYPE_XDP,
>          .flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
> },
> 
> The first program looks good both to me and the verifier: if data + 8 > data_end, we bail out, otherwise, if data + 8 <= data_end, we read 8 bytes: [data; data+7].
> 
> The second program doesn't pass the verifier, and the test expects it to be rejected, but the program itself still looks fine to me: if data + 8 >= data_end, we bail out, otherwise, if data + 8 < data_end, we read 8 bytes: [data; data+7], and this is fine, because data + 7 is for sure < data_end. The verifier considers data + 7 to be out of bounds, although both data + 7 and data + 8 are still valid offsets, hence the off-by-two bug.
> 
> Are my considerations valid, or am I stupidly missing anything?

Sorry for my late reply, bit too swamped lately. So we have the two variants:

   r2 = data;
   r2 += 8;
   if (r2 > data_end) goto <handle exception>
     <access okay>

   r2 = data;
   r2 += 8;
   if (r2 >= data_end) goto <handle exception>
     <access okay>

Technically, the first option is the more correct way to check, meaning, we have 8 bytes of
access in the <access okay> branch. The second one is overly pessimistic in that if r2 equals
data_end we bail out even though we wouldn't have to. So in that case <access okay> branch
would have 9 bytes for access since r2 with offset 8 is already < data_end.

Anyway, please send a fix and updated test cases. Thanks Maxim!
