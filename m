Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6EC647B01
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLIAyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLIAyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:54:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B093B9B7BE;
        Thu,  8 Dec 2022 16:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B9C0B82635;
        Fri,  9 Dec 2022 00:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC28C433EF;
        Fri,  9 Dec 2022 00:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670547257;
        bh=y3hhIU5Rl3GF6VDoLuNFVW7bzD/EbLLFLA4hegv1nPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bPTyVZO/YzaxuP1SqU+mBoSkjRyId0bPT/Mxkovi+3AXO8tRaYXtzMbXd/eaJUqG3
         2n3HSc14YAZ+7vOsKTGeRB2aeLaoi1Fi3Q3/XVI7NYpnWw+yPjGvIeGQ40dzzM060K
         h9mMxDWF/VtV0m1uIO3eoBQznvQwngNF4+csNI5Y1OOv1nekEJkj9d0BMkM1SVAgyp
         bUYEBZJp3IYACzeE/gmcAfpm72WnUwiuH30AbFuaBsEWJpx1cg9z3aOd/0M01HehHr
         5cjjCGHqVexlGbgrb8BeHuMPajcEbzBFLd016bd3n1NO+UhB4hqTqPBb70FwN04zU2
         Rj7tTz+t/z9lA==
Date:   Thu, 8 Dec 2022 16:54:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <20221208165415.583f38b5@kernel.org>
In-Reply-To: <Y5HSQU1aCGpOZLiJ@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>
        <20221206184740.28cb7627@kernel.org>
        <Y5CofhLCykjsFie6@nanopsycho>
        <20221207091946.3115742f@kernel.org>
        <Y5HSQU1aCGpOZLiJ@nanopsycho>
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

On Thu, 8 Dec 2022 13:02:09 +0100 Jiri Pirko wrote:
> Wed, Dec 07, 2022 at 06:19:46PM CET, kuba@kernel.org wrote:
> >On Wed, 7 Dec 2022 15:51:42 +0100 Jiri Pirko wrote:  
> >> Really, even in case only one driver actually consumes the complexicity?
> >> I understand having a "libs" to do common functionality for drivers,
> >> even in case there is one. But this case, I don't see any benefit.  
> >
> >In the same email thread you admit that mlx5 has multiple devlink
> >instances for the same ASIC and refuse to try to prevent similar
> >situation happening in the new subsystem.  
> 
> I don't understand your point. In CX there is 1 clock for 2 pci PFs. I
> plan to have 1 dpll instance for the clock shared.
> 
> But how is what you write relevant to the discussion? We are talking
> about:
> a) 1 pin in 2 dpll instances
> what I undestand you say here is to prevent:
> b) 2 dpll instances for 1 clock
> apples and oranges. Am I missing something?
> 
> I'm totally against b) but that is not what we discuss here, correct?

Correct, neither (a), nor (b), and as much code for "find other PFs
referring to this device on the board" moved into the core as possible.

AFAIU (and if I'm reading the docs Maciek linked) in case of Intel
there are actually multiple DPLL instances in a single package / Si die.
I presume we want those to be a separate DPLL instance each?
But being part of a single die they share pins.. 
