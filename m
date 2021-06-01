Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F8D39745A
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhFANem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:34:42 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:46764 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbhFANeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:34:14 -0400
Received: by mail-oi1-f174.google.com with SMTP id x15so15472936oic.13;
        Tue, 01 Jun 2021 06:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=YqWuiSTFlne4C5q70OsuxqNoPOF4B7tUapyXWpisMTU=;
        b=onlOPDlN1fZDHm+DvFrDSVlP9XfSRi5NcR7zk9WMqA/BmnL3nG/kTopXpA0w3b+khK
         oPiEyzp48om4wiIHgtoQHiSzVXdMx5zF+dE8rqhzrEgr/1tdrGQR/STGXVH0EGzRi1od
         /xdX6Fj2NYnixTWG6ly5n51FZGXqIgZXBm/KhT+e81DkMsUEeaX2UP27daTsAbAR6b4g
         hHNwK47YXwflNwJW+J1ox4ASWxFFyvSbwjye9+Yzg5AIqX0qfeY2FXDNhB5pA5bMmgpX
         +mDD2hvlDspBIyF78PgXB4c7NS0T99K3fhGog5Fbr8qNRGyL8gi6VtVBV148PYSCpfvs
         /ojg==
X-Gm-Message-State: AOAM5304Nz/xIZzkHIfIIUsruFRpGfDkhexy+SUHbvktjEPAHso4uxgD
        O2o+8YvDpK4jmE5Yu7++/g==
X-Google-Smtp-Source: ABdhPJzclIZ42/ZAmE854DlHZkc7PxwF5Uqo0k+1hCFlR4gYOXgEwGnJyyAlwyJ4RjzBYQRtiqHIIw==
X-Received: by 2002:a05:6808:1404:: with SMTP id w4mr3283059oiv.53.1622554352937;
        Tue, 01 Jun 2021 06:32:32 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f2sm3694297otp.77.2021.06.01.06.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 06:32:32 -0700 (PDT)
Received: (nullmailer pid 242373 invoked by uid 1000);
        Tue, 01 Jun 2021 13:32:10 -0000
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
In-Reply-To: <20210531234735.1582031-1-olteanv@gmail.com>
References: <20210531234735.1582031-1-olteanv@gmail.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: sja1105: convert to YAML schema
Date:   Tue, 01 Jun 2021 08:32:10 -0500
Message-Id: <1622554330.085169.242372.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Jun 2021 02:47:35 +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The following issues exist with the device-specific sja1105,role-mac and
> sja1105,role-phy:
> 
> (a) the "sja1105" is not a valid vendor prefix and should probably have
>     been "nxp", but
> (b) as per the discussion with Florian here:
>     https://lore.kernel.org/netdev/20210201214515.cx6ivvme2tlquge2@skbuf/
>     more phy-mode values similar to "revmii" can be added which denote
>     that the port is in the role of a PHY (such as "revrmii"), making
>     the sja1105,role-phy redundant. Because there are no upstream users
>     (or any users at all, to my knowledge) of these properties, they
>     could even be removed in a future commit as far as I am concerned.
> (c) when I force-add sja1105,role-phy to a device tree for testing, the
>     patternProperties matching does not work, it results in the following
>     error:
> 
> ethernet-switch@2: ethernet-ports:port@1: 'sja1105,role-phy' does not match any of the regexes: 'pinctrl-[0-9]+'
>         From schema: Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> 
> But what's even more interesting is that if I remove the
> "additionalProperties: true" that dsa.yaml has, I get even more
> validation errors coming from patternProperties not matching either,
> from spi-controller.yaml:
> 
> ethernet-switch@2: 'compatible', 'mdio', 'reg', 'spi-cpol', 'spi-max-frequency' do not match any of the regexes: '^(ethernet-)?ports$', 'pinctrl-[0-9]+'
> 
> So... it is probably broken. Rob Herring says here:
> https://lore.kernel.org/linux-spi/20210324181037.GB3320002@robh.at.kernel.org/
> 
>   I'm aware of the issue, but I don't have a solution for this situation.
>   It's a problem anywhere we have a parent or bus binding defining
>   properties for child nodes. For now, I'd just avoid it in the examples
>   and we'll figure out how to deal with actual dts files later.
> 
> So that's what I did.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../bindings/net/dsa/nxp,sja1105.yaml         | 128 ++++++++++++++
>  .../devicetree/bindings/net/dsa/sja1105.txt   | 156 ------------------
>  2 files changed, 128 insertions(+), 156 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:65:17: [warning] wrong indentation: expected 14 but found 16 (indentation)

dtschema/dtc warnings/errors:

See https://patchwork.ozlabs.org/patch/1485820

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

