Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B502466F6E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbhLCCCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:02:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53810 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhLCCCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:02:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F36F6284B
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 01:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93669C00446;
        Fri,  3 Dec 2021 01:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638496724;
        bh=9kRopIxFaf5ct/hJg/sAhFDbClvS75bU0MQpqYIsx+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XAeaNHoxJrc3Q15lmViQspCBWX8GWcw7MM/ZbrQcPNTdlWRYxZnQmukUbjE9S2XW5
         wNdWa5g/C6BV3B6VrEnvOaQ0UbY8UK3ti7nMhN0HP+rso6XqEQaKfUEkw66FKSn7y2
         To8sss6vJ1hKG3tWn7TA8bQvTVRX01yeqN+gET3OWafHV1PhL7qJuq681DresBnr2G
         Ci38C0vzzhgBOO5FZh2XnfwDXYXXLjDqz823S/eosFV14ithn5ZoO+xmfPUQk6XFc1
         VMOFlIkewvfEhfCSsKA4ZVobl99ikqkGJ8yPPIHZmmK9+5D1CUqZUvN1Qhou19xQFe
         ysgcj9pz8240w==
Date:   Thu, 2 Dec 2021 17:58:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>, netdev@vger.kernel.org,
        =?UTF-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without
 diag mode
Message-ID: <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130073929.376942-1-bjorn@mork.no>
References: <20211130073929.376942-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 08:39:29 +0100 Bj=C3=B8rn Mork wrote:
> Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
> modules") changed semantics for high power modules without diag mode.
> We repeatedly try to read the current power status from the non-existing
> 0xa2 address, in the futile hope this failure is temporary:
>=20
> [    8.856051] sfp sfp-eth3: module NTT              0000000000000000 rev=
 0000 sn 0000000000000000 dc 160408
> [    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000base-=
x link mode
> [    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
> [    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
> [    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5
>=20
> Eeprom dump:
>=20
> 0x0000: 03 04 01 00 00 00 80 00 00 00 00 01 0d 00 0a 64
> 0x0010: 00 00 00 00 4e 54 54 20 20 20 20 20 20 20 20 20
> 0x0020: 20 20 20 20 00 00 00 00 30 30 30 30 30 30 30 30
> 0x0030: 30 30 30 30 30 30 30 30 30 30 30 30 05 1e 00 7d
> 0x0040: 02 00 00 00 30 30 30 30 30 30 30 30 30 30 30 30
> 0x0050: 30 30 30 30 31 36 30 34 30 38 20 20 00 00 00 75
> 0x0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x00f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>=20
> Previously we assumed such modules were powered up in the correct
> mode, continuing without further configuration as long as the
> required power class was supported by the host.
>=20
> Revert to that behaviour, refactoring to keep the improved
> diagnostic messages.
>=20
> Fixes: 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change modu=
les")
> Reported-and-tested-by: =E7=85=A7=E5=B1=B1=E5=91=A8=E4=B8=80=E9=83=8E <te=
ruyama@springboard-inc.jp>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>

Russell, any comments?
