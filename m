Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6474277C6B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgIXXqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgIXXqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 19:46:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE7F72399A;
        Thu, 24 Sep 2020 23:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600991177;
        bh=hcjNPNNEkrCllMGIC4/Aoo4nXUGcj7v8iZT1Th3f0Yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ikzQUNtpowzs46Y/FCoLzg9ZSyGpUeyOK0y2ugFoShVB9cN3HgNUWvfp1M/Ikm6Ds
         INqKyAjx/jcWfGMbjS8z2KJIg+wxjMH4cFwAG6dVHAWqnF48reVupUMpu5ZlDdbW+J
         mS2EdTRFTAEVYKpUfOQY+1aOKviRBMcwAkuZT/HI=
Date:   Thu, 24 Sep 2020 16:46:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] net: vlan: Avoid using BUG() in
 vlan_proto_idx()
Message-ID: <20200924164615.619badc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924041627.33106-1-f.fainelli@gmail.com>
References: <20200924041627.33106-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 21:16:27 -0700 Florian Fainelli wrote:
> While we should always make sure that we specify a valid VLAN protocol
> to vlan_proto_idx(), killing the machine when an invalid value is
> specified is too harsh and not helpful for debugging. All callers are
> capable of dealing with an error returned by vlan_proto_idx() so check
> the index value and propagate it accordingly.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Perhaps it's heresy but I wonder if the error checking is worth it 
or we'd be better off WARNing and assuming normal Q tag.. unlikely
someone is getting it wrong now given the BUG().

> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index d4bcfd8f95bf..6c08de1116c1 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -57,6 +57,9 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
>  	ASSERT_RTNL();
>  
>  	pidx  = vlan_proto_idx(vlan_proto);
> +	if (pidx < 0)
> +		return -EINVAL;
> +
>  	vidx  = vlan_id / VLAN_GROUP_ARRAY_PART_LEN;
>  	array = vg->vlan_devices_arrays[pidx][vidx];
>  	if (array != NULL)
> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
> index bb7ec1a3915d..143e9c12dbd6 100644
> --- a/net/8021q/vlan.h
> +++ b/net/8021q/vlan.h
> @@ -44,8 +44,8 @@ static inline unsigned int vlan_proto_idx(__be16 proto)

adjust return type

>  	case htons(ETH_P_8021AD):
>  		return VLAN_PROTO_8021AD;
>  	default:
> -		BUG();
> -		return 0;
> +		WARN(1, "invalid VLAN protocol: 0x%04x\n", htons(proto));

ntohs()

> +		return -EINVAL;
>  	}
>  }
