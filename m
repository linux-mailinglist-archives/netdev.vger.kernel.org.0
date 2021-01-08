Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F732EEA8B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbhAHAuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbhAHAuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:50:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8428E23447;
        Fri,  8 Jan 2021 00:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610066969;
        bh=S+brV20O/Ncak/QxhHlEcqydPjggfGUBM/oMewgZuiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=heJA5rUGZZ8Stu4gU4lQ7ce+PBTsPq1CJAo964dxV0y/lEtwtH3Yo6y+MEm1TvzHr
         8qVpcovPDwNS0j1iVuUO3X/MrVmLL+E7w7YpFYuOr6uV8FuADmTGB1CnfSj9K5c83y
         /DHfsMJ4YJuZm1EEniAqJzCC6CygD1D4Gq1rhWH8RDMsKn0NrBrkzlcLy8qomWeEaF
         60D00VFXDi4Gi1Py6U8gTbtaKW04C7DtDz3+93ULP56EMRY+hl/nEUIkrn8FtZwEi4
         5Y6ra+L0NI/QgrwjYWMeKp1yWHCkacON/o0feXQL5P7cf877DnVbzSp+mT01WirZnG
         aKRrx7JmaTJ7w==
Received: by pali.im (Postfix)
        id 34E9AAF1; Fri,  8 Jan 2021 01:49:27 +0100 (CET)
Date:   Fri, 8 Jan 2021 01:49:27 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210108004927.jr5tclbi7tzjpk6x@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
 <X/dCm1fK9jcjs4XT@lunn.ch>
 <20210107194549.GR1551@shell.armlinux.org.uk>
 <20210107212116.44a2baea@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210107212116.44a2baea@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 07 January 2021 21:21:16 Marek Behún wrote:
> On Thu, 7 Jan 2021 19:45:49 +0000
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > I think you're not reading the code very well. It checks for bytes at
> > offset 1..blocksize-1, blocksize+1..2*blocksize-1, etc are zero. It
> > does _not_ check that byte 0 or the byte at N*blocksize is zero - these
> > bytes are skipped. In other words, the first byte of each transfer can
> > be any value. The other bytes of the _entire_ ID must be zero.
> 
> Wouldn't it be better, instead of checking if 1..blocksize-1 are zero,
> to check whether reading byte by byte returns the same as reading 16
> bytes whole?

It would means to read EEPROM two times unconditionally for every SFP.
With current solution we read EEPROM two times only for these buggy
RTL-based SFP modules. For all other SFPs EEPROM content is read only
one time. I like current solution because we do not change the way how
are other (non-broken) SFPs detected. It is better to not touch things
which are not broken.

And as we know that these zeros are expected behavior on these broken
RTL-based SFPs I think such test is fine.

Moreover there are Nokia SFPs which do not like one byte read and locks
i2c bus. Yes, it happens only for EEPROM content on second address
(therefore ID part for this test is not affected) but who knows how
broken would be any other SFPs in future.
