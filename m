Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A086C5EBE
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjCWFYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCWFYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:24:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D5B30E7;
        Wed, 22 Mar 2023 22:24:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA58AB81EDF;
        Thu, 23 Mar 2023 05:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B178C433EF;
        Thu, 23 Mar 2023 05:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679549044;
        bh=xdQEi2T23B51NOtmLtEDnwhGyrXL92E2kjmml3aOZVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xd8+S/jIUIfM95b95dyllL8/aA6NwDvroRUD0L5LxTwB/WyCRrc1wm/4g4mjkuchs
         4zREMHnIyKMKKmeang2N38wfBrObnHejBosnVO9+oxxxhr12qj1dv1tDBu4LyMFr8t
         xWJEV1jq/DWD9ev9Kls9dPLYSQ72M531F3CmSYOVciWSnhErNw6Bw9Cx3QaFrnORgm
         e8V/YKlJ7raptRwbUr0bbsH1oDrOKRqFDKGxnN+gRjTFfyFoSZoHYM/24VYvQ2AZyK
         JNR+DM6wJkLhz6A7B1vGCyZLrMBejwjaNoCM30tTyukuoJSjbm1zAyBrE1TX5ngMeC
         pD7OmY+/AyFlg==
Date:   Wed, 22 Mar 2023 22:24:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@amd.com>,
        <harinikatakamlinux@gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: macb: Enable PTP unicast
Message-ID: <20230322222403.39191060@kernel.org>
In-Reply-To: <20230321124005.7014-2-harini.katakam@amd.com>
References: <20230321124005.7014-1-harini.katakam@amd.com>
        <20230321124005.7014-2-harini.katakam@amd.com>
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

On Tue, 21 Mar 2023 18:10:04 +0530 Harini Katakam wrote:
> +#ifdef CONFIG_MACB_USE_HWSTAMP
> +	if (gem_has_ptp(bp)) {
> +		gem_writel(bp, RXPTPUNI, bottom);
> +		gem_writel(bp, TXPTPUNI, bottom);
> +	}
> +#endif

You can use the same IS_ENABLED() trick here as you used in the if ()
below, to avoid the direct preprocessor use. In fact why not just
add the IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) to the condition inside
gem_has_ptp() ? It looks like all callers want that extra check.

> +	if (IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) && gem_has_ptp(bp))
> +		ctrl |= MACB_BIT(PTPUNI);
