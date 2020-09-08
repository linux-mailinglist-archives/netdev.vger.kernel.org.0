Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FCF261467
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbgIHQT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731797AbgIHQTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90DAC2065E;
        Tue,  8 Sep 2020 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580851;
        bh=vc0BtnP6e5D+73bIKGbLBXslTUB0qhWkmKMc6lLPNYs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tY9q47mLC5nxcwiDjVTOUhv10PekE8tSUyJZKcDM7OW9d9LIn84lXDBT0FTEItjcY
         TLQZbgtZ4DXQjSRgP3Xv8CYaKB24bDY+lYJd/E2HOzObxb/tsGbMI0Y2sV8oJj3Amh
         TWM/ZAYKxKupO62l3eR6QeBx61MzDUrKf+9ZBqjw=
Date:   Tue, 8 Sep 2020 09:00:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roopa@nvidia.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH net-next] net: bridge: mcast: fix unused br var when
 lockdep isn't defined
Message-ID: <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908071713.916165-1-nikolay@cumulusnetworks.com>
References: <20200908130000.7d33d787@canb.auug.org.au>
        <20200908071713.916165-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 10:17:13 +0300 Nikolay Aleksandrov wrote:
> Stephen reported the following warning:
>  net/bridge/br_multicast.c: In function 'br_multicast_find_port':
>  net/bridge/br_multicast.c:1818:21: warning: unused variable 'br' [-Wunused-variable]
>   1818 |  struct net_bridge *br = mp->br;
>        |                     ^~
> 
> It happens due to bridge's mlock_dereference() when lockdep isn't defined.
> Silence the warning by annotating the variable as __maybe_unused.
> 
> Fixes: 0436862e417e ("net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/bridge/br_multicast.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index b83f11228948..33adf44ef7ec 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1814,8 +1814,8 @@ br_multicast_find_port(struct net_bridge_mdb_entry *mp,
>  		       struct net_bridge_port *p,
>  		       const unsigned char *src)
>  {
> +	struct net_bridge *br __maybe_unused = mp->br;
>  	struct net_bridge_port_group *pg;
> -	struct net_bridge *br = mp->br;
>  
>  	for (pg = mlock_dereference(mp->ports, br);
>  	     pg;

That's a lazy fix :( Is everyone using lockdep annotations going to
sprinkle __maybe_unused throughout the code? Macros should also always
evaluate their arguments.
