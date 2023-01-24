Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE75679E77
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 17:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbjAXQVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 11:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbjAXQVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 11:21:32 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32064ABEA;
        Tue, 24 Jan 2023 08:21:28 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pKM2x-0007MD-Fm; Tue, 24 Jan 2023 17:21:19 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pKM2w-000AGl-Ro; Tue, 24 Jan 2023 17:21:18 +0100
Subject: Re: [PATCH] selftests/bpf: fix vmtest static compilation error
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20230121064128.67914-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <32195f48-8b45-1a78-1964-dfe7b5a4933f@iogearbox.net>
Date:   Tue, 24 Jan 2023 17:21:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230121064128.67914-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26791/Tue Jan 24 09:27:43 2023)
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/23 7:41 AM, Daniel T. Lee wrote:
> As stated in README.rst, in order to resolve errors with linker errors,
> 'LDLIBS=-static' should be used. Most problems will be solved by this
> option, but in the case of urandom_read, this won't fix the problem. So
> the Makefile is currently implemented to strip the 'static' option when
> compiling the urandom_read. However, stripping this static option isn't
> configured properly on $(LDLIBS) correctly, which is now causing errors
> on static compilation.
> 
>      # LDLIBS=-static ./vmtest.sh
>      ld.lld: error: attempted static link of dynamic object liburandom_read.so
>      clang: error: linker command failed with exit code 1 (use -v to see invocation)
>      make: *** [Makefile:190: /linux/tools/testing/selftests/bpf/urandom_read] Error 1
>      make: *** Waiting for unfinished jobs....
> 
> This commit fixes this problem by configuring the strip with $(LDLIBS).
> 
> Fixes: 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>   tools/testing/selftests/bpf/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 22533a18705e..7bd1ce9c8d87 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -188,7 +188,7 @@ $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
>   $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
>   	$(call msg,BINARY,,$@)
>   	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^) \
> -		     liburandom_read.so $(LDLIBS)			       \
> +		     liburandom_read.so $(filter-out -static,$(LDLIBS))	     \

Do we need the same also for liburandom_read.so target's $(LDLIBS) further above?

>   		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
>   		     -Wl,-rpath=. -o $@
>   
> 

