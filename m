Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871B142FF83
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbhJPAnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236462AbhJPAm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:42:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B822D61073;
        Sat, 16 Oct 2021 00:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344849;
        bh=5/IApdZcbtV9DsJZ2Qr+kCwQqzgpglYWvBbFf6ejJVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rlTCdIJhZPX4r44S93+G4tmfGvVAo3uWPCWbLdileOAMrpa7G6WQqVIItrT3A+FE9
         tLkZoVg/bgeLoDgThl22MX7amNRHdSgy8TgEvfGCr2Xnc52P6LgPrbdRT9YDxM4X95
         JQ/aFR2Hr1YtKohok+Ce2yxIUP0nzP7rIBmZebGkMrmkm2RYuoVZzkmjVYXh+Yh6S5
         du+ElyHWHPrCzLP/tdnaGRTYgeApu8iidZaGRJ2hd6/CHtbBHEroAJXWpiXlhbQOet
         qSw0z8qRXU04wze1lLP3mfHjROAtlHz7MUj61lN8xk8CMvPaFBvZ/1eS+DoRF87FVY
         fB4UwUX86r15Q==
Date:   Fri, 15 Oct 2021 17:40:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 6/7] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20211015174047.6552112a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015171030.2713493-7-alvin@pqrs.dk>
References: <20211015171030.2713493-1-alvin@pqrs.dk>
        <20211015171030.2713493-7-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 19:10:27 +0200 Alvin =C5=A0ipraga wrote:
> v2 -> v3:
>   - collect Florian's Reviewed-by
>   - move IRQ setup earlier in probe per Florian's suggestion
>   - follow Jakub's suggestion and use the standard ethtool stats API

Thanks a lot for doing this. The code LGTM, the only thing that stands
out is the use of spin_locks(). I couldn't quickly parse out what bus
this device hangs off, if it's MMIO and registers can be read without
sleeping you could potentially get rid of the delayed work to read
stats, but I think you need to switch to
regmap_read_poll_timeout_atomic() because regmap_read_poll_timeout()
itself can sleep.

If the register access sleeps (I2C, SPI, MDIO etc) you need to switch
from a spin lock to a mutex.

Either way CONFIG_DEBUG_ATOMIC_SLEEP is your friend.
