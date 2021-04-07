Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC14C357066
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbhDGPfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhDGPfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:35:09 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000AEC061756;
        Wed,  7 Apr 2021 08:34:59 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id E5C6E6A45; Wed,  7 Apr 2021 11:34:58 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org E5C6E6A45
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1617809698;
        bh=bLQwzZC+bbhqKQBwwlTZfOUN0mKSee0/NQ+qVibG9tA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BxDWI9NjGmn6HGVSDiAJrvOjV3elqwdY183AU2UszAVMZ8YhXiuxCvN4Y8iDUZoqG
         dPnrzDbm+UF74K70EuqcAwDc3WO8Dl10+HR0kH2fJ9dDvJQWpjd0A5EnhF5YGkpQRU
         xG8nwVkN+xrMHVh/Y8zm9kFnu5LHNpgL8PYADcx4=
Date:   Wed, 7 Apr 2021 11:34:58 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <20210407153458.GA28924@fieldses.org>
References: <20210407001658.2208535-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407001658.2208535-1-pakki001@umn.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 07:16:56PM -0500, Aditya Pakki wrote:
> In gss_pipe_destroy_msg(), in case of error in msg, gss_release_msg
> deletes gss_msg. The patch adds a check to avoid a potential double
> free.

We're already dereferenced msg.  Nothing has set gss_msg to NULL.  It's
the gss_msg->count reference count that's supposed to prevent double
frees.

Did you see an actual bug or warning from some tool, and if so, could
you share the details?

--b.

> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  net/sunrpc/auth_gss/auth_gss.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index 5f42aa5fc612..eb52eebb3923 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -848,7 +848,8 @@ gss_pipe_destroy_msg(struct rpc_pipe_msg *msg)
>  			warn_gssd();
>  		gss_release_msg(gss_msg);
>  	}
> -	gss_release_msg(gss_msg);
> +	if (gss_msg)
> +		gss_release_msg(gss_msg);
>  }
>  
>  static void gss_pipe_dentry_destroy(struct dentry *dir,
> -- 
> 2.25.1
