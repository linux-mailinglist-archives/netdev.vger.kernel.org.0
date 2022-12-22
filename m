Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353CF653E5B
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 11:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbiLVKdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 05:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiLVKc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 05:32:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1698286C6;
        Thu, 22 Dec 2022 02:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65BDBB81D18;
        Thu, 22 Dec 2022 10:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955F3C433F2;
        Thu, 22 Dec 2022 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671705175;
        bh=Q1jf7hCQcWE81Qo6KPt6TdzNOzcZweCptnXxP/q3zlc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rg2w+9Rd54MtURxVRBtxTC24m/vXIFrUovSw8/vZn5ZCgiEjjhl1eb9zpt8PR2Eei
         dkJlICxg9961l7UqH91HmaspSJxJMCRocIkkz3mLK+uzma5V6XYV4ouUVcVPJkQ1mh
         4/8AQgs2HKaGmGLV8hoYGIiPrukF0jBwYhHsk4JK+P1+yXqfauBfhJJBZzXZnoLdSD
         1aCWSgG5kXMq+RBgnzJYyJBI/t0ff4o4lsaGHz/y5SRmylS0oLLe8iJ2gXrpnzHuAG
         DPnUz3nyQPO1MCfwHBcpwCVqF5G5fKhjnmyh/ZMeIGeXr6oXZ0ZTAEz+gQT2iEd1UE
         AAjVwyxyrDzMw==
Message-ID: <4fa68299-cc69-3856-dc3d-75f7db3dbd7a@kernel.org>
Date:   Thu, 22 Dec 2022 11:32:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] net: rfkill: gpio: add DT support
Content-Language: en-US
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel@pengutronix.de
References: <20221221104803.1693874-1-p.zabel@pengutronix.de>
 <20221221104803.1693874-2-p.zabel@pengutronix.de>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20221221104803.1693874-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/12/2022 11:48, Philipp Zabel wrote:
> Allow probing rfkill-gpio via device tree. This just hooks up the
> already existing support that was started in commit 262c91ee5e52 ("net:
> rfkill: gpio: prepare for DT and ACPI support") via the "rfkill-gpio"
> compatible.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  net/rfkill/rfkill-gpio.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index f5afc9bcdee6..9f763654cd27 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -157,12 +157,21 @@ static const struct acpi_device_id rfkill_acpi_match[] = {
>  MODULE_DEVICE_TABLE(acpi, rfkill_acpi_match);
>  #endif
>  
> +#ifdef CONFIG_OF

__maybe_unused instead

> +static const struct of_device_id rfkill_of_match[] = {
> +	{ .compatible = "rfkill-gpio", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, rfkill_of_match);


Best regards,
Krzysztof

