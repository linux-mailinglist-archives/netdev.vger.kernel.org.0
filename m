Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFF3184E32
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCMR4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgCMR4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 13:56:31 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B41620724;
        Fri, 13 Mar 2020 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584122191;
        bh=9Nke1s57My6lMKuqekfy60wrYVJLAhyF2Igp6v56kHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OaRJwjUZtkVsu/lHoqp4xiUa9YlUt64f6sW4fxzsB5QGsOSOAspwluOWJgIQD1pKA
         xUIWsRCzPCuy/zT35BGgfxIZTvfYJtRP4eMD78GNCelQgiq3Bd11xdJLMhkminlV0P
         1gPJa800Rtn3TKnfjThGGglli5WO64IDxTJrMFqI=
Date:   Fri, 13 Mar 2020 19:56:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 net-next 4/7] octeontx2-vf: Ethtool support
Message-ID: <20200313175625.GB67638@unreal>
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-5-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584092566-4793-5-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 03:12:43PM +0530, sunil.kovvuri@gmail.com wrote:
> From: Tomasz Duszynski <tduszynski@marvell.com>
>
> Added ethtool support for VF devices for
>  - Driver stats, Tx/Rx perqueue stats
>  - Set/show Rx/Tx queue count
>  - Set/show Rx/Tx ring sizes
>  - Set/show IRQ coalescing parameters
>  - RSS configuration etc
>
> It's the PF which owns the interface, hence VF
> cannot display underlying CGX interface stats.
> Except for this rest ethtool support reuses PF's
> APIs.
>
> Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
>  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 133 ++++++++++++++++++++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   4 +
>  3 files changed, 136 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index ca757b2..95b8f1e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -631,6 +631,7 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf);
>  int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
>  int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
>  void otx2_set_ethtool_ops(struct net_device *netdev);
> +void otx2vf_set_ethtool_ops(struct net_device *netdev);
>
>  int otx2_open(struct net_device *netdev);
>  int otx2_stop(struct net_device *netdev);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index f450111..1751e2d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -17,6 +17,7 @@
>  #include "otx2_common.h"
>
>  #define DRV_NAME	"octeontx2-nicpf"
> +#define DRV_VF_NAME	"octeontx2-nicvf"
>
>  struct otx2_stat {
>  	char name[ETH_GSTRING_LEN];
> @@ -63,14 +64,34 @@ static const unsigned int otx2_n_dev_stats = ARRAY_SIZE(otx2_dev_stats);
>  static const unsigned int otx2_n_drv_stats = ARRAY_SIZE(otx2_drv_stats);
>  static const unsigned int otx2_n_queue_stats = ARRAY_SIZE(otx2_queue_stats);
>
> +int __weak otx2vf_open(struct net_device *netdev)
> +{
> +	return 0;
> +}
> +
> +int __weak otx2vf_stop(struct net_device *netdev)
> +{
> +	return 0;
> +}

We tried very politely to explain that drivers shouldn't have "__weak"
in their code, sorry if it wasn't clear enough.

Thanks
