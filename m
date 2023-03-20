Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6D6C1047
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCTLID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjCTLHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:07:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D74D449C;
        Mon, 20 Mar 2023 04:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CD3AB80E39;
        Mon, 20 Mar 2023 11:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA8EC433D2;
        Mon, 20 Mar 2023 11:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679310198;
        bh=FE/th3Oj5FXqMW7qvNabQKdlCzCJHk9jDGONrfYIemE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VzjcxNbvQoEFFvmZ1Ih3G6Xh0c82ftIijBX0LrZfjd7G8j7ML2+++vAVcL3Dp3EMU
         0Ztp7TA2sNzCeAN+QInBNteV/XjG7ZlqU7V2op8kCb6X+3vVA6+hN+8LdWwGr5si3K
         SKX3vU8LE/uJ3Hk6paZpMPsfUJ8FqYZ1uuyunlRqsTdZm2zBsHhkb3LfE1J+cl3TeK
         goikisadNJJEW3TB2/4nrpjgO/rpTrjMPC+2NKh48giU/1JdWbXxzmOmPB/VlxiGBy
         fszOjloouN/kRGdAa9G0g8tXUt+VK3AitjIUF23hz+gWcGyGJuh5bvk9tUmLo1xcgo
         6uGAjA2omCX3w==
Date:   Mon, 20 Mar 2023 13:03:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nuno =?iso-8859-1?Q?Gon=E7alves?= <nunog@fr24.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] xsk: allow remap of fill and/or completion rings
Message-ID: <20230320110314.GJ36557@unreal>
References: <20230320105323.187307-1-nunog@fr24.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320105323.187307-1-nunog@fr24.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 10:53:23AM +0000, Nuno Gonçalves wrote:
> The remap of fill and completion rings was frowned upon as they
> control the usage of UMEM which does not support concurrent use.
> At the same time this would disallow the remap of this rings
> into another process.
> 
> A possible use case is that the user wants to transfer the socket/
> UMEM ownerwhip to another process (via SYS_pidfd_getfd) and so
> would need to also remap this rings.
> 
> This will have no impact on current usages and just relaxes the
> remap limitation.
> 
> Signed-off-by: Nuno Gonçalves <nunog@fr24.com>
> ---
>  net/xdp/xsk.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 2ac58b282b5eb..2af4ff64b22bd 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -1300,10 +1300,11 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>  {
>  	loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
>  	unsigned long size = vma->vm_end - vma->vm_start;
> +	int state = READ_ONCE(xs->state);
>  	struct xdp_sock *xs = xdp_sk(sock->sk);
>  	struct xsk_queue *q = NULL;
>  
> -	if (READ_ONCE(xs->state) != XSK_READY)
> +	if (!(state == XSK_READY || state == XSK_BOUND))

This if(..) is actually:
 if (state != XSK_READY && state != XSK_BOUND)

Thanks
