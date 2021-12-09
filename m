Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B34346E0EE
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhLICjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:39:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhLICjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:39:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80585B823AA;
        Thu,  9 Dec 2021 02:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E977BC00446;
        Thu,  9 Dec 2021 02:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639017370;
        bh=45tMk4F/MluMy76hTixev2X+GL6EAl4gWxHrb+ZdNe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IPm4tzh/h6ly2iJXwyIIwuAwzpO5H8pJWvgFsKuISBuP2VrGstxL1rcZttgYHX7Lm
         hq8y29fyUPOfzZszSmil/Qz0CRnnNvDL0Z+qvtFwgbWRwOWJs0TLFMUrQS4BsGJBsf
         mYXo9ZuwtYOYkiK35nwu5jI1Sc1o/T61hUp3R6y9ygE6jmzWoXTJd0jvcktA2Jm9/J
         EhZuz/g7M9/GWpSeL9n34i47RAfBfsz+ZdT8S53sBMY3NnlXRu1xZ2P2IrjG7hU+1z
         NX6BDLgPfuqHA3+7FGJ9N/GP13Y9GtVkCrcCVGEpJWNT0x+urxLz3/LMsdGC/oBa6h
         46iqAXfk+mjIA==
Date:   Wed, 8 Dec 2021 18:36:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: gred: potential dereference of null pointer
Message-ID: <20211208183608.27852c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211209021346.2004600-1-jiasheng@iscas.ac.cn>
References: <20211209021346.2004600-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Dec 2021 10:13:46 +0800 Jiasheng Jiang wrote:
> The return value of kzalloc() needs to be checked.
> To avoid use of null pointer in gred_change_vq() in case
> of the failure of alloc.
> 
> Fixes: 869aa41044b0 ("sch_gred: prefer GFP_KERNEL allocations")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

I don't see how. Please explain in more detail. gred_change_vq() gets 
a pointer to a pointer and checks if its values is NULL.

> diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
> index f4132dc25ac0..c0d355281baf 100644
> --- a/net/sched/sch_gred.c
> +++ b/net/sched/sch_gred.c
> @@ -697,6 +697,8 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
>  	}
>  
>  	prealloc = kzalloc(sizeof(*prealloc), GFP_KERNEL);
> +	if (!prealloc)
> +		return -ENOMEM;
>  	sch_tree_lock(sch);
>  
>  	err = gred_change_vq(sch, ctl->DP, ctl, prio, stab, max_P, &prealloc,

