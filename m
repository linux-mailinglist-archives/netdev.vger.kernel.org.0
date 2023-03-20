Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9F66C0B89
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 08:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjCTHmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 03:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjCTHmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 03:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727142367C;
        Mon, 20 Mar 2023 00:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 578F6611D9;
        Mon, 20 Mar 2023 07:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC221C433EF;
        Mon, 20 Mar 2023 07:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679298127;
        bh=WjYiW3bdBC26DMUYGurbBPSF3Li7THUYtv1H3tndCY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSSytet/200iwrE/lIMidXGrJh+pzH43ULVTOKfB6cKLziSBSCB/id5jVbuVDjMpH
         eGtjeNUzYIVQ96U7U1cMrNlsE8jaxfOLrLbj20Ra5+FL9KaB4AulMJkyCGKXxmjYqF
         v8FB6Uz50mVCuGTuXBMT744SK5kx/KkNrkvucvW1CylcSlbz2CdOUmeVJWU9xglr+E
         ysiGXzVMqt+0OdYClaTxrnmMr6CH4lVEjBGbdWWFumpx0NeWO4PklXINtXdoOPjUYl
         T3214e1BkukTMmxuOJ21WwUto7l77j5NNfC7FWTvKJFusZxGlWshgfyp9rYhZhczly
         nFs1i7xEOeX6A==
Date:   Mon, 20 Mar 2023 09:42:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, longli@microsoft.com,
        ssengar@linux.microsoft.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add support for jumbo frame
Message-ID: <20230320074202.GH36557@unreal>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 02:27:44PM -0700, Haiyang Zhang wrote:
> During probe, get the hardware allowed max MTU by querying the device
> configuration. Users can select MTU up to the device limit. Also,
> when XDP is in use, we currently limit the buffer size to one page.
> 
> Updated RX data path to allocate and use RX queue DMA buffers with
> proper size based on the MTU setting.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/mana_bpf.c    |  22 +-
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 229 ++++++++++++------
>  include/net/mana/gdma.h                       |   4 +
>  include/net/mana/mana.h                       |  18 +-
>  4 files changed, 183 insertions(+), 90 deletions(-)

<...>

> +static int mana_change_mtu(struct net_device *ndev, int new_mtu)
> +{
> +	unsigned int old_mtu = ndev->mtu;
> +	int err, err2;
> +
> +	err = mana_detach(ndev, false);
> +	if (err) {
> +		netdev_err(ndev, "mana_detach failed: %d\n", err);
> +		return err;
> +	}
> +
> +	ndev->mtu = new_mtu;
> +
> +	err = mana_attach(ndev);
> +	if (!err)
> +		return 0;
> +
> +	netdev_err(ndev, "mana_attach failed: %d\n", err);
> +
> +	/* Try to roll it back to the old configuration. */
> +	ndev->mtu = old_mtu;
> +	err2 = mana_attach(ndev);

I second to Francois and agree with him that it is very questionable.
If mana_attach() failed for first try, you should bail out and not
retry with some hope that it will pass.

Thanks

> +	if (err2)
> +		netdev_err(ndev, "mana re-attach failed: %d\n", err2);
> +
> +	return err;
