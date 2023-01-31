Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96845682DF9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjAaNc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbjAaNcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:32:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF17151427
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ACC961519
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10316C433EF;
        Tue, 31 Jan 2023 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675171959;
        bh=d+6BT8JVSgEFjcy1nrHUrWL1dja7eV7LU+hE8XcgdKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pes9sHnLghuyBq1lbURcdB7zDnGTSwRDZB0+EKBLqNBJDecx1Cu/zl4o8EY0/Uiuv
         WKhq36iRnN6nSXRZ2D6GioT3mL1abMVkS2QWeFWW4FQ5B7ivByXinVfjUUjUmPodO2
         B8W7wPuWnl8qIkhQV5nTb9Xrrw4SJo1pKmfA+Ae4kAhnnd9FEGj6qt1eR8ahXbCI6P
         E/vqHZoF/3IbFvS66BdgoNX139/lYg3nsLblW/d/TD+f/9gOUZjCDk5Pxb9wCOKpM7
         kv+KIuRw3xZExMXpAzDm9LIKwSPiNIyEQSFTPwIcA6kKjQK01t9K3B6vgUFRs0Uagf
         zLPzlAW+BnFAg==
Date:   Tue, 31 Jan 2023 15:32:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2] netlink: provide an ability to set default
 extack message
Message-ID: <Y9kYcwSm8X0mP5gR@unreal>
References: <c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org>
 <801a4a44f0fb6e37f79037eae9a3db50191cdb12.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <801a4a44f0fb6e37f79037eae9a3db50191cdb12.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 12:47:03PM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Sun, 2023-01-29 at 18:51 +0200, Leon Romanovsky wrote:
> > In netdev common pattern, extack pointer is forwarded to the drivers
> > to be filled with error message. However, the caller can easily
> > overwrite the filled message.
> > 
> > Instead of adding multiple "if (!extack->_msg)" checks before any
> > NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> > add new macro to common code.
> > 
> > [1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> I'm sorry for nit-picking, but checkpatch complains the author
> (leon@kernel.org) does not match the SoB tag. A v3 with a suitable
> From: tag should fix that.

Sure, will resend.

> 
> Thanks,
> 
> Paolo
> 
