Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236E34BDC9D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbiBUJ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 04:59:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353457AbiBUJ51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 04:57:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137AC39685;
        Mon, 21 Feb 2022 01:25:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8AA4B80EB8;
        Mon, 21 Feb 2022 09:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A733BC340F3;
        Mon, 21 Feb 2022 09:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645435554;
        bh=pTs1KoJz12fq0suxK/PNOmIm2Mipe1yi2Mmf5i++HuA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BdOvfN2KPA6X/hKIAutABNjteXHPyRcli2E0FCJs6/ucQQHN9197WbEkn5KYm/x1s
         cbRgeO8J2i5PsQIQOeJprrAwLNIsZ5euWk2hoINpcws3RX9QT/DrPZNc+M31mQ5iUl
         4AxrQ8qhs1Em+kw86BeJe6vdOI5QtAd5JCB36m99v3FTKgni/HU0E3YCLwnptoOTox
         nxaI/KCiQMcuKez4F7GZBO6ErYYgGs8mv8YHVjAYdJk/bc+rVRIAjY5+7vEe55W7ar
         HJU9PMJIp0U8rfXvt6qPoxO176scYBVJij/eENXJ/Z1eJESOSQDin6jgkL29QIL3tT
         qdH/dhIFMCKgA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        ryan.odonoghue@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] wcn36xx: Initialize channel to NULL inside wcn36xx_change_opchannel()
References: <20220219152912.93580-1-jrdr.linux@gmail.com>
Date:   Mon, 21 Feb 2022 11:25:49 +0200
In-Reply-To: <20220219152912.93580-1-jrdr.linux@gmail.com> (Souptick Joarder's
        message of "Sat, 19 Feb 2022 20:59:12 +0530")
Message-ID: <87o830y3j6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Souptick Joarder <jrdr.linux@gmail.com> writes:

> From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
>
> Kernel test robot reported below warning ->
> drivers/net/wireless/ath/wcn36xx/main.c:409:7: warning: Branch
> condition evaluates to a garbage value
> [clang-analyzer-core.uninitialized.Branch]
>
> Also code walk indicates, if channel is not found in first band,
> it will break the loop and instead of exit it will go ahead and
> assign a garbage value in wcn->channel which looks like a bug.
>
> Initialize channel with NULL should avoid this issue.
>
> Fixes: 	d6f2746691cb ("wcn36xx: Track the band and channel we are tuned to")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index 75661d449712..1a06eff07107 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -394,7 +394,7 @@ static void wcn36xx_change_opchannel(struct wcn36xx *wcn, int ch)
>  	struct ieee80211_vif *vif = NULL;
>  	struct wcn36xx_vif *tmp;
>  	struct ieee80211_supported_band *band;
> -	struct ieee80211_channel *channel;
> +	struct ieee80211_channel *channel = NULL;
>  	unsigned long flags;
>  	int i, j;

I have already applied an identical patch from Dan:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=11e41e2929378df945bf50b95409d93059ad4507

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
