Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35D8462322
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 22:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhK2VYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 16:24:14 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:34796 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhK2VWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 16:22:14 -0500
Received: by mail-oi1-f181.google.com with SMTP id t19so37144904oij.1;
        Mon, 29 Nov 2021 13:18:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LGyswygMip+gM0Zn2BGMTWYAL3PU4WmvGzxWJOLmzEI=;
        b=NgaCvlXwu7NJpuPtEJD0Q3j41fWjPyX4rPM68M7/fbXhEYuifRNSbnp01yxOyN5rOa
         YM9us3ORBdHHsqKXSqArr19MeDFtJ8oPHhbW55t/8kDVdZ/HZLCxnbXq+YyteRjMEfE/
         25fX1SuKVV5V8GQ4aM4Xq2i3dg2SYldceG8SZG9NBoU5lCpXcdyyr9Y5R+F6p2vW9LZG
         ncfnZSWa1VYX1dmFM5UBjx3X6IBIsiccx/b8WJdZlTuZCO+iyp9sQDNd4wkWsmIL5Lw+
         MMh7z5hcQ1Jhs5BGfnxo8j0ge5sw0A3JlpWoNxbSCKPtZoLymc9YqrP2Lv+ziky1/0kY
         Ctiw==
X-Gm-Message-State: AOAM533Iq43sGuUlA9VTBr9qqASJfpl2zMO0DfnNEqAZwkXCMUdFxbbU
        i/XnouH+8uCjqoa931QmptgtEqNHhA==
X-Google-Smtp-Source: ABdhPJxk0fy0MyrB5DhYEmPvPi2RqSF74r4uL04+jlY31ic2yvmMwZcSajbKwIAAsp4mpfYe0uJF7Q==
X-Received: by 2002:a05:6808:9ae:: with SMTP id e14mr531360oig.68.1638220735718;
        Mon, 29 Nov 2021 13:18:55 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id c3sm3331057oiw.8.2021.11.29.13.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 13:18:55 -0800 (PST)
Received: (nullmailer pid 627249 invoked by uid 1000);
        Mon, 29 Nov 2021 21:18:54 -0000
Date:   Mon, 29 Nov 2021 15:18:54 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: dsa: split generic port definition
 from dsa.yaml
Message-ID: <YaVDvuXlU64I8GL+@robh.at.kernel.org>
References: <20211112165752.1704-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112165752.1704-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 05:57:51PM +0100, Ansuel Smith wrote:
> Some switch may require to add additional binding to the node port.
> Move DSA generic port definition to a dedicated yaml to permit this.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 70 +++++++++++++++++++
>  .../devicetree/bindings/net/dsa/dsa.yaml      | 54 +-------------
>  2 files changed, 72 insertions(+), 52 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> new file mode 100644
> index 000000000000..258df41c9133
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -0,0 +1,70 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ethernet Switch port Device Tree Bindings
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Vivien Didelot <vivien.didelot@gmail.com>
> +
> +description:
> +  Ethernet switch port Description
> +
> +properties:
> +  reg:
> +    description: Port number
> +
> +  label:
> +    description:
> +      Describes the label associated with this port, which will become
> +      the netdev name
> +    $ref: /schemas/types.yaml#/definitions/string
> +
> +  link:
> +    description:
> +      Should be a list of phandles to other switch's DSA port. This
> +      port is used as the outgoing port towards the phandle ports. The
> +      full routing information must be given, not just the one hop
> +      routes to neighbouring switches
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +
> +  ethernet:
> +    description:
> +      Should be a phandle to a valid Ethernet device node.  This host
> +      device is what the switch port is connected to
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +
> +  dsa-tag-protocol:
> +    description:
> +      Instead of the default, the switch will use this tag protocol if
> +      possible. Useful when a device supports multiple protocols and
> +      the default is incompatible with the Ethernet device.
> +    enum:
> +      - dsa
> +      - edsa
> +      - ocelot
> +      - ocelot-8021q
> +      - seville
> +
> +  phy-handle: true
> +
> +  phy-mode: true
> +
> +  fixed-link: true
> +
> +  mac-address: true
> +
> +  sfp: true
> +
> +  managed: true
> +
> +required:
> +  - reg
> +
> +additionalProperties: true
> +
> +...
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index 224cfa45de9a..15ea9ef3def9 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -46,58 +46,8 @@ patternProperties:
>          type: object
>          description: Ethernet switch ports
>  
> -        properties:
> -          reg:
> -            description: Port number
> -
> -          label:
> -            description:
> -              Describes the label associated with this port, which will become
> -              the netdev name
> -            $ref: /schemas/types.yaml#/definitions/string
> -
> -          link:
> -            description:
> -              Should be a list of phandles to other switch's DSA port. This
> -              port is used as the outgoing port towards the phandle ports. The
> -              full routing information must be given, not just the one hop
> -              routes to neighbouring switches
> -            $ref: /schemas/types.yaml#/definitions/phandle-array
> -
> -          ethernet:
> -            description:
> -              Should be a phandle to a valid Ethernet device node.  This host
> -              device is what the switch port is connected to
> -            $ref: /schemas/types.yaml#/definitions/phandle
> -
> -          dsa-tag-protocol:
> -            description:
> -              Instead of the default, the switch will use this tag protocol if
> -              possible. Useful when a device supports multiple protocols and
> -              the default is incompatible with the Ethernet device.
> -            enum:
> -              - dsa
> -              - edsa
> -              - ocelot
> -              - ocelot-8021q
> -              - seville
> -
> -          phy-handle: true
> -
> -          phy-mode: true
> -
> -          fixed-link: true
> -
> -          mac-address: true
> -
> -          sfp: true
> -
> -          managed: true
> -
> -        required:
> -          - reg
> -
> -        additionalProperties: false
> +        allOf:
> +          - $ref: dsa-port.yaml#

Don't need 'allOf' here. And you need to add 'unevaluatedProperties: 
false'. With that,

Reviewed-by: Rob Herring <robh@kernel.org>

(This needs to go in net-next to avoid conflicts, but given the 
maintainers didn't apply it already unreviewed they probably expect I 
will apply it.)
