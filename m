Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130F24A57B2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiBAHXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiBAHXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 02:23:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375E8C06173D
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 23:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB9E61186
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1068FC340EB;
        Tue,  1 Feb 2022 07:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643700142;
        bh=ict/T96utVEHgVjh8jUevBU9eAawryl2RFnfDPCN6V0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJeV3DXbmUnn/63Q5/9uz69eQ60xTj9bg02fq/pyDQNYUsrW3V5GoZ6M4iqos5SUN
         R6lnNhZQfCvoZhDvIl8gj2RsMDoSwE0O2QkkfWJssev67SolD+xRXLzY/1WMPGvu+D
         7YBLwIvP7hPAXtXV+xNC/MrKmGv1tuElQ3lSIexZiEzvQcq7ctxC11Qoq6xhO4Yo3k
         gJL/8bTb7xdOZSciGUTvqf7QGbK5zVhBWqXCvrxgN7y5KlSX1sarDKTKBQqVm5+48j
         3dWoHW671o4CAKUWBTVURSqhiRKf0AW7CV6mKJNOADsqC0tcQspXYyT7Tbdr5yWjGp
         CAZjeyJWTfCMA==
Date:   Tue, 1 Feb 2022 09:22:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [PATCH ipsec-next] xfrm: delete not-used XFRM_OFFLOAD_IPV6 define
Message-ID: <YfjfqWRVr4KpkQC8@unreal>
References: <31811e3cf276ae2af01574f4fbcb127b88d9c6b5.1643307803.git.leonro@nvidia.com>
 <20220201065836.GT1223722@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201065836.GT1223722@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 07:58:36AM +0100, Steffen Klassert wrote:
> On Thu, Jan 27, 2022 at 08:24:58PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > XFRM_OFFLOAD_IPV6 define was exposed in the commit mentioned in the
> > fixes line, but it is never been used both in the kernel and in the
> > user space. So delete it.
> 
> How can you be sure that is is not used in userspace? At least some
> versions of strongswan set that flag. So even if it is meaningless
> in the kernel, we can't remove it.

I looked over all net/* and include/uapi/* code with "git log -p" and didn't
see any use of this flag ever. 

Looking in strongsswan, I see that they bring kernel header files [1] for the build
and removal won't break build of old strongsswan versions.

We just can't use this bit anymore, because of this commit [2]. I have
no clue why it was used there.

So yes, we can remove, but worth to add a comment about old strongsswan.

And if we are talking about xfrm_user_offload flags, there is a
well-known API mistake in xfrm_dev_state_add() of not checking validity
of flags. So *theoretically* we can find some software in the wild that
uses other bits too.

I would like to see it is fixed.

[1] 5bfae68670f2 ("include: Update xfrm.h to include hardware offloading extensions")
[2] d42948fc057e ("kernel-netlink: Enable hardware offloading if configured for an SA")

Thanks

> 
> > 
> > Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  include/uapi/linux/xfrm.h | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> > index 4e29d7851890..2c822671cc32 100644
> > --- a/include/uapi/linux/xfrm.h
> > +++ b/include/uapi/linux/xfrm.h
> > @@ -511,7 +511,6 @@ struct xfrm_user_offload {
> >  	int				ifindex;
> >  	__u8				flags;
> >  };
> > -#define XFRM_OFFLOAD_IPV6	1
> >  #define XFRM_OFFLOAD_INBOUND	2
> >  
> >  struct xfrm_userpolicy_default {
> > -- 
> > 2.34.1
