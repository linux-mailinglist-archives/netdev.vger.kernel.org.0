Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC7C6BDD5A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCQAHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjCQAH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:07:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B3C738B0;
        Thu, 16 Mar 2023 17:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F36B822EC;
        Fri, 17 Mar 2023 00:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12907C433EF;
        Fri, 17 Mar 2023 00:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679011638;
        bh=qfqozMAegKijY8JNbuj9EKz7MePhaVeyD54LoSNyvDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZhWPY3/M3Sqi+evrt88Clwt3B9SMEDaX2TLOVy+k7nLqDt057pQc0Pbxk02rspClR
         626vz/UV35x2vMwvvCF9Qtn6hli5foqzEvZXwtxFkb91PPN2Zkq81L95WTOgddmw7H
         iHcIfXk+406ouIkKWI9q/pfGjJg0MdTGUOD7rU9YzQfV7NaIg8MBs8iWayNU6qUX+q
         wKc9kko5zNaRoPQAw9578Em3wT39m1Iw3qu1xGG2XRFx+UwskZWBKZQYNkS2KuJ2F+
         EZYT/CuLzjp6JhmwRvJuhjJqMYLNomtdp66H/StV9XEWgx+3Eoz9R+1rtUQbZHOCM/
         t1CoZWi1wh6oA==
Date:   Thu, 16 Mar 2023 17:07:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhao Qiang <qiang.zhao@nxp.com>, Kalle Valo <kvalo@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] net: Use of_property_read_bool() for boolean
 properties
Message-ID: <20230316170716.7039161d@kernel.org>
In-Reply-To: <20230314191828.914124-1-robh@kernel.org>
References: <20230314191828.914124-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 14:18:27 -0500 Rob Herring wrote:
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to of_property_read_bool().
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for net/can
> Acked-by: Kalle Valo <kvalo@kernel.org>
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>
> Reviewed-by: Wei Fang <wei.fang@nxp.com>
> Signed-off-by: Rob Herring <robh@kernel.org>

Applied, to net(?), thanks!
