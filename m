Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A39D269DCD
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIOF0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgIOF0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 01:26:45 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4320C20756;
        Tue, 15 Sep 2020 05:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600147604;
        bh=3YRNdYIm4sAf3BLgQjBz79qzM15AHtoJPCq5PN9ukyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zuMEpouuEr8pt08h+xo1UWS3YJw43raWeTOxfgZvC72zPFpYl70NRSDSuToU2Aecw
         X/ofVOJe662gdkbA2w8+rjyoemD2RHFUoyKTjYBbwCPVC2NiX9BqjTCM09AI7r4xkk
         JZUwj2AgpmKt4RTu/lraKqhKBfczLVvVeZcWYQYI=
Date:   Mon, 14 Sep 2020 22:26:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Necip Fazil Yildiran <necip@google.com>
Subject: Re: [PATCH] idr: remove WARN_ON_ONCE() when trying to check id
Message-ID: <20200915052642.GO899@sol.localdomain>
References: <20200914071724.202365-1-anmol.karan123@gmail.com>
 <20200914110803.GL6583@casper.infradead.org>
 <20200914184755.GB213347@Thinkpad>
 <20200914192655.GW6583@casper.infradead.org>
 <20200915051331.GA7980@Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915051331.GA7980@Thinkpad>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 10:43:31AM +0530, Anmol Karn wrote:
> On Mon, Sep 14, 2020 at 08:26:55PM +0100, Matthew Wilcox wrote:
> > On Tue, Sep 15, 2020 at 12:17:55AM +0530, Anmol Karn wrote:
> > > On Mon, Sep 14, 2020 at 12:08:03PM +0100, Matthew Wilcox wrote:
> > > > On Mon, Sep 14, 2020 at 12:47:24PM +0530, Anmol Karn wrote:
> > > > > idr_get_next() gives WARN_ON_ONCE() when it gets (id > INT_MAX) true
> > > > > and this happens when syzbot does fuzzing, and that warning is
> > > > > expected, but WARN_ON_ONCE() is not required here and, cecking
> > > > > the condition and returning NULL value would be suffice.
> > > > > 
> > > > > Reference: commit b9959c7a347 ("filldir[64]: remove WARN_ON_ONCE() for bad directory entries")
> > > > > Reported-and-tested-by: syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com
> > > > > Link: https://syzkaller.appspot.com/bug?extid=f7204dcf3df4bb4ce42c 
> > > > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > > 
> > > > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> > > 
> > > Hello sir,
> > > 
> > > I have looked into the patch, and it seems the problem is fixed to the root cause
> > > in this patch, but not yet merged due to some backport issues, so, please ignore 
> > > this patch(sent by me), and please let me know if i can contribute to fixing this 
> > > bug's root cause.
> > 
> > The root cause is that the network maintainers believe I have a far
> > greater interest in the qrtr code than I actually do, and the maintainer
> > of the qrtr code is not doing anything.
> 
> Hello sir,
> 
> I hope the patch will get merged soon.

No need to "hope"; you could split up Matthew's patch yourself, and test and
send the resulting patches.  From the above thread, it looks like the networking
developers want one patch to fix the improper use of GFP_ATOMIC (which is the
bug reported by syzbot), and a separate patch to convert qrtr to use the XArray.

> also, i have tried a patch for this bug
> 
> Link: https://syzkaller.appspot.com/bug?extid=3b14b2ed9b3d06dcaa07
> 
> can you please guide me little how should i proceede with it, and 
> also syzbot tested it.  

Looks like something timer-related.  You'll need to investigate more, write and
test a fix, and send it to the appropriate kernel mailing lists and developers
(which will probably be different from the ones receiving this current thread).

- Eric
