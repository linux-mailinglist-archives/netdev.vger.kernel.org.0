Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68316B1C2D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCIHUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCIHUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:20:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2F3BC6E2
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 23:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1F75B81269
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDDDC433EF;
        Thu,  9 Mar 2023 07:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678346402;
        bh=JyyB7QzI06VLOhyJOay95dLaG0um/vgM+E3+ktWkVDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IS8TxNecME5kY1SpTiSBNCXqdU631b/xG6lai9thhpwZNdnW0QWZ3gUVopEqGdWXD
         4y60o7EgoOAr1RfJ9uHG2dsetPxQB3JQYjOlCdOBfPUmrHfmiDG2WqPXu3CUoBPPUc
         w/zAafyFBPRoQslv0d8U1/lGMGJiXfTLR3OiWAl9PugwYLKR0gt7aethsDTINZVSCT
         HOWyvxstKxLMn4UkBYwStp3Tjvgq32rOgjjIxGinyGAtzwJSWDfAGehdcXB62oS5Co
         jl5DrfwBhx57RgjJQUqajpNuOBamFkDOYeiDkJ6nhQMVjDrvuKn2MzKCGlMgeEUXtE
         IAYW9JEqJcjfw==
Date:   Wed, 8 Mar 2023 23:20:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kristian Overskeid <koverskeid@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: hsr: Don't log netdev_err message on unknown prp
 dst node
Message-ID: <20230308232001.2fb62013@kernel.org>
In-Reply-To: <20230307133229.127442-1-koverskeid@gmail.com>
References: <20230307133229.127442-1-koverskeid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Mar 2023 14:32:29 +0100 Kristian Overskeid wrote:
>  	if (!node_dst) {
> -		if (net_ratelimit())
> +		if (net_ratelimit() && port->hsr->prot_version != PRP_V1)

nit: wouldn't the condition make more sense before the net_ratelimit() ?
net_ratelimit() will update its state which is unnecessary if we're not
going to print either way.

When you repost - could you cast a wider net with the CC list?
Add the author of the code? (The print itself, not Taehee)
Maybe some folks who touched this file most recently?

>  			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
