Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D0B21BC69
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgGJRjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:39:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgGJRjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 13:39:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtwzo-004VL4-Ci; Fri, 10 Jul 2020 19:39:36 +0200
Date:   Fri, 10 Jul 2020 19:39:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
Message-ID: <20200710173936.GF1037260@lunn.ch>
References: <20200710090618.28945-1-kurt@linutronix.de>
 <20200710090618.28945-2-kurt@linutronix.de>
 <20200710164500.GA2775934@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710164500.GA2775934@bogus>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 10:45:00AM -0600, Rob Herring wrote:
> On Fri, Jul 10, 2020 at 11:06:18AM +0200, Kurt Kanzenbach wrote:
> > For future DSA drivers it makes sense to add a generic DSA yaml binding which
> > can be used then. This was created using the properties from dsa.txt. It
> > includes the ports and the dsa,member property.
> > 
> > Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> > ---
> >  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
> >  1 file changed, 80 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > new file mode 100644
> > index 000000000000..bec257231bf8
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -0,0 +1,80 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Distributed Switch Architecture Device Tree Bindings
> 
> DSA is a Linuxism, right?

Hi Rob

Marvell'ism actually. They came up the idea for how you can
interconnect multiple switches to form a distributed switch fabric. So
far, the Marvell driver is the only driver that makes use of D in
DSA. But it seems like some other vendors have similar concepts. And
those which don't allow D in DSA can use a simplified version of the
architecture for a single switch.

> Describe what type of h/w should use this binding.
> 
> > +
> > +properties:
> > +  $nodename:
> > +    pattern: "^switch(@.*)?$"
> > +
> > +  dsa,member:
> > +    minItems: 2
> > +    maxItems: 2
> > +    description:
> > +      A two element list indicates which DSA cluster, and position within the
> > +      cluster a switch takes. <0 0> is cluster 0, switch 0. <0 1> is cluster 0,
> > +      switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
> > +      (single device hanging off a CPU port) must not specify this property
> > +    $ref: /schemas/types.yaml#/definitions/uint32-array
> > +
> > +  ports:
> > +    type: object
> > +    properties:
> > +      '#address-cells':
> > +        const: 1
> > +      '#size-cells':
> > +        const: 0
> > +
> > +    patternProperties:
> > +      "^port@[0-9]+$":
> 
> As ports and port are OF graph nodes, it would be better if we 
> standardized on a different name for these. I think we've used 
> 'ethernet-port' some.

I suspect DSA was using port before OF graph came along. Yep:

commit 5e95329b701c4edf6c4d72487ec0369fa148c0bd
Author: Florian Fainelli <florian@openwrt.org>
Date:   Fri Mar 22 10:50:50 2013 +0000

    dsa: add device tree bindings to register DSA switches

commit 4d56ed5a009b7d31ecae1dd26c047b8bb0dd9287
Author: Philipp Zabel <p.zabel@pengutronix.de>
Date:   Tue Feb 25 15:44:49 2014 +0100

    Documentation: of: Document graph bindings

So this usage is will established and it is probably a bit late to
change it now.

   Andrew
