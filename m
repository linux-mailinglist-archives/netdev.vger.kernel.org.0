Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BEC2561FB
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 22:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgH1U1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 16:27:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:43756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgH1U1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 16:27:30 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBky6-000596-IX; Fri, 28 Aug 2020 22:27:26 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBky6-000PUr-Ab; Fri, 28 Aug 2020 22:27:26 +0200
Subject: Re: [PATCH v3 bpf-next 1/5] mm/error_inject: Fix allow_error_inject
 function signatures.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     josef@toxicpanda.com, bpoirier@suse.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-2-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d6eae293-5427-d5e4-73aa-4df7a493bb89@iogearbox.net>
Date:   Fri, 28 Aug 2020 22:27:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200827220114.69225-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25913/Fri Aug 28 15:19:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 12:01 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> 'static' and 'static noinline' function attributes make no guarantees that
> gcc/clang won't optimize them. The compiler may decide to inline 'static'
> function and in such case ALLOW_ERROR_INJECT becomes meaningless. The compiler
> could have inlined __add_to_page_cache_locked() in one callsite and didn't
> inline in another. In such case injecting errors into it would cause
> unpredictable behavior. It's worse with 'static noinline' which won't be
> inlined, but it still can be optimized. Like the compiler may decide to remove
> one argument or constant propagate the value depending on the callsite.
> 
> To avoid such issues make sure that these functions are global noinline.

Back in the days when adding 6bf37e5aa90f ("crypto: crypto_memneq - add equality
testing of memory regions w/o timing leaks") we added noinline, but also an
explicit EXPORT_SYMBOL() to prevent this from being optimized away; I wonder
whether ALLOW_ERROR_INJECT() should have something implicit here too to prevent
from optimization .. otoh we probably don't want to expose every ALLOW_ERROR_INJECT()
function also to modules generically...

Thanks,
Daniel
