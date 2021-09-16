Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6F40DA01
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbhIPMhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:37:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhIPMhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:37:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=V6UiYMHUcx5TF7n24nYkSm/8/ySg85wDtoqkAeaY5B0=; b=E0k1SVPE/SRI7xHGQptd3ceuNZ
        rxG+qoikEDd0dYbi/Cf8ht8yF2RT8mky4ZZg6iHhNCuWQLZTVLwFMWNDtHwrwnRemT5PmOyk32UOg
        Ht+AU4rQjzqki9vXM2E/SmDIBdehqOATkI8jbMNrr9ikOtCMzZjQnE3N5BBZnVzH1ePI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQqc9-006u8h-KC; Thu, 16 Sep 2021 14:35:41 +0200
Date:   Thu, 16 Sep 2021 14:35:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] net: vertexcom: Add MSE102x SPI support
Message-ID: <YUM6HfDYX0Twe67+@lunn.ch>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
 <20210914151717.12232-4-stefan.wahren@i2se.com>
 <YUJi0cVawjyiteEx@lunn.ch>
 <bfbbf816-f467-7e2e-12ca-fb2172ce93f9@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfbbf816-f467-7e2e-12ca-fb2172ce93f9@i2se.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +	netif_carrier_off(mse->ndev);
> >> +	ndev->if_port = IF_PORT_10BASET;
> > That is not correct. Maybe you should add a IF_PORT_HOMEPLUG ?


> There is already a driver (qca_spi, qcauart) for a similiar Homeplug
> device (QCA7000), which also uses IF_PORT_10BASET. Should i change this
> too or leave it because of resulting changes to userspace?

Technically, it would be an ABI change. But ifmap seems pretty loosely
defined. See man 7 netdevice:

       SIOCGIFMAP, SIOCSIFMAP
              Get or set the interface's hardware parameters using ifr_map.
	      Setting the parameters is a privileged operation.

                  struct ifmap {
                      unsigned long   mem_start;
                      unsigned long   mem_end;
                      unsigned short  base_addr;
                      unsigned char   irq;
                      unsigned char   dma;
                      unsigned char   port;
                  };

              The interpretation of the ifmap structure depends on the device driver
	      and the architecture.

The if_port value ends up in port. And i've no idea where it is
actually available in user space. iproute2 does not use it, nor
ethtool. So, i would say, submit a separate patch for the other
drivers, and we will see if anybody notices.

> >> +static const struct of_device_id mse102x_match_table[] = {
> >> +	{ .compatible = "vertexcom,mse1021" },
> >> +	{ .compatible = "vertexcom,mse1022" },
> > Is there an ID register you can read to determine what device you
> > actually have? If so, i suggest you verify the correct compatible is
> > used.
> 
> AFAIK the device doesn't have any kind of ID register.

Then i would suggest changing the compatible to "vertexcom,mse102x".

If you cannot verify it, and it makes no actual difference, then 50%
of the boards will use the wrong one. Which means you can then later
not actually make use of it to enable features specific to a
compatible string.

	   Andrew
