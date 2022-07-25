Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9AE580218
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiGYPlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiGYPlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:41:23 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8874F233;
        Mon, 25 Jul 2022 08:41:08 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id mf4so21358879ejc.3;
        Mon, 25 Jul 2022 08:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X5PtptT5MGKoliRohdoT/El7PLZkkAvtB3XDWrkG3nU=;
        b=RoqFwVeln7p2VdwXFVEl4sRYcm+l4ctGuM+chpQn2L9hezz7eHtN8MueytvmParpjZ
         WhqjVDGPdHDKlaGFofKDP00X1b+gD5RO+9qhNTcQrlHnLH4cPvDQTYjleyrjDytz4fPD
         2G+RRIIday0+wHWKTBN7jAmzXQMAuvoYL+FbvDIDlOJ3km8X6zp/6VnhGGed4In6VgQO
         ab45DAyC6husiLaGbRybxb5ipzyPzX0HN39bm2uinxn7XsXSyHjv4gQHR4hzaTokpdhQ
         nrUJsHuW9qCJvG/Tnqa895HFxTeIKeuovTnlOXdxPKpEOtm0r8PhpTGgjxhdVY67RHfE
         t51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X5PtptT5MGKoliRohdoT/El7PLZkkAvtB3XDWrkG3nU=;
        b=jKiFAJ4fUNtg8SxY2DBKSTALf26HV2pkXQrs4h/Tr6mGI87MwoYBbQIP2w8oqB33O/
         x0N9vvvMfV1SdOdJk0/bUdpzRSIfBbTJZGdjTdNK0WJLpkY3f41mVRhvrL7d4EZUbWZ2
         kSaClTG+07oOeApzsFd+0xWmZBHyQVO6wGjQGYn1Mj13PqaN9uZP+/xEgXl7Onae65KL
         wx6O3iXcg+Smx8XkuAvtITO8oww4RckhSGmjE9xuhdeRRfrJLYhUb+UdOO+G8AgOEkXr
         SgZb4aG8NIEYQVGbspPaQzFESKiRYVobubJC3Ort6u19gHPnYxXYhw/ajLgRdkbGBAfd
         jSpA==
X-Gm-Message-State: AJIora8gWnmU6RDNnoFdNvLxpHgFpYSp7KaLFISK2VdKidZioupDaF2k
        1yFLYIrVXV1tYAYHq8x6t5L50EokM5Q9qg==
X-Google-Smtp-Source: AGRyM1swT6HsBhMbOic6x2DwXTl7b0c4JGfmQjV6bk6o4V0s4aHIAaSJqk4Gbuab7D9VfG7TVe8ngg==
X-Received: by 2002:a17:907:3f29:b0:72b:91df:2c4b with SMTP id hq41-20020a1709073f2900b0072b91df2c4bmr10566441ejc.206.1658763667039;
        Mon, 25 Jul 2022 08:41:07 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id k7-20020a056402048700b0043a61f6c389sm7234872edv.4.2022.07.25.08.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 08:41:06 -0700 (PDT)
Date:   Mon, 25 Jul 2022 18:41:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 06/11] net: phylink: Add some helpers for working with
 mac caps
Message-ID: <20220725154103.e3l4cde3bhgdl65y@skbuf>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-7-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725153730.2604096-7-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 11:37:24AM -0400, Sean Anderson wrote:
> This adds a table for converting between speed/duplex and mac
> capabilities. It also adds a helper for getting the max speed/duplex
> from some caps. It is intended to be used by Russell King's DSA phylink
> series. The table will be used directly later in this series.
> 
> Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> [ adapted to live in phylink.c ]
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This is adapted from [1].
> 
> [1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk/

I did not write even one line of code from this patch, please drop my
name from the next revision when there will be one.
