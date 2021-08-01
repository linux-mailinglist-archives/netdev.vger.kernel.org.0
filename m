Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1085B3DCDAB
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 22:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhHAUYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 16:24:42 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:38882 "EHLO
        zzt.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229955AbhHAUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 16:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nucleusys.com; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6vjd0yjQG3cLOQPkVqx7MVzNhtwrgIO01TVQGBQE7jQ=; b=lJ8Qylio8uUdgrs8Pn4kHtGhxW
        7marUVg9NQX/bYzKVnT5vhaC0JuIoYlObAgCj+b3OILLllpxqH5ZlUITZk0druvvYIBN/94NDvv5u
        11FAu1V+LkoehwR8HPdJEHhQu3oOYBgdQc+pfXATie9KTzjCM4HMWRY/z013NcQrWUog=;
Received: from [94.26.108.4] (helo=carbon)
        by zzt.nucleusys.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <petkan@nucleusys.com>)
        id 1mAI0U-000Bk6-CG; Sun, 01 Aug 2021 23:24:23 +0300
Date:   Sun, 1 Aug 2021 23:24:21 +0300
From:   Petko Manolov <petkan@nucleusys.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: pegasus: fix uninit-value in get_interrupt_interval
Message-ID: <YQcC9eOf5+MXZRsG@carbon>
Mail-Followup-To: Pavel Skripkin <paskripkin@gmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
References: <20210730214411.1973-1-paskripkin@gmail.com>
 <YQaVS5UwG6RFsL4t@carbon>
 <20210801223513.06bede26@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210801223513.06bede26@gmail.com>
X-Spam_score: -1.0
X-Spam_bar: -
X-Spam_report: Spam detection software, running on the system "zzt.nucleusys.com",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  On 21-08-01 22:35:13, Pavel Skripkin wrote: > On Sun, 1 Aug
    2021 15:36:27 +0300 Petko Manolov <petkan@nucleusys.com> wrote: > > > On
   21-07-31 00:44:11, Pavel Skripkin wrote: > > > Syzbot reported unin [...] 
 Content analysis details:   (-1.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-08-01 22:35:13, Pavel Skripkin wrote:
> On Sun, 1 Aug 2021 15:36:27 +0300 Petko Manolov <petkan@nucleusys.com> wrote:
> 
> > On 21-07-31 00:44:11, Pavel Skripkin wrote:
> > > Syzbot reported uninit value pegasus_probe(). The problem was in missing
> > > error handling.
> > > 
> > > get_interrupt_interval() internally calls read_eprom_word() which can fail
> > > in some cases. For example: failed to receive usb control message. These
> > > cases should be handled to prevent uninit value bug, since
> > > read_eprom_word() will not initialize passed stack variable in case of
> > > internal failure.
> > 
> > Well, this is most definitelly a bug.
> > 
> > ACK!
> > 
> > 
> >		Petko
> 
> BTW: I found a lot uses of {get,set}_registers without error checking. I
> think, some of them could be fixed easily (like in enable_eprom_write), but, I
> guess, disable_eprom_write is not so easy. For example, if we cannot disable
> eprom should we retry? If not, will device get in some unexpected state?

Everything bracketed by PEGASUS_WRITE_EEPROM is more or less dead code.  I've
added this feature because the chip give us the ability to write to the flash,
but i seriously doubt anybody ever used it.  Come to think about it, i should
just remove this code.

> Im not familiar with this device, but I can prepare a patch to wrap all these
> calls with proper error checking

Well, i've stared at the code a bit and i see some places where not checking the
error returned by {get,set}_registers() could really be problematic.  I'll cook
a patch with what i think needs doing and will submit it here for review.


cheers,
Petko
