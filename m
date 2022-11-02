Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E64615ABE
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKBDkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiKBDkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:40:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557CF26AC1;
        Tue,  1 Nov 2022 20:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D74796172F;
        Wed,  2 Nov 2022 03:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF521C433D7;
        Wed,  2 Nov 2022 03:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667360408;
        bh=YvIE6halxY+/sZPI1kuhiNcmZGBmKfv091gJ/Usx2HU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dECRwqqCEG/Ct8DxQAtr8C782XsNfmXDEDV81c7jZKYHL8WkVDivFge03dx1WFqYt
         3hddwowmUhVE6gknEMzNvvrV/wsz7JrN/ozMeEGjaaXPWIOWIRxp/9h1MoLIOiQwMK
         m0UZXjj7iZf3lHXapvRo4IscVwD5GGkerF9tXaUcG2hsHqrP6COh96FjjIeZ4htbmF
         mFB4YySnu96McpPBejZ3mdmdv/jEG+W6tPmK+BTEau0MTtdnms9iVycaeqUqzdkPd/
         o6R0GM1r1Aiww/bDz31IF28c5O+5WQA6FehCguOjobRPpTDlLwwpKqIIcU0ZqSxyhr
         9dYRFoLcyoG/A==
Date:   Tue, 1 Nov 2022 20:40:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Andy Ren <andy.ren@getcruise.com>, netdev@vger.kernel.org,
        richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, pabeni@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev
Subject: Re: [PATCH net-next v2] netconsole: Enable live renaming for
 network interfaces used by netconsole
Message-ID: <20221101204006.75b46660@kernel.org>
In-Reply-To: <Y2G+SYXyZAB/r3X0@lunn.ch>
References: <20221102002420.2613004-1-andy.ren@getcruise.com>
        <Y2G+SYXyZAB/r3X0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 01:48:09 +0100 Andrew Lunn wrote:
> Changing the interface name while running is probably not an
> issue. There are a few drivers which report the name to the firmware,
> presumably for logging, and phoning home, but it should not otherwise
> affect the hardware.

Agreed. BTW I wonder if we really want to introduce a netconsole
specific uAPI for this or go ahead with something more general.
A sysctl for global "allow UP rename"?

We added the live renaming for failover a while back and there were 
no reports of user space breaking as far as I know. So perhaps nobody
actually cares and we should allow renaming all interfaces while UP?
For backwards compat we can add a sysctl as mentioned or a rtnetlink 
"I know what I'm doing" flag? 

Maybe print an info message into the logs for a few releases to aid
debug?

IOW either there is a reason we don't allow rename while up, and
netconsole being bound to an interface is immaterial. Or there is 
no reason and we should allow all.
