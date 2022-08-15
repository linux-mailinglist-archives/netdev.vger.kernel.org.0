Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135BB594E81
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiHPCJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241251AbiHPCJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:09:29 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E173722F1F2;
        Mon, 15 Aug 2022 15:04:57 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNiCb-0002dT-7C; Tue, 16 Aug 2022 00:04:53 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNiCa-000N3M-Tl; Tue, 16 Aug 2022 00:04:52 +0200
Subject: Re: [PATCH v3 bpf-next 00/15] bpf: net: Remove duplicated code from
 bpf_setsockopt()
To:     sdf@google.com, Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
References: <20220810190724.2692127-1-kafai@fb.com>
 <YvU2md/W4YSlnkBH@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1b791103-1f8d-bc08-3f65-7c1b2316e2c3@iogearbox.net>
Date:   Tue, 16 Aug 2022 00:04:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YvU2md/W4YSlnkBH@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26628/Mon Aug 15 09:51:41 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/22 7:04 PM, sdf@google.com wrote:
> On 08/10, Martin KaFai Lau wrote:
>> The code in bpf_setsockopt() is mostly a copy-and-paste from
>> the sock_setsockopt(), do_tcp_setsockopt(), do_ipv6_setsockopt(),
>> and do_ip_setsockopt().  As the allowed optnames in bpf_setsockopt()
>> grows, so are the duplicated code.  The code between the copies
>> also slowly drifted.
> 
>> This set is an effort to clean this up and reuse the existing
>> {sock,do_tcp,do_ipv6,do_ip}_setsockopt() as much as possible.
> 
>> After the clean up, this set also adds a few allowed optnames
>> that we need to the bpf_setsockopt().
> 
>> The initial attempt was to clean up both bpf_setsockopt() and
>> bpf_getsockopt() together.  However, the patch set was getting
>> too long.  It is beneficial to leave the bpf_getsockopt()
>> out for another patch set.  Thus, this set is focusing
>> on the bpf_setsockopt().
> 
>> v3:
>> - s/in_bpf/has_current_bpf_ctx/ (Andrii)
>> - Add comments to has_current_bpf_ctx() and sockopt_lock_sock()
>>    (Stanislav)
>> - Use vmlinux.h in selftest and add defines to bpf_tracing_net.h
>>    (Stanislav)
>> - Use bpf_getsockopt(SO_MARK) in selftest (Stanislav)
>> - Use BPF_CORE_READ_BITFIELD in selftest (Yonghong)
> 
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> 
> (I didn't go super deep on the selftest)

Looks like that one throws a build error, fwiw:

https://github.com/kernel-patches/bpf/runs/7844497492?check_suite_focus=true

   [...]
     CLNG-BPF [test_maps] kfunc_call_test_subprog.o
     CLNG-BPF [test_maps] bpf_iter_test_kern6.o
   progs/setget_sockopt.c:39:33: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
           { .opt = SO_REUSEADDR, .flip = 1, },
                                          ^
   progs/setget_sockopt.c:42:33: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
           { .opt = SO_KEEPALIVE, .flip = 1, },
                                          ^
   progs/setget_sockopt.c:44:33: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
           { .opt = SO_REUSEPORT, .flip = 1, },
                                          ^
     CLNG-BPF [test_maps] btf__core_reloc_type_id.o
   progs/setget_sockopt.c:48:32: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
           { .opt = SO_TXREHASH, .flip = 1, },
                                         ^
   progs/setget_sockopt.c:53:32: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
           { .opt = TCP_NODELAY, .flip = 1, },
                                         ^
   progs/setget_sockopt.c:61:45: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
           { .opt = TCP_THIN_LINEAR_TIMEOUTS, .flip = 1, },
                                                      ^
   progs/setget_sockopt.c:75:39: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
           { .opt = IPV6_AUTOFLOWLABEL, .flip = 1, },
                                                ^
   7 errors generated.
   make: *** [Makefile:521: /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/setget_sockopt.o] Error 1
   make: *** Waiting for unfinished jobs....
   make: Leaving directory '/tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf'
   Error: Process completed with exit code 2.
