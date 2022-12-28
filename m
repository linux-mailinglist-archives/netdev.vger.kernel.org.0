Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6733C657480
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 10:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiL1JPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 04:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiL1JPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 04:15:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAE6DEF5;
        Wed, 28 Dec 2022 01:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 476BD61356;
        Wed, 28 Dec 2022 09:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD92C433EF;
        Wed, 28 Dec 2022 09:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672218905;
        bh=xYhr5uhlKdptK0DYghqZVkuxC4UV7CC/gyvUEUOnE2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nu2xgrCop9EMDeNqUC5PECTIAKfcuC1AF/UlHyrc0n0xJ0EWVvFei003SPk5aZr44
         Z1lRpEvP3Ap7D6lzRwlgQIbXNVEI91DuCs4jGj/nzXkhVjkk6egSdMkoQizpGqKbTD
         BUJX5nPkpfSWFmxVKB5pTqRIE3z5u/ukpG/kVtxB8WtmDZjoxoSYJUjVQTbtqF5lWd
         WzBhpY/eM37lGGicYo/Ecy1gFT8MOmxmEpqYtLEBovphRmwaqkVRcX3oGkqYlryUrE
         MTHAwHD5Xea5fmxqtf+1blK5JFYQYoy83TJLWUPx/KWxD2j4yXkKXPNX557elYoAyo
         2AtTt8IL0qecw==
Date:   Wed, 28 Dec 2022 11:15:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lixue Liang <lianglixuehao@126.com>,
        anthony.l.nguyen@intel.com, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        lianglixue@greatwall.com.cn
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <Y6wJFYMZVQ7V+ogG@unreal>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal>
 <20221214085106.42a88df1@kernel.org>
 <Y5obql8TVeYEsRw8@unreal>
 <20221214125016.5a23c32a@kernel.org>
 <Y57SPPmui6cwD5Ma@unreal>
 <CAKgT0UfZk3=b0q3AQiexaJ=gCz6vW_hnHRnFiYLFSCESYdenOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfZk3=b0q3AQiexaJ=gCz6vW_hnHRnFiYLFSCESYdenOw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 07:30:45AM -0800, Alexander Duyck wrote:
> On Sun, Dec 18, 2022 at 12:41 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Dec 14, 2022 at 12:50:16PM -0800, Jakub Kicinski wrote:
> > > On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
> > > > On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
> > > > > On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:
> > > > > > NAK to any module driver parameter. If it is applicable to all drivers,
> > > > > > please find a way to configure it to more user-friendly. If it is not,
> > > > > > try to do the same as other drivers do.
> > > > >
> > > > > I think this one may be fine. Configuration which has to be set before
> > > > > device probing can't really be per-device.
> > > >
> > > > This configuration can be different between multiple devices
> > > > which use same igb module. Module parameters doesn't allow such
> > > > separation.
> > >
> > > Configuration of the device, sure, but this module param is more of
> > > a system policy.
> >
> > And system policy should be controlled by userspace and applicable to as
> > much as possible NICs, without custom module parameters.
> >
> > I would imagine global (at the beginning, till someone comes forward and
> > requests this parameter be per-device) to whole stack parameter with policies:
> >  * Be strict - fail if mac is not valid
> >  * Fallback to random
> >  * Random only ???
> >
> > Thanks
> 
> So are you suggesting you would rather see something like this as a
> sysctl then? Maybe something like net.core.netdev_mac_behavior where
> we have some enum with a predetermined set of behaviors available? I
> would be fine with us making this a global policy if that is the route
> we want to go. It would just be a matter of adding the sysctl and an
> accessor so that drivers can determine if it is set or not.

Something like that and maybe convert drivers and/or to honor this policy.

Thanks
