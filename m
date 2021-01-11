Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94A92F19A3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbhAKP2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbhAKP2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 10:28:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66E40225AC;
        Mon, 11 Jan 2021 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610378891;
        bh=2TwVSubr1Utb54puJyi85tzxRDvhFI6tBd3O/Tah+Bc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s2JjqMdzP0q3o6qkUOgaehXBBuFWIbiYZV/Zw5TY5x6KKOEluYZwlEpEkdZiRVGlI
         pFE5DxiPMySbcmlDOEQ/9mvUPxGJtPkIEG2DmRAhSIG32y35n92gg/qOWqR59T0OYS
         4H5xtEZOc4XpIs4ul+z5xrlMbYfoVBUvO3aWEUXEpNnjlf1FrJnwCIijFhnmL/xAsF
         B0tsqNyya0ykUkaqHOh1VPtnpVMvPuav3jqk1AlXOdkPxVhb33H0B45NFV4EbaKkUg
         P1Sv2wye4uwvzZLjDNARpoAMp8kzGLY4ZuNdpCB/CIe4uR7gReEyDgBFCi3kNHK6Ev
         Ezn+5hpLFVLdQ==
Date:   Mon, 11 Jan 2021 16:28:05 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210111162805.77cf82b2@kernel.org>
In-Reply-To: <20210111113909.31702-2-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
        <20210111113909.31702-1-pali@kernel.org>
        <20210111113909.31702-2-pali@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,
I have rewritten the commit message a little:

The workaround for VSOL V2801F brand based GPON SFP modules added in
commit 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490
v2.0 workaround") works only for IDs added explicitly to the list.
Since there are rebranded modules where OEM vendors put different
strings into the vendor name field, we cannot base workaround on IDs
only.

Moreover the issue which the above mentioned commit tried to work
around is generic not only to VSOL based modules, but rather to all
GPON modules based on Realtek RTL8672 and RTL9601C chips.
 
These include at least the following GPON modules:
* V-SOL V2801F
* C-Data FD511GX-RM0
* OPTON GP801R
* BAUDCOM BD-1234-SFM
* CPGOS03-0490 v2.0
* Ubiquiti U-Fiber Instant
* EXOT EGS1

These Realtek chips have broken EEPROM emulator which for N-byte read
operation returns just the first byte of EEPROM data, followed by N-1 zeros.

Introduce a new function, sfp_id_needs_byte_io(), which detects SFP
modules with broken EEPROM emulator based on N-1 zeros and switch to 1
byte EEPROM reading operation.

Function sfp_i2c_read() now always uses single byte reading when it is
required and when function sfp_hwmon_probe() detects single byte access,
it disables registration of hwmon device, because in this case we
cannot reliably and atomically read 2 bytes as is required byt the
standard for retrieving values from diagnostic area.

(These Realtek chips are broken in a way that violates SFP standards for
 diagnostic interface. Kernel in this case simply cannot do anything
 less of skipping registration of the hwmon interface.)

This patch fixes reading of EEPROM content from SFP modules based on
Realtek RTL8672 and RTL9601C chips. Diagnostic interface of EEPROM stays
broken and cannot be fixed.
