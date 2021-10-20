Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DE7434743
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhJTIux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhJTIuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3DCB6109F;
        Wed, 20 Oct 2021 08:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634719718;
        bh=nzYRt6YXTrg4ra8XaU4hiQb6YWfwEdUjDkURPalWat8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRbx2W2WYhYwGnNZ0ob8zsrY3TbSg+qIDGfI6vmf9A95v9IZlI6Rxud28VICBsaLr
         AHESkBip/tzbK64TWDrp498V4ZR66vBVhrvnH1dSToA2nc9SNj2PFbtJcXWxXyppcS
         ayBFU+yaI5+lZvgG1Uqvaks7+s0yQG9pSwBOb6kFi+2HdC/SBfnTDRnmCHXwBYFDfB
         NfCcRYOOtxoRhl5I9mNdUYRCukuNtgxXFLlsqW6cDhzInP4tqHqFxt99wcVUTaFtD+
         oBg60yPR6FOzvn+3QPVF+JyaDsngOGK/FMH+4a/Bi4EU3+xd81lTglAR7jUna8aksd
         QnJpyQM8Qkrrw==
Date:   Wed, 20 Oct 2021 10:48:35 +0200
From:   Simon Horman <horms@kernel.org>
To:     =?utf-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: qed_ptp: fix redundant check of rc and
 against -EINVAL
Message-ID: <20211020084835.GB3935@kernel.org>
References: <cover.1634621525.git.sakiwit@gmail.com>
 <492df79e1ae204ec455973e22002ca2c62c41d1e.1634621525.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492df79e1ae204ec455973e22002ca2c62c41d1e.1634621525.git.sakiwit@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 12:26:41AM -0600, Jεan Sacren wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> We should first check rc alone and then check it against -EINVAL to
> avoid repeating the same operation.
> 
> With this change, we could also use constant 0 for return.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_ptp.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> index 2c62d732e5c2..c927ff409109 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> @@ -52,9 +52,9 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
>  	qed_mcp_resc_lock_default_init(&params, NULL, resource, true);
>  
>  	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &params);
> -	if (rc && rc != -EINVAL) {
> -		return rc;
> -	} else if (rc == -EINVAL) {
> +	if (rc) {
> +		if (rc != -EINVAL)
> +			return rc;
>  		/* MFW doesn't support resource locking, first PF on the port
>  		 * has lock ownership.
>  		 */
> @@ -63,12 +63,14 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
>  
>  		DP_INFO(p_hwfn, "PF doesn't have lock ownership\n");
>  		return -EBUSY;
> -	} else if (!rc && !params.b_granted) {
> +	}
> +
> +	if (!params.b_granted) {

Can it be the case where the condition above is met and !rc is false?
If so your patch seems to have changed the logic of this function.

>  		DP_INFO(p_hwfn, "Failed to acquire ptp resource lock\n");
>  		return -EBUSY;
>  	}
>  
> -	return rc;
> +	return 0;
>  }
>  
>  static int qed_ptp_res_unlock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> 
