Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E06D133E2C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgAHJRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:17:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:53846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbgAHJRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 04:17:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B9261AAC3;
        Wed,  8 Jan 2020 09:17:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 60042E008B; Wed,  8 Jan 2020 10:17:52 +0100 (CET)
Date:   Wed, 8 Jan 2020 10:17:52 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ethtool: potential NULL dereference in
 strset_prepare_data()
Message-ID: <20200108091752.GL22387@unicorn.suse.cz>
References: <20200108054236.ult5qxiiwpw2wamk@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108054236.ult5qxiiwpw2wamk@kili.mountain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 08:42:36AM +0300, Dan Carpenter wrote:
> Smatch complains that the NULL checking isn't done consistently:
> 
>     net/ethtool/strset.c:253 strset_prepare_data()
>     error: we previously assumed 'dev' could be null (see line 233)
> 
> It looks like there is a missing return on this path.

I believe this is a false positive as the first loop makes sure no
explicitly requested set is per device if dev is NULL so that we would
never actually call strset_prepare_set() with null dev.

But there is no point to go through the second part of the function if
it is not going to do anything and the fact that it took me few minutes
to make sure the null pointer dereference is not possible clearly
indicates the code is cleaner with the explicit return.

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/ethtool/strset.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> index 9f2243329015..82a059c13c1c 100644
> --- a/net/ethtool/strset.c
> +++ b/net/ethtool/strset.c
> @@ -239,6 +239,7 @@ static int strset_prepare_data(const struct ethnl_req_info *req_base,
>  				return -EINVAL;
>  			}
>  		}
> +		return 0;
>  	}
>  
>  	ret = ethnl_ops_begin(dev);
> -- 
> 2.11.0
> 
