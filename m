Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B6B614406
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 06:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiKAFF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 01:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKAFFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 01:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB4B13D3F;
        Mon, 31 Oct 2022 22:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC3296152C;
        Tue,  1 Nov 2022 05:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB457C433C1;
        Tue,  1 Nov 2022 05:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667279124;
        bh=HhWTqUJ0/Hjh59ReDgoeYvu4XA6vfKrVKTQdy+QckFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mLujFD2MGhSauTFXfgW8Fdps0GoG8APokfXodZVbB0qTsTcWWNZDBeYeg+z1yCOdM
         NgiYDmOj1wbfxLJCnnTxQ0zXQRdkCiVxmI8CSdEeV7KHcaNdxLyMfnFcwaLCgXGmYI
         xQmd47UrpshFrpCo8d22Q8eRt5PykFnObvoLqalg=
Date:   Tue, 1 Nov 2022 06:06:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/14] pull-request: can-next 2022-10-31
Message-ID: <Y2CpRfuto8wFrXX+@kroah.com>
References: <20221031154406.259857-1-mkl@pengutronix.de>
 <20221031202714.1eada551@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031202714.1eada551@kernel.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 08:27:14PM -0700, Jakub Kicinski wrote:
> On Mon, 31 Oct 2022 16:43:52 +0100 Marc Kleine-Budde wrote:
> > The first 7 patches are by Stephane Grosjean and Lukas Magel and
> > target the peak_usb driver. Support for flashing a user defined device
> > ID via the ethtool flash interface is added. A read only sysfs
> 
> nit: ethtool eeprom set != ethtool flash
> 
> > attribute for that value is added to distinguish between devices via
> > udev.
> 
> So the user can write an arbitrary u32 value into flash which then
> persistently pops up in sysfs across reboots (as a custom attribute
> called "user_devid")?
> 
> I don't know.. the whole thing strikes me as odd. Greg do you have any
> feelings about such.. solutions?
> 
> patches 5 and 6 here:
> https://lore.kernel.org/all/20221031154406.259857-1-mkl@pengutronix.de/

Device-specific attributes should be in the device-specific directory,
not burried in a class directory somewhere that is generic like this one
is.

Why isn't this an attribute of the usb device instead?

And there's no need to reorder the .h file includes in patch 06 while
you are adding a sysfs entry, that should be a separate commit, right?

Also, the line:

+	.attrs	= (struct attribute **)peak_usb_sysfs_attrs,

Is odd, there should never be a need to cast anything like this if you
are doing things properly.

So this still needs work, sorry.

thanks,

greg k-h

