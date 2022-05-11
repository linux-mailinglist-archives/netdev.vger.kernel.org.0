Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3438523DC9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 21:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347105AbiEKTp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 15:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238550AbiEKTpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 15:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B2EB54
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 12:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A362061882
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 19:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D87C340EE;
        Wed, 11 May 2022 19:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652298353;
        bh=9FJALjqPoUiLhyzy/15XRzGMtTPXqafD4/Tt3OcIYT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ovd3tRuaRrGdugeB9nsBbL2BrAQYeDuoDpSkuF0yT6XLDlzZfxaLZ9fsO3QqnqliR
         AcBgR2hzfGJVD2CwgKFMxc5T9c/BWZtpTSTQh/INE7bwlJbzz2UYrBC5ZHP4geGCeK
         fAmsWdY5fpQTmztaCeFGf546vvp2lC24IUCsKgNX8dPkT7QyGeagYFycfsH7guMIA8
         0SQAC0sCDHrSfyKIrvLax5GnHTTKYlMUoAQGgeRBXM08AA69l+ZGc3uS2nNV1Bja96
         a8HsKtLi0TlwwYn2ViGgA4bHLdjwUJxsY0Oh2Ep8XQz+/rMnl4bXrSPGRfm9VdOnaG
         Bh+H6Y4XrReSQ==
Date:   Wed, 11 May 2022 12:45:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, Martin Habets <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH net-next 3/6] eth: switch to netif_napi_add_weight()
Message-ID: <20220511124551.1766aa66@kernel.org>
In-Reply-To: <d61cf1ea-94bc-6f71-77b6-939ba9e115c4@gmail.com>
References: <20220506170751.822862-1-kuba@kernel.org>
        <20220506170751.822862-4-kuba@kernel.org>
        <d61cf1ea-94bc-6f71-77b6-939ba9e115c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 18:57:53 +0100 Edward Cree wrote:
> > diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> > index eec80b024195..3f28f9861dfa 100644
> > --- a/drivers/net/ethernet/sfc/efx_channels.c
> > +++ b/drivers/net/ethernet/sfc/efx_channels.c
> > @@ -1316,8 +1316,8 @@ void efx_init_napi_channel(struct efx_channel *channel)
> >  	struct efx_nic *efx = channel->efx;
> >  
> >  	channel->napi_dev = efx->net_dev;
> > -	netif_napi_add(channel->napi_dev, &channel->napi_str,
> > -		       efx_poll, napi_weight);
> > +	netif_napi_add_weight(channel->napi_dev, &channel->napi_str, efx_poll,
> > +			      napi_weight);
> >  }  
> 
> This isn't really a custom weight; napi_weight is initialised to
>  64 and never changed, so probably we ought to be just using
>  NAPI_POLL_WEIGHT here and end up on the non-_weight API.
> Same goes for Falcon.

Ack, I wanted to be nice. I figured this must be a stub for a module
param in your our of tree driver. Should I send a patch to remove
the non-const static napi_weight globals and switch back to non-_weight?
