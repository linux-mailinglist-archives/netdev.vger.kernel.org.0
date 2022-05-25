Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61716534569
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 22:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344075AbiEYU57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 16:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiEYU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 16:57:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60B7A0D04;
        Wed, 25 May 2022 13:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/JLR/8lAKxQhIS1LV8N9wRlA5QhOohZrfDX4jJsejTI=; b=IIQUHxMdfsA+EZZLgeyQBhxz7n
        KiB62pbh7elhZ0euF9OXTnkGrbGjT6Vp8USXHt3HSGZTltWccPCBOAh/OMKYXxKJNkFimCaQ5xMoX
        ergpPT2mgIyGPVNyO5z4+VBiNYrBq7NW+rouz7+7vKGn0Sa4sxZYCR12TSf+pU/hGgXg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nty4m-004HNs-DF; Wed, 25 May 2022 22:57:52 +0200
Date:   Wed, 25 May 2022 22:57:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org, tytso@mit.edu
Subject: Re: RFC: Ioctl v2
Message-ID: <Yo6YUHi7NcZAAKg4@lunn.ch>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
 <Yof6hsC1hLiYITdh@lunn.ch>
 <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
 <20220521124559.69414fec@hermes.local>
 <20220525170233.2yxb5pm75dehrjuj@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525170233.2yxb5pm75dehrjuj@moria.home.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Actually, I have one in bcachefs that might fit better into the netlink bucket -
> maybe while I've got your attention you could tell me what this is like in
> netlink land.
> 
> In bcachefs, we have "data jobs", where userspace asks us to do something that
> requires walking data and performing some operation on them - this is used for
> manual rebalance, evacuating data off a device, scrub (when that gets
> implemented), etc.
> 
> The way I did this was with an ioctl that takes as a parameter the job to
> perform, then it kicks off a kernel thread to do the work and returns a file
> descriptor, which userspace reads from to find out the current status of the job
> (which it uses to implement a progress indicator). We kill off the kthread if
> the file descriptor is closed, meaning ctrl-c works as expected.
> 
> I really like how this turned out, it's not much code and super slick - I was
> considering abstracting it out as generic functionality. But this definitely
> sounds like what netlink is targeted at - thoughts?

What is tricky with networking, is that it has a Big Lock, the
RTNL. All ioctl and netlink operations are performed while holding
this lock. So you cannot do an operation which takes a while.

But i implemented something similar to what you want a couple of years
ago. Ethernet cable testing. It is split into a couple of netlink
messages. There is one to initiate the cable test, and you can pass
some parameters. If the Ethernet PHY supports it, you get back an
immediate ACK, or an error messages, with probably -EOPNOTSUP, or
-EINVAL. This is all done with the RTNL held, the lock being released
after the reply.

The PHY then actually starts doing the cable test. I can take from a
couple of seconds, to 10-20 seconds, depending on exactly how it is
implemented, how fast the PHY is etc.

Once the PHY has finished, it broadcasts a report of the cable test to
userspace. Any process can receive this. So the invoking ethtool
--cable-test eth42 process waits around for it and dumps the test
results.

broadcasting messages is a big part of netlink. 'ip monitor' will
receive all these broadcasts and decode them. So you get to see routes
added/remove, ARP resolutions, interfaces going up and down. etc.

Your ctrl-c handling does not exist, as far as i know. With cable
testing, it runs to completion and makes the report. It could be there
is nobody listening. At least for some PHYs you cannot abort a cable
test once started, so ctrl-c might not even make sense.

There is a video of my LPC talk online somewhere. But 1/2 of it is
physics, how cable testing actually works. There is some details of
the netlink part and how the PHY state machine works.

    Andrew



