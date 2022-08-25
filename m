Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277EC5A06E3
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiHYBq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiHYBoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:44:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B395A9E117
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 18:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1711561AF0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B46C433B5;
        Thu, 25 Aug 2022 01:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391586;
        bh=L/TmHANVnaXnqOI/y7++/JNJ+B5g0j+VRF0+3vuUlw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E1lcdvA7PozdL8aEjmvbQJFAw5+k0/GagkKn1Xpk0G9wx0W2Vu9emop5jfmGkmHQL
         lIahElxvG37OiOU1r2VxjYWJj9IYWVwjNZhZ90WXyeN9P+jF6BvUnx8/YbK4oUjv/P
         UjGKXIFNijN+37fiKdNjqF8F4nQ7PeoutnJUPWZG5aGLLeMc/vsh4/QYl2AZO86uKY
         Rb0vfF4yeGYObXPv2ZlSVaTJLiHSKJY/zZP2Egc2LCZLtWRIIMuY15EQxzaAwLiVDz
         hWNxnrHUzaAKHWJrbxF3giMESOXftt6yFE0FtKUwuab9huWYY5Z44N+tpr27pnmlko
         q1e+1qZXUbt8g==
Date:   Wed, 24 Aug 2022 18:39:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Question] Should NLMSG_DONE has flag NLM_F_MULTI?
Message-ID: <20220824183945.6ce7251d@kernel.org>
In-Reply-To: <YwWY8ux/PyMWQBWr@Laptop-X1>
References: <YwWY8ux/PyMWQBWr@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 11:20:18 +0800 Hangbin Liu wrote:
> When checking the NLMSG_DONE message in kernel, I saw lot of functions would
> set NLM_F_MULTI flag. e.g. netlink_dump_done(),
> devlink_dpipe_{tables, entries, headers}_fill().
> 
> But from rfc3549[1]:
> 
>    [...] For multipart
>    messages, the first and all following headers have the NLM_F_MULTI
>    Netlink header flag set, except for the last header which has the
>    Netlink header type NLMSG_DONE.
> 
> What I understand is the last nlmsghdr(NLMSG_DONE message) doesn't need to
> have NLM_F_MULTI flag. Am I missing something?
> 
> [1] https://www.rfc-editor.org/rfc/rfc3549.html#section-2.3.2

Looks like you're right, we seem to fairly consistently set it.
Yet another thing in Netlink we defined and then used differently?
In practice it likely does not matter, I'd think.
