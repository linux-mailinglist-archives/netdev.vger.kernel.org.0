Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B73D62483F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiKJRVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiKJRVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:21:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE3F4C27D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:20:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6EC1B82269
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47CAC433C1;
        Thu, 10 Nov 2022 17:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668100856;
        bh=pLDaFCfcZhJQgX0RuTHGdDoqNH6H633GFd+Lk86Op5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+qso7/yfJOyorU22G8Qx2UfoNLybgf+ZCFnGTCiPiaoviv7gfJLAAfEC/1IpoEs/
         lFsU+tXlfQ204Pp19qTjBq+wcBI57bsrUzGP7WJguknqkJdwbdy+s+UjMUfrKLdh6b
         /+mTUn3jQSkuVI8ZxcWWX+qqdkClz0nzqX1gTEoltDlD7jl9lDhIb2uSd4qWQNzM0/
         vgRRx+KtrItaG4HhYPoT7fgUbRSza8qW+cyLx18N9NHjTxD+xjxdZxMNfYK9QNJ23m
         xSQZK6wk21l2lO7VXfxqpsAmBeltRMaf2HpoLDBgaGaJBg/MyaPPyVhNIOjcflcKBw
         4KEmXYzfOmi1Q==
Date:   Thu, 10 Nov 2022 19:20:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
Message-ID: <Y20y8yDgWH42LjMp@unreal>
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
 <Y2vozcC2ahbhAvhM@unreal>
 <20221109122641.781b30d9@kernel.org>
 <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
 <Y2zASloeKjMMCgyw@unreal>
 <20221110090127.0d729f05@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110090127.0d729f05@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:01:27AM -0800, Jakub Kicinski wrote:
> On Thu, 10 Nov 2022 11:11:38 +0200 Leon Romanovsky wrote:
> > I will be happy to see such patch and will review it, but can't add sign-off
> > as I'm not netdev maintainer.
> 
> Did we finish the version removal work? :S

Good point :)

> 
> Personally I'd rather direct any effort towards writing a checkpatch /
> cocci / python check that catches new cases than cleaning up the pile
> of drivers we have. A lot of which are not actively used..

I thought about this too, but came to conclusion what first step is to
remove "version" from in-kernel API. It will reduce drastically desire
to add driver version to new drivers.

"There is no shame in doing the right thing, even if its too late.".

BTW, I hope that we all learned that allowing drivers to return free
string to users will always lead to disaster.

Thanks
