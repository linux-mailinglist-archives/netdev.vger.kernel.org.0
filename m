Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052346CB356
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 03:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbjC1BqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 21:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjC1BqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 21:46:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD422102;
        Mon, 27 Mar 2023 18:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54B556156E;
        Tue, 28 Mar 2023 01:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4BEC433D2;
        Tue, 28 Mar 2023 01:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679967969;
        bh=RZx2aaLuSa1JAWsRRdhzXJuR3cLjN0gD2XWPcoAbNfc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CdFyehDpbh0+HugIxeQ5zrUAc/8NvF3xNPHRlEPdSLwdB+lpqzlR1Z2TObZSA1axA
         YTdmU/C/9C6jIRly9yo2Hn7ooy52We53plIbNWNB/FZEjzphODIALLvel6PoBGptUk
         sqi7iooPidqYZP+XqLobe9eb5eNwGhl6xkWSXliUIBG/TAIxH3ZeuZoPxi/dDKlcLo
         e92rk+8tsfT9bjCBgJLnxnD1YRT2u55l4wcprJNsCFsvjZOIE5EasQc9629jcKltcc
         RRNRphIQHS7U5fqsoHHXgjLHoF5icBr3CA8IbHZumB3HvHdXsW03CsxaZPJhhv/iVF
         GaJ2uVwUNFXUg==
Date:   Mon, 27 Mar 2023 18:46:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 00/16] net: Add basic LED support for
 switch/phy
Message-ID: <20230327184606.37933d41@kernel.org>
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
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

On Mon, 27 Mar 2023 16:10:15 +0200 Christian Marangi wrote:
> This is a continue of [1]. It was decided to take a more gradual
> approach to implement LEDs support for switch and phy starting with
> basic support and then implementing the hw control part when we have all
> the prereq done.
> 
> This series implements only the brightness_set() and blink_set() ops.
> An example of switch implementation is done with qca8k.
> 
> For PHY a more generic approach is used with implementing the LED
> support in PHY core and with the user (in this case marvell) adding all
> the required functions.
> 
> Currently we set the default-state as "keep" to not change the default
> configuration of the declared LEDs since almost every switch have a
> default configuration.

Please run ./scripts/kernel-doc -none on the headers,
the new ops added in patches 6 and 8 need to be kdoc'ed.
