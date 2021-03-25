Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5606B348BD5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCYIqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:46:24 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48850 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhCYIqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:46:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 38E1420184;
        Thu, 25 Mar 2021 09:46:11 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id roXsiONiVYKB; Thu, 25 Mar 2021 09:46:10 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9D78820571;
        Thu, 25 Mar 2021 09:46:08 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 09:46:08 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 25 Mar
 2021 09:46:08 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C0D573180307; Thu, 25 Mar 2021 09:46:07 +0100 (CET)
Date:   Thu, 25 Mar 2021 09:46:07 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: Provide private skb extensions for segmented
 and hw offloaded ESP packets
Message-ID: <20210325084607.GX62598@gauss3.secunet.de>
References: <20210323082559.GO62598@gauss3.secunet.de>
 <20210323120235.GI22603@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210323120235.GI22603@breakpoint.cc>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 01:02:35PM +0100, Florian Westphal wrote:
> Steffen Klassert <steffen.klassert@secunet.com> wrote:
> > Commit 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec
> > crypto offload.") added a XFRM_XMIT flag to avoid duplicate ESP trailer
> > insertion on HW offload. This flag is set on the secpath that is shared
> > amongst segments. This lead to a situation where some segments are
> > not transformed correctly when segmentation happens at layer 3.
> > 
> > Fix this by using private skb extensions for segmented and hw offloaded
> > ESP packets.
> > 
> > Fixes: 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto offload.")
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > ---
> >  include/linux/skbuff.h  |  1 +
> >  net/core/skbuff.c       | 23 ++++++++++++++++++-----
> >  net/ipv4/esp4_offload.c | 16 +++++++++++++++-
> >  net/ipv6/esp6_offload.c | 16 +++++++++++++++-
> >  net/xfrm/xfrm_device.c  |  2 --
> >  5 files changed, 49 insertions(+), 9 deletions(-)
> > 
> > -	if (hw_offload)
> > +	if (hw_offload) {
> > +		ext = skb_ext_cow(skb->extensions, skb->active_extensions);
> 
> It should be possible to do
> 
> 	if (hw_offload) {
> 		if (!skb_ext_add(skb, SKB_EXT_SECPATH);
> 			return -ENOMEM;
> 
> 		xo = xfrm_offload(skb);
> 		....
> 
> without need for a new 'cow' function.
> skb_ext_add() will auto-COW if the extension area has a refcount > 1.

Good point, thanks! Will do a v2.
