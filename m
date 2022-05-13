Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670825266A5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiEMP5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiEMP5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674CA21E3E;
        Fri, 13 May 2022 08:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B85161D80;
        Fri, 13 May 2022 15:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D57C34100;
        Fri, 13 May 2022 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652457450;
        bh=inFWBKZ2hLGY2XuT1PW3OLXnYsuMwC9oDE6tzFgnnbY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=l3lnbu8RQyakdlKidWtlRtKUk/OPBmDr34NuMgc+l/K8Yv7KoZfFFfox58XAvT00O
         V0+5mFRHSXYwOihOKacp9N37ZyNHgX3PQXgMM0xn2F/mdm+9Tdj3vi57mcg5TxtlQ3
         TBBZ5ZvzAHg/3CX+3HGFb8fYD6HQgm0A7jd5dAP9rgbHTk0JdpodmuCJzx8pjG+XpD
         /woHIaW9aNAvclnuUKfLUQt9IQiYBLlR/4iAEv16eP8uIBRsZXwSqnrV9xM3HnqGHe
         j+0Nap862r7n2MEtSxO+LFc1fs/rB9YRY/MCvuTFdbvL97lmO/rwcX8AUCDrYzfmt4
         wS0SU6x/ey6Bg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Govind Singh <govinds@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ath10k: do not enforce interrupt trigger type
References: <20220513151516.357549-1-krzysztof.kozlowski@linaro.org>
Date:   Fri, 13 May 2022 18:57:22 +0300
In-Reply-To: <20220513151516.357549-1-krzysztof.kozlowski@linaro.org>
        (Krzysztof Kozlowski's message of "Fri, 13 May 2022 17:15:16 +0200")
Message-ID: <87zgjl4e8t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> writes:

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

So you tested on WCN3990? On what firmware version? I can add the
Tested-on tag if you provide that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
