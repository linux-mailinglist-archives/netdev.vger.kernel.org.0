Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38E25387E5
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 21:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbiE3TyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 15:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiE3TyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 15:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C5F64BE0
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 12:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E1B260ED7
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 19:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3EEC385B8;
        Mon, 30 May 2022 19:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653940449;
        bh=LqVKzJndb9I+vubOGOtRQHcghzdeq10zTgocqcRhVoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IaXGGVXTZ7M9cyQHjrgmX24nWgbvt8wxrT9eJLYZSiDw6jMIZAow7CT7XafVL3baG
         WMaGpPLag5PsthSw7r5nmgURQPw1qGsLCwwg4X1NJ2pZsylNtV80s02wNrjOHjQsUG
         qZGCme9q9UHhDy424Pvf9gqIELD76ZHYoUqN/+aLaW95kIzy6FmM++j0i6EtaGmvB4
         GDetbWn5EJmILkzU6kMtO2Q8xasn5BtjuezERY6Mfsx24yE0OigL7HT76uwpulr30F
         GK/1kk+vMO/R3J2WYwwNa5EkbxvA+o7Az5CT7OteCt/WDryl39/sVHYQLabXuQ1DaA
         FU461R1ISdmuw==
Date:   Mon, 30 May 2022 12:54:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220530125408.3a9cb8ed@kernel.org>
In-Reply-To: <YpM7dWye/i15DBHF@nanopsycho>
References: <YozsUWj8TQPi7OkM@nanopsycho>
        <20220524110057.38f3ca0d@kernel.org>
        <Yo3KvfgTVTFM/JHL@nanopsycho>
        <20220525085054.70f297ac@kernel.org>
        <Yo9obX5Cppn8GFC4@nanopsycho>
        <20220526103539.60dcb7f0@kernel.org>
        <YpB9cwqcSAMslKLu@nanopsycho>
        <20220527171038.52363749@kernel.org>
        <YpHmrdCmiRagdxvt@nanopsycho>
        <20220528120253.5200f80f@kernel.org>
        <YpM7dWye/i15DBHF@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 May 2022 11:23:01 +0200 Jiri Pirko wrote:
> >Let's step back and look from the automation perspective again.
> >Assuming we don't want to hardcode matching "lc$i" there how can 
> >a generic FW update service scan the dev info and decide on what
> >dev flash command to fire off?  
> 
> Hardcode matching lc$i? I don't follow. It is a part of the
> version/component name.
> So if devlink dev info outputs:
> lc2.fw 19.2010.1310
> then you use for devlink dev flash:
> devlink dev flash pci/0000:01:00.0 component lc2.fw file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
> Same name, same string.
> 
> What am I missing?

Nevermind, I think we can iterate over all the groupings.
Since I hope you agreed that component has an established
meaning can we use group instead?

> >> Also, to avoid free-form, I can imagine to have per-linecard info_get() op
> >> which would be called for each line card from devlink_nl_info_fill() and
> >> prefix the "lcX" automatically without driver being involved.
> >> 
> >> Sounds good?  
> >
> >Hm. That's moving the matryoshka-ing of the objects from the uAPI level
> >to the internals. 
> >
> >If we don't do the string prefix but instead pass the subobject info to
> >the user space as an attribute per version we can at least avoid
> >per-subobject commands (DEVLINK_CMD_LINECARD_INFO_GET). Much closer to
> >how health reporters are implemented than how params are done, so I
> >think it is a good direction.  
> 
> Sorry, I'm a bit lost. Could you please provide some example about how
> you envision it? For me it is a guessing game :/
> My guess is you would like to add to the version nest where
> DEVLINK_ATTR_INFO_VERSION_NAME resides for example
> DEVLINK_ATTR_LINECARD_INDEX?
> 
> Correct?

Yup.
