Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7AA5A330A
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbiH0AWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiH0AWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:22:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE356CE4A1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 17:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B5EC61C19
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D119C433C1;
        Sat, 27 Aug 2022 00:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661559764;
        bh=UgYynl9FhmLtBpgOrkaaTFTxKMfeseXtupzkF6xWqH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QEInJK61sOTYTMSS/lDh/SIgY7DGzyX+cSV+ojN4IhUb/Wc/HlNqrO4OJ2Hm5KZ47
         uP4BfVEa/W+l+oQvH+rq4h+CEkeq97hzhWjdqIRO3o8m5a8CSeVlJL3oJKXTE4mNMZ
         9LXdnkfonmm2WS0TNlVtr7qMOekeW+SmECvPkN8oDGX4Ns31eFdEwuguyzwcWaXmzn
         K5yxgs3bCdYdTcQPgGkNHVu6lnrkEqlfTjjMqEvIpF0bCR93gASc4XmbPHJ3DZwD5c
         p7uqUk++l85cS2W9lEHwUsmMZNm/Uma6slwD76quJeDlTJUPEBiElOXzzC8Eis1KDZ
         s4CMffwN/KRsg==
Date:   Fri, 26 Aug 2022 17:22:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next 0/7] devlink: sanitize per-port region
 creation/destruction
Message-ID: <20220826172243.16ad86fe@kernel.org>
In-Reply-To: <YwiChaPfZKkAK/c4@nanopsycho>
References: <20220825103400.1356995-1-jiri@resnulli.us>
        <20220825150132.5ec89092@kernel.org>
        <YwiChaPfZKkAK/c4@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 10:21:25 +0200 Jiri Pirko wrote:
>> The point of exposing the devlink lock was to avoid forcing drivers 
>> to order object registration in a specific way. I don't like.  
> 
> Well for params, we are also forcing them in a specific way. The
> regions, with the DSA exception which is not voluntary, don't need to be
> created/destroyed during devlink/port being registered.
> 
> I try to bring some order to the a bit messy devlink world. The
> intention is to make everyone's live happier :)

The way I remember it - we had to keep the ordering on resources for
mlx4 because of complicated locking/async nature of events, and since
it's a driver for a part which is much EoL we won't go back now and do
major surgery, that's fine.

But that shouldn't mean that the recommended way of using resources is
"hook them up before register". The overall devlink locking ordering
should converge towards the "hold devl_lock() around registration of
your components, or whenever the device goes out of consistent state".
