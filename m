Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B167250A64C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357491AbiDUQ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbiDUQ4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:56:18 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850E949907;
        Thu, 21 Apr 2022 09:53:28 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nha3X-0008eV-6I; Thu, 21 Apr 2022 18:53:23 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nha3W-000O6u-TK; Thu, 21 Apr 2022 18:53:22 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix prog_tests/uprobe_autoattach
 compilation error
To:     Artem Savkov <asavkov@redhat.com>,
        Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20220421132317.1583867-1-asavkov@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e5919342-0697-65f0-063f-4941e74fe1ca@iogearbox.net>
Date:   Thu, 21 Apr 2022 18:53:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220421132317.1583867-1-asavkov@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26519/Thu Apr 21 10:23:36 2022)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 3:23 PM, Artem Savkov wrote:
> I am getting the following compilation error for prog_tests/uprobe_autoattach.c
> 
> tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c: In function ‘test_uprobe_autoattach’:
> ./test_progs.h:209:26: error: pointer ‘mem’ may be used after ‘free’ [-Werror=use-after-free]
> 
> mem variable is now used in one of the asserts so it shouldn't be freed right
> away. Move free(mem) after the assert block.

Looks good, but I rephrased this a bit to avoid confusion. It's false positive given we
only compare the addresses but don't deref mem, which the compiler might not be able to
follow in this case.

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=6a12b8e20d7e72386594a9dbe7bf2d7fae3b3aa6

Thanks,
Daniel

> Fixes: 1717e248014c ("selftests/bpf: Uprobe tests should verify param/return values")
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>   tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> index d6003dc8cc99..35b87c7ba5be 100644
> --- a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> @@ -34,7 +34,6 @@ void test_uprobe_autoattach(void)
>   
>   	/* trigger & validate shared library u[ret]probes attached by name */
>   	mem = malloc(malloc_sz);
> -	free(mem);
>   
>   	ASSERT_EQ(skel->bss->uprobe_byname_parm1, trigger_val, "check_uprobe_byname_parm1");
>   	ASSERT_EQ(skel->bss->uprobe_byname_ran, 1, "check_uprobe_byname_ran");
> @@ -44,6 +43,8 @@ void test_uprobe_autoattach(void)
>   	ASSERT_EQ(skel->bss->uprobe_byname2_ran, 3, "check_uprobe_byname2_ran");
>   	ASSERT_EQ(skel->bss->uretprobe_byname2_rc, mem, "check_uretprobe_byname2_rc");
>   	ASSERT_EQ(skel->bss->uretprobe_byname2_ran, 4, "check_uretprobe_byname2_ran");
> +
> +	free(mem);
>   cleanup:
>   	test_uprobe_autoattach__destroy(skel);
>   }
> 

