Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC44E414560
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhIVJlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234294AbhIVJlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 05:41:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC8EE61211;
        Wed, 22 Sep 2021 09:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632303610;
        bh=QQ1IBRI/vlB6loJudKjohvzWgOIaXu0mmiwtHhw2lZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EIQcN6E/TlQeCRYVHhKUE9FoD38dR9lCmPQ8EdSpWzU6P4EP3E8V2LafHjCFSxZ+u
         Sp0xgQDcxdlBgtFs0IsobwVdlK4rVwsKAN4Io5LPa/2UM3qSF/A9UUjDe1TEZ5lNq3
         Ix7cH+sTb/CAUDRGDA36HOWCJLVbXcoU5adQjcaLP9vUmHOME3u6mwZWhAwu/VSTI3
         eUw6znmUVxKGbL1CSbcTYMkWKAh4//N8Fz3pZBS//pP5KliivvMrv2PSCxnGs/NCTg
         bPNxCNyqIJq3zt9t1wzy2Urn1xEjDakZ7L9CVfHJXPtyCg3pxZ9PZVRTzRfz2oTexs
         Y3HsWzvZD/HjQ==
Date:   Wed, 22 Sep 2021 12:40:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-rdma@vger.kernel.org, jgg@ziepe.ca, aelior@marvell.com,
        malin1024@gmail.com, Michal Kalderon <mkalderon@marvell.com>
Subject: Re: [PATCH net v2] qed: rdma - don't wait for resources under hw
 error recovery flow
Message-ID: <YUr59luiezKbdOyW@unreal>
References: <20210922073631.31626-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922073631.31626-1-smalin@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 10:36:31AM +0300, Shai Malin wrote:
> If the HW device is during recovery, the HW resources will never return,
> hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
> This fix speeds up the error recovery flow.
> 
> Changes since v1:
> - Fix race condition (thanks to Leon Romanovsky).

Please put changelog under "---", there is a little value for them in the
commit message.

> 
> Fixes: 64515dc899df ("qed: Add infrastructure for error detection and recovery")
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 8 ++++++++
>  drivers/net/ethernet/qlogic/qed/qed_roce.c  | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> index fc8b3e64f153..186d0048a9d1 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> @@ -1297,6 +1297,14 @@ qed_iwarp_wait_cid_map_cleared(struct qed_hwfn *p_hwfn, struct qed_bmap *bmap)
>  	prev_weight = weight;
>  
>  	while (weight) {
> +		/* If the HW device is during recovery, all resources are
> +		 * immediately reset without receiving a per-cid indication
> +		 * from HW. In this case we don't expect the cid_map to be
> +		 * cleared.
> +		 */
> +		if (p_hwfn->cdev->recov_in_prog)
> +			return 0;
> +
>  		msleep(QED_IWARP_MAX_CID_CLEAN_TIME);
>  
>  		weight = bitmap_weight(bmap->bitmap, bmap->max_count);
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> index f16a157bb95a..cf5baa5e59bc 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> @@ -77,6 +77,14 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
>  	 * Beyond the added delay we clear the bitmap anyway.
>  	 */
>  	while (bitmap_weight(rcid_map->bitmap, rcid_map->max_count)) {
> +		/* If the HW device is during recovery, all resources are
> +		 * immediately reset without receiving a per-cid indication
> +		 * from HW. In this case we don't expect the cid bitmap to be
> +		 * cleared.
> +		 */
> +		if (p_hwfn->cdev->recov_in_prog)
> +			return;
> +
>  		msleep(100);
>  		if (wait_count++ > 20) {
>  			DP_NOTICE(p_hwfn, "cid bitmap wait timed out\n");
> -- 
> 2.27.0
> 
