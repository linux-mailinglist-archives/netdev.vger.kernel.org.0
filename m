Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7725C0AB
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgICL7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 07:59:06 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63808 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728591AbgICL6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:58:01 -0400
Received: from fsav302.sakura.ne.jp (fsav302.sakura.ne.jp [153.120.85.133])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 083Bv3Oq028317;
        Thu, 3 Sep 2020 20:57:03 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav302.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav302.sakura.ne.jp);
 Thu, 03 Sep 2020 20:57:03 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav302.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 083Bv2RW028313
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Thu, 3 Sep 2020 20:57:02 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] tipc: fix shutdown() of connectionless socket
To:     Wouter Verhelst <w@uter.be>
Cc:     syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        syzkaller-bugs@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
References: <0000000000003feb9805a9c77128@google.com>
 <1eb799fb-c6e0-3eb5-f6fe-718cd2f62e92@I-love.SAKURA.ne.jp>
 <20200903113141.GB8553@pc181009.grep.be>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <74538f06-1f88-c484-7908-a16e5cac7614@i-love.sakura.ne.jp>
Date:   Thu, 3 Sep 2020 20:57:01 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903113141.GB8553@pc181009.grep.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/09/03 20:31, Wouter Verhelst wrote:
> So.
> 
> On Wed, Sep 02, 2020 at 08:09:54PM +0900, Tetsuo Handa wrote:
>> syzbot is reporting hung task at nbd_ioctl() [1], for there are two
>> problems regarding TIPC's connectionless socket's shutdown() operation.
>> I found C reproducer for this problem (shown below) from "no output from
>> test machine (2)" report.
>>
>> ----------
>>
>> int main(int argc, char *argv[])
>> {
>>         const int fd = open("/dev/nbd0", 3);
>>         ioctl(fd, NBD_SET_SOCK, socket(PF_TIPC, SOCK_DGRAM, 0));
> 
> NBD expects a stream socket, not a datagram one.
> 
>>         ioctl(fd, NBD_DO_IT, 0);
> 
> This is supposed to sit and wait until someone disconnects the device
> again (which you probably cna't do with datagram sockets). Changing that
> changes a userspace API.
> 

Excuse me, but other datagram sockets (e.g. socket(PF_INET, SOCK_DGRAM, 0)) does not
hit this problem. What do you want to do? Add a "whether the file descriptor passed
to ioctl(NBD_SET_SOCK) is a SOCK_STREAM socket" test to the NBD side?

I think that regardless of whether NBD expects only SOCK_STREAM sockets,
tipc_wait_for_rcvmsg() on a SOCK_DGRAM socket can't return is a bug.
David Miller already applied this patch and queued up for -stable.
Do we need to revert this patch?
