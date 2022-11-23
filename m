Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2824C63511F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 08:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbiKWHfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 02:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiKWHfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 02:35:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9EFF72C5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 23:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDD7661AD8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F707C433D6;
        Wed, 23 Nov 2022 07:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669188905;
        bh=6ZeqNC2WbEGWT6T3ea2F1+2SYiHe/AdjtOnKf8zSgzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iyxer8ACE5oyWKRypUwYYIXVrIOpUAfcjo7vu0+SbUAsPd4aQwdtNIAkwgfdA+u3p
         bzia3/WJhSzXC08fiCTMDJVLAPryXwgpjHnM7xH8rOX0yl0N0Ns/eHK0KzpTgakCu1
         ZgX3wGA78alulJZhGjPDeEyfumRd+BPa+bm1xyCPaqu/Cb279O/ANNyWNqLtP7MY92
         hPRj8pdlu8hc30Io8MksDdrjSsvc+PNdL0KECm1kbkxa35d4OB9v4+voKQqKgIopv5
         joTBeT5uiTN2ayObjnE6hDo3SEjVKPX43vY6izVrMgat4FF0FnfelVOGkqyzlX5evm
         c7BOqTB84QV1A==
Date:   Wed, 23 Nov 2022 09:34:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>
Subject: Re: [PATCH net-next 0/5] Remove uses of kmap_atomic()
Message-ID: <Y33NIiawcUn7xulO@unreal>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <Y3yyf+mxwEfIi8Xm@unreal>
 <20221122105059.7ef304ff@kernel.org>
 <b19e7bcb-e781-779c-0d2b-42b2e9b184fe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b19e7bcb-e781-779c-0d2b-42b2e9b184fe@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 01:06:09PM -0800, Anirudh Venkataramanan wrote:
> On 11/22/2022 10:50 AM, Jakub Kicinski wrote:
> > On Tue, 22 Nov 2022 13:29:03 +0200 Leon Romanovsky wrote:
> > > >   drivers/net/ethernet/sun/cassini.c            | 40 ++++++-------------
> > > >   drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
> > > 
> > > Dave, Jakub, Paolo
> > > I wonder if these drivers can be simply deleted.
> > 
> > My thought as well. It's just a matter of digging thru the history,
> > platform code and the web to find potential users and contacting them.
> 
> I did a little bit of digging on these two files. Here's what I found.
> 
> For the cassini driver, I don't see any recent patches that fix an end user
> visible issue. There are clean ups, updates to use newer kernel APIs, and
> some build/memory leak fixes. I checked as far back as 2011. There are web
> references to some issues in kernel v2.6. I didn't see anything more recent.
> 
> The code in sunvnet_common.c seems to be common code that's used by
> 
> [1] "Sun4v LDOM Virtual Switch Driver" (ldmvsw.c, kconfig flag
> CONFIG_LDMVSW)
> 
> [2] "Sun LDOM virtual network driver" (sunvnet.c, kconfig flag
> CONFIG_SUNVNET).
> 
> These two seem to have had some feature updates around 2017, but otherwise
> the situation is the same as cassini.

If there is a pole to delete them, I vote for deletion. :)

Thanks

> 
> Ani
