Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7404F53887B
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 23:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiE3VDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 17:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237509AbiE3VDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 17:03:10 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B77292;
        Mon, 30 May 2022 14:03:08 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvmXW-000Be0-Qm; Mon, 30 May 2022 23:03:02 +0200
Received: from [85.1.206.226] (helo=linux-2.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvmXW-0009iv-CB; Mon, 30 May 2022 23:03:02 +0200
Subject: Re: [PATCH bpf-next v3 4/6] libbpf: Unify memory address casting
 operation style
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20220530092815.1112406-1-pulehui@huawei.com>
 <20220530092815.1112406-5-pulehui@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a31efed5-a436-49c9-4126-902303df9766@iogearbox.net>
Date:   Mon, 30 May 2022 23:03:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220530092815.1112406-5-pulehui@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26557/Mon May 30 10:05:44 2022)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/22 11:28 AM, Pu Lehui wrote:
> The members of bpf_prog_info, which are line_info, jited_line_info,
> jited_ksyms and jited_func_lens, store u64 address pointed to the
> corresponding memory regions. Memory addresses are conceptually
> unsigned, (unsigned long) casting makes more sense, so let's make
> a change for conceptual uniformity.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>   tools/lib/bpf/bpf_prog_linfo.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
> index 5c503096ef43..7beb060d0671 100644
> --- a/tools/lib/bpf/bpf_prog_linfo.c
> +++ b/tools/lib/bpf/bpf_prog_linfo.c
> @@ -127,7 +127,8 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
>   	prog_linfo->raw_linfo = malloc(data_sz);
>   	if (!prog_linfo->raw_linfo)
>   		goto err_free;
> -	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
> +	memcpy(prog_linfo->raw_linfo, (void *)(unsigned long)info->line_info,
> +	       data_sz);

Took in patch 1-3, lgtm, thanks! My question around the cleanups in patch 4-6 ...
there are various other such cases e.g. in libbpf, perhaps makes sense to clean all
of them up at once and not just the 4 locations in here.

Thanks,
Daniel
