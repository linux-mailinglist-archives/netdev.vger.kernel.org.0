Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7706F6CCDEF
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjC1XQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjC1XQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16B72683;
        Tue, 28 Mar 2023 16:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29F29B81CC9;
        Tue, 28 Mar 2023 23:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83939C433D2;
        Tue, 28 Mar 2023 23:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680045403;
        bh=dr/aVS9Be55zvJpTsMjeCdwrQeiI1QFH6vPkt8vuTvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pzs3GpvfhGTKR0xo3I7NciiFyh7+WvAVLl5PGMvJITmwt41luFKf2SsiIpmRXUIvw
         nOSK9sJMllpz8yd6i0NXERZW1H6QzrP9A45OkvSapoeJYxQkAK4LTHdBSdGJ/owvSb
         BujTfG4niP+DLxl227cW+eFjB1vWgGmrC5bWJEkyAq6uLnUf9un70J6ivXnVYsrLYE
         NwNw9oHmO7AFSme6LFvjfoyXjnLSt1UrHvvmU5HZqLvRlPv6ZWueEdjjiL89VaNrQB
         LpBbxxchLrRo3NeCpeZOwlFlvsmPC9hD/FPP57qJ1T74pmhzikhbtlfw2tL5xspyDj
         ougT6MLOuUeXw==
Date:   Tue, 28 Mar 2023 16:16:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/core: add optional threading for
 backlog processing
Message-ID: <20230328161642.3d2f101c@kernel.org>
In-Reply-To: <20230328195925.94495-1-nbd@nbd.name>
References: <20230328195925.94495-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 21:59:25 +0200 Felix Fietkau wrote:
> When dealing with few flows or an imbalance on CPU utilization, static RPS
> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
> for backlog processing in order to allow the scheduler to better balance
> processing. This helps better spread the load across idle CPUs.

Can you share some numbers vs a system where RPS only spreads to 
the cores which are not running NAPI?

IMHO you're putting a lot of faith in the scheduler and you need 
to show that it actually does what you say it will do.
