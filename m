Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2DE260385
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgIGRuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbgIGRud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 13:50:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9F0206B5;
        Mon,  7 Sep 2020 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599501033;
        bh=zfiMDHSm/3DxWRI4PM6CSYLMm6VbRQOG91VXXMxoeQE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BWYD2OmcAzM52JYsE5SExWc8mxH1azryhC30jgeDIt2Lk1rRISSDR6wwVi+Ay8lNt
         jWBm0c37BhaYKr/tm/gAYS+1PKNjDMiNKboS2XHf2MKiFJOysvP+Fiq8v3rt0g8ifO
         VfNXJHbKhlYZuwqHNHrDDL3f15llwHygs1W/9W28=
Date:   Mon, 7 Sep 2020 10:50:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: tracepoint: fix print wrong sysctl_mem value
Message-ID: <20200907105030.6e70adc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907144757.43389-1-dust.li@linux.alibaba.com>
References: <20200907144757.43389-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 22:47:57 +0800 Dust Li wrote:
> sysctl_mem is an point, and tracepoint entry do not support
> been visited like an array. Use 3 long type to get sysctl_mem
> instead.
> 
> tracpoint output with and without this fix:
> - without fix:
>    28821.074 sock:sock_exceed_buf_limit:proto:UDP
>    sysctl_mem=-1741233440,19,322156906942464 allocated=19 sysctl_rmem=4096
>    rmem_alloc=75008 sysctl_wmem=4096 wmem_alloc=1 wmem_queued=0
>    kind=SK_MEM_RECV
> 
> - with fix:
>   2126.136 sock:sock_exceed_buf_limit:proto:UDP
>   sysctl_mem=18,122845,184266 allocated=19 sysctl_rmem=4096
>   rmem_alloc=73728 sysctl_wmem=4096 wmem_alloc=1 wmem_queued=0
>   kind=SK_MEM_RECV
> 
> Fixes: 3847ce32aea9fdf ("core: add tracepoints for queueing skb to rcvbuf")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  include/trace/events/sock.h | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
> index a966d4b5ab37..9118dd2353b7 100644
> --- a/include/trace/events/sock.h
> +++ b/include/trace/events/sock.h
> @@ -98,7 +98,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
>  
>  	TP_STRUCT__entry(
>  		__array(char, name, 32)
> -		__field(long *, sysctl_mem)
> +		__field(long, sysctl_mem0)
> +		__field(long, sysctl_mem1)
> +		__field(long, sysctl_mem2)

Why not make it an __array() ?

>  		__field(long, allocated)
>  		__field(int, sysctl_rmem)
>  		__field(int, rmem_alloc)
