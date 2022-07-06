Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C645692E8
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiGFT4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiGFT4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:56:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4613117E24
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 12:56:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D53E0620B1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 19:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5BEC3411C;
        Wed,  6 Jul 2022 19:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657137378;
        bh=0fyEUVor9dO2HPEGGCC7hXjZqMg2WfR3LkxSUNyYur8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lHq1LTug6i26pZYIUuLJC5s0YUA2szrbRGXkji7byMH3swgFPC9uQh2jCXPlNHQms
         AzPuqo4If9SjnCA/NXu9Sc3pKa+KZEDw804xprxsFjU7AK3qGXANmnZpx6QA77EiS5
         Fs9kV8NDyGRE06jFWRaegXgAIOey+6T2hUXWiESBJ35rtxoi9sbaRlM4gDnypQfbcm
         K1jF+zildC9tV8IkoS2FWgGjrB5JoP5D9jWHP7vTR4YQZmHE6Ji6gU0z3t8P/lIViP
         kiKmM546kWA1Q9zZGiK/f4OQnibgFqXYSkEJAXVNknHGnvX0k5Y72mb2m7Xo2tp1cZ
         V+eNZktcD5umw==
Date:   Wed, 6 Jul 2022 12:56:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     <netdev@vger.kernel.org>, Dima Chumak <dchumak@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        "Knitter, Konrad" <konrad.knitter@intel.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [RFC] ice: Reconfigure tx scheduling for SR-IOV
Message-ID: <20220706125616.0a853dfc@kernel.org>
In-Reply-To: <ec6bfee4-cf0f-c5c1-a7b3-726d7e3c6d33@intel.com>
References: <20220704114513.2958937-1-michal.wilczynski@intel.com>
        <20220705151505.7a4757ae@kernel.org>
        <ec6bfee4-cf0f-c5c1-a7b3-726d7e3c6d33@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reminder: please don't top post on the Linux lists.

On Wed, 6 Jul 2022 12:54:12 +0200 Wilczynski, Michal wrote:
> Hi,
> 
> Thank you for your e-mail.
> 
> I considered using devlink-rate, and it seems like a good fit. However 
> we would also
> 
> need support for rate-limiting for individual queues on the VF. 
> Currently we have
> 
> two types of rate objects in devlink-rate: leaf and node. Would adding a 
> third one - queue be accepted ?

Something along those lines. IIUC htb offload as admission control for
VF representors is not a thing today, so since devlink rate exists the
lowest amount of duplication would be teaching it about queues.

> Also we might want to add some other object rate parameters to currently 
> existing ones, for example 'priority'.

Presumably you can't admission control at a granularity higher than 
a queue, so grouping queues should cover all use cases.

> If this sounds acceptable I will work on the patch and submit it as 
> soon, as it's ready.

I'd be curious to hear from nVidia and Corigine folks as well.

We can revive the switchdev call if talking over VC helps with
the alignment between vendors.
