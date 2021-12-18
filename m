Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237CA479D74
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhLRVmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:42:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhLRVmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eLPtaZ6jc0qsf67b3YZgHOu1SauyK+DFYf2BGnq0Y/g=; b=FiUun95p5z52jWx54fo7WPoGhA
        eX9iGH9ULGssd/3V/tllMMSrJevCBRia/bQk6xkTKbE6angpnXWrfl9rAcED/CIzHsV1KR9wAkO7j
        aIg1dlQOptjtRkPrnd8X6HOsgqCbkoBQz5mJvPLJ2aKfDIhRLfTW7h48ioLjkIYSGPf0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1myhT9-00GvN8-Vc; Sat, 18 Dec 2021 22:42:19 +0100
Date:   Sat, 18 Dec 2021 22:42:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+f44badb06036334e867a@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@rempel-privat.de, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (2)
Message-ID: <Yb5Vu8+45wh5FiCQ@lunn.ch>
References: <00000000000021160205d369a962@google.com>
 <13821c8b-c809-c820-04f0-2eadfdef0296@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13821c8b-c809-c820-04f0-2eadfdef0296@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 12:14:30AM +0300, Pavel Skripkin wrote:
> On 12/18/21 14:07, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    b0a8b5053e8b kmsan: core: add dependency on DEBUG_KERNEL
> > git tree:       https://github.com/google/kmsan.git master
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13a4d133b00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f44badb06036334e867a
> > compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149fddcbb00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17baef25b00000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
> > 
> 
> The last unhanded case is asix_read_cmd() == 0. Let's handle it...

That does not look correct, i think.

asix_read_cmd() == 0 means no error from the read itself. If there is
no error, we should look at the value of smsr and test for bit
AX_HOST_EN. Doing a continue means we just ignore the value returned
by the good read.

I think the correct fix is to look at the value of i. If we have
exceeded 30, we should return -ETIMEDOUT.

	 Andrew
