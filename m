Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD6535A856
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 23:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhDIV21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 17:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234333AbhDIV20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 17:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 169A560233;
        Fri,  9 Apr 2021 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618003693;
        bh=eNa3jc5i+fR9c4G8fW1ZCGp7CEh5VBx8MxhELkQp05g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U1bG8r3if69oR3SMG/Fd+zACaJvsGa4Bu4azB2GKC7/qidHlA2JWQU7fZ1VVhnVzG
         ETkvqZGbqZT0Eu9zruNz+9Q94aeVz40EGtLU5id521aQH2HLoF0ce3wkerC68vHYZv
         rU8ofCqhYsxqXDwkhhnHySnLoD0k+p4g7OZ4pN3OCcAYdsjdoBAYNvVBQFaFL5f1C3
         rnXL3lTA/w4aIk4n7AB/GI6KyE9YEYUEPavA7pG6HdTyNPqXYba+UTn5wpVUTicVUD
         dBRm0M2w7eTvW4IavEk/jAbsKfO3SwPFrFYtEJn0WLPux+9s5Tq2vgXsbutgyFCRAF
         3MicEq9gbPpXw==
Date:   Fri, 9 Apr 2021 14:28:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH net-next 2/3] net: use skb_for_each_frag() helper where
 possible
Message-ID: <20210409142808.11b479ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFnufp0fGEBHnuerrMVLaGUgAP3NYpiEMyW3R-AwDeG=R0sgHQ@mail.gmail.com>
References: <20210409180605.78599-1-mcroce@linux.microsoft.com>
        <20210409180605.78599-3-mcroce@linux.microsoft.com>
        <20210409115455.49e24450@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFnufp0fGEBHnuerrMVLaGUgAP3NYpiEMyW3R-AwDeG=R0sgHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 22:44:50 +0200 Matteo Croce wrote:
> > What pops to mind (although quite nit picky) is the question if the
> > assembly changes much between driver which used to cache nr_frags and
> > now always going skb_shinfo(skb)->nr_frags? It's a relatively common
> > pattern.  
> 
> Since skb_shinfo() is a macro and skb_end_pointer() a static inline,
> it should be the same, but I was curious to check so, this is a diff
> between the following snippet before and afer the macro:
> 
> int frags = skb_shinfo(skb)->nr_frags;
> int i;
> for (i = 0; i < frags; i++)
>     kfree(skb->frags[i]);
> 
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> --- ins1.s 2021-04-09 22:35:59.384523865 +0200
> +++ ins2.s 2021-04-09 22:36:08.132594737 +0200
> @@ -1,26 +1,27 @@
>  iter:
>          movsx   rax, DWORD PTR [rdi+16]
>          mov     rdx, QWORD PTR [rdi+8]
>          mov     eax, DWORD PTR [rdx+rax]
>          test    eax, eax
>          jle     .L6
>          push    rbp
> -        sub     eax, 1
> +        mov     rbp, rdi
>          push    rbx
> -        lea     rbp, [rdi+32+rax*8]
> -        lea     rbx, [rdi+24]
> +        xor     ebx, ebx
>          sub     rsp, 8
>  .L3:
> -        mov     rdi, QWORD PTR [rbx]
> -        add     rbx, 8
> +        mov     rdi, QWORD PTR [rbp+24+rbx*8]
> +        add     rbx, 1
>          call    kfree
> -        cmp     rbx, rbp
> -        jne     .L3
> +        movsx   rax, DWORD PTR [rbp+16]
> +        mov     rdx, QWORD PTR [rbp+8]
> +        cmp     DWORD PTR [rdx+rax], ebx
> +        jg      .L3
>          add     rsp, 8
>          xor     eax, eax
>          pop     rbx
>          pop     rbp
>          ret
>  .L6:
>          xor     eax, eax
>      for (i = 0; i < frags; i++)    ret
> 

So looks like before compiler generated:

	end = &frags[nfrags]
	for (ptr = &frag[0]; ptr < end; ptr++)

and now it has to use the actual value of i, read nfrags in the loop
each time and compare it to i.

That makes sense, since it can't prove kfree() doesn't change nr_frags.

IDK if we care, but at least commit message should mention this.
