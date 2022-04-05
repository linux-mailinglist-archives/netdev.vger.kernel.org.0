Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82AD4F53E4
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2359609AbiDFEYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585461AbiDEX74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:59:56 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2D637037;
        Tue,  5 Apr 2022 15:18:11 -0700 (PDT)
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nbrUx-0007Bs-JV; Wed, 06 Apr 2022 00:18:03 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nbrUx-000Q5a-4g; Wed, 06 Apr 2022 00:18:03 +0200
Subject: Re: [PATCH bpf v4] bpf: Support dual-stack sockets in
 bpf_tcp_check_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Arthur Fabre <afabre@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220329133001.2283509-1-maximmi@nvidia.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ece21940-90fc-2bf7-19da-770cf0956542@iogearbox.net>
Date:   Wed, 6 Apr 2022 00:18:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220329133001.2283509-1-maximmi@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26503/Tue Apr  5 10:19:26 2022)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Maxim,

On 3/29/22 3:30 PM, Maxim Mikityanskiy wrote:
> bpf_tcp_gen_syncookie looks at the IP version in the IP header and
> validates the address family of the socket. It supports IPv4 packets in
> AF_INET6 dual-stack sockets.
> 
> On the other hand, bpf_tcp_check_syncookie looks only at the address
> family of the socket, ignoring the real IP version in headers, and
> validates only the packet size. This implementation has some drawbacks:
> 
> 1. Packets are not validated properly, allowing a BPF program to trick
>     bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
>     socket.
> 
> 2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
>     up receiving a SYNACK with the cookie, but the following ACK gets
>     dropped.
> 
> This patch fixes these issues by changing the checks in
> bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
> version from the header is taken into account, and it is validated
> properly with address family.
> 
> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Could you do one final spin (while retaining Arthur's Ack) by splitting
off the selftest into a separate commit? Otherwise stable folks likely
won't be able to pick the fix up. Otherwise lgtm.

Thanks,
Daniel
