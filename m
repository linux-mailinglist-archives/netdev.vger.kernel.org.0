Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9537165C0CC
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbjACN2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237505AbjACN2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:28:10 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056D510FE2;
        Tue,  3 Jan 2023 05:28:09 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b88so36484661edf.6;
        Tue, 03 Jan 2023 05:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EreiMBgkUkPDnOXknsG9zCEhykLlgCHgknPkvjocXDg=;
        b=lE5AE1qGEtXjN22b/S3G1AETkhTNukPRCJ4MxTBiQDAZvKUW5Ht/FmtEV1dZHfh5LI
         SdQGBRnzfQ3SCS4mv+u7ehEnIDFFje/JfTflRycyjJaXu3743zr9CA521YiYV2oReBOO
         NRUM++tbYpXSPn9KbvB6lyyHTFLLe4UwYorzNmjnlIYdAnrG/5BHw67BdeW7LOKasHge
         kVXJ7dzv2m86oq50Oj9SszhO/YT6R1s7+1RAGL3kah6YSmlw14nq7IPv4JYCMqJpwtpA
         aFlILoGaQI/EuWQ1Y7yCIInIf89eivf3CP3hv4ftOVUsifpNEENNHDfs10EnSDtfdmCY
         rqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EreiMBgkUkPDnOXknsG9zCEhykLlgCHgknPkvjocXDg=;
        b=VHsBZgJy6kke4L+PkgvHTj8BYE5j0yC4SjnHo/GNf6QKH3YFoyKIK/awLpK5DfjEfj
         heA+hGiaMRVSetdZuHkRJj8Lb9vNbeHDrYZ2FkHmnFjwMz8bUbyw3FRH1s1xLijJwqlX
         X+ZsIdF4SLfSIfVm2s3NRfE6B2DdkK9mSdgYIh8rtpvnkURVNaoyh71KIJjp8y7HtcQR
         fPohO4oUaTmzGP8mSb7a/6wV7CGzvGn8xUhP/6udoQwhgiHlriShrq/UBIPQ+34XO1gr
         KTo+d8losPVL/EH1bLflc0xFrKZzxmivVA1j7MVO6CrNpUDp+0TaXs9jqRzYOp2Woj8k
         aVmg==
X-Gm-Message-State: AFqh2krRm9oiH2kvPHdTuHONAJV21wvUJA1SuU9MKaSoulaHMbOtvCFz
        DShhYVMCLcSbnn6OTEVvZ9Q=
X-Google-Smtp-Source: AMrXdXvoJaAQMTLwVv4xcf4a3QFrTZo4b/RaZ87Lu5eNpFpVoktvLuTqAF8pDwLTyNSShD7Z/QBTWQ==
X-Received: by 2002:aa7:c911:0:b0:48d:4504:32ed with SMTP id b17-20020aa7c911000000b0048d450432edmr7659170edt.37.1672752487476;
        Tue, 03 Jan 2023 05:28:07 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id g3-20020a170906538300b0082535e2da13sm14126800ejo.6.2023.01.03.05.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 05:28:07 -0800 (PST)
Date:   Tue, 3 Jan 2023 15:28:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 02/12] net: pcs: pcs-xpcs: Use C45 MDIO
 API
Message-ID: <20230103132804.pcqksxtiex5rglnj@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-2-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-2-ddb37710e5a7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 12:07:18AM +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Convert the PCS-XPCS driver to make use of the C45 MDIO bus API for
> modify_change().
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
