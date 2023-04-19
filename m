Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A706E724C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDSE1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDSE1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:27:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D9961A7;
        Tue, 18 Apr 2023 21:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EFD262F3A;
        Wed, 19 Apr 2023 04:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84120C433EF;
        Wed, 19 Apr 2023 04:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681878468;
        bh=z8Cnl+y8ZhRaFWwRA/tNVWmuFrnUGtE2tQkn1vH03MQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fkdNpsYCFIgLsxaPwHhk+tlApLi0x3z8fn+/RXy3qBRrG8HKTZez0cdG9Q4Tn/zqW
         pbDuIK7Da13J3SVPnzCq8RxZzzgxK+kf8tZ6dWxM2DMVeSgbb65dPl/5IMaYQFO5JA
         KP50dxYOK1RDFKc0Y7gZPql9cVf/tMGsfCEMPbyLZOu0DQ2ZHSzYxU2sddWHCPbQOl
         zzZoCJi5Or1D/qjAUeytjnOtePKUobrfvCVhfdaLSJqEHKsy3omA7a3/vShF6y/rwu
         WrvBO1Cz20shBfjEi4kU67X8yeUUEdEMLA6ULoUN2Ez2V/Qs3xPheEqlSS5fpqZr8Q
         bSFubUXxlgcKA==
Date:   Tue, 18 Apr 2023 21:27:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v7 00/16] net: Add basic LED support for
 switch/phy
Message-ID: <20230418212746.7db8096e@kernel.org>
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 17:17:22 +0200 Christian Marangi wrote:
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

IIRC we were supposed to take these via netdev with acks from Pavel/Lee.
So we need acks on patches 4/5/16 ? If there is a repost, could you
take out the arch/arm patches? They should not go via netdev, we'll try
to filter them out when applying but mistakes happen.
-- 
pw-bot: need-ack
