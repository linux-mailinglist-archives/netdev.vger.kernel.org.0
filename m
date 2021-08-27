Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD303F9EBD
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhH0SZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhH0SZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 14:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F60360E97;
        Fri, 27 Aug 2021 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630088705;
        bh=0eihSNf8es7K3C0a79CBft7H81KwqClcVqGKE0UUf04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r3PyBRg4sofODZCEjej7KHFoZXCVjj9rmLvZgi+o/u/j9NWWASRxONaVm6WqbLMhM
         UAgwNnfQwMo56SGKbrLl6mYvJkUmzZ24gCi3zXCJVQ4vOFCDv+M/RH4EjYXNwRFcS1
         RmIUwtCAVjtoNwr+HqtiRv1SYGwzi1PdTshnhr7dYmyj7Hbo1mEVrH7qmCR96cjps1
         ZylsQULgzSxblrYG9FbwqBQNosiSzd3GXqEDmu297zOcXb27VCF5zt8KukI+y4bywh
         N8w5f36qiglKvcCkdAu/25w6lpNVIWdYkSJjhvzb3CJb3KudmnLuDMxq8BIJ5mFHeE
         SiuTa77mkKKtw==
Received: by pali.im (Postfix)
        id B7971617; Fri, 27 Aug 2021 20:25:02 +0200 (CEST)
Date:   Fri, 27 Aug 2021 20:25:02 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: marvell: phy-mvebu-a3700-comphy: Remove
 unsupported modes
Message-ID: <20210827182502.vdapjcqimq4ulkg2@pali>
References: <20210827092753.2359-1-pali@kernel.org>
 <20210827092753.2359-3-pali@kernel.org>
 <20210827132713.61ef86f0@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210827132713.61ef86f0@thinkpad>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 27 August 2021 13:27:13 Marek Behún wrote:
> On Fri, 27 Aug 2021 11:27:53 +0200
> Pali Rohár <pali@kernel.org> wrote:
> 
> > Armada 3700 does not support RXAUI, XFI and neither SFI. Remove unused
> > macros for these unsupported modes.
> > 
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > Fixes: 9695375a3f4a ("phy: add A3700 COMPHY support")
> 
> BTW I was thinking about merging some parts of these 2 drivers into
> common code. Not entirely sure if I should follow, though.

cp110-comphy and a3700-comphy are just RPC drivers which calls SMC and
relay on firmware support which implements real work. And both uses same
RPC / SMC API. So merging drivers into one is possible.

But I do not think that it is a good idea that Linux kernel depends on
some external firmware which implements RPC API for configuring HW.

Rather kernel should implements its native drivers without dependency on
external firmware.

We know from history that kernel tried to avoid using x86 BIOS/firmware
due to bugs and all functionality (re)-implemented itself without using
firmware RPC functionality.

Kernel has already "hacks" in other drivers which are using these comphy
drivers, just because older versions of firmware do not support all
necessary functionality and upgrading this firmware is not easy step
(and sometimes even not possible; e.g. when is cryptographically
signed).
