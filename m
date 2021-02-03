Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69630D19F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhBCCfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhBCCf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 21:35:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA45964F68;
        Wed,  3 Feb 2021 02:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612319689;
        bh=wdzT7huHwwkXg5NEIFyNg53+HskYjTZneA+PzlEH7P0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RSHFajML+NU2yN2qEDJupPGnIm5FzkOYqtcg6m5BWIN56b2/zD8rbSlEcgDYHBhgU
         1os8hZXVFLECfG5NChRhyBwvhNkzSiun8l+/VjAyRsk4EOqq2xxhsnRK45tex1aV9x
         rtQik8r4f6yWYB1cbUom3MhaOM96ku/SzP8JwWCIkqGfy9tUEKraBRn7RHUXIUUOFU
         3TQlWsERQRjKLsCzS9gWXrvrNem7FDMVNgm42BYcR6mnT6tIYhkVFT6txomxZtx+tv
         WCy+NXe7zt4PM8JaTLhjJxCiisgwlx2PEjmHjhUOdIzYZsgz6eozuWK16od/XykJKB
         yPIcjwdN7cDAg==
Date:   Tue, 2 Feb 2021 18:34:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Eryk Rybak <eryk.roch.rybak@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: Re: [PATCH net-next 6/6] i40e: Log error for oversized MTU on
 device
Message-ID: <20210202183448.060eeabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202022420.1328397-7-anthony.l.nguyen@intel.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
        <20210202022420.1328397-7-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Feb 2021 18:24:20 -0800 Tony Nguyen wrote:
> From: Eryk Rybak <eryk.roch.rybak@intel.com>
> 
> When attempting to link XDP prog with MTU larger than supported,
> user is not informed why XDP linking fails. Adding proper
> error message: "MTU too large to enable XDP".
> Due to the lack of support for non-static variables in netlinks
> extended ACK feature, additional information has been added to dmesg
> to better inform about invalid MTU setting.
> 
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
> Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> @@ -12459,8 +12460,13 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
>  	int i;
>  
>  	/* Don't allow frames that span over multiple buffers */
> -	if (frame_size > vsi->rx_buf_len)
> +	if (frame_size > vsi->rx_buf_len) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
> +		dev_info(&pf->pdev->dev,
> +			 "MTU of %u bytes is too large to enable XDP (maximum: %u bytes)\n",
> +			 vsi->netdev->mtu, vsi->rx_buf_len);

Extack should be enough.
