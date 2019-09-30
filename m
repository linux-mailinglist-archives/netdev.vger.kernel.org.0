Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1747C2060
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfI3MKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 08:10:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfI3MKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 08:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8/whdTvtxaSHDnckZh8xraAOckZe8+t1HR7C1adovV8=; b=Xtza2B2H3ABP3/YTC+r6V1nKIv
        J8BZmYkQ6PZyV0vHZE3G9uQmb26ohfuz4KmO4Z21FwpBvGw+I4QH/rmg0PrKy3/EHG4QF5BIu+O1/
        QwFBwqQx5JIeza9isp6aAg/zhpLqhmr89fGKahM/VBQjaIYjWD1Bv5ehMCypTj06GQUM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iEuV9-0003XG-4A; Mon, 30 Sep 2019 14:10:03 +0200
Date:   Mon, 30 Sep 2019 14:10:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        jiri@mellanox.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net] devlink: Fix error handling in param and info_get
 dumpit cb
Message-ID: <20190930121003.GB13301@lunn.ch>
References: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 11:52:21AM +0530, Vasundhara Volam wrote:
> If any of the param or info_get op returns error, dumpit cb is
> skipping to dump remaining params or info_get ops for all the
> drivers.
> 
> Fix to not return if any of the param/info_get op returns error
> as not supported and continue to dump remaining information.
> 
> v2: Modify the patch to return error, except for params/info_get
> op that return -EOPNOTSUPP as suggested by Andrew Lunn. Also, modify
> commit message to reflect the same.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> ---
>  net/core/devlink.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index e48680e..f80151e 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3172,7 +3172,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
>  						    NETLINK_CB(cb->skb).portid,
>  						    cb->nlh->nlmsg_seq,
>  						    NLM_F_MULTI);
> -			if (err) {
> +			if (err && err != -EOPNOTSUPP) {
>  				mutex_unlock(&devlink->lock);
>  				goto out;
>  			}

and out: is

out:
        mutex_unlock(&devlink_mutex);

        cb->args[0] = idx;
        return msg->len;
}

Jiri: Is the intention really to throw away the error?

Looking at the rest of devlink, all the other _get_dumpit() functions,
except health_reporter_dump_get_dumpit(), do discard any errors.

As for this patch

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
