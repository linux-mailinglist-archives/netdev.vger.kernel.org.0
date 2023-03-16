Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC536BD750
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjCPRmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCPRmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:42:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332E2E1FC4;
        Thu, 16 Mar 2023 10:41:39 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id h9so2543797ljq.2;
        Thu, 16 Mar 2023 10:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678988493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VCEK18KBlDYLQ7OEMzR7HnppC+UI/QYp8BO7Maeae4E=;
        b=oFsag5hhqInljbtef0/hP1RXd6oSwyIIMSv9hA/PxGa0ai8DpY19lTLktTrhPAz4xy
         BfLbQv6Eb1F2t7RWeaoTdNJHJ3qyPf8Y+PU/o7JrBxIJAk4TIQ+B9zYUo1mxp51VBlvC
         zMSQbeVQ2pNAi+ZrCvto/ivai2+UNtuTRr6xm1e7ptrp5pZGF4U8RI5Lz+BDteNWqq0y
         JGAO8GlL79AEtedkxPhEyfp//fiQSEHOBsxw9Jx5Rsem+xKRRyM22/ce0IFQ2fDcsQ3X
         ngXFNFUGSxyI2cl0Tg8P2/uawWbOc2dkuQBzau0L80czPgghtQSNnSiuOwBQMFg1LFK/
         CgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678988493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCEK18KBlDYLQ7OEMzR7HnppC+UI/QYp8BO7Maeae4E=;
        b=iVvNgU8BKz3Iysk/yMn9rFaw/V6DqlGhLfMEihlbjbPl9/84jTohhVQz3HKO1TmRwf
         qbrerEOYHlhUNMHDCoBya9KUDPH4pPrqPX3PPquBz53wcmja78o7zsDbHi/a+/edVT8H
         rtF1ysm39woFKq3B5CDEQLRUe9KNo7q3d7aKfRchlNEzYYzS61lRi7qovi/e7Ke5/4Ei
         bvrBbGUAvu3JnkovPAh+2SoibL5yn5i+aOArb/85arU7fC9dy0Ud2kTrXySz640uamQa
         osr5tFqhYa8IrGApw/s603n85dFiffiMrHOrXFuA1K1VIOeJufZaRiQG6jrtCBLYgs1L
         5Oqw==
X-Gm-Message-State: AO0yUKWrlITxZmdjmQKWlz5KARaNbwczDwjt8/wfa/B9PMi4kRlx2Mwh
        Son8/9+8nDIjMpv47r5DUx/MrXxJkXIctkfgTS0=
X-Google-Smtp-Source: AK7set/bgmPOJ4MQqd+gBp8UCNOe3nq/zDO36RKP9TZpsTqUMAvS0jfxEoJ8tx9lxQTLq2cWRG8eplaGpmAfDfQTjvs=
X-Received: by 2002:a05:651c:b9b:b0:293:4be3:9e6c with SMTP id
 bg27-20020a05651c0b9b00b002934be39e6cmr2443039ljb.1.1678988492694; Thu, 16
 Mar 2023 10:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
In-Reply-To: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 16 Mar 2023 14:41:20 -0300
Message-ID: <CAJq09z7cTSTXsKzF8=fryNbA_+_h40OsbAYNtyttHC-ktq7ryg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
> with the expectation that priv has enough trailing space.
>
> However, only realtek-smi actually allocated this chip_data space.
> Do likewise in realtek-mdio to fix out-of-bounds accesses.
>
> Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

My bad. Thanks for the fix, Ahmad.

Reviewed-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
