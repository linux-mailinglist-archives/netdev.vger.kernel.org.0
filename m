Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14A3168970
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBUVlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:41:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:48852 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgBUVlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 16:41:21 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j5G2w-0002vi-Uj; Fri, 21 Feb 2020 22:41:19 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j5G2w-000Aca-Lk; Fri, 21 Feb 2020 22:41:18 +0100
Subject: Re: [PATCH bpf-next v7 00/11] Extend SOCKMAP/SOCKHASH to store
 listening sockets
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c86784f5-ef2c-cfd6-cb75-a67af7e11c3c@iogearbox.net>
Date:   Fri, 21 Feb 2020 22:41:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200218171023.844439-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25730/Fri Feb 21 13:08:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 6:10 PM, Jakub Sitnicki wrote:
> This patch set turns SOCK{MAP,HASH} into generic collections for TCP
> sockets, both listening and established. Adding support for listening
> sockets enables us to use these BPF map types with reuseport BPF programs.
> 
> Why? SOCKMAP and SOCKHASH, in comparison to REUSEPORT_SOCKARRAY, allow the
> socket to be in more than one map at the same time.
> 
> Having a BPF map type that can hold listening sockets, and gracefully
> co-exist with reuseport BPF is important if, in the future, we want
> BPF programs that run at socket lookup time [0]. Cover letter for v1 of
> this series tells the full story of how we got here [1].
> 
> Although SOCK{MAP,HASH} are not a drop-in replacement for SOCKARRAY just
> yet, because UDP support is lacking, it's a step in this direction. We're
> working with Lorenz on extending SOCK{MAP,HASH} to hold UDP sockets, and
> expect to post RFC series for sockmap + UDP in the near future.
> 
> I've dropped Acks from all patches that have been touched since v6.
> 
> The audit for missing READ_ONCE annotations for access to sk_prot is
> ongoing. Thus far I've found one location specific to TCP listening sockets
> that needed annotating. This got fixed it in this iteration. I wonder if
> sparse checker could be put to work to identify places where we have
> sk_prot access while not holding sk_lock...
> 
> The patch series depends on another one, posted earlier [2], that has been
> split out of it.
> 
> Thanks,
> jkbs
> 
> [0] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> [1] https://lore.kernel.org/bpf/20191123110751.6729-1-jakub@cloudflare.com/
> [2] https://lore.kernel.org/bpf/20200217121530.754315-1-jakub@cloudflare.com/
> 
> v6 -> v7:
> 
> - Extended the series to cover SOCKHASH. (patches 4-8, 10-11) (John)
> 
> - Rebased onto recent bpf-next. Resolved conflicts in recent fixes to
>    sk_state checks on sockmap/sockhash update path. (patch 4)
> 
> - Added missing READ_ONCE annotation in sock_copy. (patch 1)
> 
> - Split out patches that simplify sk_psock_restore_proto [2].

Applied, thanks!
