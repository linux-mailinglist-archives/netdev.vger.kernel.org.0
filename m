Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5076D895C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 23:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjDEVMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 17:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDEVMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 17:12:07 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2534CBE;
        Wed,  5 Apr 2023 14:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=nvlDqqC1HZuZQCP4v7nUD2qz1uhbB8cOkjERLKw3KrA=;
        b=C4V+NPIo1+xxWmyO0NQH7xUErAJZJX3oSffFr23lsnd01cYkB0mRAWDizGRCgSk2ZG1OIYDlKvy+l
         cFFyYcF7sEgP7iRmQhC5A8hv40I7XSRTN8vHKjGOgoCD4VhUkHCxQIHBT5u6e9KAONrQJqYBns3J7z
         PZnoECnVU0CZwoFLTQvzDKyF2nH1z+MDxZRpUf3TSl2uTgpbibHQQvh++s5wniVz/52vIZ6aa3KT8r
         EXlWqJBO3wbVwooBoAWCAOqWt0kTBzYT4Zhs7K/a8vMRReOFNBHvmsnRDH2QdUTdzTwfL/kFmJ5NM4
         2qBSXjv/UO4EvsDsLJxdm5j/ApflHfg==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.2.1477, Stamp: 3], Multi: [Enabled, t: (0.000043,0.009637)], BW: [Enabled, t: (0.000025,0.000001)], RTDA: [Enabled, t: (0.072898), Hit: No, Details: v2.49.0; Id: 15.zzc5h.1gt9ie61g.171og; mclb], total: 0(700)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from x260 ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Wed, 5 Apr 2023 23:41:21 +0300
Date:   Wed, 5 Apr 2023 23:41:16 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        system@metrotek.ru, stable@vger.kernel.org
Subject: Re: [PATCH net] net: sfp: initialize sfp->i2c_block_size at sfp
 allocation
Message-ID: <20230405204116.mo5j6klyjnuvenag@x260>
References: <20230405153900.747-1-i.bornyakov@metrotek.ru>
 <19d7ef3c-de9d-4a44-92e9-16ac14b663d9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d7ef3c-de9d-4a44-92e9-16ac14b663d9@lunn.ch>
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 09:35:31PM +0200, Andrew Lunn wrote:
> On Wed, Apr 05, 2023 at 06:39:00PM +0300, Ivan Bornyakov wrote:
> > sfp->i2c_block_size is initialized at SFP module insertion in
> > sfp_sm_mod_probe(). Because of that, if SFP module was not inserted
> > since boot, ethtool -m leads to zero-length I2C read attempt.
> > 
> >   # ethtool -m xge0
> >   i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
> >   Cannot get Module EEPROM data: Operation not supported
> 
> Do i understand you correct in that this is when the SFP cage has
> always been empty? The I2C transaction is going to fail whatever the
> length is.
> 

Yes, SFP cage is empty, I2C transaction will fail anyways, but not all
I2C controllers are happy about zero-length reads.

> > If SFP module was plugged then removed at least once,
> > sfp->i2c_block_size will be initialized and ethtool -m will fail with
> > different error
> > 
> >   # ethtool -m xge0
> >   Cannot get Module EEPROM data: Remote I/O error
> 
> So again, the SFP cage is empty?
> 
> I wonder if a better fix is to use
> 
> sfp->state & SFP_F_PRESENT
> 
> in sfp_module_eeprom() and sfp_module_eeprom_by_page() and don't even
> do the I2C read if there is no module in the cage?
> 

This is also worthy addition to sfp.c, but IMHO sfp->i2c_block_size
initialization still need to be fixed since

  $ grep -c "sfp_read(" drivers/net/phy/sfp.c
  31

and I can't vouch all of them are possible only after SFP module
insertion. Also for future proof reason.

