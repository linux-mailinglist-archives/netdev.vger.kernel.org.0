Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4152425299
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbfEUOsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:48:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:50624 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728337AbfEUOsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:48:06 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT63f-0001h5-Vg; Tue, 21 May 2019 16:48:04 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT63f-000BH8-Mx; Tue, 21 May 2019 16:48:03 +0200
Subject: Re: [PATCH bpf] bpf: Check sk_fullsock() before returning from
 bpf_sk_lookup()
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>, kernel-team@fb.com,
        Joe Stringer <joe@isovalent.com>
References: <20190517212117.2792415-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <83f40245-7953-9f5c-3191-3d9f4d50f9bb@iogearbox.net>
Date:   Tue, 21 May 2019 16:48:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190517212117.2792415-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/17/2019 11:21 PM, Martin KaFai Lau wrote:
> The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_NULL.
> Meaning a fullsock ptr and its fullsock's fields in bpf_sock can be
> accessed, e.g. type, protocol, mark and priority.
> Some new helper, like bpf_sk_storage_get(), also expects
> ARG_PTR_TO_SOCKET is a fullsock.
> 
> bpf_sk_lookup() currently calls sk_to_full_sk() before returning.
> However, the ptr returned from sk_to_full_sk() is not guaranteed
> to be a fullsock.  For example, it cannot get a fullsock if sk
> is in TCP_TIME_WAIT.
> 
> This patch checks for sk_fullsock() before returning. If it is not
> a fullsock, sock_gen_put() is called if needed and then returns NULL.
> 
> Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> Cc: Joe Stringer <joe@isovalent.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
