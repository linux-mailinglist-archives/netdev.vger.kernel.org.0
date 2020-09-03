Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB47A25C495
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgICMEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 08:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728785AbgICMDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 08:03:51 -0400
X-Greylist: delayed 1885 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Sep 2020 05:03:38 PDT
Received: from lounge.grep.be (lounge.grep.be [IPv6:2a01:4f8:200:91e8::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96567C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 05:03:38 -0700 (PDT)
Received: from [196.251.239.242] (helo=pc181009)
        by lounge.grep.be with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <w@uter.be>)
        id 1kDnSz-0007fe-Qk; Thu, 03 Sep 2020 13:31:45 +0200
Received: from wouter by pc181009 with local (Exim 4.92)
        (envelope-from <w@uter.be>)
        id 1kDnSw-0005x1-0G; Thu, 03 Sep 2020 13:31:42 +0200
Date:   Thu, 3 Sep 2020 13:31:41 +0200
From:   Wouter Verhelst <w@uter.be>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        syzkaller-bugs@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] tipc: fix shutdown() of connectionless socket
Message-ID: <20200903113141.GB8553@pc181009.grep.be>
References: <0000000000003feb9805a9c77128@google.com>
 <1eb799fb-c6e0-3eb5-f6fe-718cd2f62e92@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eb799fb-c6e0-3eb5-f6fe-718cd2f62e92@I-love.SAKURA.ne.jp>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: none
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So.

On Wed, Sep 02, 2020 at 08:09:54PM +0900, Tetsuo Handa wrote:
> syzbot is reporting hung task at nbd_ioctl() [1], for there are two
> problems regarding TIPC's connectionless socket's shutdown() operation.
> I found C reproducer for this problem (shown below) from "no output from
> test machine (2)" report.
> 
> ----------
> 
> int main(int argc, char *argv[])
> {
>         const int fd = open("/dev/nbd0", 3);
>         ioctl(fd, NBD_SET_SOCK, socket(PF_TIPC, SOCK_DGRAM, 0));

NBD expects a stream socket, not a datagram one.

>         ioctl(fd, NBD_DO_IT, 0);

This is supposed to sit and wait until someone disconnects the device
again (which you probably cna't do with datagram sockets). Changing that
changes a userspace API.

-- 
To the thief who stole my anti-depressants: I hope you're happy

  -- seen somewhere on the Internet on a photo of a billboard
