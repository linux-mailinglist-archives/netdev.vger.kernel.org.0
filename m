Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA83188F23
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCQUit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgCQUis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 16:38:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A52CA20714;
        Tue, 17 Mar 2020 20:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584477528;
        bh=VHD4rAkbSaoUgPN7k0Fur2+SkX2RyJSccvlCjAt8Z18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j6QYJU1jNGkpJS9it+Rc/9eP02/CVKgqnMDKGMgGnIa5kKu7cIkyA84Kxgc/KgMmH
         qX6KCucXiJJyAuWbaBrxwWz+F4/Vov99VBN1zirFc8zHBizkJ1cfUOWRurMKv7Qn/K
         kVs717U8rve2VPQA51UykNqcf7PV7MckDlgZFWEw=
Date:   Tue, 17 Mar 2020 13:38:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v1 09/15] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
Message-ID: <20200317133846.3c7fffe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <158446619342.702578.1522482431365026926.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
        <158446619342.702578.1522482431365026926.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 18:29:53 +0100 Jesper Dangaard Brouer wrote:
> To reviewers: Need some opinions if this is needed?
> 
> (TODO: Squash patch)

I'd vote we don't clear, since we don't clear in adjust head.

We could also add some wrapper around memset() which could be compiled
out based on some CONFIG_ but that could be seen as just moving the
responsibility onto the user..

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 0ceddee0c678..669f29992177 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3432,6 +3432,12 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>  	if (unlikely(data_end < xdp->data + ETH_HLEN))
>  		return -EINVAL;
>  
> +	// XXX: To reviewers: How paranoid are we? Do we really need to
> +	/* clear memory area on grow, as in-theory can contain uninit kmem */
> +	if (offset > 0) {
> +		memset(xdp->data_end, 0, offset);
> +	}
> +
>  	xdp->data_end = data_end;
>  
>  	return 0;
> 
> 

