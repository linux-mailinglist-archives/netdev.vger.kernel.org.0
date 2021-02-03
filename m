Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3459330D0A9
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBCBMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 20:12:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229825AbhBCBMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 20:12:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAF1B64F5F;
        Wed,  3 Feb 2021 01:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612314723;
        bh=G56cuTj7fGN7W2fU3Qs6pcj0JWGlS38pXvfg6G8gpzA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r9sJR0cCHIZx/8QEfnt12gS5ccJzbZrhRZpE7UkqwdNu+eIM0eoZqSlUyvaQTUNxS
         k1DUvcSqxlJU9wOAcw91C5QXrNZsHJiWdlvfUrqkPR+pQXx0P3fZ6hH9pylb8cC7wh
         f/gRkBrE6vtHURXbxajcup1t0PpbzcroaiDfVUilbJaZqxZtbGFYGk6F5JRGiXCn+b
         XD7jkOtlIz52rcR7NVkIP53uAFh6/OFihQYAnziB/hN0GD8U48N1vstqkWnTmswL1x
         00ZT98tJpAf+CDdplrGGpG1fYVUo6MZajw1DVYb8g9Q8hfOwlcH61tphdi/31VkMmv
         d9CYXfJ7ufPcA==
Date:   Tue, 2 Feb 2021 17:12:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <andrew@lunn.ch>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 3/7] octeontx2-pf: ethtool fec mode support
Message-ID: <20210202171201.59d2e461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612157084-101715-4-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
        <1612157084-101715-4-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 10:54:40 +0530 Hariprasad Kelam wrote:
> From: Christina Jacob <cjacob@marvell.com>
> 
> Add ethtool support to configure fec modes baser/rs and
> support to fecth FEC stats from CGX as well PHY.
> 
> Configure fec mode
> 	- ethtool --set-fec eth0 encoding rs/baser/off/auto
> Query fec mode
> 	- ethtool --show-fec eth0

> +	if (pfvf->linfo.fec) {
> +		sprintf(data, "Fec Corrected Errors: ");
> +		data += ETH_GSTRING_LEN;
> +		sprintf(data, "Fec Uncorrected Errors: ");
> +		data += ETH_GSTRING_LEN;

Once again, you can't dynamically hide stats. ethtool makes 3 separate
system calls - to get the number of stats, get the names, and get the
values. If someone changes the FEC config in between those user space
dumping stats will get confused.

> +	}
>  }

> +static int otx2_get_fecparam(struct net_device *netdev,
> +			     struct ethtool_fecparam *fecparam)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct cgx_fw_data *rsp;
> +	const int fec[] = {
> +		ETHTOOL_FEC_OFF,
> +		ETHTOOL_FEC_BASER,
> +		ETHTOOL_FEC_RS,
> +		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
> +#define FEC_MAX_INDEX 3
> +	if (pfvf->linfo.fec < FEC_MAX_INDEX)

This should be <

> +		fecparam->active_fec = fec[pfvf->linfo.fec];


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
> +	/* Firmware does not support AUTO mode consider it as FEC_NONE */
> +	case ETHTOOL_FEC_OFF:
> +	case ETHTOOL_FEC_AUTO:
> +	case ETHTOOL_FEC_NONE:

I _think_ NONE is for drivers to report that they don't support FEC
settings. It's an output only parameter. On input OFF should be used.

> +		fec = OTX2_FEC_NONE;
> +		break;
> +	case ETHTOOL_FEC_RS:
> +		fec = OTX2_FEC_RS;
> +		break;
> +	case ETHTOOL_FEC_BASER:
> +		fec = OTX2_FEC_BASER;
> +		break;
> +	default:
> +		netdev_warn(pfvf->netdev, "Unsupported FEC mode: %d",
> +			    fecparam->fec);
> +		return -EINVAL;
> +	}
> +
> +	if (fec == pfvf->linfo.fec)
> +		return 0;
> +
> +	mutex_lock(&mbox->lock);
> +	req = otx2_mbox_alloc_msg_cgx_set_fec_param(&pfvf->mbox);
> +	if (!req) {
> +		err = -ENOMEM;
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
> +		/* clear stale counters */
> +		pfvf->hw.cgx_fec_corr_blks = 0;
> +		pfvf->hw.cgx_fec_uncorr_blks = 0;

Stats are supposed to be cumulative. Don't reset the stats just because
someone changed the FEC mode. You can miss errors this way.

> +	} else {
> +		err = rsp->fec;
> +	}
