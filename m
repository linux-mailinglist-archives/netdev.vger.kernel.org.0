Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFAFB194A3
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfEIVaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 17:30:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:59618 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfEIVaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 17:30:35 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hOqca-0007ay-Nx; Thu, 09 May 2019 23:30:32 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hOqca-000J7d-Hy; Thu, 09 May 2019 23:30:32 +0200
Subject: Re: [PATCH bpf v1] bpf: Fix undefined behavior in narrow load
 handling
To:     Krzesimir Nowak <krzesimir@kinvolk.io>, bpf@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=c3=b3pez_Galeiras?= <iago@kinvolk.io>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190508160859.4380-1-krzesimir@kinvolk.io>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <46056c60-f106-e539-b614-498cb1e9e3d0@iogearbox.net>
Date:   Thu, 9 May 2019 23:30:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190508160859.4380-1-krzesimir@kinvolk.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25444/Thu May  9 09:57:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/08/2019 06:08 PM, Krzesimir Nowak wrote:
> Commit 31fd85816dbe ("bpf: permits narrower load from bpf program
> context fields") made the verifier add AND instructions to clear the
> unwanted bits with a mask when doing a narrow load. The mask is
> computed with
> 
> (1 << size * 8) - 1
> 
> where "size" is the size of the narrow load. When doing a 4 byte load
> of a an 8 byte field the verifier shifts the literal 1 by 32 places to
> the left. This results in an overflow of a signed integer, which is an
> undefined behavior. Typically the computed mask was zero, so the
> result of the narrow load ended up being zero too.
> 
> Cast the literal to long long to avoid overflows. Note that narrow
> load of the 4 byte fields does not have the undefined behavior,
> because the load size can only be either 1 or 2 bytes, so shifting 1
> by 8 or 16 places will not overflow it. And reading 4 bytes would not
> be a narrow load of a 4 bytes field.
> 
> Reviewed-by: Alban Crequy <alban@kinvolk.io>
> Reviewed-by: Iago López Galeiras <iago@kinvolk.io>
> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  kernel/bpf/verifier.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 09d5d972c9ff..950fac024fbb 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7296,7 +7296,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>  									insn->dst_reg,
>  									shift);
>  				insn_buf[cnt++] = BPF_ALU64_IMM(BPF_AND, insn->dst_reg,
> -								(1 << size * 8) - 1);
> +								(1ULL << size * 8) - 1);
>  			}

Makes sense, good catch & thanks for the fix!

Could you also add a test case to test_verifier.c so we keep track of this?

Thanks,
Daniel
