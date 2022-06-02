Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B471753B13E
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiFBBBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiFBBBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:01:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F63AEB1;
        Wed,  1 Jun 2022 18:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCE4A615B6;
        Thu,  2 Jun 2022 01:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CE8C385A5;
        Thu,  2 Jun 2022 01:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654131709;
        bh=aC9ykK5hOX32xqGww6ZHmNtED1DXIZriCxTeqEarar4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qhkHOANd/4demtkSkrYacaFAmct1Faxrw1rc3/HSbUYfmbPYEcw2WAk4Bfj7UD44n
         Y75jIBiyjd1oZveBG/zyMpBA29Ykz1Gp/+/FolcWFYfFKEnAaJlY+vRUM8Yto7NK3k
         IFlIfelB+Kw/RG2FOw+VMG7uhXoxOFxobj7VsCyf/wNq3wtbffblY20nCK901QRdWB
         U3Tc3a2rEtQ/L2abxcw3UhwQa3RnKyUAdxcKMgFlwD/CF7MNI++C0ipfRtiOe1L00t
         qCzH2LQBeozcyetLatGMwrBY89VMJM46IPYUcCyvkIERH/+OJ+hoRIq1gyxWaaA/4p
         dhrOfYRUEYtJA==
Date:   Wed, 1 Jun 2022 18:01:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Message-ID: <20220601180147.40a6e8ea@kernel.org>
In-Reply-To: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
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

On Thu, 2 Jun 2022 02:35:23 +0200 Joakim Tjernlund wrote:
> UP/DOWN and carrier are async events and it makes sense one can
> adjust carrier in sysfs before bringing the interface up.

Can you explain your use case?

> Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Cc: stable@vger.kernel.org

Seems a little too risky of a change to push into stable.

> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index a4ae65263384..3418ef7ef2d8 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -167,8 +167,6 @@ static DEVICE_ATTR_RO(broadcast);
>  
>  static int change_carrier(struct net_device *dev, unsigned long new_carrier)
>  {
> -	if (!netif_running(dev))
> -		return -EINVAL;
>  	return dev_change_carrier(dev, (bool)new_carrier);
>  }
