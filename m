Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8501630AA6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfEaIun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfEaIun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:50:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59922308213B;
        Fri, 31 May 2019 08:50:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3A4B2E16C;
        Fri, 31 May 2019 08:50:41 +0000 (UTC)
Message-ID: <cf215a1abc1e2fd7c8015ac93b369de530cbb9d3.camel@redhat.com>
Subject: Re: [PATCH] net/vxlan: fix potential null pointer deference
From:   Paolo Abeni <pabeni@redhat.com>
To:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        petrm@mellanox.com, roopa@cumulusnetworks.com, idosch@mellanox.com,
        sbrivio@redhat.com, netdev@vger.kernel.org
Date:   Fri, 31 May 2019 10:50:41 +0200
In-Reply-To: <1559291681-6002-1-git-send-email-92siuyang@gmail.com>
References: <1559291681-6002-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 31 May 2019 08:50:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 16:34 +0800, Young Xiao wrote:
> There is a possible null pointer deference bug in vxlan_fdb_info(),
> which is similar to the bug which was fixed in commit 6adc5fd6a142
> ("net/neighbour: fix crash at dumping device-agnostic proxy entries").
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  drivers/net/vxlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 5994d54..1ba5977 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -274,7 +274,7 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
>  	} else
>  		ndm->ndm_family	= AF_BRIDGE;
>  	ndm->ndm_state = fdb->state;
> -	ndm->ndm_ifindex = vxlan->dev->ifindex;
> +	ndm->ndm_ifindex = vxlan->dev ? vxlan->dev->ifindex : 0;
>  	ndm->ndm_flags = fdb->flags;
>  	if (rdst->offloaded)
>  		ndm->ndm_flags |= NTF_OFFLOADED;

vxlan->dev points to the struct net_device for this vxlan device. It
can't be NULL. 

I suggest to look for working reproducer for this kind of issue before
adding additional, unneeded, checks. We want to avoid as many unneeded
conditionals as possible.

Thanks,

Paolo

 

