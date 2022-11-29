Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C52D63C727
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiK2S0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbiK2S0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:26:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701D964555;
        Tue, 29 Nov 2022 10:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cy0Wc6FUl5cpTdVMiVOmfG61yLTXh8RJczd8KP8IoZA=; b=keVuLupjCmT6F9EPe36KrGtKkD
        LG5B2kQ3QljwPULHTAUg4iugMd1EkEVtyt2Jav4kfKeTdbsPdpp/svvkSm14nJG7SKd0vEJUMYC+y
        RvAMNfCW51VkEyDSO04sth7+Bs+os9FqGE0LnCC0uZGjwmojEWMmD5FTI0rii0WD8tPw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p05Ib-003twF-QX; Tue, 29 Nov 2022 19:25:41 +0100
Date:   Tue, 29 Nov 2022 19:25:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     yang.yang29@zte.com.cn
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xu.panda@zte.com.cn, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH linux-next v2] net: stmmac: use sysfs_streq() instead of
 strncmp()
Message-ID: <Y4ZOpQL3daLPqXXl@lunn.ch>
References: <202211291502286285262@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211291502286285262@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 03:02:28PM +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> Replace the open-code with sysfs_streq().
> 
> ---
> change for v2
>  - fix the mistake of redundant parameter.

> -		} else if (!strncmp(opt, "tc:", 3)) {
> +		} else if (sysfs_streq(opt, "tc:")) {
>  			if (kstrtoint(opt + 3, 0, &tc))
>  				goto err;

Vladimir made the comment:

> What's even worse is that the patch is flat out wrong. The stmmac_cmdline_opt()
> function does not parse sysfs input, but cmdline input such as
> "stmmaceth=tc:1,pause:1". The pattern of using strsep() followed by
> strncmp() for such strings is not unique to stmmac, it can also be found
> mainly in drivers under drivers/video/fbdev/.
> 
> With strncmp("tc:", 3), the code matches on the "tc:1" token properly.
> With sysfs_streq("tc:"), it doesn't.

It is not clear you have addressed this point.

   Andrew
