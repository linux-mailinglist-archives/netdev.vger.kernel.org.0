Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8B73A8F63
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 05:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFPDaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 23:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFPDaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 23:30:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B5561209;
        Wed, 16 Jun 2021 03:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623814091;
        bh=DElUYX+Vqhg5mZNbADXHK9olpxoWCOQxXtjgskUK90k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=reS/HXrikfUlLj7ksFHdFF5DeAua13Wf4K038zAROOLOtxIqGJoRCIfBIC0DljNB9
         RTohZ1r2lkZen1r4Uj6htnNujAWK4So5zDw6/2JQh0pVZKapfFX2WXMcNYNcMSo4La
         K/+fxAg00pqcQiO9kS4wntWezNr00RqTWiay2ImEwM6UZUZoHlKHD2h0k7+66GMK0A
         K7lff5j6Mevfxbsepun3Cc6KbCX2ruIP2FE0jHeygrTl44LOfSdfFvEG1tynD6anh4
         bU7gulnp24hyAqH2DWnqHd1A9ckcHTX/wDUGHiqSLR3j0PbnnbL/+jIec9T970E/Oi
         5A/R3casIqROg==
Date:   Tue, 15 Jun 2021 20:28:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [RFC net-next] ethtool: add a stricter length check
Message-ID: <20210615202810.37c680b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210615231033.32opvfjz7hhha7zs@lion.mk-sys.cz>
References: <20210612031135.225292-1-kuba@kernel.org>
        <20210615231033.32opvfjz7hhha7zs@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Jun 2021 01:10:33 +0200 Michal Kubecek wrote:
> > @@ -346,15 +346,20 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
> >  	ret = ops->reply_size(req_info, reply_data);
> >  	if (ret < 0)
> >  		goto err_cleanup;
> > -	reply_len = ret + ethnl_reply_header_size();
> > +	reply_len = ret;
> >  	ret = -ENOMEM;
> > -	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
> > +	rskb = ethnl_reply_init(reply_len + ethnl_reply_header_size(),
> > +				req_info->dev, ops->reply_cmd,
> >  				ops->hdr_attr, info, &reply_payload);
> >  	if (!rskb)
> >  		goto err_cleanup;
> > +	hdr_len = rskb->len;
> >  	ret = ops->fill_reply(rskb, req_info, reply_data);
> >  	if (ret < 0)
> >  		goto err_msg;
> > +	WARN(rskb->len - hdr_len > reply_len,
> > +	     "ethnl cmd %d: calculated reply length %d, but consumed %d\n",
> > +	     cmd, reply_len, rskb->len - hdr_len);
> >  	if (ops->cleanup_data)
> >  		ops->cleanup_data(reply_data);  
> 
> We may want WARN_ONCE or ratelimited here, if there is bug in reply
> length estimate for a request not requiring admin privileges, the
> warning might be invoked by a regular user at will.

Ah, good point!

> Also the patch changes the meaning of reply_len which is also used in
> the original warning after err_msg label. But it's probably not a big
> deal, it's not obvious what exactly "payload" means there so that anyone
> trying to investigate the problem has to start by checking what exactly
> the value reported means.

I'll add a note to this effect to the commit message.

Thanks!
