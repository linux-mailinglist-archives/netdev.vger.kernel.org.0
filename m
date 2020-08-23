Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B0424ECE8
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 12:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgHWK4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 06:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgHWK4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 06:56:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 130D92072D;
        Sun, 23 Aug 2020 10:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598180162;
        bh=4yd51JrmDIU9v+Uu6SenJKfbOo3beI55UZ1+lyBGMa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v/aPdIfAiaTcN17ybARTdRUaeD7Hd5J/SIBYkPBlSXaUP0egieEsu/OYYKZLS4tA+
         2Fz2FCNGu2cwIRqIpyfjeMXphy4vy+i6KDUPF8+huSX2XMC0NeoFplO97MSaEWdWdw
         kcIx2Jt3wxp9RDvWhg0qUl9QKI26gtne3FnlHOIk=
Date:   Sun, 23 Aug 2020 12:56:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_cmd()
Message-ID: <20200823105622.GA87391@kroah.com>
References: <20200823082042.20816-1-himadrispandya@gmail.com>
 <CACT4Y+Y1TpqYowNXj+OTcQwH-7T4n6PtPPa4gDWkV-np5KhKAQ@mail.gmail.com>
 <20200823101924.GA3078429@kroah.com>
 <CACT4Y+YbDODLRFn8M5QcY4CazhpeCaunJnP_udXtAs0rYoASSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YbDODLRFn8M5QcY4CazhpeCaunJnP_udXtAs0rYoASSg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 12:31:03PM +0200, Dmitry Vyukov wrote:
> On Sun, Aug 23, 2020 at 12:19 PM Greg Kroah-Hartman
> > It's not always a failure, some devices have protocols that are "I could
> > return up to a max X bytes but could be shorter" types of messages, so
> > it's up to the caller to check that they got what they really asked for.
> 
> Yes, that's why I said _separate_ helper function. There seems to be
> lots of callers that want exactly this -- "I want 4 bytes, anything
> else is an error". With the current API it's harder to do - you need
> additional checks, additional code, maybe even additional variables to
> store the required size. APIs should make correct code easy to write.

One note on this, will respond to the rest of the email later.

It should be the same exact amount of code in the driver to handle this
either way:

Today's correctly written driver:

	data_size = 4;
	data = kmalloc(data_size, GFP_KERNEL);
	...

	retval = usb_control_msg(....., data, data_size, ...);
	if (retval < buf_size) {
		/* SOMETHING WENT WRONG! */
	}

With your new function:

	data_size = 4;
	data = kmalloc(data_size, GFP_KERNEL);
	...

	retval = usb_control_msg_error_on_short(....., data, data_size, ...);
	if (retval < 0) {
		/* SOMETHING WENT WRONG! */
	}


Catch the difference, it's only in checking for retval, either way you
are writing the exact same logic in the driver, you still have to tell
the USB layer the size of the buffer you want to read into, still have
to pass in the buffer, and everything else.  You already know the size
of the data you want, and you already are doing the check, those things
you have to do no matter what, it's not extra work.

We can write a wrapper around usb_control_msg() for something like this
that does the transformation of a short read into an error, but really,
does that give us all that much here?

Yes, I want to make it easy to write correct drivers, and hard to get
things wrong, but in this case, I don't see the new way any "harder" to
get wrong.

Unless you know of a simpler way here?

thanks,

greg k-h
