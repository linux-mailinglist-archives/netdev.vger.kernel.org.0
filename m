Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C3E349B68
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 22:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYVHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 17:07:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:36552 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhCYVHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 17:07:15 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lPXCB-0007ix-HM; Thu, 25 Mar 2021 22:07:11 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lPXCB-000GzT-Cx; Thu, 25 Mar 2021 22:07:11 +0100
Subject: Re: [bpf PATCH] bpf, selftests: test_maps generating unrecognized
 data section
To:     John Fastabend <john.fastabend@gmail.com>, andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com
References: <161661993201.29133.10763175125024005438.stgit@john-Precision-5820-Tower>
 <161662006586.29133.187705917710998342.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <013bbba5-ae52-f472-02ad-8530cc8b665a@iogearbox.net>
Date:   Thu, 25 Mar 2021 22:07:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <161662006586.29133.187705917710998342.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26120/Thu Mar 25 12:15:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 10:07 PM, John Fastabend wrote:
> With a relatively recent clang master branch test_map skips a section,
> 
>   libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
> 
> the cause is some pointless strings from bpf_printks in the BPF program
> loaded during testing. Remove them so we stop tripping our test bots.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |    3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> index fdb4bf4408fa..0f603253f4ed 100644
> --- a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> +++ b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> @@ -16,10 +16,7 @@ int bpf_prog1(struct sk_msg_md *msg)
>   	if (data + 8 > data_end)
>   		return SK_DROP;
>   
> -	bpf_printk("data length %i\n", (__u64)msg->data_end - (__u64)msg->data);
>   	d = (char *)data;

Do we still need 'd' as well in that case, or the data + 8 > data_end test if we don't
read any of the data? I'm not sure what was the original purpose of the prog, perhaps
just to test that we can attach /something/ in general? Maybe in that case empty prog
is sufficient if we don't do anything useful with the rest?

> -	bpf_printk("hello sendmsg hook %i %i\n", d[0], d[1]);
> -
>   	return SK_PASS;
>   }
>   
> 

