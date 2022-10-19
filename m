Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF50D604652
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJSNGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiJSNGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:06:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A83D1DB263;
        Wed, 19 Oct 2022 05:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LvgRD4iN2m8G6ZpNS+5FlDAbPJRUbn+oLpBhRnPeWvY=; b=duZrPGPMQ809pOr+sYnrVIU7D7
        4Q7+nJJyxlO0d3zDQIBMXBFwC6V4p/UyXv+9X5DrmuexhHhGW+vhmVj3nkGAyrc1FpPs2R+/gRKOH
        t3z+KLmr3IZyATGwJU4xB0l7Xu3vSz4JIIWL8RXo1vPoj7Rjc/xGd7edZeXZ03svN7Pk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ol8VO-002Rsz-BE; Wed, 19 Oct 2022 14:49:06 +0200
Date:   Wed, 19 Oct 2022 14:49:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Andrew Davis <afd@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
Subject: Re: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Message-ID: <Y0/yQhRtH2iWfozx@lunn.ch>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch>
 <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
 <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com>
 <Y08dECNbfMc3VUcG@lunn.ch>
 <595b7903-610f-b76a-5230-f2d8ad5400b4@seco.com>
 <AM0PR04MB39729CFDBB20C133C269275AEC2B9@AM0PR04MB3972.eurprd04.prod.outlook.com>
 <CAMuHMdUZKQFWV8QAKmwxuhWz0ZbFmcsUuf4OUzS_C31maP5+Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUZKQFWV8QAKmwxuhWz0ZbFmcsUuf4OUzS_C31maP5+Yg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > root@localhost:~# grep 1ae /etc/udev/rules.d/72-fsl-dpaa-persistent-networking.rules
> > SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae0000", NAME="fm1-mac1"
> > SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae2000", NAME="fm1-mac2"
> > SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae4000", NAME="fm1-mac3"
> > SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae6000", NAME="fm1-mac4"
> > SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1ae8000", NAME="fm1-mac5"
> > SUBSYSTEM=="net", DRIVERS=="fsl_dpa*", ATTR{device_addr}=="1aea000", NAME="fm1-mac6"
> 
> So you rely on the physical address.
> It's a pity this uses a custom sysfs file.
> Can't you obtain this information some other way?
> Anyway, as this is in use, it became part of the ABI.

I agree about the ABI thing. Please add this to the commit messages as
a justification.

It would also be good to move user space away from this. You should be
able to use the port id in the place of the physical address. That is
what is used by Ethernet switches etc, in the udev rules for giving
switch ports names.

       Andrew
