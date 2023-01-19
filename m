Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D016674B91
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjATFCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjATFBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:01:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF92BF89B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:49:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDFF3B8266A
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 17:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F387C433EF;
        Thu, 19 Jan 2023 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674147617;
        bh=WvPEYRJYZm7B+bD+sQgZKiuqSYjBBZE17XK3wUDJ2NM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aDg2cWQYFD+ZgF9LGmicU2mvHjEulBkAXVSozMCs0H1fAt37H1+S9Y34ntLGpRIyB
         KinSHEJat4LVopVDoSF6QZQYrMhcYwItsU2fKZjFzl9T30IBxXi9VqtR/DuM5mNdps
         2L+dQvovSG6SYk6xV7yYPWAwY5uGymYGP2W0y56ltlKLPmZF0NH2jTJgWb11Aqg+pa
         Oc5jdDWrgFbB10YdxIVJUkP1tIL/RIs7JL15r03bDn4WCPOmk8yRPoVabOlEqckIsS
         MMmqRaAoICJWUj5gzwuUcG0BkEY8OKq7BcU1Rmrq2V6S4Y/vuzLjD1q1SU+rH+h52I
         EZr9pMGfJOOQg==
Date:   Thu, 19 Jan 2023 09:00:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Frantisek Krenzelok <fkrenzel@redhat.com>,
        Gal Pressman <gal@nvidia.com>,
        Apoorv Kothari <apoorvko@amazon.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230119090016.381eb61b@kernel.org>
In-Reply-To: <Y8lkd2Im7y8BXtDe@hog>
References: <cover.1673952268.git.sd@queasysnail.net>
        <20230117180351.1cf46cb3@kernel.org>
        <Y8fEodSWeJZyp+Sh@hog>
        <20230118185522.44c75f73@kernel.org>
        <Y8lkd2Im7y8BXtDe@hog>
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

On Thu, 19 Jan 2023 16:40:39 +0100 Sabrina Dubroca wrote:
> > > IIRC support for KeyUpdates is mandatory in TLS1.3, so currently the
> > > kernel can't claim to support 1.3, independent of offloading.  
> > 
> > The problem is that we will not be able to rekey offloaded connections.
> > For Tx it's a non-trivial problem given the current architecture.
> > The offload is supposed to be transparent, we can't fail the rekey just
> > because the TLS gotten offloaded.  
> 
> What's their plan when the peer sends a KeyUpdate request then? Let
> the connection break?

I believe so, yes, just open a new connection. TLS rekeying seems 
to be extremely rare.

You mentioned nbd as a potential use case for kernel SW implementation.
Can nbd rekey? Is use space responding to control messages in case of
nbd?
