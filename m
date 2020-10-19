Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87066292D7B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 20:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgJSSXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 14:23:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:35512 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730619AbgJSSXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 14:23:41 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUZom-0008GD-Lk; Mon, 19 Oct 2020 20:23:36 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUZom-000KBJ-GR; Mon, 19 Oct 2020 20:23:36 +0200
Subject: Re: [PATCH bpf 1/2] bpf_redirect_neigh: Support supplying the nexthop
 as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160312349392.7917.6673239142315191801.stgit@toke.dk>
 <160312349501.7917.13131363910387009253.stgit@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3785e450-313f-c6f0-2742-716c10b6f8a4@iogearbox.net>
Date:   Mon, 19 Oct 2020 20:23:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160312349501.7917.13131363910387009253.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25962/Mon Oct 19 15:57:02 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 6:04 PM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Based on the discussion in [0], update the bpf_redirect_neigh() helper to
> accept an optional parameter specifying the nexthop information. This makes
> it possible to combine bpf_fib_lookup() and bpf_redirect_neigh() without
> incurring a duplicate FIB lookup - since the FIB lookup helper will return
> the nexthop information even if no neighbour is present, this can simply be
> passed on to bpf_redirect_neigh() if bpf_fib_lookup() returns
> BPF_FIB_LKUP_RET_NO_NEIGH.
> 
> [0] https://lore.kernel.org/bpf/393e17fc-d187-3a8d-2f0d-a627c7c63fca@iogearbox.net/
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Looks good to me, thanks! I'll wait till David gets a chance as well to review.
One thing that would have made sense to me (probably worth a v2) is to keep the
fib lookup flag you had back then, meaning sth like BPF_FIB_SKIP_NEIGH which
would then return a BPF_FIB_LKUP_RET_NO_NEIGH before doing the neigh lookup inside
the bpf_ipv{4,6}_fib_lookup() so that programs can just unconditionally use the
combination of bpf_fib_lookup(skb, [...], BPF_FIB_SKIP_NEIGH) with the
bpf_redirect_neigh([...]) extension in that case and not do this bpf_redirect()
vs bpf_redirect_neigh() dance as you have in the selftest in patch 2/2.

Thanks,
Daniel
