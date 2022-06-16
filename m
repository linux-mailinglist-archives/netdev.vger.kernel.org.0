Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF43A54D8B1
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348893AbiFPC6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354969AbiFPC60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9268745067;
        Wed, 15 Jun 2022 19:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E81AB8216B;
        Thu, 16 Jun 2022 02:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36849C3411A;
        Thu, 16 Jun 2022 02:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655348302;
        bh=MYARrI0icKzl8Vl3RaBlTKSY/Yl0mbW1jC39SgVEBe4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OrFPbkGkm/zaRGKMQToihB2mlz2IPh6CBHfXFie+Q6idaKU4NP+maR9uQbxCqoRwA
         pMslRWioJ9DsHGUE2D+a11D1GIBhNMNGE7G6QOR6j3Pni2znLz7A6BQ/sHzjTSHccB
         NCpFYEjgeGjnnxzQW8rDPegHBS+i9CwAwqwtkNIrIRJDUsYB2FK16XsoZe4V3EQ1fq
         Qm+KWHeyRU5VoL0gBdTUp9OlN/ddGatkfixDybUlpMKImZru95o7HQvrrgeU2EhMyo
         6suvLs0y6wnwtq/10DxJZ54Jg5zltfIK37I2zXLRaJ2bmArJhez2sden4UInEpxcfe
         zKuPpzb1uRN2A==
Date:   Wed, 15 Jun 2022 19:58:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        fido_max@inbox.ru, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, yangbo.lu@nxp.com
Subject: Re: [net] net: dsa: felix: update base time of time-aware shaper
 when adjusting PTP time
Message-ID: <20220615195820.53bae850@kernel.org>
In-Reply-To: <20220615033610.35983-1-xiaoliang.yang_1@nxp.com>
References: <20220615033610.35983-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 11:36:10 +0800 Xiaoliang Yang wrote:
> When adjusting the PTP clock, the base time of the TAS configuration
> will become unreliable. We need reset the TAS configuration by using a
> new base time.
> 
> For example, if the driver gets a base time 0 of Qbv configuration from
> user, and current time is 20000. The driver will set the TAS base time
> to be 20000. After the PTP clock adjustment, the current time becomes
> 10000. If the TAS base time is still 20000, it will be a future time,
> and TAS entry list will stop running. Another example, if the current
> time becomes to be 10000000 after PTP clock adjust, a large time offset
> can cause the hardware to hang.
> 
> This patch introduces a tas_clock_adjust() function to reset the TAS
> module by using a new base time after the PTP clock adjustment. This can
> avoid issues above.
> 
> Due to PTP clock adjustment can occur at any time, it may conflict with
> the TAS configuration. We introduce a new TAS lock to serialize the
> access to the TAS registers.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

You missed some CCs (./scripts/get_maintainer.pl) and there needs to 
be a Fixes tag if you're targeting net.
