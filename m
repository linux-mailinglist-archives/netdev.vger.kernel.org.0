Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92041D5B12
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgEOU47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:56:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:34754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbgEOU46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 16:56:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 04DB9ACAE;
        Fri, 15 May 2020 20:56:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 49A51602F2; Fri, 15 May 2020 22:56:56 +0200 (CEST)
Date:   Fri, 15 May 2020 22:56:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        simon.horman@netronome.com, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/3] ethtool: check if there is at least one
 channel for TX/RX in the core
Message-ID: <20200515205656.GF21714@lion.mk-sys.cz>
References: <20200515194902.3103469-1-kuba@kernel.org>
 <20200515194902.3103469-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515194902.3103469-2-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 12:49:00PM -0700, Jakub Kicinski wrote:
> Having a channel config with no ability to RX or TX traffic is
> clearly wrong. Check for this in the core so the drivers don't
> have to.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Only one formal problem:

> @@ -170,7 +170,8 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
>  	ethnl_update_u32(&channels.other_count,
>  			 tb[ETHTOOL_A_CHANNELS_OTHER_COUNT], &mod);
>  	ethnl_update_u32(&channels.combined_count,
> -			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod);
> +			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod_combined);
> +	mod |= mod_combined;
>  	ret = 0;
>  	if (!mod)
>  		goto out_ops;

Bitwise or should do the right thing but using "|=" on bool variables
looks strange.

Michal
