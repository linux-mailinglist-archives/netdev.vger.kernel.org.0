Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520AFECC21
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 01:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfKBAGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 20:06:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:59478 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKBAGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 20:06:11 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQgvU-0003xU-Ra; Sat, 02 Nov 2019 01:05:56 +0100
Received: from [178.197.249.38] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQgvU-000Mxc-Gu; Sat, 02 Nov 2019 01:05:56 +0100
Subject: Re: [PATCH net] powerpc/bpf: fix tail call implementation
To:     Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20191101033444.143741-1-edumazet@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <91aba3b7-ab80-f748-dfac-9933ff095139@iogearbox.net>
Date:   Sat, 2 Nov 2019 01:05:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191101033444.143741-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 4:34 AM, Eric Dumazet wrote:
> We have seen many crashes on powerpc hosts while loading bpf programs.
> 
> The problem here is that bpf_int_jit_compile() does a first pass
> to compute the program length.
> 
> Then it allocates memory to store the generated program and
> calls bpf_jit_build_body() a second time (and a third time
> later)
> 
> What I have observed is that the second bpf_jit_build_body()
> could end up using few more words than expected.
> 
> If bpf_jit_binary_alloc() put the space for the program
> at the end of the allocated page, we then write on
> a non mapped memory.
> 
> It appears that bpf_jit_emit_tail_call() calls
> bpf_jit_emit_common_epilogue() while ctx->seen might not
> be stable.
> 
> Only after the second pass we can be sure ctx->seen wont be changed.
> 
> Trying to avoid a second pass seems quite complex and probably
> not worth it.
> 
> Fixes: ce0761419faef ("powerpc/bpf: Implement support for tail calls")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
> Cc: Sandipan Das <sandipan@linux.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org

Applied, thanks!
