Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D806455F6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLGJBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLGJBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:01:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA123B3;
        Wed,  7 Dec 2022 01:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B690B81B51;
        Wed,  7 Dec 2022 09:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF571C433D6;
        Wed,  7 Dec 2022 09:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670403688;
        bh=HsAIY/njquEAeiBXvkIXYVIRzC6BKGyZBfVHiR0FK00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOqy+toZ0W4FLw/mYuuKcryTgReNVNsOE/riMNkU5onAreiKw/Dj8OcOZNId9qdju
         MkmAl/J6CT3guADlVizr8s+3qyI5bjSLc44rIU+MPnNMI34xYcmDnPS/8D0o6g6vFc
         g3O+WwVeiYg85vvl2zDcIQLkbx6NPZZUbrz5WsgFs3LKGCNFdFMDq0Gf0EugDrrbyq
         ygMsgEGNQ5eFWCQkYDGldRToAtNUdqTKOpnI0fOIsse4UeztUSaZ4qPSpu3j3FPgwR
         Lm0rbgFs3BIE0rJ1pRVL8XU6OZCdLOEBDn0kzV64Bbv0f2L+W2ExqDJ8BT7EjekVXV
         FiATcJIDD/XwQ==
Date:   Wed, 7 Dec 2022 11:01:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net v2] net: mvneta: Fix an out of bounds check
Message-ID: <Y5BWZDS09uv7TTKA@unreal>
References: <Y5A7d1E5ccwHTYPf@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5A7d1E5ccwHTYPf@kadam>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 10:06:31AM +0300, Dan Carpenter wrote:
> In an earlier commit, I added a bounds check to prevent an out of bounds
> read and a WARN().  On further discussion and consideration that check
> was probably too aggressive.  Instead of returning -EINVAL, a better fix
> would be to just prevent the out of bounds read but continue the process.
> 
> Background: The value of "pp->rxq_def" is a number between 0-7 by default,
> or even higher depending on the value of "rxq_number", which is a module
> parameter. If the value is more than the number of available CPUs then
> it will trigger the WARN() in cpu_max_bits_warn().
> 
> Fixes: e8b4fc13900b ("net: mvneta: Prevent out of bounds read in mvneta_config_rss()")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> v2: fix the subject to say net instead of net-next.
> 
>  drivers/net/ethernet/marvell/mvneta.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 

Thanks for the followup,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
