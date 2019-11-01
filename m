Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9482FEBCDD
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 05:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfKAEjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 00:39:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKAEjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 00:39:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18EE61503D3BD;
        Thu, 31 Oct 2019 21:39:32 -0700 (PDT)
Date:   Thu, 31 Oct 2019 21:39:31 -0700 (PDT)
Message-Id: <20191031.213931.1743556905343073518.davem@davemloft.net>
To:     edumazet@google.com
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, bpf@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH net] powerpc/bpf: fix tail call implementation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101033444.143741-1-edumazet@google.com>
References: <20191101033444.143741-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 21:39:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 31 Oct 2019 20:34:44 -0700

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

I am anticipating this will go via the bpf tree.
