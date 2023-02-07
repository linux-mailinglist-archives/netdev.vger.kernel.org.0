Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44968CC6A
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 03:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBGCHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 21:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBGCHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 21:07:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967422B097
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 18:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Qk51GoKOUsLO7yxAXJghUF6zZ2+BdGcw6matGMmNtL8=; b=aN9nv7UByo6xIfyrrWv2PZSlBs
        RSlDgrJctRY0Ny6RL3zl6oFlcRPphoUKsLk8Rxa+6KWkfUEQRORLkwpEG/3O7/tNB1ehkKS4I5kGx
        tb9+dbCHY/rreRwWf4awv4YmShlQQ64kt1V3HcCS8fpuHDWjXbgXSNsY2aE7L+9F++6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPD2r-004Fs3-O5; Tue, 07 Feb 2023 02:45:17 +0100
Date:   Tue, 7 Feb 2023 02:45:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Svensson <christian@cmd.nu>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        Viktor Ekmark <viktor@ekmark.se>
Subject: Re: ethtool's eeprom_parse fails to determine plug type due to short
 read
Message-ID: <Y+GtLXDTJj3tUMty@lunn.ch>
References: <CADiuDATAsP7cvxmV9d8=P0j=75XRxvX3jm32d6PQ_Wqv8NR_6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADiuDATAsP7cvxmV9d8=P0j=75XRxvX3jm32d6PQ_Wqv8NR_6Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 08:06:31PM +0100, Christian Svensson wrote:
> Hi,
> 
> I am currently running a system with an Intel E810 ("ice") card as
> well as 2x QSFP28 transceivers made by ColorChip.
> The behavior I am observing for these modules is that they return
> zeroed data unless the read length is greater than 8.
> 
> $ sudo ethtool -m ens1f1 hex on length 8
> Offset          Values
> ------          ------
> 0x0000:         00 00 00 00 00 00 00 00
> $ sudo ethtool -m ens1f1 hex on length 9
> Offset          Values
> ------          ------
> 0x0000:         11 07 02 00 00 00 00 00 00
> 
> eeprom_parse uses a 1-byte read to determine the type of module. This
> obviously fails in this case and the function resorts to printing an
> hex dump - which ironically contains the correct EEPROM data.
> 
> I can see three options to handle this case:
> 1) Continue using 1-byte read, let ethtool be broken for these types
> of modules (the current state)
> 2) Switch to using e.g. a 16 byte read. Might break other modules?
> 3) Use a 1-byte read, and if it returns zero as the type byte, retry
> with e.g. a 16 byte read to see if that works better.

4) Throw the modules away since they probably don't fulfil the standard.

The problem with 4) is, most modules are broken in one way or
another. There are some modules which cannot do anything but 1-byte
reads. Which then means all the statistics you get from them are
broken because that requires 2-byte atomic reads....

The generic SFP code in drivers/net/phy/sfp.c starts out reading using
16 byte blocks. But there are some SFPs which are broken, return one
valid byte followed by 0s. So during probe of the SFP it looks for
this, and changes the block size to 1, etc.

Since the ICE driver does not use this generic code, you need to talk
with Intel about what workaround they are prepared to support.

     Andrew
