Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CA5317355
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhBJW24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:28:56 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:35520 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhBJW2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:28:52 -0500
Date:   Thu, 11 Feb 2021 01:28:05 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/16] dt-bindings: net: dwmac: Add DW GMAC GPIOs
 properties
Message-ID: <20210210222805.upoioue7uc6cat2v@mobilestation>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140820.10410-2-Sergey.Semin@baikalelectronics.ru>
 <20210209231352.GA402351@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210209231352.GA402351@robh.at.kernel.org>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:13:52PM -0600, Rob Herring wrote:
> On Mon, Feb 08, 2021 at 05:08:05PM +0300, Serge Semin wrote:
> > Synopsys DesignWare Ethernet controllers can be synthesized with
> > General-Purpose IOs support. GPIOs can work either as inputs or as outputs
> > thus belong to the gpi_i and gpo_o ports respectively. The ports width
> > (number of possible inputs/outputs) and the configuration registers layout
> > depend on the IP-core version. For instance, DW GMAC can have from 0 to 4
> > GPIs and from 0 to 4 GPOs, while DW xGMAC have a wider ports width up to
> > 16 pins of each one.
> > 
> > So the DW MAC DT-node can be equipped with "ngpios" property, which can't
> > have a value greater than 32, standard GPIO-related properties like
> > "gpio-controller" and "#gpio-cells", and, if GPIs are supposed to be
> > detected, IRQ-controller related properties.
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  .../devicetree/bindings/net/snps,dwmac.yaml     | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > index bdc437b14878..fcca23d3727e 100644
> > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > @@ -110,6 +110,23 @@ properties:
> >    reset-names:
> >      const: stmmaceth
> >  
> > +  ngpios:
> > +    description:
> > +      Total number of GPIOs the MAC supports. The property shall include both
> > +      the GPI and GPO ports width.
> > +    minimum: 1
> > +    maximum: 32
> 

> Does the driver actually need this? I'd omit it if just to validate 
> consumers are in range.

I can't say for all possible DW MAC IP-cores (I've got manuals for
GMAC and xGMAC only), but at least DW GMAC can't have more than four
GPIs and four GPOs, while XGMACs can be synthesized with up to 16
each. That's why I've set the upper boundary here as 32. But the
driver uses the ngpios property do determine the total number GPIOs
the core has been synthesized. Th number of GPIs and GPOs will be
auto-detected then (by writing-reading to-from the GPI type field of
the GPIO control register).

> 
> Are GPI and GPO counts independent? If so, this isn't really sufficient.

Yeap, they are independent. What do you suggest then? Define some
vendor-specific properties like snps,ngpis and snps,ngpos? If so then
they seem more generic than vendor-specific, because the separated
GPI and GPO space isn't an unique feature of the DW MAC GPIOs. Do we
need to create a generic version of such properties then? (That much
more changes then introduced here. We'd need to fix the dt-schema tool
too then.)

-Sergey

> 
> Rob
