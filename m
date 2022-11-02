Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB22615B81
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiKBEeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBEeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:34:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923EA1FCED;
        Tue,  1 Nov 2022 21:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 347C3B82055;
        Wed,  2 Nov 2022 04:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E303C433C1;
        Wed,  2 Nov 2022 04:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667363645;
        bh=cGNjvtOYEMURE3oMH/1D1MQCQCYunNYL8zTW+/C/DQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GNDBrB2K0kjKRaLKFfXndBZi/IdbsSkg0av+ojWRMY/IFSBhV3zIG9+AsE/gdsIOC
         M671X8qQodprjwOxL/onL48Kyl2PlRwaHqK5saAuWi+MwJJs96/6t72kBFK8d1R/Sv
         IQDpL3TQTM1qjsP0FT9TWyHga73awegLrP8f6JONS+p6atSEotQv/AqM0NcxdH5WSa
         qfAXKA4Vpt4HdoJqkh6vyDJy2z7Ax2mca9Mrr7hRXAgcyndyq0RetLrsoGxsQlkyJU
         hMHIqgB5V4G+RCUM+bYYnFR7jOnsH08o3Vmb4/ng8ZDfpjipGXDpgFVyPV5gXm5nD7
         BLZVVnuaWohZg==
Date:   Tue, 1 Nov 2022 21:34:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 9/9] net: ipa: use a bitmap for enabled
 endpoints
Message-ID: <20221101213404.3e4c3b8f@kernel.org>
In-Reply-To: <20221030001828.754010-10-elder@linaro.org>
References: <20221030001828.754010-1-elder@linaro.org>
        <20221030001828.754010-10-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Oct 2022 19:18:28 -0500 Alex Elder wrote:
>  	/* Set up the defined endpoint bitmap */
>  	ipa->defined = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
>  	ipa->set_up = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
> +	ipa->enabled = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
>  	if (!ipa->defined || !ipa->set_up) {

This condition should now check if ipa->enabled

And the error handling patch needs to free it, in case it was something
else that didn't get allocated?

Frankly I have gotten mass-NULL-checks wrong more than once myself so
I'd steer clear of those, they are strangely error prone.

>  		dev_err(dev, "unable to allocate endpoint bitmaps\n");

this error message should not be here (patch 5 adds it I think)
memory allocation failures produce a splat, no need to print errors

> +		bitmap_free(ipa->set_up);
> +		ipa->set_up = NULL;
>  		bitmap_free(ipa->defined);
