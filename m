Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C37746E77C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbhLILYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:24:20 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42308 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLILYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:24:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67F60CE25AE;
        Thu,  9 Dec 2021 11:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D622EC004DD;
        Thu,  9 Dec 2021 11:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639048842;
        bh=zf758cAypWJos/9Tzs5VqoD7YdNh1AXrtJPYppiiPag=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TlvohAryJFvg0D6AfDLIZAdyHt33EvyPoIXR+nmlKh+vk6rvMCT9/E8ZZMPBsEVyn
         mZuVfwiKiiH7wjaPIiMOzHwfVNCSA1i3sQkIYB5W31+y+E/QV4bUt1pwyMHP9E/brz
         Z1XcbLdyCePy0xnQDGe+95yYTthgpx5efh/n7z8nrCC5jE+KadJlCvTU2H59LDbgAK
         5/kqoagDmg6X41EvBtAoWQcuLMrLJflcFg3NKL+tIcFW3ZURbHnatNc6C2XrqM2w+d
         iuzS8xxP/ZGBMher3nhe/zW6Oa6fYyZS22RZZsPq1x9iFkyoK1jZyEkTbUA5sdVNy2
         j31zieAFuz8ng==
Message-ID: <2a79206d3472b279079fbef5c9507f8805061c47.camel@kernel.org>
Subject: Re: [PATCH] libceph, ceph: potential dereference of null pointer
From:   Jeff Layton <jlayton@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, idryomov@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 09 Dec 2021 06:20:40 -0500
In-Reply-To: <20211209025038.2028112-1-jiasheng@iscas.ac.cn>
References: <20211209025038.2028112-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-12-09 at 10:50 +0800, Jiasheng Jiang wrote:
> The return value of kzalloc() needs to be checked.
> To avoid use of null pointer in case of the failure of alloc.
> 
> Fixes: 3d14c5d2b6e1 ("ceph: factor out libceph from Ceph file system")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  net/ceph/osd_client.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index ff8624a7c964..3203e8a34370 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -1234,6 +1234,8 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
>  	WARN_ON(onum == CEPH_HOMELESS_OSD);
>  
>  	osd = kzalloc(sizeof(*osd), GFP_NOIO | __GFP_NOFAIL);
> +	if (!osd)
> +		return NULL;
>  	osd_init(osd);
>  	osd->o_osdc = osdc;
>  	osd->o_osd = onum;

__GFP_NOFAIL should ensure that it never returns NULL, right?

Also, if you're going to fix this up to handle that error then you
probably also need to fix lookup_create_osd to handle a NULL return from
create_osd as well.
-- 
Jeff Layton <jlayton@kernel.org>
