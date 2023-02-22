Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9D569F243
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjBVJx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjBVJxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:53:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A17305CA;
        Wed, 22 Feb 2023 01:52:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDF66B81218;
        Wed, 22 Feb 2023 09:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6649CC433D2;
        Wed, 22 Feb 2023 09:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677059516;
        bh=PyUDgmO8GAvIrVIlTy6DR+3I37FfQ9drabu8uH/vTLU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=f+/ukOx2KzvGnXjS/bxr1wPEjhw6z37QZrpnv0SwajPPUQ1ZHAKYXHtBPSLDScMqw
         PkxpaO60xDNd6ttMJ7M8TZpa9YSbEVCMGathT54evZ//094i4gNguukSXdBzv1xPDD
         xcteuIeJWzI6KMgel7MWe/0VD5zesSPl6wUP7mc6aNFskGi7befFGCoYEgTVjC1j1X
         YJ7oZVG1Bk2LexqTt6AqItVUW0m27B0mDth/9GrVa+k9Eb95zhzaB6UJ5EMo39c/KJ
         M0XxMzjqqivo+aob78SL6f72gJGW+dtERSPQ0bMS3zVcWI72fHQxI8hqE/D3rWpyI4
         2Qz59+Q1vZmCQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] wifi: ath11k: Use platform_get_irq() to get the
 interrupt
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
References: <20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        junyuu@chromium.org,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Marc Zyngier <maz@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167705951022.25767.9800855263902793000.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 09:51:52 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Douglas Anderson <dianders@chromium.org> wrote:

> As of commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ
> resource from DT core"), we need to use platform_get_irq() instead of
> platform_get_resource() to get our IRQs because
> platform_get_resource() simply won't get them anymore.
> 
> This was already fixed in several other Atheros WiFi drivers,
> apparently in response to Zeal Robot reports. An example of another
> fix is commit 9503a1fc123d ("ath9k: Use platform_get_irq() to get the
> interrupt"). ath11k seems to have been missed in this effort, though.
> 
> Without this change, WiFi wasn't coming up on my Qualcomm sc7280-based
> hardware. Specifically, "platform_get_resource(pdev, IORESOURCE_IRQ,
> i)" was failing even for i=0.
> 
> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1
> 
> Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
> Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Tested-by: Jun Yu <junyuu@chromium.org>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

f117276638b7 wifi: ath11k: Use platform_get_irq() to get the interrupt
95c95251d054 wifi: ath5k: Use platform_get_irq() to get the interrupt

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

