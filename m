Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4770FFB5F
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 19:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfKQSdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 13:33:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfKQSdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 13:33:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AECF4153E2ECB;
        Sun, 17 Nov 2019 10:33:32 -0800 (PST)
Date:   Sun, 17 Nov 2019 10:33:32 -0800 (PST)
Message-Id: <20191117.103332.318543543712297736.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH 03/15] octeontx2-af: Cleanup CGX config permission
 checks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574007266-17123-4-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574007266-17123-4-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 Nov 2019 10:33:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Sun, 17 Nov 2019 21:44:14 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Most of the CGX register config is restricted to mapped RVU PFs,
> this patch cleans up these permission checks spread across
> the rvu_cgx.c file by moving the checks to a common fn().
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 55 ++++++++++------------
>  1 file changed, 24 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> index 0bbb2eb..5790a76 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> @@ -350,6 +350,18 @@ int rvu_cgx_exit(struct rvu *rvu)
>  	return 0;
>  }
>  
> +/* Most of the CGX configuration is restricted to the mapped PF only,
> + * VF's of mapped PF and other PFs are not allowed. This fn() checks
> + * whether a PFFUNC is permitted to do the config or not.
> + */
> +inline bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
> +{
> +	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
> +	    !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
> +		return false;
> +	return true;
> +}

Do not use inline in foo.c files, let the compiler decide.
