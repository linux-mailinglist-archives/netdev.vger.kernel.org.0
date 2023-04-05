Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B8A6D8963
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 23:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbjDEVNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 17:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjDEVNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 17:13:54 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39D2173C;
        Wed,  5 Apr 2023 14:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=RHFbOU7mA/ADG1wjXvQHsyYnNIxPZ2MMB00EFHudKIM=;
        b=UpWDGBkttru0GC3yHfz9wyC4giIxpYLTzblb8EeIx96/yiXW9OeUed9QK5LutEv1KeF5deokdhxjt
         bHducv/dkRcQMwjo+SUXqfifhbyhXsEv/lHK+HMzpOwszR9/ZzDc+pBWk98U73sC3NckQhkrlic7HD
         MNPh2yrm86dG2cmOSXcdnOa14IyPmJfIQ1sw/R0P5T4qtcOQ7hUxPV54TBoT2I5pWLofUpj7zBZ7nt
         +V6c0VVlAQlRagoPBXKZeDUHnuRJNs3o/KllTlNjHrz4LVwPhemq90t2o9NSpaW0PGP+hWiIMdqHov
         u7oz/ZezXCMQ/P1yF+SRQicUQqPHrIg==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.2.1477, Stamp: 3], Multi: [Enabled, t: (0.000046,0.013484)], BW: [Enabled, t: (0.000024,0.000001)], RTDA: [Enabled, t: (0.165626), Hit: No, Details: v2.49.0; Id: 15.xdj4v.1gt9k97si.q6aj; mclb], total: 0(700)
X-Spam-Status: No, score=1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from x260 ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Thu, 6 Apr 2023 00:13:36 +0300
Date:   Thu, 6 Apr 2023 00:13:31 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        system@metrotek.ru, stable@vger.kernel.org
Subject: Re: [PATCH net] net: sfp: initialize sfp->i2c_block_size at sfp
 allocation
Message-ID: <20230405211331.nn54eqg4pd34tnai@x260>
References: <20230405153900.747-1-i.bornyakov@metrotek.ru>
 <19d7ef3c-de9d-4a44-92e9-16ac14b663d9@lunn.ch>
 <20230405204116.mo5j6klyjnuvenag@x260>
 <4c78acf7-3c72-40c5-b6cf-ff6033b80e85@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c78acf7-3c72-40c5-b6cf-ff6033b80e85@lunn.ch>
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 10:51:38PM +0200, Andrew Lunn wrote:
> On Wed, Apr 05, 2023 at 11:41:16PM +0300, Ivan Bornyakov wrote:
> > On Wed, Apr 05, 2023 at 09:35:31PM +0200, Andrew Lunn wrote:
> > > On Wed, Apr 05, 2023 at 06:39:00PM +0300, Ivan Bornyakov wrote:
> > > > sfp->i2c_block_size is initialized at SFP module insertion in
> > > > sfp_sm_mod_probe(). Because of that, if SFP module was not inserted
> > > > since boot, ethtool -m leads to zero-length I2C read attempt.
> > > > 
> > > >   # ethtool -m xge0
> > > >   i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
> > > >   Cannot get Module EEPROM data: Operation not supported
> > > 
> > > Do i understand you correct in that this is when the SFP cage has
> > > always been empty? The I2C transaction is going to fail whatever the
> > > length is.
> > > 
> > 
> > Yes, SFP cage is empty, I2C transaction will fail anyways, but not all
> > I2C controllers are happy about zero-length reads.
> > 
> > > > If SFP module was plugged then removed at least once,
> > > > sfp->i2c_block_size will be initialized and ethtool -m will fail with
> > > > different error
> > > > 
> > > >   # ethtool -m xge0
> > > >   Cannot get Module EEPROM data: Remote I/O error
> > > 
> > > So again, the SFP cage is empty?
> > > 
> > > I wonder if a better fix is to use
> > > 
> > > sfp->state & SFP_F_PRESENT
> > > 
> > > in sfp_module_eeprom() and sfp_module_eeprom_by_page() and don't even
> > > do the I2C read if there is no module in the cage?
> > > 
> > 
> > This is also worthy addition to sfp.c, but IMHO sfp->i2c_block_size
> > initialization still need to be fixed since
> > 
> >   $ grep -c "sfp_read(" drivers/net/phy/sfp.c
> >   31
> > 
> > and I can't vouch all of them are possible only after SFP module
> > insertion. Also for future proof reason.
> 
> I think everything else should be safe. A lot of those reads are for
> the HWMON code. And the HWMON code only registers when the module is
> inserted.
> 
> How about two patches, what you have here, plus checking sfp->state &
> SFP_F_PRESENT in the ethtool functions?
> 
> 	Andrew

Sure, will do in the near future.

