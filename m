Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B84D6D8316
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDEQJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDEQJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:09:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B331A134;
        Wed,  5 Apr 2023 09:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0YOe3B05kwzESGEZwtFaaWYdJFRP1kunFb8Z3mAHVNE=; b=W0PM71DUI+PeuWeSJKT8aBibBy
        uebHBj+i/fYRZBkUdz14UDuxq7PuT5EG9CxOG505qP46ASoyrqq4emsiKFfjyh2IMb/FVdOMwinit
        e1GIZ4HFF4JNi8RHSCB6wluvmQbDEJx+8a6OdPZ6UbJt2E55iPrYfuvR1FUir4n+lars=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk5hC-009XOU-NY; Wed, 05 Apr 2023 18:09:14 +0200
Date:   Wed, 5 Apr 2023 18:09:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 05/12] net: phy: add phy_id_broken support
Message-ID: <8acb116d-6a14-439d-82ce-d32f2b510fce@lunn.ch>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-5-7e5329f08002@pengutronix.de>
 <6461467c-8f9d-41b6-b060-08190126e81f@lunn.ch>
 <956792db-c6a4-f16f-e7e4-b9d08c12f986@gmail.com>
 <20230405152706.qr2rsuxr2y3usbru@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405152706.qr2rsuxr2y3usbru@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The nxp-tja11xx.c is a bit special in case of two-port devices since the
> 2nd port registers a 2nd phy device which is correct but don't have a
> dedicated compatible and so on. My 2nd idea here was to check if phy_id
> is !0 and in this case just use it. I went this way to make it a bit
> more explicit.

What is actually wrong with the current solution? It is nicely hidden
away in the driver, where workarounds for broken hardware should
be. If you have found device 1 of 2, does that not suggest its resets
are already in a good state and nothing needs to be done for the
second PHY? So just register the second PHY with the code from within
the driver.

       Andrew

     
