Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9144B4D5536
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344619AbiCJXVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344546AbiCJXVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:21:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42AC1390D1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4889A61CDD
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBA7C340E8;
        Thu, 10 Mar 2022 23:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646954441;
        bh=xgIE4+0bBxpVUXnm0wSuFJrKz1iu78zxsXWHePfAX0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h+bN95XzhDzN/ln3LCf5WYcAQsiw9MtHdMeJ1Ur7DM7JIKs8Kcu/TjMynx9UQOqmR
         JKovz0LxBhsSdRPdorqNSsy3jOPPDj04iBqAgcBIEYKMUNkH8eAi7B/Dl5t3IdAc1Y
         yePw85Weowc6SiHdc8YMHNSXLfcQNXy2XPqnf8hy87QTcP/EnrCcKHHRYR5sCMSlQP
         m5lJedMz/JsyLlir30WggKElhvbLzG45n/8oFG3fKsGFOuen6feJYgOQHxyI/HemEA
         4HjVX+IT6w3/xCRAztsHENPGVWoqA/mAzNabFeWdNjg7nDbPkVSnmLdWnxnS8GdaLH
         mNNKOTp5oo7HQ==
Date:   Thu, 10 Mar 2022 15:20:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] alx: acquire mutex for alx_reinit in alx_change_mtu
Message-ID: <20220310152040.0389f6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <14cf7c22-622b-d5e2-0eb1-076d92db56a2@gmail.com>
References: <20220310161313.43595-1-dossche.niels@gmail.com>
        <20220310150500.38ae567c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <14cf7c22-622b-d5e2-0eb1-076d92db56a2@gmail.com>
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

On Fri, 11 Mar 2022 00:14:55 +0100 Niels Dossche wrote:
> On 11/03/2022 00:05, Jakub Kicinski wrote:
> > On Thu, 10 Mar 2022 17:13:16 +0100 Niels Dossche wrote:  
> >> alx_reinit has a lockdep assertion that the alx->mtx mutex must be held.
> >> alx_reinit is called from two places: alx_reset and alx_change_mtu.
> >> alx_reset does acquire alx->mtx before calling alx_reinit.
> >> alx_change_mtu does not acquire this mutex, nor do its callers or any
> >> path towards alx_change_mtu.
> >> Acquire the mutex in alx_change_mtu.
> >>
> >> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>  
> > 
> > What's the Fixes tag?  
> 
> Commit 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
> introduced fine-grained locking and introduced the assertion.
> I can resend the patch with the Fixes tag if you want me to.

If you don't mind resend would be helpful, thanks!
