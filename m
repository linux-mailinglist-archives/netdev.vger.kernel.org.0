Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0255650C514
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiDVXbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiDVXb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8461B1A5DF3;
        Fri, 22 Apr 2022 16:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C16A61211;
        Fri, 22 Apr 2022 23:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BC3C385A4;
        Fri, 22 Apr 2022 23:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650668973;
        bh=1YkEp/4qTedMg0FaaL4g8kyBit3OibvG2l1O64f/l8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mppH4TmgBNU3u3QYB8nTYkIRI5rlHdgIoIsZiqIQdubiEdkleS11ZD+ZSVFKSWeCl
         BX5PY/zXMzg+VRkI73cbR5AUAumL4L7rE9LNmAn5kyCaeRNDy84F0ESDJ5Lz4qDlwP
         v5PR189gh+GcqHW+wrECRLwR4doUaIx09OHVXqN9XMYzPfrXk6Kk/H0okBmTc1bMFu
         aH5yVX3z7ps6cMUvwJ3qv0yRvuVII4e4kCA7cvalWP+6TOdE1jyzFMt75sntSX7SCN
         723+/gmvBedDSD5DsOG6dYXAou+XII1kvF70U4eHdu/vPlnkiB8IjlvcAlc0pfvBhp
         bVTnb8hYIk4Ig==
Date:   Fri, 22 Apr 2022 16:09:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        lv.ruyi@zte.com.cn, yashsri421@gmail.com, sameo@linux.intel.com,
        cuissard@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] NFC: nfcmrvl: fix error check return value of
 irq_of_parse_and_map()
Message-ID: <20220422160931.6a4eca42@kernel.org>
In-Reply-To: <20220422084605.2775542-1-lv.ruyi@zte.com.cn>
References: <20220422084605.2775542-1-lv.ruyi@zte.com.cn>
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

On Fri, 22 Apr 2022 08:46:05 +0000 cgel.zte@gmail.com wrote:
> diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
> index ceef81d93ac9..7dcc97707363 100644
> --- a/drivers/nfc/nfcmrvl/i2c.c
> +++ b/drivers/nfc/nfcmrvl/i2c.c
> @@ -167,7 +167,7 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
>  		pdata->irq_polarity = IRQF_TRIGGER_RISING;
>  
>  	ret = irq_of_parse_and_map(node, 0);
> -	if (ret < 0) {
> +	if (!ret) {
>  		pr_err("Unable to get irq, error: %d\n", ret);
>  		return ret;

If ret is guaranteed to be 0 in this branch now, why print it, 
and how is it okay to return it from this function on error?

The usual low quality patch from the CGEL team :/
