Return-Path: <netdev+bounces-7539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B08E4720949
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9D7C1C21102
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785501B8EF;
	Fri,  2 Jun 2023 18:42:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5641992A
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:42:53 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E82A1A5;
	Fri,  2 Jun 2023 11:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=eNfE8L27WSnMGrKhYSIEYK8Z+p50w3HySEc+m+GC5XM=; b=fxFy3Ip6ShI5edhwdL9zyX2ZXD
	xS9Q+2ldQU6lAjXFBrnkHrBiNaVzxnimumOPaRZIjzpWmTq6E22hPXd98uv0fqKvu63Wq/ukcqmtd
	K8747UlDszc7me6WI+VwrHF2LPB9No4kSw7YH0OMzKxNQoNWnCeZ2zbGPt9ZqVDLecKE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q59jS-00Ehfx-3D; Fri, 02 Jun 2023 20:42:38 +0200
Date: Fri, 2 Jun 2023 20:42:38 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Detlev Casanova <detlev.casanova@collabora.com>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: net: phy: Document support for
 external PHY clk
Message-ID: <4255bc0a-491c-4fbb-88ea-ec1d864a1a24@lunn.ch>
References: <20230602182659.307876-1-detlev.casanova@collabora.com>
 <20230602182659.307876-3-detlev.casanova@collabora.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602182659.307876-3-detlev.casanova@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:26:58PM -0400, Detlev Casanova wrote:
> Ethern PHYs can have external an clock that needs to be activated before
> probing the PHY.

`Ethernet PHYs can have an external clock.`

We need to be careful with 'activated before probing the PHY'. phylib
itself will not activate the clock. You must be putting the IDs into
the compatible string, so the correct driver is loaded, and its probe
function is called. The probe itself enables the clock, so it is not
before probe, but during probe.

I'm picky about this because we have issues with enumerating the MDIO
bus to find PHYs. Some boards needs the PHY taking out of reset,
regulators enabled, clocks enabled etc, before the PHY will respond on
the bus. It is hard for the core to do this, before the probe. So we
recommend putting IDs in the compatible, so the driver probe function
to do any additional setup needed.

> Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 4f574532ee13..c1241c8a3b77 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -93,6 +93,12 @@ properties:
>        the turn around line low at end of the control phase of the
>        MDIO transaction.
>  
> +  clocks:
> +    maxItems: 1
> +    description:
> +      External clock connected to the PHY. If not specified it is assumed
> +      that the PHY uses a fixed crystal or an internal oscillator.

This text is good.

    Andrew

---
pw-bot: cr

