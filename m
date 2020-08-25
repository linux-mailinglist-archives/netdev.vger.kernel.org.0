Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F91251B15
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHYOoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHYOoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 10:44:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4264820578;
        Tue, 25 Aug 2020 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598366661;
        bh=H4ZjIEM1FoCEKtZPFYTxt0y4DJtVqeusqC+bdNjG5Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVfNwM2xGfolB0ytEUD3umzKOJXUzM3sBZS523JV7zuqDlg0+rDnIVKRh3e5nGhnU
         R/lDxscVLLMMygvwAO8Tf1+7GcZ+zL3BpmiU4hlppToOx0q22P79AzMZjRe8cqNtB2
         D/IoM4cZLKEnUQIOYHIoBuw2b5VEISrn6Y35sEYg=
Date:   Tue, 25 Aug 2020 16:44:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Himadri Pandya <himadrispandya@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_cmd()
Message-ID: <20200825144437.GA1484901@kroah.com>
References: <20200823082042.20816-1-himadrispandya@gmail.com>
 <CACT4Y+Y1TpqYowNXj+OTcQwH-7T4n6PtPPa4gDWkV-np5KhKAQ@mail.gmail.com>
 <20200823101924.GA3078429@kroah.com>
 <CACT4Y+YbDODLRFn8M5QcY4CazhpeCaunJnP_udXtAs0rYoASSg@mail.gmail.com>
 <20200823105808.GB87391@kroah.com>
 <CACT4Y+ZiZQK8WBre9E4777NPaRK4UDOeZOeMZOQC=5tDsDu23A@mail.gmail.com>
 <20200825065135.GA1316856@kroah.com>
 <20200825143946.GA365901@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825143946.GA365901@rowland.harvard.edu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 10:39:46AM -0400, Alan Stern wrote:
> On Tue, Aug 25, 2020 at 08:51:35AM +0200, Greg Kroah-Hartman wrote:
> > At first glance, I think this can all be cleaned up, but it will take a
> > bit of tree-wide work.  I agree, we need a "read this message and error
> > if the whole thing is not there", as well as a "send this message and
> > error if the whole thing was not sent", and also a way to handle
> > stack-provided data, which seems to be the primary reason subsystems
> > wrap this call (they want to make it easier on their drivers to use it.)
> > 
> > Let me think about this in more detail, but maybe something like:
> > 	usb_control_msg_read()
> > 	usb_control_msg_send()
> > is a good first step (as the caller knows this) and stack provided data
> > would be allowed, and it would return an error if the whole message was
> > not read/sent properly.  That way we can start converting everything
> > over to a sane, and checkable, api and remove a bunch of wrapper
> > functions as well.
> 
> Suggestion: _read and _send are not a natural pair.  Consider instead
> _read and _write.  _recv and _send don't feel right either, because it
> both cases the host sends the control message -- the difference lies
> in who sends the data.

Yes, naming is hard :)

	usb_control_read_msg()
	usb_control_write_msg()

feels good to me, let me try this out and see if it actually makes sense
to do this on a few in-usb-core files and various drivers...

thanks,

greg k-h
