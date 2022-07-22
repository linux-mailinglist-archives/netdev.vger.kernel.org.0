Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B676E57E6B2
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbiGVSjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbiGVSjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:39:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C7A6F8E
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:39:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFEA960EDC
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 18:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2A6C341C6;
        Fri, 22 Jul 2022 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658515190;
        bh=AvBFXHrwVIkTuc1Uv6TUREvG4PuZQr7CVQ7hzeH2hI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UiBe5CMq3alYM5a9GxHyadggj0hHVbgouF4VDF0BwijV+7/Q9uv2EhKGtSVR8gkEl
         8ZBPRDUKjrX0lY1cA91v7NEeFIa4bNCXsAvL94EmizM2gilVf32sQBXOEqIafAOrUz
         G/llIeK6qbZmYbECOWsHC/xpxEI2MiMAw6vHCssNOcre+vL7GSmVDTN0QpOWTvFimQ
         sFaU02AFD31jt555RfCAeOTaazUJ+10ny0MMkSNMbdt/rcWQxwCGfZjQJLgL8s+J+r
         c7nCtOCPHJpVDwJXwq0wVQe/QAzl5LA0Zxl5jYTIE4pdq3tqYg5oNTfh7b2+6oBhY7
         vsqIj58jviZRA==
Date:   Fri, 22 Jul 2022 11:39:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Subject: Re: [PATCH net-next v2 5/7] tcp: allow tls to decrypt directly from
 the tcp rcv queue
Message-ID: <20220722113948.010ff284@kernel.org>
In-Reply-To: <9daa8e1cfa2da8662579290281bd4171e72c1917.camel@redhat.com>
References: <20220719231129.1870776-1-kuba@kernel.org>
        <20220719231129.1870776-6-kuba@kernel.org>
        <084d3496bfb35de821d2ba42a22fd43ff6087921.camel@redhat.com>
        <20220721103538.583907c0@kernel.org>
        <9daa8e1cfa2da8662579290281bd4171e72c1917.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 10:00:44 +0200 Paolo Abeni wrote:
> I'm personally fine either way, and the new helper looks small enough,
> so whatever is easier to you.
> 
> Unrealted to this series, I'm wondering if it would makes sense
> reworking tcp_read_sock() API to avoid the indirect call? 

Perhaps those who care and don't drop the lock could move to the API
I'm adding? Not sure what the major use cases for tcp_read_sock() are.
