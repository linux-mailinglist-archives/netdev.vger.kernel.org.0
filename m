Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111A8624E6B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiKJXYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiKJXYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:24:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3994AF09
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oEqIEKohBxfCq0VgwF5DAeOVZyKbg41yW2Xhn9rk/PQ=; b=BZFLNdb/s+15OyAKhsmjMneXO+
        ptsw7648G6aJqA3Ei4wj+CPv0+LY9k3Q9Pd7IwILdWBQcY3gTlQyVcBOecpgj0HcuhSIeeOeJ3AMj
        Cb8qsUxcYBP5kq4e21KGz2ew4slYG2zl0oZMfdhrv2J43VqUkJ3QD9OpN7oErZW4uS8Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otGto-0024n4-L6; Fri, 11 Nov 2022 00:23:56 +0100
Date:   Fri, 11 Nov 2022 00:23:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     John Ousterhout <ouster@cs.stanford.edu>, netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <Y22IDLhefwvjRnGX@lunn.ch>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110132540.44c9463c@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 01:25:40PM -0800, Stephen Hemminger wrote:
> On Thu, 10 Nov 2022 11:42:35 -0800
> John Ousterhout <ouster@cs.stanford.edu> wrote:
> 
> > Several people at the netdev conference asked me if I was working to
> > upstream the Homa transport protocol into the kernel. I have assumed
> > that this is premature, given that there is not yet significant usage of
> > Homa, but they encouraged me to start a discussion about upstreaming
> > with the netdev community.
> > 
> > So, I'm sending this message to ask for advice about (a) what state
> > Homa needs to reach before it would be appropriate to upstream it,
> > and, (b) if/when that time is reached, what is the right way to go about it.
> > Homa currently has about 13K lines of code, which I assume is far too
> > large for a single patch set; at the same time, it's hard to envision a
> > manageable first patch set with enough functionality to be useful by itself.
> > 
> > -John-

Hi John

> The usual upstream problem areas are:
>  - coding style

You can get a good feeling about what sort of coding style review
comments you will get by running ./scripts/checkpatch.pl over your
files. You don't need to be completely checkpatch clean, it does get
things wrong sometimes.

Adding to Stephens list.

- You have reinvented something which the kernel already has. You need
  to throw away your version and use the kernel version.

- You have used deprecated things, like /proc, ioctls rather than
  netlink.

- 32 bit kernel problems. Since this is about data center, your code
  might make assumptions about running on a 64 bit machine. Statistics
  tend to be done wrong, unless you are using the correct kernel
  helpers to deal with 64 bit counters on 32 bit machines.

Andrew
