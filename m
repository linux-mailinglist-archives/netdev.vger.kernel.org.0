Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3585D33323D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCJATw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:19:52 -0500
Received: from www62.your-server.de ([213.133.104.62]:41512 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCJATZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:19:25 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJmZL-0007q8-Te; Wed, 10 Mar 2021 01:19:19 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lJmZL-000UiR-Ku; Wed, 10 Mar 2021 01:19:19 +0100
Subject: Re: [PATCH bpf-next v6 0/2] Optimize
 bpf_redirect_map()/xdp_do_redirect()
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
References: <20210308112907.559576-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8a094161-56fc-e6f6-3108-e5758f3bf977@iogearbox.net>
Date:   Wed, 10 Mar 2021 01:19:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210308112907.559576-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26103/Tue Mar  9 13:03:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 12:29 PM, Björn Töpel wrote:
> Hi XDP-folks,
> 
> This two patch series contain two optimizations for the
> bpf_redirect_map() helper and the xdp_do_redirect() function.
> 
> The bpf_redirect_map() optimization is about avoiding the map lookup
> dispatching. Instead of having a switch-statement and selecting the
> correct lookup function, we let bpf_redirect_map() be a map operation,
> where each map has its own bpf_redirect_map() implementation. This way
> the run-time lookup is avoided.
> 
> The xdp_do_redirect() patch restructures the code, so that the map
> pointer indirection can be avoided.
> 
> Performance-wise I got 4% improvement for XSKMAP
> (sample:xdpsock/rx-drop), and 8% (sample:xdp_redirect_map) on my
> machine.
> 
> @Jesper/@Toke I kept your Acked-by: for patch 2. Let me know, if you
> don't agree with that decision.
> 
> More details in each commit.
> 
> Changelog:
> v5->v6:  Removed REDIR enum, and instead use map_id and map_type. (Daniel)
>           Applied Daniel's fixups on patch 1. (Daniel)
> v4->v5:  Renamed map operation to map_redirect. (Daniel)
> v3->v4:  Made bpf_redirect_map() a map operation. (Daniel)
> v2->v3:  Fix build when CONFIG_NET is not set. (lkp)
> v1->v2:  Removed warning when CONFIG_BPF_SYSCALL was not set. (lkp)
>           Cleaned up case-clause in xdp_do_generic_redirect_map(). (Toke)
>           Re-added comment. (Toke)
> rfc->v1: Use map_id, and remove bpf_clear_redirect_map(). (Toke)
>           Get rid of the macro and use __always_inline. (Jesper)

Applied, thanks!
