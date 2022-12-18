Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FDE64FE13
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 09:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiLRIlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 03:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiLRIll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 03:41:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321505F4C;
        Sun, 18 Dec 2022 00:41:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A03F560C40;
        Sun, 18 Dec 2022 08:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0BBC433EF;
        Sun, 18 Dec 2022 08:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671352897;
        bh=bTTHW54ywvYaPl0xp7dDxXJxXxuIkgm4KU9HqKO/f6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sFyZe5Z+xuPBxmDdc1BY9PDe12EdH7hq2wEzbJdvbf7mZXYtdapzdc2TB5THbjgUD
         8Ui6iyY/8cO+t2ZXXpFt6joQERaiPSuXlqODSG7iGKrcXTfhBrHsUtyiyWwSxQpno7
         Lk8CiczP6Gw+cTvCxmJPvp6/R5XGDciFYlU4myMK3TLufTI0Pir9AYcY1RblwXitIL
         k2aE2aIch4fqR8oarlAPK5oPMyiUq7VouvKAOwcXMBQKJsslCe4bNSclNfg0AgMgbv
         Cqokj9ZJb1Q2JhnU5lKKpo05qDARkipL1a9fBwFa0iMSTTONWhA7MvQUCVpKSHEbh8
         oG/UbjdLd0wZQ==
Date:   Sun, 18 Dec 2022 10:41:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lixue Liang <lianglixuehao@126.com>, anthony.l.nguyen@intel.com,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, lianglixue@greatwall.com.cn,
        Alexander H Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <Y57SPPmui6cwD5Ma@unreal>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal>
 <20221214085106.42a88df1@kernel.org>
 <Y5obql8TVeYEsRw8@unreal>
 <20221214125016.5a23c32a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214125016.5a23c32a@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 12:50:16PM -0800, Jakub Kicinski wrote:
> On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
> > On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
> > > On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:  
> > > > NAK to any module driver parameter. If it is applicable to all drivers,
> > > > please find a way to configure it to more user-friendly. If it is not,
> > > > try to do the same as other drivers do.  
> > > 
> > > I think this one may be fine. Configuration which has to be set before
> > > device probing can't really be per-device.  
> > 
> > This configuration can be different between multiple devices
> > which use same igb module. Module parameters doesn't allow such
> > separation.
> 
> Configuration of the device, sure, but this module param is more of 
> a system policy. 

And system policy should be controlled by userspace and applicable to as
much as possible NICs, without custom module parameters.

I would imagine global (at the beginning, till someone comes forward and
requests this parameter be per-device) to whole stack parameter with policies:
 * Be strict - fail if mac is not valid
 * Fallback to random
 * Random only ???

Thanks
