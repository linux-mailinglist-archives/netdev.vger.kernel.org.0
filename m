Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DCB53C354
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiFCCrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 22:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiFCCro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 22:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E37117054;
        Thu,  2 Jun 2022 19:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A4B161653;
        Fri,  3 Jun 2022 02:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9FEC385A5;
        Fri,  3 Jun 2022 02:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654224462;
        bh=QpU53RoJdAdCnP8jdYOtc2Hs4xhTtWtlmS+OW4nJ7R0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J1xZfil0Hbqojp2D/PUUnQCSTrqhMcJnUNscIDLPT5ctZn+JCQLaXonE7ZssC12cj
         jWq5BiNys05aMpJKvhucLZiJjrj3IPwzZHF5G8rdby1mWQbHT0bqnbfAzD8yKcOTT7
         3m1HXVnD9iovCMHzJPA7x1syBUAv/+MKWaFhgmff/CoUXhPdueVtrAjyi8hq+C/+do
         xibiTPAlkY1RM17MkkS+r0hkSkxiYHEyl9TVQ1zxjpznT1sA6qPLAlYO9bS5yHVK5A
         jRYNCeaxKsRZADWI2btMVsNKIYOFNWInSBWbXdQg4BSUgDI6i35jJ6VinhqIj05ssi
         TwZRpgJ228QFQ==
Date:   Thu, 2 Jun 2022 19:47:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Lafreniere <pjlafren@mtu.edu>
Cc:     linux-hams@vger.kernel.org, ralf@linux-mips.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ax25: use GFP_KERNEL over GFP_ATOMIC where possible
Message-ID: <20220602194741.6bba0611@kernel.org>
In-Reply-To: <20220602112138.8200-1-pjlafren@mtu.edu>
References: <20220602112138.8200-1-pjlafren@mtu.edu>
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

On Thu,  2 Jun 2022 07:21:38 -0400 Peter Lafreniere wrote:
> There are a few functions that can sleep that use GFP_ATOMIC.
> Here we change allocations to use the more reliable GFP_KERNEL
> flag.
> 
> ax25_dev_device_up() is only called during device setup, which is
> done in user context. In addition, ax25_dev_device_up()
> unconditionally calls ax25_register_dev_sysctl(), which already
> allocates with GFP_KERNEL.
> 
> ax25_rt_add() is a static function that is only called from
> ax25_rt_ioctl(), which must run in user context already due to
> copy_from_user() usage.
> 
> Since it is allowed to sleep in both of these functions, here we
> change the functions to use GFP_KERNEL to reduce unnecessary
> out-of-memory errors.
> 
> Signed-off-by: Peter Lafreniere <pjlafren@mtu.edu>

For merging into the Linux networking trees you'll have to repost next
week, this seems like an optimization and we're currently in the merge
window period where we only accept fixes.
