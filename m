Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C07D963D6
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbfHTPLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:11:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:41682 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729847AbfHTPLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:11:30 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05nC-0000ZY-30; Tue, 20 Aug 2019 17:11:26 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05nB-000Sxp-QN; Tue, 20 Aug 2019 17:11:25 +0200
Subject: Re: [PATCH] test_bpf: Fix a new clang warning about xor-ing two
 numbers
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20190819043419.68223-1-natechancellor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <636449fa-9bfb-2c1e-af20-2ddac83a2143@iogearbox.net>
Date:   Tue, 20 Aug 2019 17:11:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190819043419.68223-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25547/Tue Aug 20 10:27:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/19 6:34 AM, Nathan Chancellor wrote:
> r369217 in clang added a new warning about potential misuse of the xor
> operator as an exponentiation operator:
> 
> ../lib/test_bpf.c:870:13: warning: result of '10 ^ 300' is 294; did you
> mean '1e300'? [-Wxor-used-as-pow]
>                  { { 4, 10 ^ 300 }, { 20, 10 ^ 300 } },
>                         ~~~^~~~~
>                         1e300
> ../lib/test_bpf.c:870:13: note: replace expression with '0xA ^ 300' to
> silence this warning
> ../lib/test_bpf.c:870:31: warning: result of '10 ^ 300' is 294; did you
> mean '1e300'? [-Wxor-used-as-pow]
>                  { { 4, 10 ^ 300 }, { 20, 10 ^ 300 } },
>                                           ~~~^~~~~
>                                           1e300
> ../lib/test_bpf.c:870:31: note: replace expression with '0xA ^ 300' to
> silence this warning
> 
> The commit link for this new warning has some good logic behind wanting
> to add it but this instance appears to be a false positive. Adopt its
> suggestion to silence the warning but not change the code. According to
> the differential review link in the clang commit, GCC may eventually
> adopt this warning as well.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/643
> Link: https://github.com/llvm/llvm-project/commit/920890e26812f808a74c60ebc14cc636dac661c1
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks!
