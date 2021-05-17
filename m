Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235C5382936
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 12:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbhEQKCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 06:02:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:34142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236218AbhEQKBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 06:01:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621245621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXKFGvhWgRDh4a44rCYHMonlDFHgBOcrx0uWlKqddC8=;
        b=TSN1Ocz8jSQnzuNpSXb1BfOYvmg8iF3nGI4HpTkyIWrxbVbPcya/qg3MYSkerhCKbCdF65
        Ak8Ma1iBdMQiqoeduugC2K5LPtR5kh9325gBFup6/JmjUOZ41cb8GsXdOpmABUgvvkBZOM
        183XNUwuo7apmZziC6HuGQIlZVhW3PM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 60A96AE4D;
        Mon, 17 May 2021 10:00:21 +0000 (UTC)
Message-ID: <93a10a341eccd8b680cdcc422947e4a1b83099db.camel@suse.com>
Subject: Re: [syzbot] WARNING in rtl8152_probe
From:   Oliver Neukum <oneukum@suse.com>
To:     Hayes Wang <hayeswang@realtek.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     syzbot <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        nic_swsd <nic_swsd@realtek.com>
Date:   Mon, 17 May 2021 12:00:19 +0200
In-Reply-To: <547984d34f58406aa2e37861d7e8a44d@realtek.com>
References: <0000000000009df1b605c21ecca8@google.com>
         <7de0296584334229917504da50a0ac38@realtek.com>
         <20210513142552.GA967812@rowland.harvard.edu>
         <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com> <YJ4dU3yCwd2wMq5f@kroah.com>
         <bddf302301f5420db0fa049c895c9b14@realtek.com>
         <20210514153253.GA1007561@rowland.harvard.edu>
         <547984d34f58406aa2e37861d7e8a44d@realtek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 17.05.2021, 01:01 +0000 schrieb Hayes Wang:
> Alan Stern <stern@rowland.harvard.edu>
> > Sent: Friday, May 14, 2021 11:33 PM

> > So if a peculiar emulated device created by syzbot is capable of
> > crashing the driver, then somewhere there is a bug which needs to
> > be
> > fixed.  It's true that fixing all these bugs might not protect
> > against a
> > malicious device which deliberately behaves in an apparently
> > reasonable
> > manner.  But it does reduce the attack surface.
> 
> Thanks for your response.
> I will add some checks.

Hi,

the problem in this particular case is in
static bool rtl_vendor_mode(struct usb_interface *intf)
which accepts any config number. It needs to bail out
if you find config #0 to be what the descriptors say,
treating that as an unrecoverable error.

	Regards
		Oliver


