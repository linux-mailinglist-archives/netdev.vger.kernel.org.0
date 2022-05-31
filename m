Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6685399DE
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 01:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348599AbiEaXBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 19:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346457AbiEaXBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 19:01:30 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F16F8D698;
        Tue, 31 May 2022 16:01:29 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nwArS-0004W3-2r; Wed, 01 Jun 2022 01:01:14 +0200
Received: from [85.1.206.226] (helo=linux-2.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nwArR-000Czu-Lw; Wed, 01 Jun 2022 01:01:13 +0200
Subject: Re: [PATCH] selftests net: fix bpf build error
To:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej enczykowski <maze@google.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, rong.a.chen@intel.com,
        kernel test robot <oliver.sang@intel.com>
References: <20220530062126.27808-1-lina.wang@mediatek.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9c462ffc-f2c0-f542-4e61-251571da8c22@iogearbox.net>
Date:   Wed, 1 Jun 2022 01:01:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220530062126.27808-1-lina.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26558/Tue May 31 10:05:17 2022)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/22 8:21 AM, Lina Wang wrote:
> bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add more
> incliding path.
> 
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Lina Wang <lina.wang@mediatek.com>
> ---
>   tools/testing/selftests/net/bpf/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
> index f91bf14bbee7..070251986dbe 100644
> --- a/tools/testing/selftests/net/bpf/Makefile
> +++ b/tools/testing/selftests/net/bpf/Makefile
> @@ -2,6 +2,7 @@
>   
>   CLANG ?= clang
>   CCINCLUDE += -I../../bpf
> +CCINCLUDE += -I../../../../lib
>   CCINCLUDE += -I../../../../../usr/include/
>   
>   TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
> 

 From building the selftest in general, I'm getting:

clang -O2 -target bpf -c bpf/nat6to4.c -I../../bpf -I../../../../lib -I../../../../../usr/include/ -o /root/daniel/bpf/tools/testing/selftests/net/bpf/nat6to4.o
In file included from bpf/nat6to4.c:27:
In file included from /usr/include/linux/bpf.h:11:
/usr/include/linux/types.h:5:10: fatal error: 'asm/types.h' file not found
#include <asm/types.h>
          ^~~~~~~~~~~~~
1 error generated.

Could we reuse the build infra from tools/testing/selftests/bpf/ for nat6to4.c?
