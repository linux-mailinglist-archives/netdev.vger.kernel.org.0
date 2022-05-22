Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DDB530302
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245567AbiEVMWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiEVMWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:22:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99DB3BBDD;
        Sun, 22 May 2022 05:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FFDB80B05;
        Sun, 22 May 2022 12:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8980EC385AA;
        Sun, 22 May 2022 12:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653222139;
        bh=Mfo0m4hywKPiCkbJC9Y94IuwEqZd7gBdjqZR9nR3ImA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=oPLBRLUW8NAnzWitefrHXNP5m6s6TJXvVI1/cuJft5+KabX5BlIvZFC/mDwceWP8A
         0goICNZ0uEiVd3NfLswcqUTIq2ULS3Oo/xooWVY3o1vt1YTTE0PDpXOmAeGX0+aJSl
         KQdOL8aS6ET76aTf37oHSht1TaJwQxD2Ctj/zF2has+e5rO176lGOsBbSwTUAnFWjj
         wBWdYFTHD2pgiuku6A2o34SbwqFyfqB8BdNRujiTgR4nCMgoe9NoK3WsdO78Wqnchs
         /Ljpmm+wLyl0c64oFtbMHCTmW1GiQOqKofxvjMRplMefk0h/iJsvRwfdF9A1n4EVwn
         eUD62H5gc4eUA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: do not enforce interrupt trigger type
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220513151516.357549-1-krzysztof.kozlowski@linaro.org>
References: <20220513151516.357549-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Govind Singh <govinds@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165322213441.774.12044822958989724904.kvalo@kernel.org>
Date:   Sun, 22 May 2022 12:22:16 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> Interrupt line can be configured on different hardware in different way,
> even inverted.  Therefore driver should not enforce specific trigger
> type - edge rising - but instead rely on Devicetree to configure it.
> 
> All Qualcomm DTSI with WCN3990 define the interrupt type as level high,
> so the mismatch between DTSI and driver causes rebind issues:
> 
>   $ echo 18800000.wifi > /sys/bus/platform/drivers/ath10k_snoc/unbind
>   $ echo 18800000.wifi > /sys/bus/platform/drivers/ath10k_snoc/bind
>   [   44.763114] irq: type mismatch, failed to map hwirq-446 for interrupt-controller@17a00000!
>   [   44.763130] ath10k_snoc 18800000.wifi: error -ENXIO: IRQ index 0 not found
>   [   44.763140] ath10k_snoc 18800000.wifi: failed to initialize resource: -6
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.0.c8-00009-QCAHLSWSC8180XMTPLZ-1
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1
> 
> Fixes: c963a683e701 ("ath10k: add resource init and deinit for WCN3990")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Tested-by: Steev Klimaszewski <steev@kali.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

1ee6c5abebd3 ath10k: do not enforce interrupt trigger type

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220513151516.357549-1-krzysztof.kozlowski@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

