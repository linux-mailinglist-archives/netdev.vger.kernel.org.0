Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFD9665E8B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbjAKO5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238488AbjAKO47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:56:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50A75FB2;
        Wed, 11 Jan 2023 06:56:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7963C61D4C;
        Wed, 11 Jan 2023 14:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556BFC433D2;
        Wed, 11 Jan 2023 14:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673449015;
        bh=7KrxrMBTrm2k5eaChJutXbGFMMhPgdWPn4Daxh7vj4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xB4v8A+uaOYPztnyzpvJhzF/L/8BSpKtxAKSF2vT3BVz9RxB3k+c6x4PJWplH9Kow
         UgOdqDYZvRdjpsbRsqg7aEc5DeFYIDlBa0qxPsSU/rwHMp5wPRR8I/0b2AROGTz66K
         PE/w7ZOXNejyCziVaxsLhn3ON6//0fMKtF08Emis=
Date:   Wed, 11 Jan 2023 15:56:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jan Engelhardt <jengelh@inai.de>
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
Message-ID: <Y77ONKx60xWUxvcN@kroah.com>
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
 <n9108s34-9rn0-3n8q-r3s5-51r9647331ns@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n9108s34-9rn0-3n8q-r3s5-51r9647331ns@vanv.qr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 02:38:04PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2022-11-23 13:46, Greg Kroah-Hartman wrote:
> >
> >The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> >any system that uses it with untrusted hosts or devices.  Because the
> >protocol is impossible to make secure, just disable all rndis drivers to
> >prevent anyone from using them again.
> >
> >Windows only needed this for XP and newer systems, Windows systems older
> >than that can use the normal USB class protocols instead, which do not
> >have these problems.
> 
> 
> In other news, someone just proposed adding "RNDIS" things to UEFI, so 
> now the security problem is added right back into machines but at 
> another layer?!
> 
> https://edk2.groups.io/g/devel/topic/patch_1_3/95531719

I guess systems that use this will always have to trust that the device
plugged into them is "trusted".  Seems like an easy way to get access to
a "locked down" system if you ever need it :)

{sigh}

greg k-h
