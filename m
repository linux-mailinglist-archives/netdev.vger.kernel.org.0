Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7825749D98A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 05:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbiA0ENh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 23:13:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40831 "EHLO
        einhorn-mail-out.in-berlin.de" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232382AbiA0ENg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 23:13:36 -0500
X-Greylist: delayed 777 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2022 23:13:36 EST
X-Envelope-From: thomas@x-berg.in-berlin.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 20R3xugg026181
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 04:59:56 +0100
Received: from thomas by x-berg.in-berlin.de with local (Exim 4.92)
        (envelope-from <thomas@x-berg.in-berlin.de>)
        id 1nCvwy-0003eu-9x; Thu, 27 Jan 2022 04:59:56 +0100
Date:   Thu, 27 Jan 2022 04:59:56 +0100
From:   Thomas Osterried <thomas@osterried.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jpr@f6fbb.org, davem@davemloft.net, kuba@kernel.org,
        wang6495@umn.edu, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] yam: fix a memory leak in yam_siocdevprivate()
Message-ID: <20220127035956.GE18529@x-berg.in-berlin.de>
References: <20220124032954.18283-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124032954.18283-1-hbh25y@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Thomas Osterried <thomas@x-berg.in-berlin.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Just a comment: Looks ok for me.

On Mon, Jan 24, 2022 at 11:29:54AM +0800, Hangyu Hua wrote:
> ym needs to be free when ym->cmd != SIOCYAMSMCS.
> 
> Fixes: 0781168e23a2 ("yam: fix a missing-check bug")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  drivers/net/hamradio/yam.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
> index 6376b8485976..980f2be32f05 100644
> --- a/drivers/net/hamradio/yam.c
> +++ b/drivers/net/hamradio/yam.c
> @@ -950,9 +950,7 @@ static int yam_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __
>  		ym = memdup_user(data, sizeof(struct yamdrv_ioctl_mcs));
>  		if (IS_ERR(ym))
>  			return PTR_ERR(ym);
> -		if (ym->cmd != SIOCYAMSMCS)
> -			return -EINVAL;
> -		if (ym->bitrate > YAM_MAXBITRATE) {
> +		if (ym->cmd != SIOCYAMSMCS || ym->bitrate > YAM_MAXBITRATE) {
>  			kfree(ym);
>  			return -EINVAL;
>  		}
> -- 
> 2.25.1
> 
