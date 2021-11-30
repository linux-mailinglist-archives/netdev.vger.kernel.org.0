Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFFA464149
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 23:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhK3WaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 17:30:22 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:34497 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbhK3WaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 17:30:21 -0500
Received: by mail-ot1-f52.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso32335313otj.1;
        Tue, 30 Nov 2021 14:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=V+bVPWjSVEh3pPYr1CMTA6k70Qwse01FJz22PrKn/tY=;
        b=wE6TPZVujcGQ9B1bSFAbxI6Fwfra41X9OhJf63vjUOcaT36RPN4QI40Qo+U6jElJys
         yR3l7N6Ved4WNRe6y4KfctvAgLpx+nTz2xATSZh9M6SeTXTUV1HEvsYxsxqPkjDNw8pA
         S7iXMfhcw8oWLSsHf1IGFrY/8TWCSsceSiiP25UY1ySeFHhHmqcN55tcfUhICAShwrRp
         8TdDixk6KFgl5ElIjqIXruEPVHafGPJODCuflXzfib0eTZqsIBCbbAZBJZ+fViYKD3Ci
         v9yRX+csnZSrvuUJ0+ChInoXlLlT3Jge9gDK0Hv1tYMEE6LVzrXqP5Fs2E3/3ktUxhUd
         3X+g==
X-Gm-Message-State: AOAM530gMwFSdnLAIdPHasBm9Enpe7o5WcAB3EijvlvR8sJ3/4Mezeeo
        WVbPREvcV7Z+k6qYHZYrhQ==
X-Google-Smtp-Source: ABdhPJxtJ5EXvGqTWFh+0fohZjbqmz3ItdrhbI9S2QbhtGqSVIj6lvbtF2M7V2g02eswRMYAZAho/g==
X-Received: by 2002:a9d:4e93:: with SMTP id v19mr2019149otk.146.1638311221422;
        Tue, 30 Nov 2021 14:27:01 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bh12sm4237745oib.25.2021.11.30.14.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 14:27:00 -0800 (PST)
Received: (nullmailer pid 3123425 invoked by uid 1000);
        Tue, 30 Nov 2021 22:26:59 -0000
Date:   Tue, 30 Nov 2021 16:26:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, Russell King <rmk+kernel@armlinux.org.uk>,
        devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 1/8] dt-bindings: ethernet-controller:
 support multiple PHY connection types
Message-ID: <YaalM87hNMv5jXhv@robh.at.kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
 <20211123164027.15618-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211123164027.15618-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 17:40:20 +0100, Marek Behún wrote:
> Sometimes, an ethernet PHY may communicate with ethernet controller with
> multiple different PHY connection types, and the software should be able
> to choose between them.
> 
> Russell King says:
>   conventionally phy-mode has meant "this is the mode we want to operate
>   the PHY interface in" which was fine when PHYs didn't change their
>   mode depending on the media speed
> This is no longer the case, since we have PHYs that can change PHY mode.
> 
> Existing example is the Marvell 88X3310 PHY, which supports connecting
> the MAC with the PHY with `xaui` and `rxaui`. The MAC may also support
> both modes, but it is possible that a particular board doesn't have
> these modes wired (since they use multiple SerDes lanes).
> 
> Another example is one SerDes lane capable of `1000base-x`, `2500base-x`
> and `sgmii` when connecting Marvell switches with Marvell ethernet
> controller. Currently we mention only one of these modes in device-tree,
> and software assumes the other modes are also supported, since they use
> the same SerDes lanes. But a board may be able to support `1000base-x`
> and not support `2500base-x`, for example due to the higher frequency
> not working correctly on a particular board.
> 
> In order for the kernel to know which modes are supported on the board,
> we need to be able to specify them all in the device-tree.
> 
> Change the type of property `phy-connection-type` of an ethernet
> controller to be an array of the enumerated strings, instead of just one
> string. Require at least one item defined.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Cc: devicetree@vger.kernel.org
> ---
>  .../bindings/net/ethernet-controller.yaml     | 94 ++++++++++---------
>  1 file changed, 49 insertions(+), 45 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
