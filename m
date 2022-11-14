Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2C1628138
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiKNNZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiKNNZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:25:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A376183B1
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zFao31XckDGOMjh2X4dN1DzBdFrA/TiqLugbeR3q7PU=; b=dWqu1epLI8kun7YDZjatflfs1/
        CaJK20x4nqUdnEoZ9fR5M8PccsUdhaGHDfsV0XEo84PGs5IZ0wnYgk7mAyI2QAStu0FvAb1QdEBEJ
        EYWDZ0GkVX0cJYJDiF/in1SM5FrgSyiUXYhyP9iVMDUIRKM1Hsh/pj6ySfVzSge7X9Oo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouZT9-002L5S-41; Mon, 14 Nov 2022 14:25:47 +0100
Date:   Mon, 14 Nov 2022 14:25:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     'Mengyuan Lou' <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Message-ID: <Y3JB2xrBOOa6MR+H@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-2-mengyuanlou@net-swift.com>
 <Y2rBo3KI2LmjS55y@lunn.ch>
 <02a901d8f405$1c21a350$5464e9f0$@trustnetic.com>
 <Y2uqk9BwVjPcEtPP@lunn.ch>
 <005c01d8f80c$574c16d0$05e44470$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005c01d8f80c$574c16d0$05e44470$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When ethernet driver does a reset to the hardware, like
> 'txgbe_reset_hw', the I2C configuration will be reset.  It needs to
> be reconfigured once. So how could I call the I2C function here? Can
> I treat the I2C driver as a lib?

The I2C driver will be embedded within your MAC driver. So you have
control over it.

How often do you need to call txgbe_reset_hw()?  Hopefully just once
early in the probe? So you can register the I2C bus master with the
I2C core after the reset.

If you need to use txgbe_reset_hw() at other times, you will need a
mutex or similar in .master_xfer function so you don't perform a reset
while an I2C transfer is happening, or start another transfer while a
reset is happening.

	Andrew

