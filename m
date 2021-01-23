Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAB3301310
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbhAWEah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbhAWEag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 23:30:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997E023601;
        Sat, 23 Jan 2021 04:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611376195;
        bh=hLHo7mfSPRIbnQWSc9flUm38ftt5VN8HqJYp0ZQpb8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lJTIM0C45DNI9UY2KJoxVp84qoIaFptWxM2AZ97dktFLrHc0OzpOErrkZKiPSCgr7
         1g7I0qeu/Kj1eKQnzFeTHuYjTEZxcIfVeF2BW4u/NBY205ajcEWy6RojCPHkRxBSuV
         Z5KH0Kdc6QiNS4ULUwuApGmrtWYJ2QuFqk9CauVkCjVK4l/VeeYqqsC7rl1iwxLg7h
         8qxK94OEM4BCzSn7rZ6aogQkxa5tsYex63cpER6s0Voaa8SHv32JXcyRMh6QWu6pA9
         W0IK93SzTVkpZF90ahmv6xjxOJhNqeBWJzIeQo7YXhhUiPwv64GoC5h/drS95f4r9o
         HZhRYEOnTg6cg==
Date:   Fri, 22 Jan 2021 20:29:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Christina Jacob <cjacob@marvell.com>
Subject: Re: [net-next PATCH 3/7] octeontx2-pf: ethtool fec mode support
Message-ID: <20210122202953.59f806c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1611215609-92301-4-git-send-email-hkelam@marvell.com>
References: <1611215609-92301-1-git-send-email-hkelam@marvell.com>
        <1611215609-92301-4-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 13:23:25 +0530 Hariprasad Kelam wrote:
