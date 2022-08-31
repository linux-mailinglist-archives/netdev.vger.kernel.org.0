Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FAB5A7651
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiHaGNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiHaGNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:13:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E77BCC05
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2391E61747
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E53AC433C1;
        Wed, 31 Aug 2022 06:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661926411;
        bh=vciwpSezVSd6fDTFE8syRjiyVPiMxXG2BpVfvnM0WoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b0oWw2cYysKckFeyknYQ9xUs8c9Kf1r6r0LzYwREpkA2aENYxw9k/cGFxw5X09JvZ
         TIRGVK6G4baIydLmAGcnj0ZUSQ4+yguCfh07TQOcqvFSByJLtyaxP4zKIbh19htD8W
         8wzJJ/NznIR339c5uDlVX9+uVEUnjmJpAQ8Q3dlm+ofiQCnwKvKJid90wlGWAN5b9h
         RPZDM3nR6r+mSNgnNKx5PtdqaTN40aBEotOMgxlG/QEB5xLl71zhN0lRUJJ4Q4CYh/
         Mq2OmC8fEn7BRa5idh+KL0otbLQ7NDqEinq50n2Ot+KubqAfuxlnaGz8NP9aPEuLz4
         S0LU8CKmqWZEQ==
Date:   Tue, 30 Aug 2022 23:13:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <20220830231330.1c618258@kernel.org>
In-Reply-To: <20220830101237.22782-1-gal@nvidia.com>
References: <20220830101237.22782-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 13:12:37 +0300 Gal Pressman wrote:
> When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
> NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
> error:
> net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
>  2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                   NL802154_CMD_SET_CCA_ED_LEVEL
> 
> Use __NL802154_CMD_AFTER_LAST instead of
> 'NL802154_CMD_DEL_SEC_LEVEL + 1' to indicate the last command.
> 
> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  net/ieee802154/nl802154.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 38c4f3cb010e..dbfd24c70bd0 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -2500,7 +2500,7 @@ static struct genl_family nl802154_fam __ro_after_init = {
>  	.module = THIS_MODULE,
>  	.ops = nl802154_ops,
>  	.n_ops = ARRAY_SIZE(nl802154_ops),
> -	.resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
> +	.resv_start_op = __NL802154_CMD_AFTER_LAST,
>  	.mcgrps = nl802154_mcgrps,
>  	.n_mcgrps = ARRAY_SIZE(nl802154_mcgrps),
>  };

Thanks for the fix! I think we should switch to 
NL802154_CMD_SET_WPAN_PHY_NETNS + 1, tho.

The point is to set the value to the cmd number after _currently_ 
last defined command. The meta-value like LAST will move next time
someone adds a command, meaning the validation for new commands will
never actually come.
