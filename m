Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B55251C80
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHYPoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgHYPoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 11:44:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EDA420782;
        Tue, 25 Aug 2020 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598370239;
        bh=DgFyxOdNOTi3TG94BiEuLcvBwr2/zo4bHO/PeqCjCx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IKrg3F2vFQXnqAASePy/mMuLsPQW7IEiL+Xux1qbWn0qGtd1OeKAs6//mcqd5evcH
         FplyaJzVGuDTO1NiHzr441tAkqzWhwayfwfl5jDKAJkZMHemuEv0dp2dMbGVIreylT
         pochdB6GTVu2BLXiAolfJbfQGA4AiPxAdKQgbtQI=
Date:   Tue, 25 Aug 2020 17:44:15 +0200
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
Message-ID: <20200825154415.GA1513396@kroah.com>
References: <20200823082042.20816-1-himadrispandya@gmail.com>
 <CACT4Y+Y1TpqYowNXj+OTcQwH-7T4n6PtPPa4gDWkV-np5KhKAQ@mail.gmail.com>
 <20200823101924.GA3078429@kroah.com>
 <CACT4Y+YbDODLRFn8M5QcY4CazhpeCaunJnP_udXtAs0rYoASSg@mail.gmail.com>
 <20200823105808.GB87391@kroah.com>
 <CACT4Y+ZiZQK8WBre9E4777NPaRK4UDOeZOeMZOQC=5tDsDu23A@mail.gmail.com>
 <20200825065135.GA1316856@kroah.com>
 <20200825143946.GA365901@rowland.harvard.edu>
 <20200825144437.GA1484901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825144437.GA1484901@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 04:44:37PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 25, 2020 at 10:39:46AM -0400, Alan Stern wrote:
> > On Tue, Aug 25, 2020 at 08:51:35AM +0200, Greg Kroah-Hartman wrote:
> > > At first glance, I think this can all be cleaned up, but it will take a
> > > bit of tree-wide work.  I agree, we need a "read this message and error
> > > if the whole thing is not there", as well as a "send this message and
> > > error if the whole thing was not sent", and also a way to handle
> > > stack-provided data, which seems to be the primary reason subsystems
> > > wrap this call (they want to make it easier on their drivers to use it.)
> > > 
> > > Let me think about this in more detail, but maybe something like:
> > > 	usb_control_msg_read()
> > > 	usb_control_msg_send()
> > > is a good first step (as the caller knows this) and stack provided data
> > > would be allowed, and it would return an error if the whole message was
> > > not read/sent properly.  That way we can start converting everything
> > > over to a sane, and checkable, api and remove a bunch of wrapper
> > > functions as well.
> > 
> > Suggestion: _read and _send are not a natural pair.  Consider instead
> > _read and _write.  _recv and _send don't feel right either, because it
> > both cases the host sends the control message -- the difference lies
> > in who sends the data.
> 
> Yes, naming is hard :)
> 
> 	usb_control_read_msg()
> 	usb_control_write_msg()
> 
> feels good to me, let me try this out and see if it actually makes sense
> to do this on a few in-usb-core files and various drivers...

Turns out we have a long history of using snd/rcv for USB control
messages:
	usb_rcvctrlpipe()
	usb_sndctrlpipe()

so while _recv and _send might feel a bit "odd", it is what we are used
to using, and when converting existing users, I can drop the pipe macro
from the calls, turning something like:
	usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0), ...);
into:
	usb_control_send_msg(hdev, 0, ...);

or maybe:
	usb_control_msg_send(hdev, 0, ...);
with a full noun_verb pairing, instead of noun_verb_noun.

thanks,

greg k-h
