Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B7040965F
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 16:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347181AbhIMOva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 10:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347079AbhIMOsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 10:48:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 482B760698;
        Mon, 13 Sep 2021 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631544308;
        bh=kDrijgADMkD1GAJHX9DR6GmGqB3tm6umwruHur5C6c4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBoyc3dkR8tgKt++AaQUfiD0jOja2FiZsFePRHKuFQnrZpVzlmNvSBD4zoKHnBEd2
         PvczU+kfZYul6nSltiS6+YpHxmnf5qykIgm0+F7sg9NP7RFX+4FMOwNlbeqBC+bZWF
         jXzx2ykTYIDefQSExN7zKvgaeg0U6hYnVawqepPWwgOk5CZ1wtDIV27lk5g/2ujYos
         ofJbY+QeiWAtMbjd0vvv0R87yJu3PX6l2k7AnjeDHmlixAC2Ve1K2uymfwpeU+jFER
         Q5vo43iIQbZzpLzXGRBzOyY2INwhGi9J71Id4OpEbHIm/E0EGr2u/FjuI4RnE45fcW
         hBvRwsBUvnF0A==
Date:   Mon, 13 Sep 2021 17:45:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-rdma@vger.kernel.org, jgg@ziepe.ca, aelior@marvell.com,
        malin1024@gmail.com, Michal Kalderon <mkalderon@marvell.com>
Subject: Re: [PATCH net] qed: rdma - don't wait for resources under hw error
 recovery flow
Message-ID: <YT9j8Mq67CpHsaGO@unreal>
References: <20210913121442.10189-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913121442.10189-1-smalin@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 03:14:42PM +0300, Shai Malin wrote:
> If the HW device is during recovery, the HW resources will never return,
> hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
> This fix speeds up the error recovery flow.
> 
> Fixes: 64515dc899df ("qed: Add infrastructure for error detection and recovery")
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 7 +++++++
>  drivers/net/ethernet/qlogic/qed/qed_roce.c  | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> index fc8b3e64f153..4967e383c31a 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> @@ -1323,6 +1323,13 @@ static int qed_iwarp_wait_for_all_cids(struct qed_hwfn *p_hwfn)
>  	int rc;
>  	int i;
>  
> +	/* If the HW device is during recovery, all resources are immediately
> +	 * reset without receiving a per-cid indication from HW. In this case
> +	 * we don't expect the cid_map to be cleared.
> +	 */
> +	if (p_hwfn->cdev->recov_in_prog)
> +		return 0;

How do you ensure that this doesn't race with recovery flow?

> +
>  	rc = qed_iwarp_wait_cid_map_cleared(p_hwfn,
>  					    &p_hwfn->p_rdma_info->tcp_cid_map);
>  	if (rc)
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> index f16a157bb95a..aff5a2871b8f 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> @@ -71,6 +71,13 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
>  	struct qed_bmap *rcid_map = &p_hwfn->p_rdma_info->real_cid_map;
>  	int wait_count = 0;
>  
> +	/* If the HW device is during recovery, all resources are immediately
> +	 * reset without receiving a per-cid indication from HW. In this case
> +	 * we don't expect the cid bitmap to be cleared.
> +	 */
> +	if (p_hwfn->cdev->recov_in_prog)
> +		return;
> +
>  	/* when destroying a_RoCE QP the control is returned to the user after
>  	 * the synchronous part. The asynchronous part may take a little longer.
>  	 * We delay for a short while if an async destroy QP is still expected.
> -- 
> 2.22.0
> 
