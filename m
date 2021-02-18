Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729E331ED73
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhBRRk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:40:27 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:52576 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbhBRP4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 10:56:30 -0500
Date:   Thu, 18 Feb 2021 18:55:18 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/24] dt-bindings: net: dwmac: Refactor snps,*-config
 properties
Message-ID: <20210218155518.vfedhfkfro42wkmh@mobilestation>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
 <20210208135609.7685-5-Sergey.Semin@baikalelectronics.ru>
 <20210209222608.GA269004@robh.at.kernel.org>
 <20210210215749.yswl5efc3k55zx3v@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210210215749.yswl5efc3k55zx3v@mobilestation>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 12:58:00AM +0300, Serge Semin wrote:
> On Tue, Feb 09, 2021 at 04:26:08PM -0600, Rob Herring wrote:
> > On Mon, Feb 08, 2021 at 04:55:48PM +0300, Serge Semin wrote:
> > > Currently the "snps,axi-config", "snps,mtl-rx-config" and
> > > "snps,mtl-tx-config" properties are declared as a single phandle reference
> > > to a node with corresponding parameters defined. That's not good for
> > > several reasons. First of all scattering around a device tree some
> > > particular device-specific configs with no visual relation to that device
> > > isn't suitable from maintainability point of view. That leads to a
> > > disturbed representation of the actual device tree mixing actual device
> > > nodes and some vendor-specific configs. Secondly using the same configs
> > > set for several device nodes doesn't represent well the devices structure,
> > > since the interfaces these configs describe in hardware belong to
> > > different devices and may actually differ. In the later case having the
> > > configs node separated from the corresponding device nodes gets to be
> > > even unjustified.
> > > 
> > > So instead of having a separate DW *MAC configs nodes we suggest to
> > > define them as sub-nodes of the device nodes, which interfaces they
> > > actually describe. By doing so we'll make the DW *MAC nodes visually
> > > correct describing all the aspects of the IP-core configuration. Thus
> > > we'll be able to describe the configs sub-nodes bindings right in the
> > > snps,dwmac.yaml file.
> > > 
> > > Note the former "snps,axi-config", "snps,mtl-rx-config" and
> > > "snps,mtl-tx-config" properties have been marked as deprecated in favor of
> > > the added by this commit "axi-config", "mtl-rx-config" and "mtl-tx-config"
> > > sub-nodes respectively.
> > > 
> > > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > > 
> > > ---
> > > 
> > > Note this change will work only if DT-schema tool is fixed like this:
> > > 
> > > --- a/meta-schemas/nodes.yaml	2021-02-08 14:20:56.732447780 +0300
> > > +++ b/meta-schemas/nodes.yaml	2021-02-08 14:21:00.736492245 +0300
> > > @@ -22,6 +22,7 @@
> > >      - unevaluatedProperties
> > >      - deprecated
> > >      - required
> > > +    - not
> > >      - allOf
> > >      - anyOf
> > >      - oneOf
> > 
> 
> > Can you send me a patch or GH PR. There is another way to express. More 
> > below.
> 
> Ok. I'll send a patch. To what email and mailing lists shall I send it
> to?

Rob, any comments on my questions above and below?

-Sergey

