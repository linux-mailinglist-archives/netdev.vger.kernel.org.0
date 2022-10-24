Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F80609CC7
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJXIdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJXIdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:33:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98CE48CAA;
        Mon, 24 Oct 2022 01:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0285BB80EF1;
        Mon, 24 Oct 2022 08:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7719C433D6;
        Mon, 24 Oct 2022 08:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666600376;
        bh=AUUSjBeYjbwK2lpBXq61R8lKy6FD4M3AGLnDSBq1XUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WPSXV24oTrPf9yzWeajlqfZV99jvwMk0brHqmlcwzaowitAh307rmuzCz1l7+RS5l
         yPVPWZIegXjdvYj7V+d41XaDUyqIYRQwj2+1eaQHzwWMXk4WreOlXvoopWfhO+w40M
         ZB9saR9IwxJbiW6BqrdRLLKneELlHwlPX3L5MN+6RyWxw/xWltvyTVzunQpGW9sfpd
         IhkNxh4wm+cjPo96Ouqv3iYW9zulXcHwEcslSw0KWDXlTDb4Lryh+XTY6dWiHmkZgo
         CY38nvxnio5G6s/HOIvQBIfVQcRXZhWKcdW4or5DCMs6RlLRXtpqbcCXN2+D5U3CSn
         58+P8JOPRm5iA==
Date:   Mon, 24 Oct 2022 11:32:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH -next] rfkill: replace BUG_ON() with WARN_ON() in core.c
Message-ID: <Y1ZNs3w1ymYbjM9f@unreal>
References: <20221021135738.524370-1-yangyingliang@huawei.com>
 <Y1T4aWIbueaf4jYM@unreal>
 <ab635939-6763-42c1-0410-79e6c65b4568@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab635939-6763-42c1-0410-79e6c65b4568@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 09:58:59AM +0800, Yang Yingliang wrote:
> 
> On 2022/10/23 16:16, Leon Romanovsky wrote:
> > On Fri, Oct 21, 2022 at 09:57:38PM +0800, Yang Yingliang wrote:
> > > Replace BUG_ON() with WARN_ON() to handle fault more gracefully.
> > > 
> > > Suggested-by: Johannes Berg <johannes@sipsolutions.net>
> > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > ---
> > >   net/rfkill/core.c | 25 ++++++++++++++++---------
> > >   1 file changed, 16 insertions(+), 9 deletions(-)
> > Please add changelog and version numbers when you set your series.
> > 
> > The same comment as https://lore.kernel.org/all/Y1T3a1y/pWdbt2ow@unreal
> The link is unreachable.

Try this https://lore.kernel.org/netdev/Y1T3a1y%2FpWdbt2ow@unreal/

> > or you should delete BUG_ONs completely or simply replace them with WARN_ONs.
> > 
> > There is no need in all these if (...).
> If remove BUG_ONs or not use if (...), it may lead null-ptr-deref, it's same
> as
> using BUG_ON(), which leads system crash.

May or will? Do you have crash report in hand?

This is rfkill API and an expectation is to have valid struct rfkill *rfkill.
Callers shouldn't call to these API functions if they know what rfkill is NULL.

Thanks

> 
> Thanks,
> Yang
> > 
> > Thanks
> > .
