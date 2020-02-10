Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E856D1583D4
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 20:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBJTh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 14:37:26 -0500
Received: from bmailout1.hostsharing.net ([83.223.95.100]:55421 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgBJTh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 14:37:26 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2020 14:37:24 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id AF2B3300020C5;
        Mon, 10 Feb 2020 20:31:02 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 827FA22805D; Mon, 10 Feb 2020 20:31:02 +0100 (CET)
Date:   Mon, 10 Feb 2020 20:31:02 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 1/3] net: ks8851-ml: Remove 8-bit bus accessors
Message-ID: <20200210193102.q7qikf4czfzuqlox@wunner.de>
References: <20200210184139.342716-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210184139.342716-1-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 07:41:37PM +0100, Marek Vasut wrote:
> This driver is mixing 8-bit and 16-bit bus accessors for reasons unknown,
> however the speculation is that this was some sort of attempt to support
> the 8-bit bus mode.

ks8851.c was introduced in July 2009 with commit 3ba81f3ece3c.
ks8851_mll.c was introduced two months later with a55c0a0ed415.

Perhaps the 8-bit accesses are remnants of the SPI-version ks8851.c?

Both chips are very similar.  Unfortunately ks8851_mll.c duplicated
much of ks8851.c, instead of separating it into a common portion and
an SPI-specific portion.  I've deduplicated at least the register
macros with commit aae079aa76d0.  It would be great if you could
continue this effort and increase the amount of shared code between
the two drivers.  Right now ks8851_mll.c supports features that
ks8851.c does not, e.g. multicast filtering.  On the other hand
I've fixed bugs in ks8851.c which I believe still exist in ks8851_mll.c,
see 536d3680fd2d for an example.  I didn't apply the fixes to
ks8851_mll.c simply because I don't have hardware with that chip.
I do have access to hardware using ks8851.c.

HTH,

Lukas
