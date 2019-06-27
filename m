Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EFD58636
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfF0Pqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:46:34 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:56092 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0Pqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:46:34 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id EC88215000C4;
        Thu, 27 Jun 2019 17:46:31 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id B7C1F830;
        Thu, 27 Jun 2019 17:46:31 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.52,VDF=8.16.17.176)
X-Spam-Status: 
X-Spam-Level: 0
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 0DCF7611;
        Thu, 27 Jun 2019 17:46:30 +0200 (CEST)
Date:   Thu, 27 Jun 2019 17:46:29 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Subject: Re: 4.19: Traced deadlock during xfrm_user module load
Message-ID: <20190627154629.27g5uwd47esyhz4s@intra2net.com>
References: <20190625155509.pgcxwgclqx3lfxxr@intra2net.com>
 <20190625165344.ii4zgvxydqj663ny@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625165344.ii4zgvxydqj663ny@breakpoint.cc>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

You wrote on Tue, Jun 25, 2019 at 06:53:44PM +0200:
> Thanks for this detailed analysis.
> In this specific case I think this is enough:
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 92077d459109..61ba92415480 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -578,7 +578,8 @@ static int nfnetlink_bind(struct net *net, int group)
>         ss = nfnetlink_get_subsys(type << 8);
>         rcu_read_unlock();
>         if (!ss)
> -               request_module("nfnetlink-subsys-%d", type);
> +               request_module_nowait("nfnetlink-subsys-%d", type);
>         return 0;
>  }
>  #endif

thanks for the patch! We finally found an easy way to reproduce the deadlock,
the following commands instantly trigger the problem on our machines:

    rmmod nf_conntrack_netlink
    rmmod xfrm_user
    conntrack -e NEW -E & modprobe -v xfrm_user

Note: the "-e" filter is needed to trigger the problematic
code path in the kernel.

We were worried that using "_nowait" would introduce other race conditions,
since the requested service might not be available by the time it is required.

On the other hand, if we understand correctly, it seems that after
"nfnetlink_bind()", the caller will listen on the socket for messages
regardless whether the needed modules are loaded, loading or unloaded.
To verify this we added a three second sleep during the initialisation of
nf_conntrack_netlink. The events started to appear after
the delayed init was completed.

If this is the case, then using "_nowait" should suffice as a fix
for the problem. Could you please confirm these assumptions
and give us some piece of mind?

Best regards,
Juliana Rodrigueiro and Thomas Jarosch
