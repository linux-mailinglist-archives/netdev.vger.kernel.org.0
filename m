Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9C4382DD4
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 15:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbhEQNsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 09:48:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55325 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S237493AbhEQNsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 09:48:35 -0400
Received: (qmail 1085329 invoked by uid 1000); 17 May 2021 09:47:18 -0400
Date:   Mon, 17 May 2021 09:47:18 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        syzbot <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [syzbot] WARNING in rtl8152_probe
Message-ID: <20210517134718.GC1083813@rowland.harvard.edu>
References: <0000000000009df1b605c21ecca8@google.com>
 <7de0296584334229917504da50a0ac38@realtek.com>
 <20210513142552.GA967812@rowland.harvard.edu>
 <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com>
 <YJ4dU3yCwd2wMq5f@kroah.com>
 <bddf302301f5420db0fa049c895c9b14@realtek.com>
 <20210514153253.GA1007561@rowland.harvard.edu>
 <547984d34f58406aa2e37861d7e8a44d@realtek.com>
 <93a10a341eccd8b680cdcc422947e4a1b83099db.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93a10a341eccd8b680cdcc422947e4a1b83099db.camel@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 12:00:19PM +0200, Oliver Neukum wrote:
> Am Montag, den 17.05.2021, 01:01 +0000 schrieb Hayes Wang:
> > Alan Stern <stern@rowland.harvard.edu>
> > > Sent: Friday, May 14, 2021 11:33 PM
> 
> > > So if a peculiar emulated device created by syzbot is capable of
> > > crashing the driver, then somewhere there is a bug which needs to
> > > be
> > > fixed.  It's true that fixing all these bugs might not protect
> > > against a
> > > malicious device which deliberately behaves in an apparently
> > > reasonable
> > > manner.  But it does reduce the attack surface.
> > 
> > Thanks for your response.
> > I will add some checks.
> 
> Hi,
> 
> the problem in this particular case is in
> static bool rtl_vendor_mode(struct usb_interface *intf)
> which accepts any config number. It needs to bail out
> if you find config #0 to be what the descriptors say,
> treating that as an unrecoverable error.

No, the problem is that the routine calls WARN_ON_ONCE when it doesn't 
find an appropriate configuration.  WARN_ON_ONCE means there is a bug or 
problem in the kernel.  That's not the issue here; the issue is that the 
device doesn't have the expected descriptors.

The line should be dev_warn(), not WARN_ON_ONCE.

Alan Stern
