Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A4C3CF935
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbhGTLMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 07:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237079AbhGTLLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 07:11:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5110B610FB;
        Tue, 20 Jul 2021 11:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626781899;
        bh=cPkVD06eenYDkKcw7pGNakQi9Hf08xTsUMSmB2Kb6ag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TRYoV+xTvU+BxpEKnfdXUhlAIwZ9cXoRg3s+6LAkahzLt9D3rjfnL5Ww/Ppy7B/Ik
         A+GICr3F4cwfpFfhBIe6IjAMTPmzImlo76Yd9Nc46LHDCjUnENuYJwMfQF1BgAfjl3
         Ut57Lihc2cO5XFHy/nmbn/APTioAMc6gJqJ4BMM9jj+k3elsihAEwMyrIVtXqAAzFN
         IcVjVQ6OCFAhjLctfEwnZUNGzANz9DWZO9NJS10URaCEgGwwPpPCMl+05c3yVQ7KjW
         YSrgy8nr9YwWrQqHJfzqkkigeWB8Jfu0HLChbnTjQsuu70DJCKSed/x2smQki/4OC5
         WbTgMWZEtC2qA==
Date:   Tue, 20 Jul 2021 13:51:33 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>
Subject: Re: [net-next PATCH 3/3] octeontx2-af: Introduce internal packet
 switching
Message-ID: <20210720135133.3873fb4e@cakuba>
In-Reply-To: <1626685174-4766-4-git-send-email-sbhatta@marvell.com>
References: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
        <1626685174-4766-4-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 14:29:34 +0530, Subbaraya Sundeep wrote:
> +static int rvu_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
> +					struct netlink_ext_ack *extack)
> +{
> +	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
> +	struct rvu *rvu = rvu_dl->rvu;
> +	struct rvu_switch *rswitch;
> +
> +	rswitch = &rvu->rswitch;
> +	switch (mode) {
> +	case DEVLINK_ESWITCH_MODE_LEGACY:
> +	case DEVLINK_ESWITCH_MODE_SWITCHDEV:
> +		if (rswitch->mode == mode)
> +			return 0;
> +		rswitch->mode = mode;
> +		if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
> +			rvu_switch_enable(rvu);
> +		else
> +			rvu_switch_disable(rvu);

I don't see the code handle creation and tearing down of representors.

How do things work in this driver? Does AF have a representor netdev
for each VF (that's separate from the VF netdev itself)? Those should
only exist in switchdev mode, while legacy mode should use DMAC
switching.

I think what you want is a textbook VEPA vs VEB switch. Please take a
look at drivers implementing .ndo_bridge_getlink/.ndo_bridge_setlink.
