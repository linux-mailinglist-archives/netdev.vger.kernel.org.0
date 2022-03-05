Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE624CE2D8
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiCEFZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiCEFZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:25:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B42C271548;
        Fri,  4 Mar 2022 21:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1633260C4A;
        Sat,  5 Mar 2022 05:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B853C340EE;
        Sat,  5 Mar 2022 05:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646457889;
        bh=BTE9peZPrHWQmkbC811zx4G15wHO4xQdxxZCeZIdvzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VOdtm+E8OdnE4klgtcY4giso4LYdez9P1UB7089ew6aOSAFjMehlCMfbsZFDiO9co
         XrC5LB2O7s1liK0UQpt3mVrl80RUN/1l/EkOy55V4sAvQxbi+/TMw1Vun+W45GFyyH
         vSOFU6idey1ijx3+mkN7fCgs4ZtD1Z+lKVpp74AiYPQZPvyOkTXkE6poXCA+G13U1T
         tf5b7TLP/ew+zpFFB7MuOp65lwdtehXztUAC/1mGBRObBJgJuVVvA0y1KkBXfuRWT3
         /HldIcngCUtSQpIa0rCkT9EGKRRkz9QH3KS/A7Inxdub4m7gJ1P3fL8pM9DIk0pky5
         revwwtj3TDKdQ==
Date:   Fri, 4 Mar 2022 21:24:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net,
        Mario Limonciello <mario.limonciello@amd.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: atlantic: Avoid out-of-bounds indexing
Message-ID: <20220304212447.074c8caf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220304050812.7472-1-kai.heng.feng@canonical.com>
References: <20220304050812.7472-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Mar 2022 13:08:12 +0800 Kai-Heng Feng wrote:
> UBSAN warnings are observed on atlantic driver:
> [ 294.432996] UBSAN: array-index-out-of-bounds in /build/linux-Qow4fL/linux-5.15.0/drivers/net/ethernet/aquantia/atlantic/aq_nic.c:484:48
> [ 294.433695] index 8 is out of range for type 'aq_vec_s *[8]'
> 
> The index is assigned right before breaking out the loop, so there's no actual
> deferencing happening.

I think you're underselling it. This codes does not compute the address
of the ring, it reads the ring pointer from an array. The description
reads like it was doing:

	ring = &self->ring[i];

which would indeed be valid. What the code actually does is not.

Please repost with the commit message improved and a Fixes: tag(s)
pointing to commit(s) where the buggy code was introduced.

> So only use the index inside the loop to fix the issue.
> 
> BugLink: https://bugs.launchpad.net/bugs/1958770
> Tested-by: Mario Limonciello <mario.limonciello@amd.com>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  .../net/ethernet/aquantia/atlantic/aq_vec.c   | 24 +++++++++----------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
> index f4774cf051c97..6ab1f3212d246 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
> @@ -43,8 +43,8 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
>  	if (!self) {
>  		err = -EINVAL;
>  	} else {
> -		for (i = 0U, ring = self->ring[0];
> -			self->tx_rings > i; ++i, ring = self->ring[i]) {
> +		for (i = 0U; self->tx_rings > i; ++i) {
> +			ring = self->ring[i];
>  			u64_stats_update_begin(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
>  			ring[AQ_VEC_RX_ID].stats.rx.polls++;
>  			u64_stats_update_end(&ring[AQ_VEC_RX_ID].stats.rx.syncp);
