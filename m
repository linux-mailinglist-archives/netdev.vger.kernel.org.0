Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3D9539BD8
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 05:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349536AbiFAD4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 23:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349534AbiFAD41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 23:56:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8453091570;
        Tue, 31 May 2022 20:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2574FB816D8;
        Wed,  1 Jun 2022 03:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEC4C385B8;
        Wed,  1 Jun 2022 03:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654055783;
        bh=taaX67TqpbjlALhz00Fz0B4fcS5avMYVJlLFkD5iriU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=URfkb99ysqil4Iu7Ixb6vF+ILdN7TeatdQ1LNZs2vLMIMjUruJvKGEDdaVD63lPad
         /HHcoD0CYIWc4D9Q66XrEqwv/Yp0Mv8u+WiPo1GcpLdnjo/6xn8nfO6h8RLix8//e/
         I0ED8+t6oiFVj1JyOLG6ky2SbppwS+raEVpaGiEgj8zxdl0iuSqu65HwWTAWWsT+U0
         unEZD+PL8/mxMZP5VD3mIvd5Aic1YcdhIJoXqxyCmkNylQtcSB/Um+hEHQDQVyIsBT
         rLFskxn7xfBMCzNkiEjbhhrVRpQ+EIXrR3yk1rFJ8TqKmHKpzmyzfNiLbfvnVcuKko
         sFTApKwks6M1A==
Date:   Tue, 31 May 2022 20:56:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piyush Malgujar <pmalgujar@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <cchavva@marvell.com>, <deppel@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 3/3] net: mdio: mdio-thunder: support for clock-freq
 attribute
Message-ID: <20220531205622.71475964@kernel.org>
In-Reply-To: <20220530125329.30717-4-pmalgujar@marvell.com>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
        <20220530125329.30717-4-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 05:53:28 -0700 Piyush Malgujar wrote:
> +static inline u32 clk_freq(u32 phase)
> +{
> +	return (100000000U / (2 * (phase)));
> +}
> +
> +static inline u32 calc_sample(u32 phase)

Please drop the inline keyword, the compiler will inline this anyway
and static inline prevents unused code warnings.

> +{
> +	return (2 * (phase) - 3);

No need to wrap arguments to a static inline in brackets.

> +}
> +
> +static u32 _config_clk(u32 req_freq, u32 *phase, u32 *sample)
> +{
> +	unsigned int p;
> +	u32 freq = 0, freq_prev;

It's customary in networking to order variable decl lines longest
to shortest.

> +	for (p = PHASE_MIN; p < PHASE_DFLT; p++) {
> +		freq_prev = freq;
> +		freq = clk_freq(p);
> +
> +		if (req_freq >= freq)
> +			break;
> +	}
> +
> +	if (p == PHASE_DFLT)
> +		freq = clk_freq(PHASE_DFLT);
> +
> +	if (p == PHASE_MIN || p == PHASE_DFLT)
> +		goto out;
> +
> +	/* Check which clock value from the identified range
> +	 * is closer to the requested value
> +	 */
> +	if ((freq_prev - req_freq) < (req_freq - freq)) {

No need for brackets around the arithmetic, assume basic operator
precedence is not broken in the compiler...
