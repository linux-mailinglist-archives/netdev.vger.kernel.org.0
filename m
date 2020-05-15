Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF041D5C5E
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgEOW0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOW0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:26:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CEAF2065C;
        Fri, 15 May 2020 22:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589581601;
        bh=/Bbj/rSk/B6tfqZuUxd6QJ8nWputYI3VQ280SWRWzhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WmXyzZeH7D9dBdd95dVzKxZXyQ56MaIp7TVzZRToUwRclxbGAYAg0xXIweaQ6kN/5
         cnnloXcOpnJJCz4L7ci7PKEsWwZ+qMN2CDyPaXMg10yc64ftnOV7Q4y6s47CgSLhJw
         sK/jxzB1fMr3Yczh26FvvRtb7OWO5/lKB24X06fQ=
Date:   Fri, 15 May 2020 15:26:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        simon.horman@netronome.com, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/3] ethtool: check if there is at least one
 channel for TX/RX in the core
Message-ID: <20200515152640.4d2ec3dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515205656.GF21714@lion.mk-sys.cz>
References: <20200515194902.3103469-1-kuba@kernel.org>
        <20200515194902.3103469-2-kuba@kernel.org>
        <20200515205656.GF21714@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 22:56:56 +0200 Michal Kubecek wrote:
> On Fri, May 15, 2020 at 12:49:00PM -0700, Jakub Kicinski wrote:
> > Having a channel config with no ability to RX or TX traffic is
> > clearly wrong. Check for this in the core so the drivers don't
> > have to.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Thanks for the reviews!

> > @@ -170,7 +170,8 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
> >  	ethnl_update_u32(&channels.other_count,
> >  			 tb[ETHTOOL_A_CHANNELS_OTHER_COUNT], &mod);
> >  	ethnl_update_u32(&channels.combined_count,
> > -			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod);
> > +			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod_combined);
> > +	mod |= mod_combined;
> >  	ret = 0;
> >  	if (!mod)
> >  		goto out_ops;  
> 
> Bitwise or should do the right thing but using "|=" on bool variables
> looks strange.

Interesting, I never thought about it in this way.