> From: Christina Jacob <cjacob@marvell.com>
> 
> Add ethtool support to configure fec modes baser/rs and
> support to fecth FEC stats from CGX as well PHY.
> 
> Configure fec mode
> 	- ethtool --set-fec eth0 encoding rs/baser/off/auto
> Query fec mode
> 	- ethtool --show-fec eth0
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 +++
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
>  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 174 ++++++++++++++++++++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
>  4 files changed, 204 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index bdfa2e2..d09119b 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -60,6 +60,22 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf)
>  	mutex_unlock(&pfvf->mbox.lock);
>  }
>  
> +void otx2_update_lmac_fec_stats(struct otx2_nic *pfvf)
> +{
> +	struct msg_req *req;
> +
> +	if (!netif_running(pfvf->netdev))
> +		return;
> +	mutex_lock(&pfvf->mbox.lock);
> +	req = otx2_mbox_alloc_msg_cgx_fec_stats(&pfvf->mbox);
> +	if (!req) {
> +		mutex_unlock(&pfvf->mbox.lock);
> +		return;
> +	}
> +	otx2_sync_mbox_msg(&pfvf->mbox);
> +	mutex_unlock(&pfvf->mbox.lock);
> +}
> +
>  int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx)
>  {
>  	struct otx2_rcv_queue *rq = &pfvf->qset.rq[qidx];
> @@ -1491,6 +1507,13 @@ void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
>  		pfvf->hw.cgx_tx_stats[id] = rsp->tx_stats[id];
>  }
>  
> +void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
> +				struct cgx_fec_stats_rsp *rsp)
> +{
> +		pfvf->hw.cgx_fec_corr_blks += rsp->fec_corr_blks;
> +		pfvf->hw.cgx_fec_uncorr_blks += rsp->fec_uncorr_blks;

double indented

> +}
> +
>  void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
>  				  struct nix_txsch_alloc_rsp *rsp)
>  {

> @@ -183,12 +210,42 @@ static void otx2_get_ethtool_stats(struct net_device *netdev,
>  	for (stat = 0; stat < CGX_TX_STATS_COUNT; stat++)
>  		*(data++) = pfvf->hw.cgx_tx_stats[stat];
>  	*(data++) = pfvf->reset_count;
> +
> +	if (pfvf->linfo.fec == OTX2_FEC_NONE)
> +		return;

Don't hide the stats based on configuration.
Getting number of stats and requesting them are two different syscalls.

> +	fec_corr_blks = pfvf->hw.cgx_fec_corr_blks;
> +	fec_uncorr_blks = pfvf->hw.cgx_fec_uncorr_blks;
> +
> +	rsp = otx2_get_fwdata(pfvf);
> +	if (!IS_ERR(rsp) && rsp->fwdata.phy.misc.has_fec_stats &&
> +	    !otx2_get_phy_fec_stats(pfvf)) {
> +		/* Fetch fwdata again because it's been recently populated with
> +		 * latest PHY FEC stats.
> +		 */
> +		rsp = otx2_get_fwdata(pfvf);
> +		if (!IS_ERR(rsp)) {
> +			struct fec_stats_s *p = &rsp->fwdata.phy.fec_stats;
> +
> +			if (pfvf->linfo.fec == OTX2_FEC_BASER) {
> +				fec_corr_blks   = p->brfec_corr_blks;
> +				fec_uncorr_blks = p->brfec_uncorr_blks;
> +			} else {
> +				fec_corr_blks   = p->rsfec_corr_cws;
> +				fec_uncorr_blks = p->rsfec_uncorr_cws;
> +			}
> +		}
> +	}
> +
> +	*(data++) = fec_corr_blks;
> +	*(data++) = fec_uncorr_blks;
>  }

> +static int otx2_get_fecparam(struct net_device *netdev,
> +			     struct ethtool_fecparam *fecparam)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct cgx_fw_data *rsp;
> +	int fec[] = {

const

> +		ETHTOOL_FEC_OFF,
> +		ETHTOOL_FEC_BASER,
> +		ETHTOOL_FEC_RS,
> +		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
> +#define FEC_MAX_INDEX 3
> +	if (pfvf->linfo.fec < FEC_MAX_INDEX)
> +		fecparam->active_fec = fec[pfvf->linfo.fec];
> +
> +	rsp = otx2_get_fwdata(pfvf);
> +	if (IS_ERR(rsp))
> +		return PTR_ERR(rsp);
> +
> +	if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX) {
> +		if (!rsp->fwdata.supported_fec)
> +			fecparam->fec = ETHTOOL_FEC_NONE;
> +		else
> +			fecparam->fec = fec[rsp->fwdata.supported_fec];
> +	}
> +	return 0;
> +}
> +
> +static int otx2_set_fecparam(struct net_device *netdev,
> +			     struct ethtool_fecparam *fecparam)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct mbox *mbox = &pfvf->mbox;
> +	struct fec_mode *req, *rsp;
> +	int err = 0, fec = 0;
> +
> +	switch (fecparam->fec) {
> +	case ETHTOOL_FEC_OFF:
> +		fec = OTX2_FEC_NONE;
> +		break;
> +	case ETHTOOL_FEC_RS:
> +		fec = OTX2_FEC_RS;
> +		break;
> +	case ETHTOOL_FEC_BASER:
> +		fec = OTX2_FEC_BASER;
> +		break;
> +	default:
> +		fec = OTX2_FEC_NONE;

IIRC fecparam->fec is a bitmask, you can't assume other than one bit
set is NONE.

> +		break;
> +	}
> +
> +	if (fec == pfvf->linfo.fec)
> +		return 0;
> +
> +	mutex_lock(&mbox->lock);
> +	req = otx2_mbox_alloc_msg_cgx_set_fec_param(&pfvf->mbox);
> +	if (!req) {
> +		err = -EAGAIN;

Why -EAGAIN? When does msg allocation fail?

> +		goto end;
> +	}
> +	req->fec = fec;
> +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (err)
> +		goto end;
> +
> +	rsp = (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
> +						   0, &req->hdr);
> +	if (rsp->fec >= 0) {
> +		pfvf->linfo.fec = rsp->fec;
> +		pfvf->hw.cgx_fec_corr_blks = 0;
> +		pfvf->hw.cgx_fec_uncorr_blks = 0;

Are you clearing stats every time FEC changes?

> +

spurious new line

> +	} else {
> +		err = rsp->fec;
> +	}
> +
> +end:	mutex_unlock(&mbox->lock);

label on a separate line

> +	return err;
> +}
