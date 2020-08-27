Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B712542C0
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgH0Ju2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:50:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:53030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgH0Ju1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 05:50:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C031CAD78;
        Thu, 27 Aug 2020 09:50:57 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5A269603FB; Thu, 27 Aug 2020 11:50:25 +0200 (CEST)
Date:   Thu, 27 Aug 2020 11:50:25 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7 net-next] vxlan: add VXLAN_NL2FLAG macro
Message-ID: <20200827095025.p4mxmuh2jwmzs5kt@lion.mk-sys.cz>
References: <20200827065019.5787-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827065019.5787-1-fabf@skynet.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 08:50:19AM +0200, Fabian Frederick wrote:
> Replace common flag assignment with a macro.
> This could yet be simplified with changelink/supported but it would
> remove clarity
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
[...]
> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index 3a41627cbdfe5..8a56b7a0f75f9 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -290,6 +290,16 @@ struct vxlan_dev {
>  					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
>  					 VXLAN_F_COLLECT_METADATA)
>  
> +
> +#define VXLAN_NL2FLAG(iflag, flag, changelink, changelink_supported) {   \
> +	if (data[iflag]) {						 \
> +		err = vxlan_nl2flag(conf, data, iflag, flag, changelink, \
> +				    changelink_supported, extack);       \
> +		if (err)						 \
> +			return err;					 \
> +	}								 \
> +}
> +

Hiding a goto or return in a macro is generally discouraged as it may
confuse people reading or updating the code. See e.g. commit
94f826b8076e ("net: fix a potential rcu_read_lock() imbalance in
rt6_fill_node()") for an example of such problem - which was likely the
trigger for removal of NLA_PUT() and related macros shortly after.

Michal

>  struct net_device *vxlan_dev_create(struct net *net, const char *name,
>  				    u8 name_assign_type, struct vxlan_config *conf);
>  
> -- 
> 2.27.0
> 
