Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FA625C498
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgICPMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728813AbgICMFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 08:05:50 -0400
Received: from lounge.grep.be (lounge.grep.be [IPv6:2a01:4f8:200:91e8::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF4FC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 05:05:35 -0700 (PDT)
Received: from [196.251.239.242] (helo=pc181009)
        by lounge.grep.be with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <w@uter.be>)
        id 1kDnzT-0001pW-24; Thu, 03 Sep 2020 14:05:19 +0200
Received: from wouter by pc181009 with local (Exim 4.92)
        (envelope-from <w@uter.be>)
        id 1kDnzP-0006ZQ-Ex; Thu, 03 Sep 2020 14:05:15 +0200
Date:   Thu, 3 Sep 2020 14:05:15 +0200
From:   Wouter Verhelst <w@uter.be>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        syzkaller-bugs@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] tipc: fix shutdown() of connectionless socket
Message-ID: <20200903120515.GC8553@pc181009.grep.be>
References: <0000000000003feb9805a9c77128@google.com>
 <1eb799fb-c6e0-3eb5-f6fe-718cd2f62e92@I-love.SAKURA.ne.jp>
 <20200903113141.GB8553@pc181009.grep.be>
 <74538f06-1f88-c484-7908-a16e5cac7614@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74538f06-1f88-c484-7908-a16e5cac7614@i-love.sakura.ne.jp>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: none
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 08:57:01PM +0900, Tetsuo Handa wrote:
> On 2020/09/03 20:31, Wouter Verhelst wrote:
> > So.
> > 
> > On Wed, Sep 02, 2020 at 08:09:54PM +0900, Tetsuo Handa wrote:
> >> syzbot is reporting hung task at nbd_ioctl() [1], for there are two
> >> problems regarding TIPC's connectionless socket's shutdown() operation.
> >> I found C reproducer for this problem (shown below) from "no output from
> >> test machine (2)" report.
> >>
> >> ----------
> >>
> >> int main(int argc, char *argv[])
> >> {
> >>         const int fd = open("/dev/nbd0", 3);
> >>         ioctl(fd, NBD_SET_SOCK, socket(PF_TIPC, SOCK_DGRAM, 0));
> > 
> > NBD expects a stream socket, not a datagram one.
> > 
> >>         ioctl(fd, NBD_DO_IT, 0);
> > 
> > This is supposed to sit and wait until someone disconnects the device
> > again (which you probably cna't do with datagram sockets). Changing that
> > changes a userspace API.
> > 
> 
> Excuse me, but other datagram sockets (e.g. socket(PF_INET, SOCK_DGRAM, 0)) does not
> hit this problem. What do you want to do? Add a "whether the file descriptor passed
> to ioctl(NBD_SET_SOCK) is a SOCK_STREAM socket" test to the NBD side?

I missed originally that you were checking whether the passed socket is
in fact a SOCK_DGRAM socket, and limiting the changes to that. That's
fine, because NBD doesn't deal with SOCK_DGRAM sockets anyway (i.e.,
passing a SOCK_DGRAM socket to the NBD device is undefined behavior). If
the behavior also changes for SOCK_STREAM sockets then that would be a
problem that would need to be reverted, but otherwise it's fine.

-- 
To the thief who stole my anti-depressants: I hope you're happy

  -- seen somewhere on the Internet on a photo of a billboard
