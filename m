Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AC163650C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbiKWP4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238569AbiKWP4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:56:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B044C76BB;
        Wed, 23 Nov 2022 07:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCB7A61DDD;
        Wed, 23 Nov 2022 15:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1843C433D7;
        Wed, 23 Nov 2022 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669218956;
        bh=ZuVdYwErHyT91Nxq7Ryx7NmqLgrFG/cDPHKGxFR2ZFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U2jGkw8JTEW0C6phd70XCZqs+hQEYskiW31puxOmhSaxxbnL7VTHzxnHchF1UOEdz
         kZEA4Q2n1FvfL3mMI7in0/8iFYeSD6mZwwj8tOnzA/0kxtA5tAoIYEDszzjvfm6lt4
         Fko4yGV+Zoxg2s69SXNsjjvbx+oACotgEJLlBuRA=
Date:   Wed, 23 Nov 2022 16:55:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
Message-ID: <Y35CiSPS+A0pHtwO@kroah.com>
References: <04ea37cc-d97a-3e00-8a99-135ab38860f2@green-communications.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ea37cc-d97a-3e00-8a99-135ab38860f2@green-communications.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 04:40:33PM +0100, Nicolas Cavallari wrote:
> On 23/11/2022 13:46, Greg Kroah-Hartman wrote:
> > The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> > any system that uses it with untrusted hosts or devices.  Because the
> > protocol is impossible to make secure, just disable all rndis drivers to
> > prevent anyone from using them again.
> > 
> > Windows only needed this for XP and newer systems, Windows systems older
> > than that can use the normal USB class protocols instead, which do not
> > have these problems.
> > 
> > Android has had this disabled for many years so there should not be any
> > real systems that still need this.
> 
> I kind of disagree here. I have seen plenty of android devices that only
> support rndis for connection sharing, including my android 11 phone released
> in Q3 2020. I suspect the qualcomm's BSP still enable it by default.

Qualcomm should not have it enabled, and if they do, they are adding
code that Google says should not be enabled, and so Qualcom is
responsible for supporting that mess.  Good luck to them.

> There are also probably cellular dongles that uses rndis by default. Maybe
> ask the ModemManager people ?

That would be very very sad if it were the case, as they are totally
unsafe.

> I'm also curious if reimplementing it in userspace would solve the security
> problem.

The kernel would be happier, as all of the buffer overflows that are
possible would only be happening in userspace.  But I doubt any library
or userspace code that interacts with the protocol would really enjoy
it.

thanks,

greg k-h
