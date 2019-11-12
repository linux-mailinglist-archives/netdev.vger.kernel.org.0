Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A966F8501
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKLASg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:18:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKLASg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:18:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92F80154014C3;
        Mon, 11 Nov 2019 16:18:35 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:18:34 -0800 (PST)
Message-Id: <20191111.161834.1399688973316931565.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/17] Allow slow to initialise GPON modules
 to work
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 16:18:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sun, 10 Nov 2019 14:05:30 +0000

> Some GPON modules take longer than the SFF MSA specified time to
> initialise and respond to transactions on the I2C bus for either
> both 0x50 and 0x51, or 0x51 bus addresses.  Technically these modules
> are non-compliant with the SFP Multi-Source Agreement, they have
> been around for some time, so are difficult to just ignore.
> 
> Most of the patch series is restructuring the code to make it more
> readable, and split various things into separate functions.
> 
> We split the three state machines into three separate functions, and
> re-arrange them to start probing the module as soon as a module has
> been detected (without waiting for the network device.)  We try to
> read the module's EEPROM, retrying quickly for the first second, and
> then once every five seconds for about a minute until we have read
> the EEPROM.  So that the kernel isn't entirely silent, we print a
> message indicating that we're waiting for the module to respond after
> the first second, or when all retries have expired.
> 
> Once the module ID has been read, we kick off a delayed work queue
> which attempts to register the hwmon, retrying for up to a minute if
> the monitoring parameters are unreadable; this allows us to proceed
> with module initialisation independently of the hwmon state.
> 
> With high-power modules, we wait for the netdev to be attached before
> switching the module power mode, and retry this in a similar way to
> before until we have successfully read and written the EEPROM at 0x51.
> 
> We also move the handling of the TX_DISABLE signal entirely to the main
> state machine, and avoid probing any on-board PHY while TX_FAULT is
> set.

Series applied.
