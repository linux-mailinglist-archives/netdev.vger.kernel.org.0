Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407FA2A73FA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387729AbgKEAuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733303AbgKEAuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 19:50:07 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D9420867;
        Thu,  5 Nov 2020 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604537406;
        bh=/dLoEEPA5mFc7W0MUN5og5nPNdU4oAEDMP6XwDO/TsQ=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=qv6n5GID/ve4s4A70z4qZblArtMyNSMip0vIeySlFGYhYnf8/bdPhuJf65GT3orpL
         P29rBkeL7guU1aREwNLaTR+PR3c3tldwhhL4tHfn6cqwWpcuD6PF88pkkgIKlhsAVz
         yqYO4fzF2Z/2B66puLJLDLrRCwAI/Z/b+r6zYLwU=
Message-ID: <14d1fa0c69605427a1bd99a034da3ed99075e8a2.camel@kernel.org>
Subject: Re: [PATCH net-next 3/6] ionic: add lif quiesce
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Date:   Wed, 04 Nov 2020 16:50:05 -0800
In-Reply-To: <20201104223354.63856-4-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
         <20201104223354.63856-4-snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
> After the queues are stopped, expressly quiesce the lif.
> This assures that even if the queues were in an odd state,
> the firmware will close up everything cleanly.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../net/ethernet/pensando/ionic/ionic_lif.c   | 24
> +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 519d544821af..28044240caf2 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1625,6 +1625,28 @@ static void ionic_lif_rss_deinit(struct
> ionic_lif *lif)
>  	ionic_lif_rss_config(lif, 0x0, NULL, NULL);
>  }
>  
> +static int ionic_lif_quiesce(struct ionic_lif *lif)
> +{
> +	struct ionic_admin_ctx ctx = {
> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
> +		.cmd.lif_setattr = {
> +			.opcode = IONIC_CMD_LIF_SETATTR,
> +			.index = cpu_to_le16(lif->index),
> +			.attr = IONIC_LIF_ATTR_STATE,
> +			.state = IONIC_LIF_QUIESCE,
> +		},
> +	};
> +	int err;
> +
> +	err = ionic_adminq_post_wait(lif, &ctx);
> +	if (err) {
> +		netdev_err(lif->netdev, "lif quiesce failed %d\n",
> err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
>  static void ionic_txrx_disable(struct ionic_lif *lif)
>  {
>  	unsigned int i;
> @@ -1639,6 +1661,8 @@ static void ionic_txrx_disable(struct ionic_lif
> *lif)
>  		for (i = 0; i < lif->nxqs; i++)
>  			err = ionic_qcq_disable(lif->rxqcqs[i], (err !=
> -ETIMEDOUT));
>  	}
> +
> +	ionic_lif_quiesce(lif);

if you don't care about return value just void out the function retval


