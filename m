Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E606CD20F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjC2GZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjC2GZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:25:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CFD10A;
        Tue, 28 Mar 2023 23:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8E73B82011;
        Wed, 29 Mar 2023 06:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBE1C433D2;
        Wed, 29 Mar 2023 06:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680071143;
        bh=58+TN5T0+QqVRS20B5Y2g96nsW5P5e4yB9oBRdQxQUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bmp/jVkYGlPKwlDUOCwbyn4BQA+z6qAuxf6+14Evq4w9P9TYv+e3PnlI15k2/vlfP
         MjnvP7IC8LIBdmMObfHqjtzD4DH4qGPt8aOKoflWptDTXZ0ZY+0TWS/kiT975YEpDP
         pkkUyCm7bAZuVABxmUg+OiZoGYUIPHMzF3mNUMuC1PhR7Cs/csNCXS3pqMKRuJjUfA
         Kc9G1RmxHqdShSjDrv6TmPYL3E6eJyCClAzErsfsVbr3VU0TzMmvqZNjZZ7yBxWysL
         //x/987vYKpd24QP5DNTrfff8Ofyfh23Brze5v6vBWFkCnBvyCDeTsS5aUwN5Kf4sI
         7H198CtZ3IdHw==
Date:   Tue, 28 Mar 2023 23:25:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guo Samin <samin.guo@starfivetech.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: Re: [net-next v9 5/6] net: stmmac: Add glue layer for StarFive
 JH7110 SoC
Message-ID: <20230328232541.5539bce6@kernel.org>
In-Reply-To: <f8be0cf7-fe78-7e63-7fbc-78d083a9f186@starfivetech.com>
References: <20230328062009.25454-1-samin.guo@starfivetech.com>
        <20230328062009.25454-6-samin.guo@starfivetech.com>
        <20230328191716.18a302a1@kernel.org>
        <f8be0cf7-fe78-7e63-7fbc-78d083a9f186@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 10:57:00 +0800 Guo Samin wrote:
> static void starfive_dwmac_fix_mac_speed(void *priv, unsigned int speed)
> {
>         struct starfive_dwmac *dwmac = priv;
>         unsigned long rate;
>         int err;
> 
> 	rate = clk_get_rate(dwmac->tx_clk);
> 
>         switch (speed) {
>         case SPEED_1000:
>                 rate = 125000000;
>                 break;
>         case SPEED_100:
>                 rate = 25000000;
>                 break;
>         case SPEED_10:
>                 rate = 2500000;
>                 break;
>         default:
>                 dev_err(dwmac->dev, "invalid speed %u\n", speed);
>                 break;
>         }   
> 
>         err = clk_set_rate(dwmac->clk_tx, rate);
>         if (err)
>                 dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
> }
> 
> What do you think?

Yup, that's even better.
