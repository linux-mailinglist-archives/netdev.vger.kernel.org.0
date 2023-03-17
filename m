Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7096BEF98
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCQRYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjCQRYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:24:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163B435EC0
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=raonv0aDRKMeNG+9Z4xa3VtDroLCx3ONeZFuGHG3aO4=; b=O8rxrAuETWNmvBj/G+syfhZkan
        UY818OoFzjqkhu6MXG9mMWKvchA3lN0NWZu/v/xw2XgDRBOtyghsxGKMQnEbqXYrBdGtpd/5DTnka
        Y9g02zIcwRn1zbVHuCrx5M8d6xD54WOPP6lXnH8pwA/Pqbdfc7XiSF/EZRSfRwwfzZvA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdDoH-007dUT-5I; Fri, 17 Mar 2023 18:24:09 +0100
Date:   Fri, 17 Mar 2023 18:24:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     arturo.buzarra@digi.com
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Message-ID: <245d1cc7-9059-4a94-992f-ad37108df366@lunn.ch>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317121646.19616-1-arturo.buzarra@digi.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:16:46PM +0100, arturo.buzarra@digi.com wrote:
> From: Arturo Buzarra <arturo.buzarra@digi.com>
> 
> A PHY driver can dynamically determine the devices features, but in some
> circunstances, the PHY is not yet ready and the read capabilities does not fail
> but returns an undefined value, so incorrect capabilities are assumed and the
> initialization process fails. This commit postpones the PHY probe to ensure the
> PHY is accessible.

In additional to Florians comments i have a few questions.

Are you resetting the device via a GPIO? Turning a regulator off/one
etc?

Is there anything in the data sheet about how long you need to wait
before accessing the device after power on, HW reset, or software
reset etc?

Does the device reliably enumerate on the bus, i.e. reading registers
2 and 3 to get its ID?

If the PHY is broken, by some yet to be determined definition of
broken, we try to limit the workaround to as narrow as possible. So it
should not be in the core probe code. It should be in the PHY specific
driver, and ideally for only its ID, not the whole vendors family of
PHYs.

  Andrew
