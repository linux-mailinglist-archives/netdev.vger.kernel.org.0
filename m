Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54083AB9B3
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhFQQbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:31:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36356 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFQQbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 12:31:32 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ADEA221B20;
        Thu, 17 Jun 2021 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623947363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XZks9EZeXdiubtp+Uta4AWHCILofE+TIAfWkdZPWiDM=;
        b=Nipm1EaPLe1np7amg0VCR9fVDTWvvqTiFEj1mnBYDvBAiDOBk8DC17RxzDJBo1kWex2+qx
        yuhUEJWCB13qzpNpNwWSik0b4liQUUaPxQJJ0l6uKjV5wRSTMJlI2f5w0BqDMUiZwlxJzF
        wseB+nQLwoAPopU7DstOyE1kZ8KqbGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623947363;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XZks9EZeXdiubtp+Uta4AWHCILofE+TIAfWkdZPWiDM=;
        b=EbetPO5T0l1YJCLQojw8jzBE7q1d7hsB86kUBy0pebrwFDuq7uXSEj1VAUY7yvSzWID/E8
        kbIVhAo3PeUC/RDw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A4945A3BDA;
        Thu, 17 Jun 2021 16:29:23 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 75D5C603CD; Thu, 17 Jun 2021 18:29:23 +0200 (CEST)
Date:   Thu, 17 Jun 2021 18:29:23 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Amit Cohen <amcohen@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] ethtool: strset: Fix reply_size value
Message-ID: <20210617162923.i7cvvxszntf7mvvl@lion.mk-sys.cz>
References: <20210617154252.688724-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617154252.688724-1-amcohen@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 06:42:52PM +0300, Amit Cohen wrote:
> strset_reply_size() does not take into account the size required for the
> 'ETHTOOL_A_STRSET_STRINGSETS' nested attribute.
> Since commit 4d1fb7cde0cc ("ethtool: add a stricter length check") this
> results in the following warning in the kernel log:
> 
> ethnl cmd 1: calculated reply length 2236, but consumed 2240
> WARNING: CPU: 2 PID: 30549 at net/ethtool/netlink.c:360 ethnl_default_doit+0x29f/0x310
> 
> Add the appropriate size to the calculation.
> 
> Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ethtool/strset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> index b3029fff715d..86dcb6b099b3 100644
> --- a/net/ethtool/strset.c
> +++ b/net/ethtool/strset.c
> @@ -365,7 +365,7 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
>  		len += ret;
>  	}
>  
> -	return len;
> +	return nla_total_size(len);
>  }
>  
>  /* fill one string into reply */

I believe this issue has been already fixed in net tree by commit
e175aef90269 ("ethtool: strset: fix message length calculation") but as
this commit has not been merged into net-next yet, you could hit it with
the stricter check.

Michal
