Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5082FC7B7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbhATCXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730859AbhATCWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DF442250E;
        Wed, 20 Jan 2021 02:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611109294;
        bh=nTEA1hudbJuhjpINDw8b4H/QEvZXPFEUU1gq/ihM7Zw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XuqZGlvSojrA7vrwI3bzByi/vC+BugX6DWrQ41pbIWybNi4FmokQKMcSGmW0tBXJP
         tldWiRdLaueqX4Y7l+r27+7EN5+JUtf3M9KGTi5LuHEEJL9UzXix4FGZT4iBh/45Zf
         fU58TEj++sigEQFxTh58K/KHOc/Glf9fivgiP7Ko3J7wvJYBk3b8fdAUEKzzyd2dza
         +Wr8iR7dUdVQnLo60H3rtHAPXmWIM6jfzmMb4Yp3pC7NqhIfytK0hnOjVTJAj/cPbv
         PVmlYK/p8ANQrwPTqrnYCbE3gp22kytX8DoPwJb7oqpIpGiuef+OX8WWjZP8iBDUPl
         yjH/iCHZW6cXw==
Date:   Tue, 19 Jan 2021 18:21:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 2/8] taprio: Add support for frame
 preemption offload
Message-ID: <20210119182133.038fbfc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119004028.2809425-3-vinicius.gomes@intel.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
        <20210119004028.2809425-3-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 16:40:22 -0800 Vinicius Costa Gomes wrote:
> Adds a way to configure which traffic classes are marked as
> preemptible and which are marked as express.
> 
> Even if frame preemption is not a "real" offload, because it can't be
> executed purely in software, having this information near where the
> mapping of traffic classes to queues is specified, makes it,
> hopefully, easier to use.
> 
> taprio will receive the information of which traffic classes are
> marked as express/preemptible, and when offloading frame preemption to
> the driver will convert the information, so the driver receives which
> queues are marked as express/preemptible.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

> @@ -1286,13 +1289,15 @@ static int taprio_disable_offload(struct net_device *dev,
>  	offload->enable = 0;
>  
>  	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
> -	if (err < 0) {
> +	if (err < 0)
> +		NL_SET_ERR_MSG(extack,
> +			       "Device failed to disable offload");
> +
> +	err = ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT, &preempt);
> +	if (err < 0)
>  		NL_SET_ERR_MSG(extack,
>  			       "Device failed to disable offload");

This was meant to say something else?

> -		goto out;
> -	}
>  
> -out:
>  	taprio_offload_free(offload);
>  
>  	return err;
