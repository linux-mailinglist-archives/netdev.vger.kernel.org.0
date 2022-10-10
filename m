Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DC85FA682
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 22:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJJUpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 16:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiJJUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 16:45:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA15071725;
        Mon, 10 Oct 2022 13:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WP+arezwzMwyESZqd4qvfOCY4eJDFC1RVVzNAdf/5TU=; b=3tOiE0txA95i+s3xZI0nMRB6ke
        FHWdPTXdqr6FshaW/lfrE8WM2Gubtyd8Odyyjy3m1MB4Djth5g/t7rvz8hS1qrgKe1w74Njarx8dF
        KyPHBYkLLCjlvEXJ2OUptpwVmw3OZ2oQsIHSBljJf8hyeFXmQieBNvrI+opj0a5scVHI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ohzen-001ehQ-G5; Mon, 10 Oct 2022 22:45:49 +0200
Date:   Mon, 10 Oct 2022 22:45:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/1] mac_pton: Don't access memory over expected length
Message-ID: <Y0SEfZi9oewmefGK@lunn.ch>
References: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
 <Y0R+ZU6kdbeUER1c@lunn.ch>
 <Y0SAsQoD0/5oDlGX@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0SAsQoD0/5oDlGX@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 11:29:37PM +0300, Andy Shevchenko wrote:
> On Mon, Oct 10, 2022 at 10:19:49PM +0200, Andrew Lunn wrote:
> > On Wed, Oct 05, 2022 at 07:43:01PM +0300, Andy Shevchenko wrote:
> > > The strlen() may go too far when estimating the length of
> > > the given string. In some cases it may go over the boundary
> > > and crash the system which is the case according to the commit
> > > 13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").
> > > 
> > > Rectify this by switching to strnlen() for the expected
> > > maximum length of the string.
> > 
> > This seems like something which should have a fixes: tag, and be
> > against net, not net-next.
> 
> I can (re-)send it that way. Just need a consensus by net maintainers.

I would probably do:

	if (strnlen(s, maxlen) != maxlen)
 		return false;

I doubt anybody is removing leading zeros in MAC addresses.

  Andrew
