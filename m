Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93510181996
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgCKNXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:23:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:52204 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgCKNXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:23:34 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC1KR-0003Tr-Kh; Wed, 11 Mar 2020 14:23:19 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC1KQ-0005iM-Nt; Wed, 11 Mar 2020 14:23:19 +0100
Subject: Re: [PATCH bpf-next] bpf: Fix trampoline generation for fmod_ret
 programs
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     kpsingh@google.com, jannh@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20200311003906.3643037-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bcf81455-6b78-1ff2-d5db-3b203696b8f0@iogearbox.net>
Date:   Wed, 11 Mar 2020 14:23:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200311003906.3643037-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25748/Wed Mar 11 12:08:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/20 1:39 AM, Alexei Starovoitov wrote:
> fmod_ret progs are emitted as:
> 
> start = __bpf_prog_enter();
> call fmod_ret
> *(u64 *)(rbp - 8) = rax
> __bpf_prog_exit(, start);
> test eax, eax
> jne do_fexit
> 
> That 'test eax, eax' is working by accident. The compiler is free to use rax
> inside __bpf_prog_exit() or inside functions that __bpf_prog_exit() is calling.
> Which caused "test_progs -t modify_return" to sporadically fail depending on
> compiler version and kconfig. Fix it by using 'cmp [rbp - 8], 0' instead of
> 'test eax, eax'.
> 
> Fixes: ae24082331d9 ("bpf: Introduce BPF_MODIFY_RETURN")
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
