Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B98345D92
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCWMDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhCWMCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 08:02:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDABC061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 05:02:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lOfk3-0004Ua-HL; Tue, 23 Mar 2021 13:02:35 +0100
Date:   Tue, 23 Mar 2021 13:02:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ipsec] xfrm: Provide private skb extensions for segmented
 and hw offloaded ESP packets
Message-ID: <20210323120235.GI22603@breakpoint.cc>
References: <20210323082559.GO62598@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323082559.GO62598@gauss3.secunet.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steffen Klassert <steffen.klassert@secunet.com> wrote:
> Commit 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec
> crypto offload.") added a XFRM_XMIT flag to avoid duplicate ESP trailer
> insertion on HW offload. This flag is set on the secpath that is shared
> amongst segments. This lead to a situation where some segments are
> not transformed correctly when segmentation happens at layer 3.
> 
> Fix this by using private skb extensions for segmented and hw offloaded
> ESP packets.
> 
> Fixes: 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto offload.")
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  include/linux/skbuff.h  |  1 +
>  net/core/skbuff.c       | 23 ++++++++++++++++++-----
>  net/ipv4/esp4_offload.c | 16 +++++++++++++++-
>  net/ipv6/esp6_offload.c | 16 +++++++++++++++-
>  net/xfrm/xfrm_device.c  |  2 --
>  5 files changed, 49 insertions(+), 9 deletions(-)
> 
> -	if (hw_offload)
> +	if (hw_offload) {
> +		ext = skb_ext_cow(skb->extensions, skb->active_extensions);

It should be possible to do

	if (hw_offload) {
		if (!skb_ext_add(skb, SKB_EXT_SECPATH);
			return -ENOMEM;

		xo = xfrm_offload(skb);
		....

without need for a new 'cow' function.
skb_ext_add() will auto-COW if the extension area has a refcount > 1.
