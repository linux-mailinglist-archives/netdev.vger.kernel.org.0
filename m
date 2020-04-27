Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FFE1BB069
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgD0VWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:22:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:47470 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgD0VWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:22:07 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBC0-00021X-HG; Mon, 27 Apr 2020 23:21:32 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTBBz-000JBo-SI; Mon, 27 Apr 2020 23:21:31 +0200
Subject: Re: [PATCH v2] bpf: Fix sk_psock refcnt leak when receiving message
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Lingpeng Chen <forrest0579@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xin Tan <tanxin.ctf@gmail.com>
References: <1587872115-42805-1-git-send-email-xiyuyang19@fudan.edu.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3d57b38c-fe77-4b2d-27e2-1b02c01226fb@iogearbox.net>
Date:   Mon, 27 Apr 2020 23:21:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1587872115-42805-1-git-send-email-xiyuyang19@fudan.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25795/Mon Apr 27 14:00:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 5:35 AM, Xiyu Yang wrote:
> tcp_bpf_recvmsg() invokes sk_psock_get(), which returns a reference of
> the specified sk_psock object to "psock" with increased refcnt.
> 
> When tcp_bpf_recvmsg() returns, local variable "psock" becomes invalid,
> so the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in several exception handling paths
> of tcp_bpf_recvmsg(). When those error scenarios occur such as "flags"
> includes MSG_ERRQUEUE, the function forgets to decrease the refcnt
> increased by sk_psock_get(), causing a refcnt leak.
> 
> Fix this issue by calling sk_psock_put() or pulling up the error queue
> read handling when those error scenarios occur.
> 
> Fixes: e7a5f1f1cd000 ("bpf/sockmap: Read psock ingress_msg before sk_receive_queue")
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied, thanks!
