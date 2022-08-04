Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4740C58A0AB
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbiHDSns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiHDSnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:43:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8522F61DBE
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DBB0B826F9
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 18:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71BDC433C1;
        Thu,  4 Aug 2022 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659638623;
        bh=kcgJznBeo5iCvIoz1VKe/pLBB2++FSE7cCNqEoz7MxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lrTTQUlTCdfyCvua4NWTd57uGptWzZXesPhFLM3wzJ8atQ54BCM/zD3DluIJB1LdJ
         4/OEJKMZA8KF1qqbyB0g8dJjEZwrFFiMM8y2DVp+tlOO5Ik9/Ff8rTa2U1v4Fk/sKL
         3zS5mwPQzOKSQgu6lFLY6yBNTQ9K/7XykWcQbLoJcbyQbWwuL6tKl6kS0NAfICq/pH
         EAWLKsHzQQaKLxB0N9sVQgzetf6Cn5oiplQ5JNnLPk8VaMkjki1Bo1JHUZFzO/2koe
         r8Dbpo9zMxxeW8Dkafg6Sj0johIdtuLgNL9LfnxFsxlkmBiJlAnbIsaZ2yf/gQiR6Z
         n8zXQlcHaLnsQ==
Date:   Thu, 4 Aug 2022 11:43:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
Message-ID: <20220804114342.71d2cff0@kernel.org>
In-Reply-To: <20220804174307.448527-2-prestwoj@gmail.com>
References: <20220804174307.448527-1-prestwoj@gmail.com>
        <20220804174307.448527-2-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Aug 2022 10:43:07 -0700 James Prestwood wrote:
> By exposing IFF_LIVE_ADDR_CHANGE to userspace it at least gives an
> indication that we can successfully randomize the address and
> connect. In the worst case address randomization can be avoided
> ahead of time. A secondary win is also time, since userspace can
> avoid a power down unless its required which saves some time.

It's not a generic thing tho, it's most of an implicit argument 
to eth_mac_addr(). Not all netdevs are Ethernet.

The semantics in wireless are also a little stretched because normally
if the flag is not set the netdev will _refuse_ (-EBUSY) to change the
address while running, not do some crazy fw reset.

Perhaps we should wait for Johannes to return form vacation but my
immediate reaction would be to add a knob (in wireless?) that controls
whether the reset dance is allowed.