> 
> > 
> > > 
> > > So a property with name "not" would be allowed and the "not-required"
> > > pattern would work.
> > > 
> > > Changelog v2:
> > > - Add the new sub-nodes "axi-config", "mtl-rx-config" and "mtl-tx-config"
> > >   describing the nodes now deprecated properties were supposed to
> > >   refer to.
> > > - Fix invalid identation in the "snps,route-*" property settings.
> > > - Use correct syntax of the JSON pointers, so the later would begin
> > >   with a '/' after the '#'.
> > > ---
> > >  .../devicetree/bindings/net/snps,dwmac.yaml   | 389 +++++++++++++-----
> > >  1 file changed, 297 insertions(+), 92 deletions(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > index 03d58bf9965f..4dda9ffa822c 100644
> > > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > @@ -150,73 +150,264 @@ properties:
> > >        in a different mode than the PHY in order to function.
> > >  
> > >    snps,axi-config:
> > > +    deprecated: true
> > >      $ref: /schemas/types.yaml#/definitions/phandle
> > >      description:
> > > -      AXI BUS Mode parameters. Phandle to a node that can contain the
> > > -      following properties
> > > -        * snps,lpi_en, enable Low Power Interface
> > > -        * snps,xit_frm, unlock on WoL
> > > -        * snps,wr_osr_lmt, max write outstanding req. limit
> > > -        * snps,rd_osr_lmt, max read outstanding req. limit
> > > -        * snps,kbbe, do not cross 1KiB boundary.
> > > -        * snps,blen, this is a vector of supported burst length.
> > > -        * snps,fb, fixed-burst
> > > -        * snps,mb, mixed-burst
> > > -        * snps,rb, rebuild INCRx Burst
> > > +      AXI BUS Mode parameters. Phandle to a node that contains the properties
> > > +      described in the 'axi-config' sub-node.
> > > +
> > > +  axi-config:
> > > +    type: object
> > > +    description: AXI BUS Mode parameters
> > > +
> > > +    properties:
> > > +      snps,lpi_en:
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: Enable Low Power Interface
> > > +
> > > +      snps,xit_frm:
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: Unlock on WoL
> > > +
> > > +      snps,wr_osr_lmt:
> > > +        $ref: /schemas/types.yaml#/definitions/uint32
> > > +        description: Max write outstanding req. limit
> > > +        default: 1
> > > +        minimum: 0
> > > +        maximum: 15
> > > +
> > > +      snps,rd_osr_lmt:
> > > +        $ref: /schemas/types.yaml#/definitions/uint32
> > > +        description: Max read outstanding req. limit
> > > +        default: 1
> > > +        minimum: 0
> > > +        maximum: 15
> > > +
> > > +      snps,kbbe:
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: Do not cross 1KiB boundary
> > > +
> > > +      snps,blen:
> > > +        $ref: /schemas/types.yaml#/definitions/uint32-array
> > > +        description: A vector of supported burst lengths
> > > +        minItems: 7
> > > +        maxItems: 7
> > > +        items:
> > > +          enum: [256, 128, 64, 32, 16, 8, 4, 0]
> > > +
> > > +      snps,fb:
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: Fixed-burst
> > > +
> > > +      snps,mb:
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: Mixed-burst
> > > +
> > > +      snps,rb:
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: Rebuild INCRx Burst
> > > +
> > > +    additionalProperties: false
> > >  
> > >    snps,mtl-rx-config:
> > 
> 
> > You could keep these pointing to child nodes to avoid driver changes.
> 
> Right, but I'd prefer having the AXI/MTL-config nodes directly found
> because they are supposed to be defined as sub-nodes anyway. Having
> the snps-prefixed AXI/MTL-config properties with phandle reference are
> going to be marked as deprecated. By doing so we'll discourage
> defining the DW MAC-related configs scattered around the new dts-es. 
> 
> > 
> > > +    deprecated: true
> > >      $ref: /schemas/types.yaml#/definitions/phandle
> > >      description:
> > > -      Multiple RX Queues parameters. Phandle to a node that can
> > > -      contain the following properties
> > > -        * snps,rx-queues-to-use, number of RX queues to be used in the
> > > -          driver
> > > -        * Choose one of these RX scheduling algorithms
> > > -          * snps,rx-sched-sp, Strict priority
> > > -          * snps,rx-sched-wsp, Weighted Strict priority
> > > -        * For each RX queue
> > > -          * Choose one of these modes
> > > -            * snps,dcb-algorithm, Queue to be enabled as DCB
> > > -            * snps,avb-algorithm, Queue to be enabled as AVB
> > > -          * snps,map-to-dma-channel, Channel to map
> > > -          * Specifiy specific packet routing
> > > -            * snps,route-avcp, AV Untagged Control packets
> > > -            * snps,route-ptp, PTP Packets
> > > -            * snps,route-dcbcp, DCB Control Packets
> > > -            * snps,route-up, Untagged Packets
> > > -            * snps,route-multi-broad, Multicast & Broadcast Packets
> > > -          * snps,priority, bitmask of the tagged frames priorities assigned to
> > > -            the queue
> > > +      Multiple RX Queues parameters. Phandle to a node that contains the
> > > +      properties described in the 'mtl-rx-config' sub-node.
> > > +
> > > +  mtl-rx-config:
> > > +    type: object
> > > +    description: Multiple RX Queues parameters
> > > +
> > > +    properties:
> > > +      snps,rx-queues-to-use:
> > > +        $ref: /schemas/types.yaml#/definitions/uint32
> > > +        description: Number of RX queues to be used in the driver
> > > +        default: 1
> > > +        minimum: 1
> > > +
> > > +    patternProperties:
> > > +      "^snps,rx-sched-(sp|wsp)$":
> > > +        $ref: /schemas/types.yaml#/definitions/flag
> > > +        description: Strict/Weighted Strict RX scheduling priority
> > > +
> > > +      "^queue[0-9]$":
> > > +        type: object
> > > +        description: Each RX Queue parameters
> > > +
> > > +        properties:
> > > +          snps,map-to-dma-channel:
> > > +            $ref: /schemas/types.yaml#/definitions/uint32
> > > +            description: DMA channel to map
> > > +
> > > +          snps,priority:
> > > +            $ref: /schemas/types.yaml#/definitions/uint32
> > > +            description: RX queue priority
> > > +            minimum: 0
> > > +            maximum: 15
> > > +
> > > +        patternProperties:
> > > +          "^snps,(dcb|avb)-algorithm$":
> > > +            $ref: /schemas/types.yaml#/definitions/flag
> > > +            description: Enable Queue as DCB/AVB
> > > +
> > > +          "^snps,route-(avcp|ptp|dcbcp|up|multi-broad)$":
> > > +            $ref: /schemas/types.yaml#/definitions/flag
> > > +            description:
> > > +              AV Untagged/PTP/DCB Control/Untagged/Multicast & Broadcast
> > > +              packets routing respectively.
> > > +
> > > +        additionalProperties: false
> > > +
> > > +        # Choose only one of the Queue modes and the packets routing
> > > +        allOf:
> > > +          - not:
> > > +              required:
> > > +                - snps,dcb-algorithm
> > > +                - snps,avb-algorithm
> > > +          - oneOf:
> > > +              - required:
> > > +                  - snps,route-avcp
> > > +              - required:
> > > +                  - snps,route-ptp
> > > +              - required:
> > > +                  - snps,route-dcbcp
> > > +              - required:
> > > +                  - snps,route-up
> > > +              - required:
> > > +                  - snps,route-multi-broad
> > > +              - not:
> > > +                  anyOf:
> > > +                    - required:
> > > +                        - snps,route-avcp
> > > +                    - required:
> > > +                        - snps,route-ptp
> > > +                    - required:
> > > +                        - snps,route-dcbcp
> > > +                    - required:
> > > +                        - snps,route-up
> > > +                    - required:
> > > +                        - snps,route-multi-broad
> > 
> 
> > This 'not: ..." could be:
> > 
> > properties:
> >   snps,route-avcp: false
> >   snps,route-ptp: false
> >   snps,route-dcbcp: false
> >   snps,route-up: false
> >   snps,route-multi-broad: false
> > 
> > Not sure which one is better. Using required everywhere or more 
> > concise...
> 
> Thanks for suggesting an alternative. I didn't figure out such option
> myself. Though in this case since we need to use the required property
> anyway, I'd prefer to have it used in the 'not' sub-schema too. At
> least for uniformity and to simplify the conditional statement
> readability, even if it causes a bit of the concise loss.
> 
> > 
> > (Really, 'route' should have taken a value and the schema would be 
> > greatly simplified. Oh well.)
> 
> Yeah, I had the same thought in mind when first saw that
> boolean-properties hell. There are few more properties in this
> bindings file which should have been also defined as taking values
> instead of being booleans...
> 
> > 
> > > +
> > > +    additionalProperties: false
> > > +
> > > +    # Choose one of the RX scheduling algorithms
> > > +    not:
> > > +      required:
> > > +        - snps,rx-sched-sp
> > > +        - snps,rx-sched-wsp
> > 
> 
> > I guess this is the problematic one. The rest should be hidden behind 
> > conditionals (a common loophole in meta-schema checks). You could do 
> > that here:
> > 
> > allOf:
> >   - not:
> >       ...
> 
> Oh, thanks. I can't believe I've missed that option. Though fixing the
> dt-schema tool would be better than using the combining schema
> keywords as a workaround.
> 
> > 
> > But why not just make one of the 2 properties required? You're already 
> > changing things. 
> 
> First of all the driver permits omitting all of them in the
> corresponding nodes and implicitly using one of the properties by
> default (the same thing is for the MTL Tx-queues). If we made some of
> them being required we would have broken the driver dts-contract,
> which is not good. Secondly I'd have to fix the
> arch/arm/boot/dts/artpec6.dtsi dts file too, which would have been an
> additional patch in the series, additional work, additional review
> from the platform maintainer, additional merge path, etc. So to speak
> that would cause more troubles, than just using the "not:" statement
> here.)
> 
> -Sergey
> 
> > 
> > Rob
