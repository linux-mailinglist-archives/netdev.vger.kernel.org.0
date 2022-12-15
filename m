Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35F664E1AB
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLOTRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiLOTRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:17:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777C9396E2
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:17:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4513CE1D07
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BBEC433EF;
        Thu, 15 Dec 2022 19:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671131824;
        bh=lNmx30OCnB4BrkwKxPxDB6YwN8B5VZyYS/06Gb1GlhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MNl5HUGR/qT4KmzCsmSr9bvKJmF2WVn3nlcGFj5wwMwx/Ido48JwCnRMZj2eczgUe
         dsXnQA6evSgqg6YPcBfxJbJBECi9YwUgOAP+webm6atxk5wsZJcC79A0qHZVzFdRw6
         LfNBPZvLjnKuqvMqKbNPDaVFd4WAR925PoomCp6WOtyDG45ZE9J3fIEYqdwIhKP3T1
         EXjhDEfHnxaaR2FAe1JrCva0A8bhhG1QLGcKlHZNN8c8+pdf6i38tu/4quOJyt7Si5
         eOkf6BhriKlf4wt3g4Gsdnv9tVTdndpdVxpeF04yLfrX9c79sQFnyqOhqA0jw3Q/hj
         zpYrs61Ae5nqQ==
Date:   Thu, 15 Dec 2022 11:17:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 04/15] devlink: protect devlink dump by the
 instance lock
Message-ID: <20221215111702.261de0d9@kernel.org>
In-Reply-To: <Y5rd8xTN/2Loy8OR@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-5-kuba@kernel.org>
        <Y5rd8xTN/2Loy8OR@nanopsycho>
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

On Thu, 15 Dec 2022 09:42:27 +0100 Jiri Pirko wrote:
> Thu, Dec 15, 2022 at 03:01:44AM CET, kuba@kernel.org wrote:
> >Take the instance lock around devlink_nl_fill() when the dumping.
> >We are only dumping basic info so in the worst case we were only
> >risking data races until now.
> 
> Should this be a separate patch targeted to -net with proper "fixes"
> instead?

Will do, if nothing else it will make the series smaller :)
But TBH I could not spot any issue other than perhaps non-atomic 
dump of the reload stats, but that's meh..
