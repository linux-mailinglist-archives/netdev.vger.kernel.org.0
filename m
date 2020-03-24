Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5284F19062B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 08:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgCXHWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 03:22:22 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:59413 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgCXHWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 03:22:21 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id D5DC02800A267;
        Tue, 24 Mar 2020 08:22:19 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 9DC4110D0DD; Tue, 24 Mar 2020 08:22:19 +0100 (CET)
Date:   Tue, 24 Mar 2020 08:22:19 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 06/14] net: ks8851: Remove ks8851_rdreg32()
Message-ID: <20200324072219.wochifgdx2mz6orx@wunner.de>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-7-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-7-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:55AM +0100, Marek Vasut wrote:
> The ks8851_rdreg32() is used only in one place, to read two registers
> using a single read. To make it easier to support 16-bit accesses via
> parallel bus later on, replace this single read with two 16-bit reads
> from each of the registers and drop the ks8851_rdreg32() altogether.

This doubles the SPI transactions necessary to read the RX queue status,
which happens for each received packet, so I expect the performance
impact to be noticeable.  Can you keep the 32-bit variant for SPI
and instead just introduce a 32-bit read for the MLL chip which performs
two 16-bit reads internally?

Thanks,

Lukas
