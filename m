Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED44731CA82
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 13:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhBPMUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 07:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhBPMUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 07:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9591764DA1;
        Tue, 16 Feb 2021 12:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613478006;
        bh=eY3JuZ3bYjD3WZtwZpW3k2wGBYvzuYHR1se+7uL9cBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rD29hmLZjn/XuY6dCet6nB0+YAsDdv1jA42aZE7Okbk1USxVcblJEgWEs7cvD9J5D
         r0BBaBIFqkp2ep1fOEsajYT7/K4O313ncgRkf1goUXru9dBixq7IhuBQfMFF6v8UZs
         kC5aA7cxVppc9PPVwETP4j/O88TsAdt5VIqTwr9UoiMp55Nwk9LmFnbZXTADkVSR2F
         FHMOYEkJPThB64JGE4MTaX427IcpydTOF7WfNuzBpYuvre2Q+Pc7RD5kNzOUuxYK/Y
         nhJ6nVWLkWLRGofVPFfPezaCWVb1AxX6f4N82JprJfC0/sIrDe5h2g0iJ26HmHrlv4
         FoO1uE+lDmkxw==
Date:   Tue, 16 Feb 2021 14:20:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        lcherian@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com
Subject: Re: [net-next v2] octeontx2-af: cn10k: Fixes CN10K RPM reference
 issue
Message-ID: <YCu4cjroqPHBPAnX@unreal>
References: <20210216113936.26580-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216113936.26580-1-gakula@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 05:09:36PM +0530, Geetha sowjanya wrote:
> This patch fixes references to uninitialized variables and
> debugfs entry name for CN10K platform and HW_TSO flag check.
>
> Fixes: 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support").
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

"---" needs to be here.

Thanks

>
> v1-v2
> - Clear HW_TSO flag for 96xx B0 version.
>
> This patch fixes the bug introduced by the commit
> 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support").
> These changes are not yet merged into net branch, hence submitting
> to net-next.
>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 ++
>  .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  2 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  3 +++
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c    | 11 ++++++-----
>  4 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> index 3a1809c28e83..e668e482383a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> @@ -722,12 +722,14 @@ u32 rvu_cgx_get_fifolen(struct rvu *rvu)
>
>  static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
>  {
> +	int pf = rvu_get_pf(pcifunc);
>  	struct mac_ops *mac_ops;
>  	u8 cgx_id, lmac_id;
>
>  	if (!is_cgx_config_permitted(rvu, pcifunc))
>  		return -EPERM;
>
> +	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
>  	mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
>
>  	return mac_ops->mac_lmac_intl_lbk(rvu_cgx_pdata(cgx_id, rvu),
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> index 48a84c65804c..094124b695dc 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> @@ -2432,7 +2432,7 @@ void rvu_dbg_init(struct rvu *rvu)
>  		debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
>  				    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
>  	else
> -		debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
> +		debugfs_create_file("rvu_pf_rpm_map", 0444, rvu->rvu_dbg.root,
>  				    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
>
>  create:
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 4c472646a0ac..f14d388efb51 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -407,6 +407,9 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
>  		pfvf->hw.rq_skid = 600;
>  		pfvf->qset.rqe_cnt = Q_COUNT(Q_SIZE_1K);
>  	}
> +	if (is_96xx_B0(pfvf->pdev))
> +		__clear_bit(HW_TSO, &hw->cap_flag);
> +
>  	if (!is_dev_otx2(pfvf->pdev)) {
>  		__set_bit(CN10K_MBOX, &hw->cap_flag);
>  		__set_bit(CN10K_LMTST, &hw->cap_flag);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index 3f778fc054b5..22ec03a618b1 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -816,22 +816,23 @@ static bool is_hw_tso_supported(struct otx2_nic *pfvf,
>  {
>  	int payload_len, last_seg_size;
>
> +	if (test_bit(HW_TSO, &pfvf->hw.cap_flag))
> +		return true;
> +
> +	/* On 96xx A0, HW TSO not supported */
> +	if (!is_96xx_B0(pfvf->pdev))
> +		return false;
>
>  	/* HW has an issue due to which when the payload of the last LSO
>  	 * segment is shorter than 16 bytes, some header fields may not
>  	 * be correctly modified, hence don't offload such TSO segments.
>  	 */
> -	if (!is_96xx_B0(pfvf->pdev))
> -		return true;
>
>  	payload_len = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
>  	last_seg_size = payload_len % skb_shinfo(skb)->gso_size;
>  	if (last_seg_size && last_seg_size < 16)
>  		return false;
>
> -	if (!test_bit(HW_TSO, &pfvf->hw.cap_flag))
> -		return false;
> -
>  	return true;
>  }
>
> --
> 2.17.1
>
