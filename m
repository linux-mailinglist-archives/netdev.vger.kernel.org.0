Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6F1560D3
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 22:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBGVuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 16:50:18 -0500
Received: from www62.your-server.de ([213.133.104.62]:50278 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgBGVuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 16:50:18 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j0BVn-0006gr-L0; Fri, 07 Feb 2020 22:50:07 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j0BVn-000Qza-62; Fri, 07 Feb 2020 22:50:07 +0100
Subject: Re: [PATCH bpf] bpf: sockmap: check update requirements after locking
To:     Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200207103713.28175-1-lmb@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <287e09b1-e510-4891-8d38-3a85e7a2efd4@iogearbox.net>
Date:   Fri, 7 Feb 2020 22:50:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200207103713.28175-1-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25717/Fri Feb  7 12:45:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/20 11:37 AM, Lorenz Bauer wrote:
> It's currently possible to insert sockets in unexpected states into
> a sockmap, due to a TOCTTOU when updating the map from a syscall.
> sock_map_update_elem checks that sk->sk_state == TCP_ESTABLISHED,
> locks the socket and then calls sock_map_update_common. At this
> point, the socket may have transitioned into another state, and
> the earlier assumptions don't hold anymore. Crucially, it's
> conceivable (though very unlikely) that a socket has become unhashed.
> This breaks the sockmap's assumption that it will get a callback
> via sk->sk_prot->unhash.
> 
> Fix this by checking the (fixed) sk_type and sk_protocol without the
> lock, followed by a locked check of sk_state.
> 
> Unfortunately it's not possible to push the check down into
> sock_(map|hash)_update_common, since BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB
> run before the socket has transitioned from TCP_SYN_RECV into
> TCP_ESTABLISHED.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")

Applied, thanks!
