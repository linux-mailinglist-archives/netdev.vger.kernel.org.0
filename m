Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9A23A5B21
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 02:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhFNAK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 20:10:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232076AbhFNAKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 20:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Inv7FxLlJNFNOYFXJpWfC0TcFgAvHVW5NM8/fw1hffE=; b=R8
        HjPwiPuSs8ZagDi0rLWtYL3jDyrZw7AGFoqVJyxU8y1B3u6KvRWdnek+HTTKdxgzIc8mAgX0GoARm
        diDc+RUWwlsV9kejPxA2e3SwhxMPNttpwzNFxeP9miD8xF6uH5xQhYGkNjr87G6Yz8r4D8hJOLjLF
        qoYvNcXHTu/RlzM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsa9L-009E8L-GP; Mon, 14 Jun 2021 02:08:19 +0200
Date:   Mon, 14 Jun 2021 02:08:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Jon Masters <jcm@redhat.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Subject: Re: [net-next: PATCH 2/3] net: mvpp2: enable using phylink with ACPI
Message-ID: <YMad84t7mOl0DFzk@lunn.ch>
References: <20210613183520.2247415-1-mw@semihalf.com>
 <20210613183520.2247415-3-mw@semihalf.com>
 <YMZg27EkTuebBXwo@lunn.ch>
 <CAPv3WKfWqdpntPKknZ+H+sscyH9mursvCUwe8Q1DH-wGpsWknQ@mail.gmail.com>
 <YMZ6E99Q/zuFh4b1@lunn.ch>
 <CAPv3WKetRLOkkOz3Cj_D5pf824VGoz+sQ6wNukTS2PKoAcdFyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKetRLOkkOz3Cj_D5pf824VGoz+sQ6wNukTS2PKoAcdFyw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 01:46:06AM +0200, Marcin Wojtas wrote:
> <Adding ACPI Maintainers>
> 
> Hi Andrew,
> 
> niedz., 13 cze 2021 o 23:35 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > > True. I picked the port type properties that are interpreted by
> > > phylink. Basically, I think that everything that's described in:
> > > devicetree/bindings/net/ethernet-controller.yaml
> > > is valid for the ACPI as well
> >
> > So you are saying ACPI is just DT stuff into tables? Then why bother
> > with ACPI? Just use DT.
> 
> Any user is free to use whatever they like, however apparently there
> must have been valid reasons, why ARM is choosing ACPI as the
> preferred way of describing the hardware over DT. In such
> circumstances, we all work to improve adoption and its usability for
> existing devices.
> 
> Regarding the properties in _DSD package, please refer to
> https://www.kernel.org/doc/html/latest/firmware-guide/acpi/DSD-properties-rules.html,
> especially to two fragments:
> "The _DSD (Device Specific Data) configuration object, introduced in
> ACPI 5.1, allows any type of device configuration data to be provided
> via the ACPI namespace. In principle, the format of the data may be
> arbitrary [...]"
> "It often is useful to make _DSD return property sets that follow
> Device Tree bindings."
> Therefore what I understand is that (within some constraints) simple
> reusing existing sets of nodes' properties, should not violate ACPI
> spec. In this patchset no new extension/interfaces/method is
> introduced.
> 
> >
> > Right, O.K. Please document anything which phylink already supports:
> >
> > hylink.c:               ret = fwnode_property_read_u32(fixed_node, "speed", &speed);
> > phylink.c:              if (fwnode_property_read_bool(fixed_node, "full-duplex"))
> > phylink.c:              if (fwnode_property_read_bool(fixed_node, "pause"))
> > phylink.c:              if (fwnode_property_read_bool(fixed_node, "asym-pause"))
> > phylink.c:              ret = fwnode_property_read_u32_array(fwnode, "fixed-link",
> > phylink.c:              ret = fwnode_property_read_u32_array(fwnode, "fixed-link",
> > phylink.c:      if (dn || fwnode_property_present(fwnode, "fixed-link"))
> > phylink.c:      if ((fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
> >
> > If you are adding new properties, please do that In a separate patch,
> > which needs an ACPI maintainer to ACK it before it gets merged.
> >
> 
> Ok, I can extend the documentation.

My real fear is snowflakes. Each ACPI implementation is unique. That
is going to be a maintenance nightmare, and it will make it very hard
to change the APIs between phylib/phylink and MAC drivers. To avoid
that, we need to push are much as possible into the core, document as
much as possible, and NACK anything does looks like a snowflake.

I actually like what you pointed out above. It makes it possible to
say, ACPI for phylink/phylib needs to follow device tree, 1 to 1.
It also means we should be able to remove a lot of the

if (is_of()) {}
else if (is_acpi() {}
else
	return -EINVAL;

in drivers, and put it into the core.

   Andrew
