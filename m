Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409BE6362B5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbiKWPFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbiKWPFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:05:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C625D21AA;
        Wed, 23 Nov 2022 07:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6242761D63;
        Wed, 23 Nov 2022 15:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA29C433C1;
        Wed, 23 Nov 2022 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669215908;
        bh=B2ieTl57vrLj6dHchJgEC9dcze5oWG9C+goXxPF5SqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0g5FXXZCC8LhG0Z5R5xKISTS656yCpFLisQI0FDcpbqrHIewFYMRDfqr0QvrIUKqS
         0dytqyrB3Xu0+54ZhF78G3qt22od7L0qoNpMofTHuz1lKNPd1Gf90ezjkS9NsX4hhp
         qmNu0RFrnMDNl1X2181dL+JJbwj+dMO41hmoFobU=
Date:   Wed, 23 Nov 2022 16:05:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
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
Message-ID: <Y342oUJu9CFHNmlW@kroah.com>
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
 <9b78783297db1ebb1a7cd922be7eef0bf33b75b9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b78783297db1ebb1a7cd922be7eef0bf33b75b9.camel@sipsolutions.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 03:20:36PM +0100, Johannes Berg wrote:
> On Wed, 2022-11-23 at 13:46 +0100, Greg Kroah-Hartman wrote:
> > The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> > any system that uses it with untrusted hosts or devices.  Because the
> > protocol is impossible to make secure, just disable all rndis drivers to
> > prevent anyone from using them again.
> > 
> 
> Not that I mind disabling these, but is there any more detail available
> on this pretty broad claim? :)

I don't want to get into specifics in public any more than the above.

The protocol was never designed to be used with untrusted devices.  It
was created, and we implemented support for it, when we trusted USB
devices that we plugged into our systems, AND we trusted the systems we
plugged our USB devices into.  So at the time, it kind of made sense to
create this, and the USB protocol class support that replaced it had not
yet been released.

As designed, it really can not work at all if you do not trust either
the host or the device, due to the way the protocol works.  And I can't
see how it could be fixed if you wish to remain compliant with the
protocol (i.e. still work with Windows XP systems.)

Today, with untrusted hosts and devices, it's time to just retire this
protcol.  As I mentioned in the patch comments, Android disabled this
many years ago in their devices, with no loss of functionality.

thanks,

greg k-h
