Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD9454E5EC
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377436AbiFPPXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350792AbiFPPXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:23:02 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D92205EC;
        Thu, 16 Jun 2022 08:23:01 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1rKi-000FQv-K2; Thu, 16 Jun 2022 17:22:56 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1rKi-0006SR-C4; Thu, 16 Jun 2022 17:22:56 +0200
Subject: Re: [RFC bpf] selftests/bpf: Curious case of a successful tailcall
 that returns to caller
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
References: <20220616110252.418333-1-jakub@cloudflare.com>
 <YqtFgYkUsM8VMWRy@boxer>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d7a52f4c-9bad-da94-2501-015bdde32e97@iogearbox.net>
Date:   Thu, 16 Jun 2022 17:22:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YqtFgYkUsM8VMWRy@boxer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26574/Thu Jun 16 10:06:40 2022)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/22 5:00 PM, Maciej Fijalkowski wrote:
> On Thu, Jun 16, 2022 at 01:02:52PM +0200, Jakub Sitnicki wrote:
>> While working aarch64 JIT to allow mixing bpf2bpf calls with tailcalls, I
>> noticed unexpected tailcall behavior in x86 JIT.
>>
>> I don't know if it is by design or a bug. The bpf_tail_call helper
>> documentation says that the user should not expect the control flow to
>> return to the previous program, if the tail call was successful:
>>
>>> If the call succeeds, the kernel immediately runs the first
>>> instruction of the new program. This is not a function call,
>>> and it never returns to the previous program.
>>
>> However, when a tailcall happens from a subprogram, that is after a bpf2bpf
>> call, that is not the case. We return to the caller program because the
>> stack destruction is too shallow. BPF stack of just the top-most BPF
>> function gets destroyed.
>>
>> This in turn allows the return value of the tailcall'ed program to get
>> overwritten, as the test below test demonstrates. It currently fails on
>> x86:
> 
> Disclaimer: some time has passed by since I looked into this :P
> 
> To me the bug would be if test would have returned 1 in your case. If I
> recall correctly that was the design choice, so tailcalls when mixed with
> bpf2bpf will consume current stack frame. When tailcall happens from
> subprogram then we would return to the caller of this subprog. We added
> logic to verifier that checks if this (tc + bpf2bpf) mix wouldn't cause
> stack overflow. We even limit the stack frame size to 256 in such case.

Yes, that is the desired behavior, so return 2 from your example below looks
correct / expected:

+SEC("tc")
+int classifier_0(struct __sk_buff *skb __unused)
+{
+	done = 1;
+	return 0;
+}
+
+static __noinline
+int subprog_tail(struct __sk_buff *skb)
+{
+	bpf_tail_call_static(skb, &jmp_table, 0);
+	return 1;
+}
+
+SEC("tc")
+int entry(struct __sk_buff *skb)
+{
+	subprog_tail(skb);
+	return 2;
+}

> Cilium docs explain this:
> https://docs.cilium.io/en/latest/bpf/#bpf-to-bpf-calls
