Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE1136D7E
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgAJNOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:14:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59386 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbgAJNOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 08:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XpVHtSSgflBD7UepzXrrYEgXlNFhuiEJtyfPaSek/yY=; b=SGf4hiUb9yXDdaekEuC35d1IVA
        LP93mUNDgjPO9sRVF0oYGELz+TEWDUunkNL8blB3guB760eReEMFkv0sIBMLIRj3fsLjQ8c1dgea+
        w15LYUbbao1ROyYKxnaamgrhde4jN3x9r16CjG5+k+TjRJsRQNwGXm2L4gc8Zqhd2eL4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipu6w-0006Zn-Lx; Fri, 10 Jan 2020 14:13:58 +0100
Date:   Fri, 10 Jan 2020 14:13:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Preimesberger <ccpisme@gmail.com>
Cc:     linville@tuxdriver.com, netdev@vger.kernel.org
Subject: Re: ethtool option to force interpretation of diagnostics?
Message-ID: <20200110131358.GA19739@lunn.ch>
References: <CAM0+VB-Zwr2Z+s1SS_rqokWcku43dwbZcRRFHZRdZJLFpkxXdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0+VB-Zwr2Z+s1SS_rqokWcku43dwbZcRRFHZRdZJLFpkxXdQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 06:25:07PM -0600, Chris Preimesberger wrote:
> Hello,
> 
> 
> Problem:
> I am testing some 10GbE RJ45 SFP+ modules and noticed that they
> accurately report their operating temperature while installed in a
> switch, but not while installed in a NIC that's being probed by
> ethtool.  The ethtool install and NIC port in question are known to
> properly report all diagnostics of installed fiber transceivers, so I
> suspect that maybe my copper transceiver's diagnostics are being
> ignored by ethtool because the diagnostic data from them is considered
> incomplete, due to the transceiver not reporting any valid Laser
> related diagnostics (because they have no laser); this is just a guess
> as to why, and I don't know whether that's the case; I'd appreciate it
> if anyone could confirm whether that's the case.
> 
> Question:
> Is there currently a way to, or can an option be made to force ethtool
> to read and interpret the transceiver's diagnostic data for cases like
> mine, where diagnostic data exists, but is not displayed by default?
> 
> 
> In case it helps, here is an example ethtool output from a transceiver
> that accurately reports temp while installed in a switch, but not
> while in a NIC and being probed by ethtool (some values masked with
> xxxxxxxx for privacy):

Hi Chris

Have you single stepped through ethtool to see why it does not display
temperatures?

What i notice is that

Optical diagnostics support               : Yes

is not present in the output. That suggests the EEPROM contents says
there is no diagnostics available, and hence ethtool is skipping all
the diagnostic information in the EEPROM contents.

A few suggestions:

Check SFP SMA. Is there a bit somewhere which indicates temperature is
supported, even if optical diagnostics are not? We can then add
support for this to ethtool.

Check if the SFP manufacture has a data sheet indicating its
behaviour. Does it clearly document that diagnostics are not
available, but nether the less, temperature values are valid? If so,
we could consider adding a quirk to ethtool to look for this SFP and
dump temperature information.

     Andrew
