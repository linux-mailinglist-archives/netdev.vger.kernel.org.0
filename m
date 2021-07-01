Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDF73B92B7
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 16:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhGAOGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 10:06:05 -0400
Received: from mail-il1-f173.google.com ([209.85.166.173]:33652 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbhGAOGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 10:06:01 -0400
Received: by mail-il1-f173.google.com with SMTP id z1so6527451ils.0;
        Thu, 01 Jul 2021 07:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=Uriiw2oK46wfr+xz0mNWX1msjZE6Zg9K8LUgs0YARhA=;
        b=dNeJYl7PVrNGNJRASLZvY0oW6XQidEvF8pQWivfRp8g8BBfcAFttqYfscusR71DMdg
         orQOnPhRKqedEzSd4GecwCNyAaxk79y2ePUi3Xdwf7pGqbo8PVbmHLpLGUFR7fbt5PS9
         tOVJOijNYKHguza5Q8mM5SgfveIWunXvz7OqmcgaQ4CDxSkdB2dMUc/yiPoHHWI6ZewR
         XS5KUkcuJk15JxwrOkPajWXEAx2MkQdCjlzw3M+yoEoKa2c2rYHU0inrYm5ESfzT+RZG
         0Xw61GjFOlQlkTpgwaakCuGEVRKAlhnWdIG/d8AfLaW6VizkerKkJObxsYB3pkcIPI6V
         rWww==
X-Gm-Message-State: AOAM531qbbcBDmP5ue6WsX+OV7QjGEND87IBiRBT0ug/gjhPOA1bFmby
        NuGl8otweoEtQHAiCH4x6ds2qwLzUQ==
X-Google-Smtp-Source: ABdhPJz3mSzWc3I0nI9smMtCYYSDVYUFVywBs/aLUAhljnMHpacOJre8MStKUN8fPx+UdNp8IdbDGQ==
X-Received: by 2002:a92:680c:: with SMTP id d12mr22694894ilc.67.1625148209059;
        Thu, 01 Jul 2021 07:03:29 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id w19sm31980ilj.46.2021.07.01.07.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 07:03:28 -0700 (PDT)
Received: (nullmailer pid 2278708 invoked by uid 1000);
        Thu, 01 Jul 2021 14:02:43 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, Peter Rosin <peda@axentia.se>
In-Reply-To: <20210701005347.8280-1-kabel@kernel.org>
References: <20210701005347.8280-1-kabel@kernel.org>
Subject: Re: [PATCH RFC net-next] dt-bindings: ethernet-controller: document signal multiplexer
Date:   Thu, 01 Jul 2021 08:02:43 -0600
Message-Id: <1625148163.578605.2278707.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Jul 2021 02:53:47 +0200, Marek Behún wrote:
> There are devices where the MAC signals from the ethernet controller are
> not directly connected to an ethernet PHY or a SFP cage, but to a
> multiplexer, so that the device can switch between the endpoints.
> 
> For example on Turris Omnia the WAN controller is connected to a SerDes
> switch, which multiplexes the SerDes lanes between SFP cage and ethernet
> PHY, depending on whether a SFP module is present (MOD_DEF0 GPIO from
> the SFP cage).
> 
> Document how to describe such a situation for an ethernet controller in
> the device tree bindings.
> 
> Example usage could then look like:
>   &eth2 {
>     status = "okay";
>     phys = <&comphy5 2>;
>     buffer-manager = <&bm>;
>     bm,pool-long = <2>;
>     bm,pool-short = <3>;
> 
>     signal-multiplexer {
>       compatible = "gpio-signal-multiplexer";
>       gpios = <&pcawan 4 GPIO_ACTIVE_LOW>;
> 
>       endpoint@0 {
>         phy-mode = "sgmii";
> 	phy-handle = <&phy1>;
>       };
> 
>       endpoint@1 {
>         sfp = <&sfp>;
> 	phy-mode = "sgmii";
> 	managed = "in-band-status";
>       };
>     };
>   };
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> I wonder if this is the proper way to do this.
> 
> We already have framework for multiplexers in Linux, in drivers/mux.
> But as I understand it, that framework is meant to be used when the
> multiplexer state is to be set by kernel, while here it is possible
> that the multiplexer state can be (and on Turris Omnia is) set by
> the user plugging a SFP module into the SFP cage.
> 
> We theoretically could add a method for getting mux state into the mux
> framework and state notification support. But using the mux framework
> to solve this case in phylink would be rather complicated, especially
> since mux framework is abstract, and if the multiplexer state is
> determined by the MOD_DEF0 GPIO, which is also used by SFP code, the
> implementation would get rather complicate in phylink...
> 
> I wonder whether driver implementation complexity should play a role
> when proposing device tree bindings :-)
> 
> Some thoughts?
> ---
>  .../bindings/net/ethernet-controller.yaml     | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:258:18: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:261:18: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:264:18: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:267:18: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:270:18: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:273:18: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:276:18: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:279:18: [error] empty value in block mapping (empty-values)

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:phy-connection-type:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:phy-mode:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:fixed-link:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:phy:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:phy-device:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:sfp:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:managed:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: properties:signal-multiplexer:patternProperties:^endpoint@[01]$:properties:phy-handle:$ref: None is not of type 'string'
	from schema $id: http://json-schema.org/draft-07/schema#
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-connection-type: $ref
./Documentation/devicetree/bindings/net/ethernet-controller.yaml: Unresolvable JSON pointer: 'properties/phy-connection-type'
./Documentation/devicetree/bindings/net/snps,dwmac.yaml: Unresolvable JSON pointer: 'properties/phy-connection-type'
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: sfp: $ref
warning: no schema found in file: ./Documentation/devicetree/bindings/net/ethernet-controller.yaml
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: sfp: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-handle: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-handle: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: sfp: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-handle: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: fixed-link: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-connection-type: $ref
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'compatible' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'reg-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'ranges' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'clocks' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'clock-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'power-domains' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'dmas' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'dma-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: '#address-cells' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: '#size-cells' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: ethernet-ports:port@1: 'label', 'phy-handle', 'phy-mode', 'phys', 'ti,mac-only', 'ti,syscon-efuse' do not match any of the regexes: '^cpts@[0-9a-f]+', '^mdio@[0-9a-f]+$', 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-device: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: fixed-link: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-device: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy-device: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: fixed-link: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: fixed-link: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: sfp: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: managed: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: fixed-link: $ref
dt-validate: recursion error: Check for prior errors in a referenced schema
dt-validate: recursion error: Check for prior errors in a referenced schema
schemas/net/ethernet-controller.yaml: ignoring, error in schema: properties: signal-multiplexer: patternProperties: ^endpoint@[01]$: properties: phy: $ref
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: 'compatible' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: 'ranges' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: 'clocks' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: 'clock-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: 'interrupt-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: '#address-cells' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: '#size-cells' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: 'label', 'mac-address', 'phy-handle', 'phy-mode', 'phys', 'ti,dual-emac-pvid' do not match any of the regexes: '^mdio@'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@1: 'oneOf' conditional failed, one must be fixed:
	'interrupts' is a required property
	'interrupts-extended' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: 'compatible' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: 'ranges' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: 'clocks' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: 'clock-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: 'interrupt-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: '#address-cells' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: '#size-cells' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: 'label', 'mac-address', 'phy-handle', 'phy-mode', 'phys', 'ti,dual-emac-pvid' do not match any of the regexes: '^mdio@'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.example.dt.yaml: switch@0: ethernet-ports:port@2: 'oneOf' conditional failed, one must be fixed:
	'interrupts' is a required property
	'interrupts-extended' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
\ndoc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1499168

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

