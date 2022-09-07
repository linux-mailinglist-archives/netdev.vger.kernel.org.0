Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB295B0C27
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiIGSGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiIGSGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:06:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AECFC04FB
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 11:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E32961A04
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A478C433C1;
        Wed,  7 Sep 2022 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662573994;
        bh=hB73CRXopAZj9uiY38ZrBgCBauoNPk8kK13rr1krClE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EGyys3G6uTIAvlSxbWWrT6ugdVvMfrNxK2U1s6JDaR3gtC8rV6N4LeMjPwpci7bYK
         WScjOR53UyC9d198nQhYcoVsoOWb/SiyQPd4l15TgjebQK/lNLgquAAjYnF6aKPZwN
         2q06ixDxh2CILEJjRCyDDcNusHhWS4qEyOxr1DQgf9n0f9b77ZfQr3auHGBu6Eagey
         XvTPXQOmE+fmVjQ6cX2M+V236pAJP2vBjzMJViiavOZ1jRak6QNvwF90CJeJcEeXcC
         aYa0I8IQ2qxY2GwS7QN1mu4R4Z2KoeSSZj3PPCCh0li0XcNcqcMKCyDk2p+0TzASnA
         y9ewDTX70LFdA==
Date:   Wed, 7 Sep 2022 21:06:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Message-ID: <Yxjdpt42BAiZe0sK@unreal>
References: <20220907094758.35571-1-simon.horman@corigine.com>
 <20220907094758.35571-4-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907094758.35571-4-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 11:47:58AM +0200, Simon Horman wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> Xfrm callbacks are implemented to offload SA info into firmware
> by mailbox. It supports 16K SA info in total.
> 
> Expose ipsec offload feature to upper layer, this feature will
> signal the availability of the offload.
> 
> Based on initial work of Norm Bagley <norman.bagley@netronome.com>.
> 
> Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c | 552 +++++++++++++++++-
>  .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
>  .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
>  3 files changed, 558 insertions(+), 4 deletions(-)

<...>

> +	if (x->props.flags & XFRM_STATE_ESN)
> +		cfg->ctrl_word.ext_seq = 1;
> +	else
> +		cfg->ctrl_word.ext_seq = 0;

Don't you need to implement xdo_dev_state_advance_esn() too?

Thanks
