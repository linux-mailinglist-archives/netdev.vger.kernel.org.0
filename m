Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D250C67CBF5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbjAZNXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbjAZNXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:23:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38192B0BF;
        Thu, 26 Jan 2023 05:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SbkeWeEgW1bNMqYbZ1eBy6sGiKmDUdecQALPl+6OB9U=; b=Pub10WGq94Ss3tqKj+w/kDQomL
        mJ9yUJ8gSAYOOAIwvXheRuBBpNv2LQWfkKvircaB9Od6RC5TGUobaRU7Qxcbbs7YmRYD+afR9KCX9
        u3IyafhcGpB8p0Fv9aemss+P3J2m2RGv7anqpvIrA6QeSGBjEa8mqUWgLueZqwsG4VSs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pL2DO-003Eyd-Sx; Thu, 26 Jan 2023 14:22:54 +0100
Date:   Thu, 26 Jan 2023 14:22:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Breno Leitao' <leitao@debian.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leit@fb.com" <leit@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael van der Westhuizen <rmikey@meta.com>
Subject: Re: [PATCH v3] netpoll: Remove 4s sleep during carrier detection
Message-ID: <Y9J+rhRFxbLIWgQv@lunn.ch>
References: <20230125185230.3574681-1-leitao@debian.org>
 <6d13242627e84bde8129e75b6324d905@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d13242627e84bde8129e75b6324d905@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 09:04:42AM +0000, David Laight wrote:
> From: Breno Leitao
> > Sent: 25 January 2023 18:53
> > This patch removes the msleep(4s) during netpoll_setup() if the carrier
> > appears instantly.
> > 
> > Here are some scenarios where this workaround is counter-productive in
> > modern ages:
> > 
> > Servers which have BMC communicating over NC-SI via the same NIC as gets
> > used for netconsole. BMC will keep the PHY up, hence the carrier
> > appearing instantly.
> > 
> > The link is fibre, SERDES getting sync could happen within 0.1Hz, and
> > the carrier also appears instantly.
> > 
> > Other than that, if a driver is reporting instant carrier and then
> > losing it, this is probably a driver bug.
> 
> I can't help feeling that this will break something.
> The 4 second delay does look counter productive though.
> Obvious alternatives are 'wait a bit before the first check'
> and 'require carrier to be present for a few checks'.

I'm guessing, but i think the issue is that the MAC reports the
carrier is up, even though autoneg has not completed, and so packets
are getting dropped. Autoneg takes around 1.5 seconds, so you need to
wait this long before starting to send to prevent packets landing in
the bit bucket. And i guess polling as you suggests does not help,
since it never returns the true status.

But this is pure guesswork. Maybe some mailing list archaeology can
help explain this code.

I guess the likely breaking scenario is that simply the first 1.5
seconds of the kernel log goes to the bit bucket for broken
MACs. Which is not fatal, just annoying for somebody trying to debug a
crash in the first few seconds. I suppose dhcp might also take longer
for broken MACs, since its first requests also get lost, and it might
get into exponential back off.

I guess the risks are small here. But i use the word guess a lot...

  Andrew
