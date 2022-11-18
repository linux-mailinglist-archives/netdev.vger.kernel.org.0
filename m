Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BD362EC9B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240808AbiKREAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240776AbiKREAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:00:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5911F91C16
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:00:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E856562302
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AD8C433C1;
        Fri, 18 Nov 2022 04:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668744047;
        bh=pl3ZxS2fntKcxzLS7DT35Q6kBB3WcBJWEa43CA4s1uQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AW2nyf3gN9zs86KPE/2NGoIXRUAT+pt+VZ4jOfFh6UjoVuhgFYXvcsvhJjkMf+gXX
         N+RhGg/X5zfTZuQdxOmCjWYu1xc0d/65iPPqTDrOgJfwLnkXDhSPNFdHooW1LLXaiw
         XodpoE04ipE7yAYvyQcGLxLoK1NLXFvAtKwFzmc1Qf6o9FFBseOQ1CZ8xhEIAKRm1y
         ia+EiOb1JfXYUDXFmdXgYEEfQkFT46+MMGq9nHQNP0G1G5P2Pw0KNeoA/Aefp1uyEM
         HadmJzdoykmfFbr4Eb5XH96nxo8V1PZ1zKn4/p46waqDYkPxwmtWQc+e8gFBCVG7hc
         H9pIob/CLGffg==
Date:   Thu, 17 Nov 2022 20:00:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sandlan: Add the sandlan virtual network
 interface
Message-ID: <20221117200046.0533b138@kernel.org>
In-Reply-To: <20221116222429.7466-1-steve.williams@getcruise.com>
References: <20221116222429.7466-1-steve.williams@getcruise.com>
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

On Wed, 16 Nov 2022 14:24:29 -0800 Steve Williams wrote:
> This is a virtual driver that is useful for testing network protocols
> or other complex networking without real ethernet hardware. Arbitrarily
> complex networks can be created and simulated by creating virtual network
> devices and assigning them to named broadcast domains, and all the usual
> ethernet-aware tools can operate on that network.
> 
> This is different from e.g. the tun/tap device driver in that it is not
> point-to-point. Virtual lans can be created that support broadcast,
> multicast, and unicast traffic. The sandlan nics are not tied to a
> process, but are instead persistent, have a mac address, can be queried
> by iproute2 tools, etc., as if they are physical ethernet devices. This
> provides a platform where, combined with netns support, distributed
> systems can be emulated. These nics can also be opened in raw mode, or
> even bound to other drivers that expect ethernet devices (vlans, etc),
> as a way to test and develop ethernet based network protocols.
> 
> A sandlan lan is not a tunnel. Packets are dispatched from a source
> nic to destination nics as would be done on a physical lan. If you
> want to create a nic to tunnel into an emulation, or to wrap packets
> up and forward them elsewhere, then you don't want sandlan, you want
> to use tun/tap or other tunneling support.

As a general rule we don't accept any test/emulation code upstream
unless it comes with some tests that actually use it.
We have had bad experience with people adding virtual interfaces and
features which then bit rot or become static checker fodder and we
don't know whether anyone is actually using them and how.

Is there something here that you can't achieve with appropriately
combined veths?
