Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E58D4D52D1
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiCJUH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiCJUH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:07:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7E418BA50
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:06:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A605615B5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B615C340E8;
        Thu, 10 Mar 2022 20:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646942785;
        bh=bH8YofhqxWIhRlUdf8zQnT1z02Nizr3IbPQMso+8HQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cpEsorPKZ/W69HXNiCyDu+WJPNrXiQkTuQo5uQ6GHfLpxPoR5mq2WGSNPyvxV+9Dg
         1Fu6VzQNyDWgUnAs5d5hv9MEjM8XtAQGqmWv3TeyRNF1UYV1LZ8v2H0ik2uJ9ZptbL
         LhmRyQWelnfUZD8AbGMqxHOFevEm8QBZppQAJEvQ16urELjsLy2XAME/Y1q7u6c65K
         TOdelqIKxNH2tcGGy5wAbBlya0Io+9nIH2CmuilMriKTkm1SZ+u7qM0ccgbS0fEXJT
         G6CYEGKEFshD9CgIr422dcvZUZ6DJs52oYPWPi6a67spkt/XBDBwCmHFam/SYsJA+F
         rQWlxToXjGXOg==
Date:   Thu, 10 Mar 2022 12:06:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <20220310120624.4c445129@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YinBchYsWd/x8kiu@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
        <20220310001632.470337-2-kuba@kernel.org>
        <YinBchYsWd/x8kiu@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 10:14:26 +0100 Jiri Pirko wrote:
> It is kind of confusing to have:
> devlink_* - locked api
> devl_* - unlocked api
> 
> And not really, because by this division, devl_lock() should be called
> devlink_lock(). So it is oddly mixed..
> 
> I believe that "_" or "__" prefix is prefered here and everyone knows
> with away what it it is good for.
> 
> If you find "__devlink_port_register" as "too much typing" (I don't),
> why don't we have all devlink api shortened to:
> devl_*
> and then the unlocked api could be called:
> __devl_*
> ?

The goal is for that API to be the main one, we can rename the devlink_
to something else at the end. The parts of it which are not completely
removed.

> >+bool devl_lock_is_held(struct devlink *devlink)
> >+{
> >+	/* We have to check this at runtime because struct devlink
> >+	 * is now private. Normally lock_is_held() should be eliminated  
> 
> "is now private" belong more to the patch description, not to the actual
> code I believe.

Alright. The comment started as a warning not to use this for anything
but lockdep but I couldn't resist taking a dig at hiding the structure.
