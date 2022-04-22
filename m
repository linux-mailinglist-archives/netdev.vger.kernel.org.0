Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6E050C4CD
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiDVXea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiDVXch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF172FBEAB;
        Fri, 22 Apr 2022 16:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88C14B832E2;
        Fri, 22 Apr 2022 23:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C92C385A4;
        Fri, 22 Apr 2022 23:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650669187;
        bh=+bWM4jQypuRyr9hdKzZtZVpK4pbUaBz3lqN1cR1DhB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P5i/KXST6+gJT5ZfDGVugr7Int5LslybQ+LA5Y423xAob3GEEbTrpjG4Scy5apKiU
         VzlApQfZTOxLn3Eh1I+2e0ju6n+FjR0TdtINFA5G1TgnolFVadUn+A+/vAtPUOZJdv
         gCndAdbB6IS+Nsi1QQBcwUtplGWCTIz7g+NOWVs8ovnti/ZKLDa2SKM18705TseOJ+
         bTUXK6IkOH2+y6LtcezSVPHIHS296RIEt4Xkaz5pR+guagb8EsrmBYFiNu1MPKGxwp
         k/39+oLydarfoUvS2gBtDOCADixi7qdslTe0JScnUA0fB55U5avKMquosjzzNarhs+
         he5UlgArKbjSg==
Date:   Fri, 22 Apr 2022 16:13:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Vincent Cuissard <cuissard@marvell.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: nfcmrvl: spi: Fix irq_of_parse_and_map() return
 value
Message-ID: <20220422161305.59e0be38@kernel.org>
In-Reply-To: <20220422104758.64039-1-krzysztof.kozlowski@linaro.org>
References: <20220422104758.64039-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 12:47:58 +0200 Krzysztof Kozlowski wrote:
> The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.
> 
> Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> This is another issue to https://lore.kernel.org/all/20220422084605.2775542-1-lv.ruyi@zte.com.cn/

Maybe send one patch that fixes both and also fixes the usage of ret?

> diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
> index a38e2fcdfd39..01f0a08a381c 100644
> --- a/drivers/nfc/nfcmrvl/spi.c
> +++ b/drivers/nfc/nfcmrvl/spi.c
> @@ -115,7 +115,7 @@ static int nfcmrvl_spi_parse_dt(struct device_node *node,
>  	}
>  
>  	ret = irq_of_parse_and_map(node, 0);
> -	if (ret < 0) {
> +	if (!ret) {
>  		pr_err("Unable to get irq, error: %d\n", ret);
>  		return ret;
>  	}
