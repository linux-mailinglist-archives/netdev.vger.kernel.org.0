Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0346865CC01
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjADCuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjADCuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:50:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D70164B6
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 18:50:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04815B810A7
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 02:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721E0C433D2;
        Wed,  4 Jan 2023 02:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672800600;
        bh=s8wxaUDnaxmJ6X4Df5A7gNFHYqhjht0Lmsy+8y3vU/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ssO8ffScxosH71j0Vbn8HBJ1E1CgdkuJ4t4NFhZTN6pempXf5DoIo1EGeeNGN25Po
         TjQ7GKO379oUgKZaTCcV0I/OgsHw7OBQEF09EDHFGQh1DBaK7rql13XGkpnJvCitEl
         6pKMsKYXZfqArLGipruJPakQbNWis18HQozSaeRt8ScQOBjINlms1RdAKLRXe2djda
         ixNTl3N82OWOo+otxybpxDwNoqPJ2XtFctUwxIYncr/6ntEjp3nlPi/QFZhEmRkaGF
         K+zCKtbC3U6DZeP7gyNFioF6+5w0FsGxeMOMx0sXgWPzYKIvMfWi2yq5nhByigLS6F
         JSc/h1/Wo7yPQ==
Date:   Tue, 3 Jan 2023 18:49:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <20230103184959.621f4b9c@kernel.org>
In-Reply-To: <Y7P0tE3+PyJSwaUC@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-5-kuba@kernel.org>
        <Y7Li+GMB6BU+D/6W@nanopsycho>
        <20230102150514.6321d2ae@kernel.org>
        <Y7P0tE3+PyJSwaUC@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Jan 2023 10:26:12 +0100 Jiri Pirko wrote:
> >> Why "alive"? To be consistent with the existing terminology, how about
> >> to name it devl_is_registered()?  
> >
> >I dislike the similarity to device_is_registered() which has very
> >different semantics. I prefer alive.  
> 
> Interesting. Didn't occur to me to look into device.h when reading
> devlink.c code. I mean, is device_register() behaviour in sync with
> devlink_register?
> 
> Your alive() helper is checking "register mark". It's an odd and unneded
> inconsistency in newly added code :/

Alright.

> >> Also, "devl_" implicates that it should be called with devlink instance
> >> lock held, so probably devlink_is_registered() would be better.  
> >
> >I'm guessing you realized this isn't correct later on.  
> 
> From what I see, no need to hold instance mutex for xa mark checking,
> alhough I understand why you want the helper to be called with the lock.
> Perhaps assert and a little comment would make this clear?

I'll add the comment. The assert would have to OR holding the subobject
locks. Is that what you had in mind?
