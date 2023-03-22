Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF44A6C41A5
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCVEla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVEl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600A01816E;
        Tue, 21 Mar 2023 21:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07BABB81A34;
        Wed, 22 Mar 2023 04:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B78BC433D2;
        Wed, 22 Mar 2023 04:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679460085;
        bh=5BSQJyN4y0Lh8PquhUBv6epLj3KQDZrfMGac+bWCkrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H6nhPYd4OcZXbpgN0+MpLu+R5pQQCo7F1lAsaQOJ9hEA5ECpyaoAvnShAjhPxnsLz
         O4tc+ybb0yXSxwi0zopcFAuFc6w+AmdMH1G+UyrURR18u+R4v1VobeGtNdXn3qBEjQ
         K0r2HnPHuw1fxa8MkRXkdK9tHTJlHOo/LXp+d2KSvxAkcsJfhwWyT4fM6c5LEyP2eI
         rtkicAHMOOemfSvMmkY04AizihDAJG8w2v3PerhtdwOGFXSSR+o0YBr7XsvSMYCx8A
         LLHGl4XT1D3kTgE1nqfzxzydmnh4DViEW7SppB40mREyXXcFnvIoJJUCzqI4lJgxmZ
         ZoJxyJ90zEdTw==
Date:   Tue, 21 Mar 2023 21:41:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next] net: phy: Improved phy_error() with function
 and error code
Message-ID: <20230321214124.19f29406@kernel.org>
In-Reply-To: <20230320213451.2579608-1-f.fainelli@gmail.com>
References: <20230320213451.2579608-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 14:34:51 -0700 Florian Fainelli wrote:
> +static inline void phy_error(struct phy_device *phydev)
> +{
> +	phy_error_precise(phydev, (const void *)_RET_IP_, -EIO);
> +}

LGTM apart from this _RET_IP_ here. Wouldn't this make @func
sometimes the function that returned the error and sometimes
the caller? The caller is in the stack trace already, so no
need to duplicate. Besides how dependable is using _RET_IP_ 
inside a static inline?
