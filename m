Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133102F408A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393520AbhAMAm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392053AbhAMATK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 19:19:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1AA223120;
        Wed, 13 Jan 2021 00:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610497109;
        bh=QlH3hVbuh92DUuXbfuMhrt8PgNrzRaD8uMC+A9uAyaU=;
        h=Date:From:To:Cc:Subject:From;
        b=mkTJWF4hApOAgvY8+Z3EazikSyxYV6NZcfP8/SDXo2szZeMR2OrRzGtwTj4cqa8u8
         WSAU7ZEQR4r7GwFxGRd5kPpXmvNTIsAQizi5FRmxAdpPBp7hnCcFec8gRdR6Mb1akP
         Ewsz2mdqzrkPob9Z2MbM1OB3btxqlxQpSiB5RCQOaM+eNMVCHPB7h3SSRO0a3ehAzf
         g40wHNI70xMJ6TsK0mGkld8ovB0y+l2JLv9RQ8vjCU8M8pVEo3HOVRjRmOAQYcGb4z
         eP5FHxrD7RYnFsu65XavEXuAH/A3ADrxKkE1l+FryEaAqTiKU/qfvyrL/j0oN1eAHR
         Z2L6JiS8pfDkw==
Date:   Wed, 13 Jan 2021 01:18:23 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, pavana.sharma@digi.com
Subject: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to do?
Message-ID: <20210113011823.3e407b31@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

it seems that inband AN is broken on Amethyst when on 2500base-x mode.

Even SERDES scripts for Amethyst from Marvell has autonegotiation
disabled for 2500base-x mode. For all the other supported Serdes modes
autonegotiation is enabled in these scripts.

The current implementation in mv88e6390_serdes_pcs_config() enables
autonegotiation if phylink_autoneg_inband(mode) is true:

  if (phylink_autoneg_inband(mode))
    bmcr = val | BMCR_ANENABLE;
  else
    bmcr = val & ~BMCR_ANENABLE;

But for PHY_INTERFACE_MODE_2500BASEX this is broken on Amethyst. The
2500base-x mode seems to work only with autoneg disabled.

The result is that when I connect via a passive SFP cable Amethyst
serdes port with a Peridot serdes port, they will not link. If I
disable autonegotiation on both sides, they will link, though.

What is strange is that if I don't use Peridot, but connect the SFP
directly to Serdes on Armada 3720, where the mvneta driver also enables
autonegotiation for 2500base-x mode, they will link even if Amethyst
does not enable 2500base-x.

To summarize:
	Amethyst  <->	Peridot
	AN -		AN -		works
	AN -		AN +		does not work

	Amethyst  <->	Armada 3720 serdes
	AN -		AN +		works

(It is possible that Marvell may find some workaround by touch some
 undocumented registers, to solve this. I will try to open a bug
 report.)

Should we just print an error in the serdes_pcs_config method if inband
autonegotiation is being requested?

phylink's code currently allows connecting SFPs in non MLO_AN_INBAND
mode only for when there is Broadcom BCM84881 PHY inside the SFP (by
method phylink_phy_no_inband() in phylink.c).

I wonder whether we can somehow in a sane way implement code to inform
phylink from the mv88e6xxx driver that inband is not supported for the
specific mode. Maybe the .mac_config/.pcs_config method could return an
error indicating this? Or the mv88e6xxx driver can just print an error
that the mode is not supported, and try to ask the user to disable AN?
That would need implementing this in ethtool for SFP, though.

What do you guys think?

Marek
